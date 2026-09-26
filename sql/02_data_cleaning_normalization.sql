CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_stg_sessions_cleaned` AS
SELECT 
    s.session_id,
    s.user_id,
    u.experiment_group,
    u.cohort_date,
    s.session_timestamp,
    DATE(s.session_timestamp) AS session_date,
    DATE_DIFF(DATE(s.session_timestamp), u.cohort_date, DAY) AS days_since_onboarding,
    COALESCE(s.cold_start_latency_ms, 180.0) AS cold_start_latency_ms,
    CASE 
        WHEN s.watch_completion_rate > 1.0 THEN 1.0 
        WHEN s.watch_completion_rate < 0.0 THEN 0.0 
        ELSE s.watch_completion_rate 
    END AS watch_completion_rate,
    s.share_count,
    CASE WHEN s.watch_completion_rate >= 0.85 THEN 1 ELSE 0 END AS flag_high_completion
FROM `driiiportfolio.snap_spotlight_growth.fact_user_sessions` s
INNER JOIN `driiiportfolio.snap_spotlight_growth.dim_users` u
    ON s.user_id = u.user_id
WHERE s.session_timestamp >= '2026-08-01';
