# Snapchat Spotlight Algorithmic Engagement & Retention Optimization

**Portfolio Project:** Growth Data Scientist, Level 4 — Snap Inc. alignment
**Req ID:** `Q326DSA4`
**Repository:** `snap-spotlight-growth-ds-l4`
**Google Cloud Project:** `driiiportfolio`
**BigQuery Dataset:** `snap_spotlight_growth`

> This is an independent portfolio project using fully synthetic data. It is designed to demonstrate quantitative analysis, data modeling, experimentation, statistical inference, product metrics, risk/guardrail design, visualization, and executive communication. It does **not** claim access to Snap internal data, systems, algorithms, or confidential business information.

## Business Scenario

Snapchat Spotlight is modeled as a product surface where recommendation changes can create a tradeoff between short-term engagement and longer-term user retention. The portfolio scenario asks whether an **Algorithmic Exploration** recommendation treatment should advance through staged exposure relative to **Standard Recommendations**.

The analytical objective is not to manufacture a successful launch. It is to build an experiment system capable of detecting both positive product effects and harmful downstream effects before broader rollout.

### Business Problem / Challenge / Bottleneck

A recommendation change can increase immediate sharing and exploration while simultaneously increasing negative feedback, latency, fatigue, or longer-term disengagement. A growth team therefore needs a measurement framework that connects:

1. Experiment assignment and integrity.
2. Short-term engagement.
3. Leading retention indicators.
4. D28 retention as the primary long-term outcome.
5. User-experience guardrails.
6. Statistical significance and effect size.
7. Staged-rollout and rollback criteria.

### Methodology

- Generate deterministic synthetic experiment data in Google Colab.
- Load data into BigQuery with an explicit schema/data contract.
- Validate completeness, uniqueness, referential integrity, ranges, and experiment balance.
- Build SQL analytical views for D1/D3/D7/D28 retention, engagement, and guardrails.
- Validate sample-ratio mismatch (SRM) with a chi-square test.
- Estimate treatment effects with confidence intervals and Welch's t-test / equivalent user-level comparisons.
- Use logistic regression to examine associations between early engagement/experience metrics and D28 retention, while clearly distinguishing association from causal effect.
- Evaluate staged exposure using stage-specific cohorts and predefined circuit-breaker rules.
- Publish an executive Looker Studio dashboard from stable BigQuery views.

### Insights

The project is intentionally structured so the result is data-dependent. The final notebook should report observed treatment effects, uncertainty, guardrail movement, and experiment integrity rather than asserting a predetermined launch outcome.

### Next Steps / Recommendations

The final decision should be driven by the completed experiment evidence. The project supports three decision states: **advance to next stage**, **hold for investigation**, or **rollback / do not advance**. The portfolio does not pre-select a winner.

## Technology Stack

- Google Colab — Python generation and statistical analysis
- Python — pandas, NumPy, SciPy, statsmodels, matplotlib
- Google BigQuery — storage, validation, SQL transformation, analytical views
- Looker Studio — executive dashboard
- GitHub — reproducible codebase and documentation

## Repository Structure

```text
snap-spotlight-growth-ds-l4/
├── README.md
├── Executive_Summary.md
├── Project_Disclaimer.md
├── Dashboard_Executive_Summary.md
├── PROCESS_MANUAL.md
├── requirements.txt
├── docs/
│   ├── Business_Scenario.md
│   ├── Data_Flow_Architecture.md
│   ├── Data_Contract.md
│   ├── Experiment_PreMortem_Protocol.md
│   ├── Methodology.md
│   └── Insights_and_Decision_Framework.md
├── notebooks/
│   ├── 00_master_project_runbook.ipynb
│   ├── 01_synthetic_data_generation.ipynb
│   └── 02_causal_inference_ab_testing.ipynb
├── sql/
│   ├── 01_schema_definition.sql
│   ├── 02_data_quality_and_cleaning.sql
│   ├── 03_growth_funnel_views.sql
│   ├── 04_analysis_dataset.sql
│   └── 05_dashboard_views.sql
└── tests/
    └── validation_queries.sql
```

## Order of Operations

1. Read `Project_Disclaimer.md` and `docs/Business_Scenario.md`.
2. Run `notebooks/01_synthetic_data_generation.ipynb`.
3. Run `sql/01_schema_definition.sql`.
4. Load the generated CSVs using the explicit schemas in `docs/Data_Contract.md`.
5. Run `sql/02_data_quality_and_cleaning.sql` and `tests/validation_queries.sql`.
6. Run `sql/03_growth_funnel_views.sql`.
7. Run `sql/04_analysis_dataset.sql`.
8. Run `notebooks/02_causal_inference_ab_testing.ipynb`.
9. Run `sql/05_dashboard_views.sql`.
10. Build Looker Studio from the dashboard views.
11. Record observed findings in `Executive_Summary.md` only after execution.

## Reproducibility Rules

- Random seed: `42` unless deliberately changed and documented.
- User count: `25,000`.
- Session count target: `150,000`.
- Treatment assignment: 50/50 randomized at the user level.
- D28 is defined as **returning on Day 28**, not any return between Days 8–28.
- Treatment parameters are implemented in the generator rather than merely declared.
- No CSV schema autodetection is used for production tables.
- No statistical result is treated as a fact until the analysis notebook computes it.

## Portfolio Alignment

The project demonstrates the job-description capabilities supplied for the Snap Data Scientist Level 4 role: quantitative analysis, data mining, statistical modeling, product metrics, dashboards, cross-functional decision support, project ownership, product sense, and responsible use of AI tools while preserving statistical integrity.
## Prerequisites & Stack
- Google Cloud Platform Account (BigQuery Sandbox, Project ID: `driiiportfolio`)
- Google Colab (Free-Tier Python Runtime)
- Looker Studio (Free Account)
