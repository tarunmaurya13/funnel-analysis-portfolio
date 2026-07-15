# Addendum: multi-day validation and session duration analysis

This addendum extends the original single-day finding in
[`01-kpi-tree.md`](01-kpi-tree.md) with two follow-up investigations that
address its stated limitations.

## 1. Multi-day validation (closes the "single day" limitation)

Query: [`sql/08_multiday_validation.sql`](../sql/08_multiday_validation.sql)

The original finding (youtube.com referral traffic converting to product
views at 1.3% vs. baseline, with an 81.1% bounce rate) was based on one day
(Aug 1, 2016). Re-running the same comparison across Aug 1-7, 2016 confirms
the pattern is stable, not a single-day anomaly:

| Date | Group | Sessions | % viewed product | Bounce rate |
|---|---|---|---|---|
| Aug 1 | All other | 1,330 | 30.8% | 32.0% |
| Aug 1 | youtube.com | 381 | 1.3% | 81.1% |
| Aug 2 | All other | 1,513 | 29.3% | 32.0% |
| Aug 2 | youtube.com | 627 | 2.2% | 77.0% |
| Aug 3 | All other | 1,958 | 28.3% | 35.2% |
| Aug 3 | youtube.com | 932 | 1.2% | 76.2% |
| Aug 4 | All other | 2,301 | 25.0% | 39.1% |
| Aug 4 | youtube.com | 860 | 1.4% | 77.3% |
| Aug 5 | All other | 1,827 | 27.4% | 36.6% |
| Aug 5 | youtube.com | 875 | 1.4% | 73.6% |
| Aug 6 | All other | 981 | 23.0% | 37.8% |
| Aug 6 | youtube.com | 682 | 1.3% | 74.2% |
| Aug 7 | All other | 1,019 | 25.0% | 39.7% |
| Aug 7 | youtube.com | 603 | 1.3% | 78.3% |

**Finding:** youtube.com's product-view rate stays locked in a 1.2%-2.2%
band across all 7 days (vs. 23%-31% baseline), and bounce rate stays at
73.6%-81.1% (vs. 32%-40% baseline) — roughly double, every single day. This
upgrades the finding from a single-day observation to a stable, week-long,
highly consistent pattern.

## 2. Session duration analysis (closes the "landing page vs. bot" ambiguity, partially)

Query: [`sql/09_session_duration_analysis.sql`](../sql/09_session_duration_analysis.sql)
(uses `ROW_NUMBER()` and `LAG()` window functions to reconstruct hit
sequences and compute session duration, per the original SQL methodology.)

| Source group | Sessions | Avg session duration | Avg hits per session |
|---|---|---|---|
| All other sources | 1,330 | 209.1 sec (~3.5 min) | 9.3 |
| youtube.com | 381 | 24.4 sec | 1.5 |

**Finding:** youtube.com sessions last 24.4 seconds on average — 8.5x
shorter than baseline (209.1 seconds) — and touch just 1.5 pages, barely
above the single-pageview bounce already observed. This is "land, glance,
leave" behavior, not "browsed but didn't find the right product."

**Interpretation:** a genuine human clicking through from a YouTube video
description, even if disappointed by the landing page, would typically
need more than 24 seconds and more than 1.5 pages to register a mismatch
and leave. This duration/hit-count evidence shifts the balance of
probability toward automated/bot traffic as the primary explanation, over
a pure landing-page mismatch. This is a stronger, more calibrated
statement than the original finding — but it remains a probability
judgment, not a proof. User-agent or IP-reputation data would be required
to confirm bot traffic definitively; that data is not available in this
dataset and is noted as a limitation.

## Updated recommendation

The recommendation in [`02-rice-prioritization.md`](02-rice-prioritization.md)
is unchanged, but Fix #1 (bot-traffic filtering) is now more strongly
supported by evidence and should be treated as a higher-confidence
prerequisite, not a hedge — the extremely short session duration on
youtube.com traffic is difficult to explain without meaningful bot
contamination in that segment.
