-- 02_data_quality_and_cleaning.sql
-- Validation and cleaned staging view.

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_stg_sessions_cleaned` AS
SELECT
  s.session_id,
  s.user_id,
  s.session_timestamp,
  u.cohort_date,
  u.device_os,
  u.region,
  u.experiment_group,
  s.avg_watch_completion,
  s.avg_latency_ms,
  s.total_shares,
  s.negative_feedback_flag,
  DATE_DIFF(DATE(s.session_timestamp), u.cohort_date, DAY) AS days_since_cohort
FROM `driiiportfolio.snap_spotlight_growth.fact_user_sessions` s
JOIN `driiiportfolio.snap_spotlight_growth.dim_users` u
  USING (user_id)
WHERE s.session_id IS NOT NULL
  AND s.user_id IS NOT NULL
  AND s.session_timestamp IS NOT NULL
  AND s.avg_watch_completion BETWEEN 0 AND 1
  AND s.avg_latency_ms >= 0
  AND s.total_shares >= 0
  AND s.negative_feedback_flag IN (0, 1);
