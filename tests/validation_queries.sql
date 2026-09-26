-- Validation queries. Each query should return zero rows unless a check fails.

-- Required-field nulls
SELECT * FROM `driiiportfolio.snap_spotlight_growth.dim_users`
WHERE user_id IS NULL OR cohort_date IS NULL OR device_os IS NULL
   OR region IS NULL OR experiment_group IS NULL;

SELECT * FROM `driiiportfolio.snap_spotlight_growth.fact_user_sessions`
WHERE session_id IS NULL OR user_id IS NULL OR session_timestamp IS NULL
   OR avg_watch_completion IS NULL OR avg_latency_ms IS NULL
   OR total_shares IS NULL OR negative_feedback_flag IS NULL;

-- Duplicate keys
SELECT user_id, COUNT(*) AS n
FROM `driiiportfolio.snap_spotlight_growth.dim_users`
GROUP BY user_id HAVING COUNT(*) > 1;

SELECT session_id, COUNT(*) AS n
FROM `driiiportfolio.snap_spotlight_growth.fact_user_sessions`
GROUP BY session_id HAVING COUNT(*) > 1;

-- Orphan sessions
SELECT s.user_id
FROM `driiiportfolio.snap_spotlight_growth.fact_user_sessions` s
LEFT JOIN `driiiportfolio.snap_spotlight_growth.dim_users` u USING (user_id)
WHERE u.user_id IS NULL;

-- Invalid experiment assignments
SELECT DISTINCT experiment_group
FROM `driiiportfolio.snap_spotlight_growth.dim_users`
WHERE experiment_group NOT IN ('Control_Standard_Recs', 'Variant_Algorithmic_Exploration');
