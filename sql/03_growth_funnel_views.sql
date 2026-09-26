CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_user_retention_experiment_summary` AS
SELECT
    user_id,
    experiment_group,
    cohort_date,
    MAX(CASE WHEN days_since_onboarding BETWEEN 1 AND 7 THEN 1 ELSE 0 END) AS retained_d7,
    MAX(CASE WHEN days_since_onboarding BETWEEN 8 AND 28 THEN 1 ELSE 0 END) AS retained_d28,
    COUNT(session_id) AS total_sessions,
    AVG(watch_completion_rate) AS avg_watch_completion,
    AVG(cold_start_latency_ms) AS avg_latency_ms,
    SUM(share_count) AS total_shares
FROM `driiiportfolio.snap_spotlight_growth.vw_stg_sessions_cleaned`
GROUP BY user_id, experiment_group, cohort_date;
