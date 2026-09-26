-- 05_dashboard_views.sql
-- Stable dashboard-facing views.

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_dashboard_executive` AS
SELECT
  experiment_group,
  users,
  d1_retention_rate,
  d3_retention_rate,
  d7_retention_rate,
  d28_retention_rate,
  mean_shares_per_user,
  mean_watch_completion,
  mean_latency_ms,
  p95_user_latency_ms,
  negative_feedback_rate
FROM `driiiportfolio.snap_spotlight_growth.vw_experiment_summary`;

CREATE OR REPLACE VIEW `driiiportfolio.snap_spotlight_growth.vw_dashboard_guardrails` AS
SELECT
  experiment_group,
  users,
  negative_feedback_rate,
  mean_latency_ms,
  p95_user_latency_ms,
  d7_retention_rate,
  d28_retention_rate
FROM `driiiportfolio.snap_spotlight_growth.vw_guardrail_summary`;

-- Stage-level decisions are produced by the statistical notebook.
-- If persisted, expose them as a table/view named `vw_rollout_stage_summary`.
