# Experiment Pre-Mortem & Governance Protocol

## Purpose

The pre-mortem identifies plausible failure modes before the treatment is advanced through staged exposure.

## Counter-Hypotheses

### Hypothesis A — Exploration Fatigue

Broader content exploration may increase curiosity and sharing while reducing longer-term content affinity.

### Hypothesis B — Negative Feedback

Greater content variance may increase hide/skip/exit-like signals represented here by synthetic negative feedback.

### Hypothesis C — Performance Tradeoff

The treatment may alter latency, potentially offsetting engagement gains.

## Observed Evidence Against the Failure Modes

The executed experiment produced a pattern consistent with the pre-mortem risks:

- Shares/user increased from 5.09 to 6.88 (+35.17%).
- Mean watch completion increased from 28.6% to 29.4% (+0.80 pp).
- Mean latency increased from 209.48 ms to 217.29 ms (+7.81 ms).
- D28 retention decreased from 79.82% to 77.49% (-2.33 pp; 95% CI [-3.35, -1.32] pp; p = 6.59 × 10⁻⁶).
- Negative-feedback guardrail movement contributed to rollback-rule breaches.

These observations do not establish the mechanism of the retention decline. They identify the engagement/retention tradeoff as the next analytical question.

## Guardrails

The portfolio uses configurable thresholds rather than presenting thresholds as Snap production standards.

Example portfolio thresholds:

- D28 absolute decline greater than `1.0 percentage point` → investigate / potential rollback.
- Negative-feedback relative increase greater than `50%` → investigate / potential rollback.
- SRM p-value below `0.001` → experiment-integrity alert.
- P95 latency above the configured threshold → performance alert.

These values are **portfolio assumptions**, not statements of Snap policy.

## Rollout States

- `ADVANCE`: no predefined critical condition triggered and evidence supports continued evaluation.
- `HOLD`: evidence is incomplete, mixed, or requires investigation.
- `ROLLBACK`: a predefined critical condition is triggered.

## Observed Simulated Rollout

The staged decision engine returned `ROLLBACK` for the 1%, 5%, 10%, and 100% deterministic portfolio cohorts. This is a simulation of the decision framework and must not be described as actual production exposure.

## Governance Principle

A launch decision is not based on a single p-value. Effect size, uncertainty, experiment integrity, user experience, and business context must be considered together.
