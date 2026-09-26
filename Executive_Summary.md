# Executive Summary: Snapchat Spotlight Algorithmic Engagement & Retention Optimization

## Business Scenario

This portfolio project models a Growth Data Scientist investigation of a recommendation-system change on Snapchat Spotlight. The scenario compares **Standard Recommendations** with **Algorithmic Exploration** and evaluates whether short-term engagement gains are accompanied by acceptable long-term retention and user-experience outcomes.

The scenario is a synthetic analytical exercise aligned to the supplied Snap Data Scientist Level 4 job description. It is not a statement about an actual internal Snap incident or production result.

## Business Problem / Challenge / Bottleneck

Recommendation changes can optimize an immediately visible engagement metric while degrading a slower-moving outcome. The central portfolio challenge is therefore to build a measurement and decision system that identifies product tradeoffs before broad rollout.

## Primary Question

> Does Algorithmic Exploration improve short-term product engagement while maintaining statistically acceptable D28 retention and user-experience guardrails?

## Primary Outcome

**D28 retention:** a user is retained if the user has at least one qualifying session on the calendar day exactly 28 days after the cohort date.

## Experiment Integrity & QA

- **Total randomized users:** 25,000.
- **Observed allocation:** 12,566 Variant / 12,434 Control.
- **SRM test:** p = 0.404; no statistically significant sample-ratio mismatch was detected at the configured 0.05 review level.
- The D1/D3/D7/D28 QA check reconciles the experiment-group counts with the corresponding `days_since_cohort` user counts.
- Day-specific user counts were: D1 = 3,139; D3 = 2,996; D7 = 18,519; D28 = 19,662.
- The retention curve is intentionally synthetic. D7 and D28 are much higher than D1/D3 because the generator explicitly creates Day-7 and Day-28 retention events, while additional ordinary sessions are sampled across Days 1–27. This explains the observed shape and does not by itself indicate a SQL retention-definition error.

## Observed Treatment Effects

| Metric | Control | Variant | Variant − Control | Relative change |
|---|---:|---:|---:|---:|
| D1 retention | 12.72% | 12.39% | -0.33 pp | -2.61% |
| D3 retention | 11.79% | 12.18% | +0.39 pp | +3.27% |
| D7 retention | 74.67% | 73.49% | -1.17 pp | -1.57% |
| D28 retention | 79.82% | 77.49% | **-2.33 pp** | **-2.92%** |
| Shares / user | 5.09 | 6.88 | **+1.79** | **+35.17%** |
| Mean watch completion | 28.6% | 29.4% | +0.80 pp | +2.80% |
| Mean latency | 209.48 ms | 217.29 ms | **+7.81 ms** | **+3.73%** |

The observed pattern is a clear engagement-versus-retention tradeoff: sharing increased materially, watch completion increased modestly, latency also increased, and D28 retention decreased.

## Primary Statistical Result: D28 Retention

- **Control:** 79.82%
- **Variant:** 77.49%
- **Absolute treatment effect:** -2.33 percentage points
- **Relative change:** -2.92%
- **95% confidence interval:** [-3.35, -1.32] percentage points
- **p-value:** 6.59 × 10⁻⁶

> The variant was associated with a 2.33 percentage-point reduction in D28 retention relative to control. The estimated 95% confidence interval ranges from a 1.32 to 3.35 percentage-point reduction, and the test produced p = 6.59 × 10⁻⁶.

The interval remains below zero, so the observed D28 difference is statistically distinguishable from zero under the portfolio's specified inference procedure.

## Guardrails

### Latency

Mean latency increased from **209.48 ms** to **217.29 ms**, a difference of **+7.81 ms (+3.73%)** for the variant. This moved the experience metric in the unfavorable direction.

### Negative Feedback

The portfolio's negative-feedback guardrail showed an elevated variant signal, and the staged decision logic flagged the relative increase against its predefined 50% portfolio threshold. The logistic regression coefficient for `negative_feedback_flag` was **0.0675 (p = 0.081)**. This model result is an association with D28 retention and should not be interpreted as evidence that negative feedback caused the retention decline.

## Secondary Logistic Regression

The D28 logistic regression included `variant`, `retained_d7`, `total_shares`, `avg_watch_completion`, `avg_latency_ms`, and `negative_feedback_flag`.

- `variant`: coefficient = -0.3252, p < 0.001, odds ratio = 0.722.
- `total_shares`: coefficient = +0.1095, p < 0.001, odds ratio = 1.116.
- `retained_d7`: coefficient = -0.0673, p = 0.060.
- `avg_watch_completion` and `avg_latency_ms`: not statistically significant in this model.

This regression is a secondary descriptive/predictive lens. The randomized experiment remains the primary basis for the treatment-effect estimate.

## Staged-Rollout Decision Framework

Under the portfolio's **simulated** staged-rollout decision framework, the evaluated 1%, 5%, 10%, and 100% deterministic portfolio cohorts each returned **ROLLBACK** because the D28 effect breached the configured decline threshold and/or the negative-feedback relative-change threshold.

These are simulated analytical cohorts, **not production exposure stages**.

## Decision Interpretation

The observed evidence supports stopping further simulated exposure under the portfolio's predefined decision rules while investigating the mechanism behind the engagement/retention tradeoff. The analysis should not optimize the short-term engagement lift in isolation.

## Next Steps / Recommendations

1. Preserve the current experiment result; do not regenerate data to remove the observed tradeoff.
2. Investigate the engagement/retention mechanism by `device_os`, `region`, engagement intensity, latency bands, and negative-feedback status.
3. Examine whether the sharing lift is concentrated among users whose longer-term retention deteriorates.
4. Review latency and negative-feedback distributions, not only group means.
5. Use the Looker Studio dashboard to communicate the treatment effect, uncertainty, guardrails, and simulated rollout decision together.
6. If a revised algorithm is proposed, run another controlled experiment with the same retention and guardrail framework.

## Portfolio Disclaimer

All data, treatment effects, user behavior, guardrails, and rollout outputs in this project are synthetic portfolio constructs. They are not internal Snap data, Snap policy, or evidence about actual Snapchat production performance.

## Dashboard Preview SnapShot
<img src="driii_snap_spotlight1.png"alt="Project Screenshot" width="500">

