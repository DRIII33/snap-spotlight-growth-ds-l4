CREATE SCHEMA IF NOT EXISTS `driiiportfolio.snap_spotlight_growth`;

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.dim_users` (
    user_id STRING NOT NULL,
    cohort_date DATE NOT NULL,
    experiment_group STRING NOT NULL
);

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.fact_user_sessions` (
    session_id STRING NOT NULL,
    user_id STRING NOT NULL,
    session_timestamp TIMESTAMP NOT NULL,
    watch_completion_rate FLOAT64,
    cold_start_latency_ms FLOAT64,
    share_count INT64
);
