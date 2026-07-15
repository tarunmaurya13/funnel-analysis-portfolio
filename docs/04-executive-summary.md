# Executive summary: purchase funnel leakage analysis

## Recommendation

Ship a contextual welcome banner for youtube.com-referred sessions, alongside
bot-traffic filtering as a prerequisite step. This is a low-effort, high-RICE-score
fix targeting the single largest identified leak in the purchase funnel.

## The three numbers that support it

1. **75.7% of sessions never view a product page** — the largest single drop
   in the funnel, and the focus of this analysis. It is not explained by
   device type: desktop, mobile, and tablet convert to product views at a
   nearly identical ~24%.

2. **youtube.com referral traffic converts to product views at 1.3%, versus
   24%+ baseline and 34%+ for organic search** — despite driving 381 sessions
   a day (87.6% of all referral traffic). Its bounce rate (81.1% single
   pageview) is 2.5x the site-wide baseline (32.0%).

3. **A simulated A/B test of a contextual banner, sized to a proper power
   analysis (~4,049 sessions per arm), showed a statistically significant
   +43.7% relative lift** in product-view rate (1.19% to 1.70%, p=0.025,
   one-sided).

## Caveats

- The root-cause finding (youtube.com bounce pattern) is based on a single
  day of data (Aug 1, 2016) and has not yet been validated across a wider
  date range.
- Two unconfirmed explanations remain open for the youtube.com bounce
  pattern: landing-page mismatch, or automated/bot traffic. This dataset
  cannot distinguish between them; user-agent or session-duration data
  would be needed to do so.
- The A/B test result is simulated, not observed. The real-world test
  requires a minimum ~21-day window at current traffic volume to reach the
  required sample size, and the significance level obtained (p=0.025) is
  close to the alpha=0.05 threshold — a real rollout should be treated as
  directionally promising, not conclusively proven, until confirmed live.
- A novelty effect is a plausible confound: a new banner may see inflated
  engagement in its first weeks that fades over time. A follow-up
  confirmation test 4-6 weeks after launch is recommended before treating
  any lift as permanent.
- Organic traffic converts at only 34% (not near-100%), suggesting a
  second, smaller, unaddressed leak may exist outside the scope of this
  analysis.

## Supporting detail

Full methodology, KPI definitions, SQL queries, and the RICE-prioritized
fix list are in this repository:
- [`docs/01-kpi-tree.md`](01-kpi-tree.md) — problem statement and KPI tree
- [`docs/02-rice-prioritization.md`](02-rice-prioritization.md) — full fix list and scoring
- [`docs/03-ab-test-results.md`](03-ab-test-results.md) — power analysis and simulated test results
- [`sql/`](../sql/) — all funnel, segmentation, and root-cause queries
