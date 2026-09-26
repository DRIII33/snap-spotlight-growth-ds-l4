# Insights & Decision Framework

## 1. Experiment Integrity

### Observed Result

- Total users: **25,000**
- Variant: **12,566**
- Control: **12,434**
- SRM p-value: **0.404**

The SRM check did not identify statistically significant sample-ratio mismatch at the configured 0.05 review level.

### D1/D3/D7/D28 QA Reconciliation

The exact-day retention definitions reconcile with the underlying session-day distribution:

| Retention day | Total users with a session | Control | Variant |
|---|---:|---:|---:|
| D1 | 3,139 | 1,582 | 1,557 |
| D3 | 2,996 | 1,466 | 1,530 |
| D7 | 18,519 | 9,284 | 9,235 |
| D28 | 19,662 | 9,925 | 9,737 |

The group counts sum exactly to the overall counts at each tested day. This supports the interpretation that the D1/D3/D7/D28 calculations are using the intended exact-day session events.

The unusual shape of the synthetic retention curve is explained by the generator: Day-7 and Day-28 return events are explicitly sampled, while ordinary sessions are additionally distributed across Days 1–27. Therefore D7/D28 are expected to be substantially higher than D1/D3 in this synthetic dataset.

## 2. Engagement Effect

| Metric | Control | Variant | Difference | Relative change |
|---|---:|---:|---:|---:|
| Mean shares / user | 5.09 | 6.88 | +1.79 | +35.17% |
| Mean watch completion | 28.6% | 29.4% | +0.80 pp | +2.80% |

The largest short-term engagement movement is sharing, which increased by approximately 35.2% relative to control.

## 3. Retention Effect

| Metric | Control | Variant | Absolute difference | Relative change |
|---|---:|---:|---:|---:|
| D1 | 12.72% | 12.39% | -0.33 pp | -2.61% |
| D3 | 11.79% | 12.18% | +0.39 pp | +3.27% |
| D7 | 74.67% | 73.49% | -1.17 pp | -1.57% |
| D28 | 79.82% | 77.49% | **-2.33 pp** | **-2.92%** |

The primary D28 estimate is:

- Difference: **-2.33 percentage points**
- 95% CI: **[-3.35, -1.32] percentage points**
- p-value: **6.59 × 10⁻⁶**

## 4. Guardrails

### Latency

Mean latency increased from 209.48 ms to 217.29 ms, or **+7.81 ms (+3.73%)**.

### Negative Feedback

The observed negative-feedback signal increased for the variant and contributed to the staged decision-rule breaches. The portfolio threshold is a synthetic governance assumption, not a Snap production standard.

The negative-feedback logistic regression coefficient was **0.0675 with p = 0.081**. This is not statistically significant at 0.05 and should be presented as a weak/non-significant association in the secondary model, not as a causal explanation.

## 5. Predictive / Associational Analysis

The logistic regression for D28 retention produced:

| Feature | Coefficient | p-value | Odds ratio | Interpretation |
|---|---:|---:|---:|---|
| Variant | -0.3252 | <0.001 | 0.722 | Lower adjusted odds of D28 retention in the model |
| Total shares | +0.1095 | <0.001 | 1.116 | Positive association with D28 retention |
| Retained D7 | -0.0673 | 0.060 | 0.935 | Not statistically significant at 0.05 |
| Negative feedback | +0.0675 | 0.081 | ~1.070 | Not statistically significant at 0.05 |

The regression is not the primary causal estimator. Its role is to provide a secondary descriptive/predictive lens on the user-level data.

## 6. Staged Rollout Decision

The notebook's simulated staged decision engine evaluated deterministic portfolio cohorts at 1%, 5%, 10%, and 100% exposure.

**Observed decision:** `ROLLBACK` at each evaluated stage.

The decision rule triggers when either:

- D28 treatment difference is below the configured **-1.0 percentage-point** threshold; or
- negative-feedback relative change exceeds the configured **50%** threshold.

The staged cohorts are a **portfolio simulation** and do not represent actual production rollout exposure.

## 7. Decision Narrative

> The Algorithmic Exploration variant generated a substantial short-term engagement lift, particularly in sharing, but this improvement was accompanied by higher latency, elevated negative-feedback signals, and a statistically significant deterioration in D28 retention. The estimated D28 treatment effect was -2.33 percentage points (95% CI: -3.35 to -1.32 pp; p = 6.59 × 10⁻⁶). Because the primary retention outcome and predefined guardrails moved beyond the portfolio's rollback thresholds, the simulated rollout decision engine consistently returned ROLLBACK. The appropriate next step is to investigate the mechanism underlying the engagement/retention tradeoff before considering another controlled exposure.

## 8. Required Analytical Follow-Up

1. Segment treatment effects by device OS and region.
2. Compare high- and low-engagement users.
3. Analyze latency bands and their relationship to retention.
4. Compare negative-feedback incidence and severity by experiment group.
5. Determine whether the sharing lift is concentrated in users with lower subsequent retention.
6. Preserve the observed experiment result and use the dashboard for executive communication.
