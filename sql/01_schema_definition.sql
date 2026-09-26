CREATE SCHEMA IF NOT EXISTS `driiiportfolio.snap_spotlight_growth`;

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.dim_users` (
    user_id STRING REQUIRED,
    cohort_date DATE REQUIRED,
    experiment_group STRING REQUIRED
);

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.fact_user_sessions` (
    session_id STRING REQUIRED,
    user_id STRING REQUIRED,
    session_timestamp TIMESTAMP REQUIRED,
    watch_completion_rate FLOAT64,
    cold_start_latency_ms FLOAT64,
    share_count INT64
);
