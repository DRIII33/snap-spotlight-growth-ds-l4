# PROJECT BLUEPRINT: SNAPCHAT SPOTLIGHT ALGORITHMIC ENGAGEMENT & RETENTION OPTIMIZATION
## Complete End-to-End Reproducible Portfolio Project & Process Manual

**Target Role:** Data Scientist, Level 4 — Growth  
**Req ID:** `Q326DSA4`  
**GitHub Repository:** `snap-spotlight-growth-ds-l4`  
**Google Cloud Project:** `driiiportfolio`  
**BigQuery Dataset:** `snap_spotlight_growth`

## Business Scenario

A hypothetical product team evaluates an Algorithmic Exploration recommendation treatment for Snapchat Spotlight against Standard Recommendations. The treatment may improve short-term sharing and exploration, but the product team must determine whether the change preserves longer-term retention and user experience.

## Business Problem / Challenge / Bottleneck

The portfolio demonstrates how a Data Scientist can prevent a single growth KPI from masking longer-term product risk by connecting experimentation, product metrics, data quality, causal inference, predictive modeling, guardrails, staged exposure, and executive communication.

## Methodology

Synthetic data generation → explicit BigQuery data contract → quality validation → SQL analytical layer → user-level experiment analysis → SRM → treatment effects → regression → guardrail evaluation → staged rollout → Looker Studio.

## Insights

The executed synthetic experiment produced a measurable engagement-versus-retention tradeoff. The variant increased shares/user from 5.09 to 6.88 (+35.17%) while D28 retention decreased from 79.82% to 77.49% (-2.33 percentage points; 95% CI: -3.35 to -1.32 pp; p = 6.59 × 10⁻⁶). Mean latency increased by 7.81 ms (+3.73%), and the negative-feedback guardrail contributed to rollback-rule breaches.

The D1/D3/D7/D28 QA check reconciled the group-level retention counts with the underlying session-day distribution. The unusual D7/D28 shape is consistent with the synthetic generator's explicit Day-7/Day-28 return-event design and is documented as a synthetic modeling characteristic.

The staged rollout decision engine returned `ROLLBACK` for the simulated 1%, 5%, 10%, and 100% cohorts. These are portfolio simulations, not production exposure.

## Next Steps / Recommendations

The core experiment and QA are complete. The next phase is dashboard configuration and mechanism analysis. The dashboard should center the observed engagement-versus-retention tradeoff, statistical evidence, guardrails, and simulated rollout decisions.

Recommended follow-up analysis includes segmentation by device OS, region, engagement intensity, latency bands, and negative-feedback status.

# PART 1: DATA FLOW ARCHITECTURE & SYSTEM RELATIONSHIPS

See `docs/Data_Flow_Architecture.md`. The architecture remains the original portfolio architecture: Colab → BigQuery → statistical analysis → Looker Studio → GitHub documentation.

# PART 2: GITHUB REPOSITORY DOCUMENTATION

The repository contains:

- `README.md`
- `Executive_Summary.md`
- `Project_Disclaimer.md`
- `Dashboard_Executive_Summary.md`
- `docs/Business_Scenario.md`
- `docs/Data_Flow_Architecture.md`
- `docs/Data_Contract.md`
- `docs/Experiment_PreMortem_Protocol.md`
- `docs/Methodology.md`
- `docs/Insights_and_Decision_Framework.md`

# PART 3: REPRODUCIBLE CODE CODEBASE

- `notebooks/01_synthetic_data_generation.ipynb`
- `notebooks/02_causal_inference_ab_testing.ipynb`
- `sql/01_schema_definition.sql`
- `sql/02_data_quality_and_cleaning.sql`
- `sql/03_growth_funnel_views.sql`
- `sql/04_analysis_dataset.sql`
- `sql/05_dashboard_views.sql`
- `tests/validation_queries.sql`

# PART 4: PHASE-BY-PHASE PROCESS MANUAL (ORDER OF OPERATIONS)

1. Environment and repository initialization.
2. Synthetic data generation.
3. Explicit BigQuery schema creation.
4. Explicit data load.
5. Data quality validation.
6. Analytical view creation.
7. User-level statistical analysis.
8. Staged rollout evaluation.
9. Dashboard view creation.
10. Executive documentation and GitHub publication.

## Restructuring Principles Applied

1. One authoritative data contract.
2. Exact-day D28 retention rather than an 8–28 day rolling proxy.
3. Treatment parameters must affect generated outcomes.
4. User is the experiment unit for user-level inference.
5. Explicit BigQuery schema; no CSV autodetection.
6. Staged rollout uses stage-specific user cohorts.
7. Statistical conclusions remain data-dependent.
8. Synthetic assumptions are clearly labeled as synthetic.
