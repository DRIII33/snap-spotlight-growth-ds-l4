-- 06_vw_rollout_stage_summary.sql
-- This view was designed to reproduce the existing notebook's calculations and decision rules from the authoritative analysis_dataset;
-- it does not regenerate the data or alter the previously validated experimental results.

CREATE OR REPLACE VIEW
`driiiportfolio.snap_spotlight_growth.vw_rollout_stage_summary`
AS
WITH stage_definitions AS (
  SELECT
    1 AS stage_number,
    0.01 AS exposure_rate
  UNION ALL
  SELECT
    2 AS stage_number,
    0.05 AS exposure_rate
  UNION ALL
  SELECT
    3 AS stage_number,
    0.10 AS exposure_rate
  UNION ALL
  SELECT
    4 AS stage_number,
    1.00 AS exposure_rate
),
dataset_size AS (
  SELECT
    COUNT(*) AS total_users
  FROM
    `driiiportfolio.snap_spotlight_growth.analysis_dataset`
),
stage_sizes AS (
  SELECT
    s.stage_number,
    s.exposure_rate,
    d.total_users,
    GREATEST(
      2,
      CAST(
        FLOOR(d.total_users * s.exposure_rate)
        AS INT64
      )
    ) AS stage_user_count
  FROM
    stage_definitions s
  CROSS JOIN
    dataset_size d
),
ranked_users AS (
  SELECT
    a.*,
    ROW_NUMBER() OVER (
      ORDER BY user_id
    ) AS user_rank
  FROM
    `driiiportfolio.snap_spotlight_growth.analysis_dataset` a
),
stage_population AS (
  SELECT
    s.stage_number,
    s.exposure_rate,
    s.total_users,
    s.stage_user_count,
    r.user_id,
    r.experiment_group,
    r.retained_d28,
    r.negative_feedback_flag
  FROM
    stage_sizes s
  INNER JOIN
    ranked_users r
  ON
    r.user_rank <= s.stage_user_count
),
stage_group_summary AS (
  SELECT
    stage_number,
    exposure_rate,
    total_users,
    stage_user_count,
    experiment_group,
    COUNT(*) AS users,
    AVG(
      retained_d28
    ) AS d28_retention_rate,
    AVG(
      negative_feedback_flag
    ) AS negative_feedback_rate
  FROM
    stage_population
  GROUP BY
    stage_number,
    exposure_rate,
    total_users,
    stage_user_count,
    experiment_group
),
stage_pivot AS (
  SELECT
    stage_number,
    exposure_rate,
    total_users,
    stage_user_count,
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        users,
        NULL
      )
    ) AS control_users,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        users,
        NULL
      )
    ) AS variant_users,
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        d28_retention_rate,
        NULL
      )
    ) AS control_d28_retention_rate,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        d28_retention_rate,
        NULL
      )
    ) AS variant_d28_retention_rate,
    MAX(
      IF(
        experiment_group = 'Control_Standard_Recs',
        negative_feedback_rate,
        NULL
      )
    ) AS control_negative_feedback_rate,
    MAX(
      IF(
        experiment_group = 'Variant_Algorithmic_Exploration',
        negative_feedback_rate,
        NULL
      )
    ) AS variant_negative_feedback_rate
  FROM
    stage_group_summary
  GROUP BY
    stage_number,
    exposure_rate,
    total_users,
    stage_user_count
),
stage_metrics AS (
  SELECT
    stage_number,
    exposure_rate,
    total_users,
    stage_user_count,
    control_users,
    variant_users,
    control_d28_retention_rate,
    variant_d28_retention_rate,
    control_negative_feedback_rate,
    variant_negative_feedback_rate,
    -- Exact notebook definition:
    -- Variant D28 - Control D28
    variant_d28_retention_rate
      - control_d28_retention_rate
      AS d28_difference,
    -- Exact notebook definition:
    -- Variant negative feedback / Control negative feedback - 1
    SAFE_DIVIDE(
      variant_negative_feedback_rate,
      control_negative_feedback_rate
    ) - 1
      AS negative_feedback_relative_change
  FROM
    stage_pivot
)
SELECT
  stage_number,
  exposure_rate,
  total_users,
  stage_user_count,
  control_users,
  variant_users,
  control_d28_retention_rate,
  variant_d28_retention_rate,
  d28_difference,
  control_negative_feedback_rate,
  variant_negative_feedback_rate,
  negative_feedback_relative_change,
  -- Decision thresholds used by the notebook.
  -0.01 AS d28_rollback_threshold,
  0.50 AS negative_feedback_rollback_threshold,
  CASE
    WHEN
      d28_difference < -0.01
      OR negative_feedback_relative_change > 0.50
    THEN 'ROLLBACK'
    ELSE 'ADVANCE'
  END AS decision,
  'Deterministic portfolio simulation; not production exposure'
    AS rollout_type,
  CURRENT_TIMESTAMP() AS generated_at
FROM
  stage_metrics
ORDER BY
  stage_number;
