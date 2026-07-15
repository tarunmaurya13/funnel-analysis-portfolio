# A/B test: contextual welcome banner for youtube.com-referred sessions

## Hypothesis

- **H0 (null):** The contextual welcome banner has no effect on product-view
  rate for youtube.com-referred sessions.
- **H1 (alternative):** The contextual welcome banner increases product-view
  rate for youtube.com-referred sessions.
- One-sided test — testing specifically for improvement, since the fix was
  designed to increase engagement, not just alter it.

## Metrics

- **Primary metric:** Product-view rate among youtube.com-referred sessions
  (actual measured baseline: 1.3%)
- **Guardrail metrics:**
  - Session-to-purchase rate for youtube.com traffic (confirms the banner
    moves people toward purchase, not just a vanity product-page view)
  - Homepage bounce rate / load time overall (confirms the banner doesn't
    slow the page or annoy non-YouTube visitors who also land there)

## Power analysis (done before generating any data)

- Baseline conversion rate: 1.3% (actual measured youtube.com product-view rate)
- Minimum detectable effect (MDE): 1.3% → 2.0% (+0.7pp, ~54% relative lift)
- Significance level (alpha): 0.05
- Power (1-beta): 0.80
- **Required sample size: ~4,049 sessions per arm (~8,098 total)**

At current youtube.com referral volume (~381 sessions/day), this requires a
minimum **~21-day test window**. This is disclosed upfront as a project
constraint, not adjusted after the fact to fit a shorter runtime.

## Simulated data

Data is clearly labeled as **simulated**, sized exactly to the sample size
above. Simulation script: [`analysis/ab_test_simulation.py`](../analysis/ab_test_simulation.py).
Raw session-level output: `analysis/ab_test_simulated_sessions.csv`.

- Control conversion rate simulated at the actual baseline (1.3%)
- Treatment conversion rate simulated at the MDE target (2.0%)
- Outcomes drawn from a binomial distribution per session, seeded for
  reproducibility

## Result

| | Control | Treatment |
|---|---|---|
| Sessions | 4,049 | 4,049 |
| Product views | 48 | 69 |
| Observed rate | 1.19% | 1.70% |
| 95% CI | 0.90%-1.57% | 1.35%-2.15% |

- Absolute lift: +0.52pp
- Relative lift: +43.7%
- Z-statistic: 1.96
- **P-value (one-sided): 0.025 — statistically significant at alpha=0.05**

## Interpretation

The result is statistically significant, but only just past the alpha=0.05
threshold, and the two confidence intervals still overlap slightly
(control's upper bound 1.57% vs. treatment's lower bound 1.35%).
Statistical significance on a two-proportion test does not require
non-overlapping CIs, but the overlap signals this is a real but not
overwhelming effect — worth describing as "directionally positive" rather
than "proven" in a stakeholder-facing summary.

## What could invalidate this result

**Novelty effect.** A new banner often gets more engagement simply because
it is new and different to returning visitors; that lift can fade after a
few weeks as visitors become used to it. A confirmation test run 4-6 weeks
after initial rollout would be needed to rule this out before treating the
lift as permanent.

A secondary risk is weekday/weekend traffic mix imbalance if the ~21-day
test window is not a clean multiple of 7 days, which could skew either
arm if youtube.com referral behavior varies by day of week.
