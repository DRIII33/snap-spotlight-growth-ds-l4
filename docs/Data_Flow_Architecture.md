# Part 1: Data Flow Architecture & System Relationships

```text
Google Colab — Python
        │
        │ deterministic synthetic generation
        ▼
data/dim_users.csv
 data/fact_user_sessions.csv
        │
        │ explicit BigQuery schema
        ▼
BigQuery Project: driiiportfolio
Dataset: snap_spotlight_growth
        │
        ├── dim_users
        ├── fact_user_sessions
        │
        ▼
SQL Validation / Cleaning
        │
        ├── vw_stg_sessions_cleaned
        ├── vw_retention_cohort_daily
        ├── vw_experiment_summary
        ├── vw_guardrail_summary
        └── vw_rollout_stage_summary
        │
        ├─────────────────────┐
        ▼                     ▼
Google Colab             Looker Studio
Statistical Analysis     Executive Dashboard
        │                     │
        └──────────┬──────────┘
                   ▼
          Executive Decision
          Advance / Hold / Rollback
```

## System Relationships

### Python → BigQuery

Python owns synthetic-data generation and writes reproducible CSV artifacts. BigQuery owns the authoritative warehouse schema and transformation layer.

### BigQuery → Statistical Analysis

The statistical notebook queries the user-level analytical dataset. Repeated sessions are aggregated before user-level inference so the unit of analysis matches the randomized unit.

### BigQuery → Looker Studio

Looker Studio reads stable analytical views rather than raw tables. This separates dashboard presentation from raw ingestion.

## Free-Tier Design Principles

- Keep synthetic datasets small enough for interactive analysis.
- Avoid unnecessary table duplication.
- Prefer views over materializing every intermediate dataset.
- Query only required columns.
- Aggregate before repeated dashboard queries where practical.
