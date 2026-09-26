# Part 4: Phase-by-Phase Process Manual (Order of Operations)

## Phase 0 — Read and Freeze the Contract

1. Read `README.md`.
2. Read `Project_Disclaimer.md`.
3. Read `docs/Data_Contract.md`.
4. Do not change column names after the first BigQuery load without updating the complete repository.

## Phase 1 — Environment & Repository Initialization

1. Create the GitHub repository `snap-spotlight-growth-ds-l4`.
2. Create the repository directories shown in `README.md`.
3. Open Google Colab.
4. Authenticate to Google Cloud only when a BigQuery operation is required.
5. Confirm project ID `driiiportfolio`.

## Phase 2 — Synthetic Data Generation

1. Run `notebooks/01_synthetic_data_generation.ipynb`.
2. Confirm `25,000` users.
3. Confirm approximately `150,000` sessions.
4. Confirm no required-field nulls.
5. Confirm 50/50 experiment assignment within expected random variation.
6. Inspect D1/D3/D7/D28 return rates before uploading.
7. Save `data/dim_users.csv` and `data/fact_user_sessions.csv`.

## Phase 3 — BigQuery Schema

1. Run `sql/01_schema_definition.sql`.
2. Confirm the dataset exists.
3. Confirm every table field and mode.
4. Do not use CSV schema autodetection.

## Phase 4 — BigQuery Load

Use either BigQuery Console with the documented explicit schema or the DataFrame loader in the generation notebook.

`user_id` must remain `STRING REQUIRED` in both the dimension and fact table.

## Phase 5 — Data Quality

Run:

- `sql/02_data_quality_and_cleaning.sql`
- `tests/validation_queries.sql`

Do not proceed until required validation checks pass.

## Phase 6 — Analytical Views

Run:

- `sql/03_growth_funnel_views.sql`
- `sql/04_analysis_dataset.sql`

Confirm the user-level analysis dataset contains one row per randomized user.

## Phase 7 — Statistical Analysis

Run `notebooks/02_causal_inference_ab_testing.ipynb`.

The notebook should produce:

- SRM result.
- Group counts.
- D1/D3/D7/D28 estimates.
- Effect sizes.
- Confidence intervals.
- Engagement effects.
- Guardrail effects.
- Logistic regression.
- Staged rollout decisions.

## Phase 8 — Dashboard

Run `sql/05_dashboard_views.sql`.

Connect Looker Studio to the resulting views. Do not connect the dashboard directly to raw tables unless there is a specific reason.

## Phase 9 — Executive Review

Update:

- `Executive_Summary.md`
- `Dashboard_Executive_Summary.md`

Only with observed results.

## Phase 10 — GitHub Publication

Commit in logical stages:

```bash
git add .
git commit -m "Build synthetic experiment data pipeline"
git commit -m "Add BigQuery analytical layer"
git commit -m "Add causal inference and guardrail analysis"
git commit -m "Add executive dashboard specification"
```

Push to the repository after reviewing for secrets, credentials, and generated artifacts that should not be committed.

## Error Handling

### `Field user_id has changed mode from REQUIRED to NULLABLE`

The incoming schema is nullable while the destination is required. Re-run the load with an explicit `STRING REQUIRED` schema or recreate the destination table from `01_schema_definition.sql`.

### `Dataset ... was not found`

Run `01_schema_definition.sql` first and confirm the project/dataset location.

### `Expected ")" or "," but got identifier "REQUIRED"`

The SQL DDL syntax is invalid. BigQuery standard SQL uses `NOT NULL` in a column definition; `REQUIRED` belongs to API schema configuration rather than the DDL syntax used in the failed notebook cell.

### Metric mismatch

Stop execution. Compare the CSV column names, `docs/Data_Contract.md`, BigQuery schema, SQL views, and analysis notebook. Do not patch individual queries until the contract is reconciled.
