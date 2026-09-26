# Methodology

## 1. Experimental Design

Users are randomized 50/50 to Control or Variant. Assignment is fixed at the user level and inherited by all sessions.

## 2. Synthetic Data Generation

The generator uses seed `42` and explicit treatment parameters. It generates cohort dates, user attributes, session events, engagement telemetry, latency, negative feedback, and day-specific return behavior.

The D28 treatment effect is implemented in the probability of a Day-28 return event. It is not merely declared as an unused parameter.

The synthetic generator also explicitly creates Day-7 return events. Ordinary sessions are then sampled across Days 1–27 to reach the target session volume. Consequently, exact-day D7/D28 retention can be materially higher than D1/D3 in this dataset. This is a property of the synthetic data-generating process and should be disclosed in portfolio interpretation.

## 3. Data Quality

Validation covers:

- Nulls in required fields.
- Duplicate user IDs and session IDs.
- Foreign-key integrity.
- Valid experiment groups.
- Valid device/region categories.
- Non-negative metrics.
- Valid completion range.
- Valid timestamp/cohort relationships.
- Reconciliation of exact-day user counts between retention calculations and the cleaned session-day distribution.

## 4. Retention Measurement

Retention is measured at exact day offsets. This avoids labeling an 8–28 day rolling return window as D28 retention.

The QA check confirmed that the experiment-group counts reconcile with the underlying `days_since_cohort` counts for D1, D3, D7, and D28.

## 5. Experiment Integrity

SRM uses a chi-square goodness-of-fit test against the expected 50/50 allocation. The observed SRM p-value was **0.404**.

## 6. Treatment Effects

For binary outcomes, report absolute percentage-point difference, relative lift, confidence interval, and p-value. For continuous user-level outcomes, report mean difference and confidence interval with Welch's t-test where appropriate.

Observed primary D28 result:

- Control: 79.82%
- Variant: 77.49%
- Absolute difference: -2.33 pp
- Relative change: -2.92%
- 95% CI: [-3.35, -1.32] pp
- p-value: 6.59 × 10⁻⁶

## 7. Logistic Regression

Logistic regression is used to identify variables associated with D28 retention. Coefficients are not interpreted as causal treatment effects unless supported by the experimental design and an appropriate causal estimand.

The observed model estimated an odds ratio of **0.722** for the Variant indicator, with p < 0.001, after accounting for the included covariates. This is a secondary model result and does not replace the randomized treatment-effect estimate.

## 8. Guardrail Evaluation

The experiment is evaluated jointly across:

- D28 retention.
- Negative-feedback rate.
- Mean latency.
- P95 user latency where available.
- Experiment integrity.

Observed mean latency increased from 209.48 ms to 217.29 ms. The negative-feedback guardrail also moved in the unfavorable direction and contributed to the staged decision-rule breaches.

## 9. Staged Rollout

Each exposure stage is evaluated using a stage-specific deterministic subset of users. The decision engine checks the primary outcome and guardrails against predeclared thresholds.

Observed portfolio simulation:

| Stage | Decision |
|---:|---|
| 1% | ROLLBACK |
| 5% | ROLLBACK |
| 10% | ROLLBACK |
| 100% | ROLLBACK |

These stages are simulated analytical cohorts, not real production exposure.

## 10. Interpretation Standard

The final interpretation prioritizes the primary outcome and predefined guardrails rather than optimizing a single engagement metric. Statistical significance is reported separately from practical magnitude and user-experience impact.
