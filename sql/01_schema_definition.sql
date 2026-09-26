-- Part 3: Reproducible Codebase
-- 01_schema_definition.sql
-- Project: driiiportfolio
-- Dataset: snap_spotlight_growth

CREATE SCHEMA IF NOT EXISTS `driiiportfolio.snap_spotlight_growth`;

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.dim_users` (
  user_id STRING NOT NULL,
  cohort_date DATE NOT NULL,
  device_os STRING NOT NULL,
  region STRING NOT NULL,
  experiment_group STRING NOT NULL
);

CREATE OR REPLACE TABLE `driiiportfolio.snap_spotlight_growth.fact_user_sessions` (
  session_id STRING NOT NULL,
  user_id STRING NOT NULL,
  session_timestamp TIMESTAMP NOT NULL,
  avg_watch_completion FLOAT64 NOT NULL,
  avg_latency_ms INT64 NOT NULL,
  total_shares INT64 NOT NULL,
  negative_feedback_flag INT64 NOT NULL
);

