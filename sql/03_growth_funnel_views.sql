-- 03_growth_funnel_views.sql
-- Exact-day retention and user-level product/guardrail metrics.

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_retention_cohort_daily` AS
WITH user_metrics AS (
  SELECT
    u.user_id,
    u.experiment_group,
    u.device_os,
    u.region,
    u.cohort_date,
    MAX(IF(s.days_since_cohort = 1, 1, 0)) AS retained_d1,
    MAX(IF(s.days_since_cohort = 3, 1, 0)) AS retained_d3,
    MAX(IF(s.days_since_cohort = 7, 1, 0)) AS retained_d7,
    MAX(IF(s.days_since_cohort = 28, 1, 0)) AS retained_d28,
    COUNT(s.session_id) AS total_sessions,
    SUM(s.total_shares) AS total_shares,
    AVG(s.avg_watch_completion) AS avg_watch_completion,
    AVG(s.avg_latency_ms) AS avg_latency_ms,
    MAX(s.negative_feedback_flag) AS negative_feedback_flag
  FROM `driiiportfolio.snap_spotlight_growth.dim_users` u
  LEFT JOIN `driiiportfolio.snap_spotlight_growth.vw_stg_sessions_cleaned` s
    USING (user_id)
  GROUP BY 1,2,3,4,5
)
SELECT * FROM user_metrics;

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_experiment_summary` AS
SELECT
  experiment_group,
  COUNT(*) AS users,
  AVG(retained_d1) AS d1_retention_rate,
  AVG(retained_d3) AS d3_retention_rate,
  AVG(retained_d7) AS d7_retention_rate,
  AVG(retained_d28) AS d28_retention_rate,
  AVG(total_shares) AS mean_shares_per_user,
  AVG(avg_watch_completion) AS mean_watch_completion,
  AVG(avg_latency_ms) AS mean_latency_ms,
  APPROX_QUANTILES(avg_latency_ms, 100)[OFFSET(95)] AS p95_user_latency_ms,
  AVG(negative_feedback_flag) AS negative_feedback_rate
FROM `driiiportfolio.snap_spotlight_growth.vw_retention_cohort_daily`
GROUP BY experiment_group;

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_guardrail_summary` AS
SELECT
  experiment_group,
  COUNT(*) AS users,
  AVG(negative_feedback_flag) AS negative_feedback_rate,
  AVG(avg_latency_ms) AS mean_latency_ms,
  APPROX_QUANTILES(avg_latency_ms, 100)[OFFSET(95)] AS p95_user_latency_ms,
  AVG(retained_d7) AS d7_retention_rate,
  AVG(retained_d28) AS d28_retention_rate
FROM `driiiportfolio.snap_spotlight_growth.vw_retention_cohort_daily`
GROUP BY experiment_group;
