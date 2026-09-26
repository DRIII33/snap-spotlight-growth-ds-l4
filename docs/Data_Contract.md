# Data Contract

## Project

`driiiportfolio`

## Dataset

`snap_spotlight_growth`

## `dim_users`

| Column | Type | Mode | Definition |
|---|---|---|---|
| user_id | STRING | REQUIRED | Synthetic stable user identifier |
| cohort_date | DATE | REQUIRED | Experiment cohort/onboarding date |
| device_os | STRING | REQUIRED | iOS or Android |
| region | STRING | REQUIRED | Synthetic geographic segment |
| experiment_group | STRING | REQUIRED | Control or Variant assignment |

## `fact_user_sessions`

| Column | Type | Mode | Definition |
|---|---|---|---|
| session_id | STRING | REQUIRED | Synthetic session identifier |
| user_id | STRING | REQUIRED | Foreign key to dim_users |
| session_timestamp | TIMESTAMP | REQUIRED | Session event timestamp |
| avg_watch_completion | FLOAT64 | REQUIRED | Session-level average watch completion proportion |
| avg_latency_ms | INT64 | REQUIRED | Session latency in milliseconds |
| total_shares | INT64 | REQUIRED | Shares associated with session |
| negative_feedback_flag | INT64 | REQUIRED | Session-level negative-feedback indicator |

## Metric Definitions

### D1 / D3 / D7 / D28 Retention

A user is retained at day N if the user has at least one qualifying session on the calendar day exactly N days after cohort date.

### Shares per User

Sum of `total_shares` across the user's sessions.

### Negative Feedback Rate

Proportion of users with at least one session where `negative_feedback_flag = 1`.

### Latency

User-level mean latency is the mean of session-level `avg_latency_ms`; P95 latency is calculated from session-level latency values.

## Schema Rule

CSV autodetection is not authoritative. The BigQuery schema in `01_schema_definition.sql` is the source of truth. The explicit schema must be used when loading DataFrames/CSV files.
