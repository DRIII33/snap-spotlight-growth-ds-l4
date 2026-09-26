-- 07_vw_dashboard_statistical_evidence.sql
-- This view was designed to reproduce the existing notebook's calculations and decision rules from the authoritative analysis_dataset;
-- it does not regenerate the data or alter the previously validated experimental results.

CREATE OR REPLACE VIEW
`driiiportfolio.snap_spotlight_growth.vw_dashboard_statistical_evidence`
AS
WITH experiment_counts AS (
  SELECT
    experiment_group,
    COUNT(*) AS users,
    SUM(retained_d28) AS retained_d28_users,
    AVG(retained_d28) AS d28_retention_rate
  FROM
    `driiiportfolio.snap_spotlight_growth.analysis_dataset`
  GROUP BY
    experiment_group
),
group_values AS (
  SELECT
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        users,
        NULL
      )
    ) AS control_users,
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        retained_d28_users,
        NULL
      )
    ) AS control_retained_d28_users,
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        d28_retention_rate,
        NULL
      )
    ) AS control_d28_rate,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        users,
        NULL
      )
    ) AS variant_users,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        retained_d28_users,
        NULL
      )
    ) AS variant_retained_d28_users,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        d28_retention_rate,
        NULL
      )
    ) AS variant_d28_rate
  FROM
    experiment_counts
),
d28_statistics AS (
  SELECT
    control_users,
    control_retained_d28_users,
    control_d28_rate,
    variant_users,
    variant_retained_d28_users,
    variant_d28_rate,
    -- Treatment effect:
    -- Variant - Control
    variant_d28_rate - control_d28_rate
      AS d28_absolute_difference,
    -- Relative treatment effect:
    -- (Variant - Control) / Control
    SAFE_DIVIDE(
      variant_d28_rate - control_d28_rate,
      control_d28_rate
    ) AS d28_relative_difference,
    -- Standard error for the difference between two independent
    -- binary proportions.
    SQRT(
      SAFE_DIVIDE(
        variant_d28_rate * (1 - variant_d28_rate),
        variant_users
      )
      +
      SAFE_DIVIDE(
        control_d28_rate * (1 - control_d28_rate),
        control_users
      )
    ) AS d28_standard_error
  FROM
    group_values
),
final_statistics AS (
  SELECT
    control_users,
    control_retained_d28_users,
    control_d28_rate,
    variant_users,
    variant_retained_d28_users,
    variant_d28_rate,
    d28_absolute_difference,
    d28_relative_difference,
    d28_standard_error,
    -- 95% confidence interval
    d28_absolute_difference
      - 1.96 * d28_standard_error
      AS d28_ci_lower,
    d28_absolute_difference
      + 1.96 * d28_standard_error
      AS d28_ci_upper,
    -- Standardized test statistic
    SAFE_DIVIDE(
      d28_absolute_difference,
      d28_standard_error
    ) AS d28_z_score
  FROM
    d28_statistics
)
SELECT
  'D28_RETENTION' AS metric_name,
  'Control_Standard_Recs' AS control_group,
  'Variant_Algorithmic_Exploration' AS variant_group,
  control_users,
  variant_users,
  control_retained_d28_users,
  variant_retained_d28_users,
  control_d28_rate,
  variant_d28_rate,
  d28_absolute_difference,
  d28_relative_difference,
  d28_standard_error,
  d28_ci_lower,
  d28_ci_upper,
  d28_z_score,
  -- Two-sided normal-approximation p-value.
  -- 2 * P(Z >= |z|) from notebook
  2 * (1 - NORM.DIST(ABS(d28_z_score), 0, 1, TRUE))
   AS d28_p_value,
  0.05 AS significance_alpha,
  1.96 AS confidence_level_z,
  'Two-proportion normal approximation' AS statistical_method,
  'Variant D28 retention minus Control D28 retention'
    AS effect_definition,
  CURRENT_TIMESTAMP() AS generated_at
FROM
  final_statistics;
