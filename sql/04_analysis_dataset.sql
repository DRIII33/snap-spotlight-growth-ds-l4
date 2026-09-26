-- 04_analysis_dataset.sql
-- One row per randomized user. This is the statistical analysis grain.

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.analysis_dataset` AS
SELECT
  user_id,
  experiment_group,
  device_os,
  region,
  cohort_date,
  retained_d1,
  retained_d3,
  retained_d7,
  retained_d28,
  total_sessions,
  total_shares,
  avg_watch_completion,
  avg_latency_ms,
  negative_feedback_flag
FROM `driiiportfolio.snap_spotlight_growth.vw_retention_cohort_daily`;
