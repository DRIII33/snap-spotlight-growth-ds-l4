# Dashboard Executive Summary — Snapchat Spotlight Growth & Retention Tradeoff Control Center

## 1. Dashboard Purpose

The Looker Studio dashboard communicates the experiment's **engagement-versus-retention tradeoff** to product, engineering, and analytics stakeholders without replacing the underlying statistical analysis.

The dashboard must make the following relationship immediately visible:

> **Algorithmic Exploration increased short-term engagement, while D28 retention declined and experience guardrails moved in the unfavorable direction.**

All data and results are synthetic portfolio constructs and are not Snap production data or policy.

## 2. Dashboard Title

**Snapchat Spotlight — Algorithmic Exploration Experiment: Engagement vs. Retention Control Center**

## 3. Recommended Dashboard Structure

Use **2 pages** so the executive decision and diagnostic evidence remain visually distinct.

### Page 1 — Executive Decision: Engagement vs. Retention

Purpose: answer "What happened, how large was it, and what is the decision state?" within one screen.

### Page 2 — Diagnostics: Retention, Experience Guardrails & Rollout

Purpose: answer "Where is the tradeoff visible, how strong is the evidence, and what triggered the simulated rollout decision?"

---

# PAGE 1 — Executive Decision: Engagement vs. Retention

## Global Controls

### Filter 1 — Experiment Group
- **Control:** `experiment_group`
- Control values: `Control_Standard_Recs`, `Variant_Algorithmic_Exploration`
- Control type: drop-down list
- Default: All

### Filter 2 — Device OS
- Dimension: `device_os`
- Source: `vw_retention_cohort_daily` or `analysis_dataset`
- Default: All

### Filter 3 — Region
- Dimension: `region`
- Source: `vw_retention_cohort_daily` or `analysis_dataset`
- Default: All

### Date Range
Do **not** add a dashboard-wide date-range control to Page 1. The executive metrics are cohort-level experiment outcomes rather than a time series. A date control would imply event-time trend analysis that these summary views are not designed to represent.

---

## Visual 1 — Primary Decision Scorecard

**Chart type:** Scorecard

**Title:** `D28 Retention — Variant`

**Dimension:** None

**Metric:** `d28_retention_rate`

**Aggregation:** Average of the user-level binary retention indicator, represented by the summary-view metric.

**Format:** Percent, 1 decimal place.

**Filter:** `experiment_group = Variant_Algorithmic_Exploration`

**Comparison:** Optional comparison to `Control_Standard_Recs` if configured through a compatible comparison calculation.

**Caption:** `Primary long-term outcome. Variant D28 retention = 77.49%; control = 79.82%.`

**Business question:** What happened to the primary retention outcome?

---

## Visual 2 — D28 Absolute Treatment Effect

**Chart type:** Scorecard

**Dimension:** None

**Metric:** Calculated field `D28_Absolute_Difference`

**Calculated field:**

```text
D28_Absolute_Difference =
AVG(CASE WHEN experiment_group = 'Variant_Algorithmic_Exploration'
         THEN d28_retention_rate ELSE NULL END)
-
AVG(CASE WHEN experiment_group = 'Control_Standard_Recs'
         THEN d28_retention_rate ELSE NULL END)
```

If the Looker Studio connector does not permit the conditional aggregation in this form, create the treatment effect upstream in BigQuery and expose it as a one-row summary field.

**Format:** Percent; display as percentage points where possible.

**Expected observed value:** `-2.33 pp`

**Caption:** `Absolute D28 difference: variant minus control.`

---

## Visual 3 — D28 Statistical Evidence

**Chart type:** Scorecard or compact table cell

**Metric:** `D28 p-value`

**Value:** `6.59 × 10⁻⁶`

**Format:** Scientific/decimal text; do not format as a percent.

**Caption:** `Two-sided test result for the observed D28 treatment difference.`

A second scorecard should display the **95% CI** as text: `-3.35 pp to -1.32 pp`.

**Important:** Do not label this visual "confidence of success" or otherwise translate the p-value into a product recommendation.

---

## Visual 4 — Short-Term Engagement Scorecard

**Chart type:** Scorecard

**Dimension:** None

**Metric:** `mean_shares_per_user`

**Aggregation:** Average

**Filter:** Variant

**Format:** Number, 2 decimal places.

**Comparison:** Control value 5.09 versus Variant 6.88.

**Caption:** `Sharing increased from 5.09 to 6.88 shares/user (+35.17% relative).`

---

## Visual 5 — Engagement vs. Retention Tradeoff

**Chart type:** Horizontal bar chart

**Dimension:** `experiment_group`

**Metric:** `mean_shares_per_user`

**Aggregation:** Average

**Format:** Number, 2 decimals.

**Sort:** `mean_shares_per_user`, DESC.

**Caption:** `The variant produces substantially higher sharing while D28 retention moves in the opposite direction.`

**Business question:** Did the treatment improve the immediate engagement behavior it was designed to influence?

---

## Visual 6 — Retention Trajectory

**Chart type:** Line chart

**Dimension:** `retention_day`

**Breakdown dimension:** `experiment_group`

**Metric:** `retention_rate`

**Aggregation:** Average / precomputed rate.

**Dimension values:** 1, 3, 7, 28 only.

**Sort:** `retention_day`, ASC.

**Format:** Percent, 1 decimal place.

**Date range:** None.

**Required dashboard-prep source:** create a long-form dashboard view such as `vw_dashboard_retention_curve` from the user-level analytical data with columns:
- `experiment_group`
- `retention_day`
- `retention_rate`
- `users`

The long-form view should contain one row per experiment group per retention day for D1, D3, D7, and D28.

**Caption:** `Exact-day retention shows a mixed early pattern followed by a lower D7 and D28 rate for the variant.`

**Business question:** Does the treatment effect persist, disappear, or reverse as the retention horizon increases?

---

## Visual 7 — Executive KPI Comparison Table

**Chart type:** Table

**Dimension:** `experiment_group`

**Metrics:**
- `users`
- `d7_retention_rate`
- `d28_retention_rate`
- `mean_shares_per_user`
- `mean_watch_completion`
- `mean_latency_ms`
- `p95_user_latency_ms`
- `negative_feedback_rate`

**Aggregations:** As supplied by `vw_dashboard_executive`; do not re-average an already aggregated summary field if the connector would double-aggregate it.

**Formats:**
- users = Number, 0 decimals
- retention = Percent, 1 decimal
- shares = Number, 2 decimals
- watch completion = Percent, 1 decimal
- latency = Number with `ms` suffix
- negative feedback = Percent, 2 decimals

**Sort:** `experiment_group`, ASC or fixed control-first ordering.

**Caption:** `Control-versus-variant operating scorecard across retention, engagement, and experience metrics.`

---

# PAGE 2 — Diagnostics: Retention, Experience Guardrails & Rollout

## Visual 8 — D28 Retention Difference Bar

**Chart type:** Column chart

**Dimension:** `experiment_group`

**Metric:** `d28_retention_rate`

**Aggregation:** Average/precomputed rate.

**Format:** Percent, 1 decimal.

**Sort:** Fixed order with Control first and Variant second. If sorting is required, use a calculated `group_order` field and sort `group_order`, ASC.

**Caption:** `Variant D28 retention is 2.33 percentage points below control.`

---

## Visual 9 — Mean Latency Guardrail

**Chart type:** Column chart

**Dimension:** `experiment_group`

**Metric:** `mean_latency_ms`

**Aggregation:** Average/precomputed mean.

**Format:** Number, 1–2 decimals with `ms` suffix.

**Sort:** `mean_latency_ms`, DESC.

**Caption:** `Mean latency increased by 7.81 ms (+3.73%) for the variant.`

---

## Visual 10 — P95 Latency Guardrail

**Chart type:** Column chart

**Dimension:** `experiment_group`

**Metric:** `p95_user_latency_ms`

**Aggregation:** Use the precomputed p95 value; do not calculate a simple average of p95 values.

**Format:** Number, 0–1 decimals with `ms` suffix.

**Sort:** `p95_user_latency_ms`, DESC.

**Caption:** `P95 user latency provides a tail-performance view that complements the mean latency metric.`

---

## Visual 11 — Negative Feedback Guardrail

**Chart type:** Column chart

**Dimension:** `experiment_group`

**Metric:** `negative_feedback_rate`

**Aggregation:** Average/precomputed rate.

**Format:** Percent, 2 decimals.

**Sort:** `negative_feedback_rate`, DESC.

**Caption:** `Negative-feedback rate is a predefined experience guardrail; the variant's increase contributed to the rollback-rule breach.`

---

## Visual 12 — Guardrail Comparison Table

**Chart type:** Table with conditional formatting

**Dimension:** `experiment_group`

**Metrics:**
- `negative_feedback_rate`
- `mean_latency_ms`
- `p95_user_latency_ms`
- `d7_retention_rate`
- `d28_retention_rate`

**Format:** Percent for rates; milliseconds for latency.

**Sort:** `experiment_group`, ASC/fixed control-first.

**Caption:** `Guardrails and long-term retention should be evaluated jointly rather than independently.`

---

## Visual 13 — Simulated Rollout Decision

**Chart type:** Table

**Source:** persisted output from the statistical notebook, exposed as `vw_rollout_stage_summary` or an equivalent BigQuery table.

**Dimensions:**
- `exposure_rate`
- `decision`

**Metrics:**
- `eligible_users`
- `d28_difference`
- `negative_feedback_relative_change`

**Formats:**
- exposure_rate = Percent, 0–2 decimals
- eligible_users = Number, 0 decimals
- d28_difference = Percentage points, 2 decimals
- negative_feedback_relative_change = Percent, 1 decimal
- decision = Text

**Sort:** `exposure_rate`, ASC.

**Caption:** `Simulated deterministic portfolio cohorts evaluated by the predefined decision engine; these are not production rollout exposures.`

**Observed decisions:** 1%, 5%, 10%, and 100% = `ROLLBACK`.

---

## Visual 14 — Treatment Effect / Guardrail Matrix

**Chart type:** Scatter chart

**Dimension:** `experiment_group`

**X metric:** `mean_shares_per_user`

**Y metric:** `d28_retention_rate`

**Bubble size:** `users`

**Aggregation:** Average/precomputed values.

**Format:** X = Number; Y = Percent; bubble size = Number.

**Sort:** Not applicable for scatter positioning.

**Caption:** `The variant occupies a higher-engagement but lower-D28-retention position, making the product tradeoff visually explicit.`

**Business question:** Is the engagement gain aligned with the long-term outcome, or does the treatment create a measurable tradeoff?

---

## Visual 15 — Device / Region Diagnostic

**Chart type:** Pivot table or heatmap-style table

**Dimension:** `device_os`

**Breakdown dimension:** `region`

**Metrics:**
- `retained_d28`
- `total_shares`
- `avg_latency_ms`
- `negative_feedback_flag`

**Aggregation:** Average for binary/rate fields; Average for user-level shares/latency.

**Filter:** Experiment group selector.

**Sort:** `retained_d28`, DESC.

**Format:** Retention/feedback = Percent; shares = Number; latency = ms.

**Caption:** `Diagnostic segmentation for identifying whether the engagement-retention tradeoff is concentrated in a specific device or region.`

This visual is diagnostic only. Do not infer a causal subgroup effect from descriptive differences without a dedicated interaction/heterogeneity analysis.

---

# 4. Dashboard Scorecard / Visualization Rules

## Primary Story Order

1. D28 retention and treatment effect.
2. Statistical uncertainty.
3. Short-term engagement movement.
4. Retention trajectory.
5. Latency and negative-feedback guardrails.
6. Simulated rollout decision.
7. Diagnostic segmentation.

## Formatting Standards

- Percentages: one decimal for major retention metrics; two decimals for negative-feedback rates where small values need precision.
- Percentage-point effects: explicitly label `pp`; do not call a percentage-point difference a percent change.
- Relative changes: percent format.
- Latency: milliseconds (`ms`), not seconds.
- Shares/user: numeric with two decimals.
- p-values: decimal/scientific notation, not percent.
- Confidence intervals: display lower and upper bounds in percentage points.
- Currency: not applicable to this dashboard; no `$` formatting should be used.
- Text decisions such as `ROLLBACK` should remain text fields.

## Captions

Every chart must have a short caption directly beneath or adjacent to the visual. Captions should state what the visual shows and why it matters, not repeat the chart title.

## Statistical Integrity

- Do not use dashboard visualizations to recompute causal effects from session-level rows.
- Use the one-row-per-user `analysis_dataset` or dashboard summary views for experiment metrics.
- Do not describe the logistic regression as proving causality.
- Do not describe simulated rollout stages as actual production exposure.
- Preserve the observed result; do not regenerate the synthetic dataset merely because the result triggered rollback.

## Synthetic Data Disclosure

Place a visible note in the dashboard footer:

> **Synthetic portfolio analysis:** Data, treatment effects, user behavior, guardrail thresholds, and rollout outputs are synthetic constructs created for a reproducible Data Scientist portfolio project. They are not internal Snap data, Snap production results, or Snap policy.

## Recommended Page-Level Footer

`Source: BigQuery — driiiportfolio.snap_spotlight_growth | Analysis grain: randomized user | Synthetic portfolio data | D28 = exact Day-28 retention`
