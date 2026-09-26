# Business Scenario

## Context

Snap Inc.'s supplied job description describes a Data Science and Insights team responsible for turning large datasets into actionable insights, improving product decisions, designing core metrics, collaborating cross-functionally, and maintaining statistical integrity. This portfolio scenario is designed around those responsibilities.

## Scenario

A hypothetical product team is evaluating an **Algorithmic Exploration** recommendation treatment for Snapchat Spotlight. The treatment is designed to expose users to a broader range of content than the **Standard Recommendations** control.

The product hypothesis is that broader exploration can increase short-term sharing and discovery. The risk hypothesis is that broader exploration may introduce content that is less aligned with user preferences, increase negative feedback, or reduce longer-term return behavior.

## Business Problem / Challenge / Bottleneck

The product team cannot rely on a single engagement KPI to judge the treatment. A valid decision requires:

- Experiment integrity.
- Clear primary and secondary metrics.
- Long-term retention measurement.
- User-experience guardrails.
- Statistical uncertainty.
- Staged rollout criteria.
- Explicit rollback conditions.

## Business Questions

1. Is the treatment assignment balanced?
2. Does the treatment change short-term engagement?
3. Does the treatment change D1, D3, D7, or D28 retention?
4. Does the treatment affect negative feedback or latency?
5. Which early user/session characteristics are associated with D28 retention?
6. Does the evidence support advancing, holding, or rolling back the next exposure stage?

## Methodology

The project uses Python for deterministic synthetic data generation and statistical analysis, BigQuery for warehouse storage and SQL transformations, and Looker Studio for executive communication.

## Insights

The project is designed to produce observed findings rather than a predetermined conclusion. The final interpretation must distinguish:

- causal treatment effects from associations;
- statistical significance from practical significance;
- leading indicators from mature outcomes;
- experiment integrity from product desirability.

## Next Steps / Recommendations

After execution, the analyst documents the observed evidence, guardrail state, uncertainty, and rollout decision. Recommendations must be traceable to the computed results.
