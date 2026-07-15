# RICE-prioritized fix list

## Context

The Sessions → Product-View leak (75.7% of sessions never view a product) is not
explained by device (desktop/mobile/tablet convert nearly identically at ~24%).
It is concentrated in referral traffic (3.4% vs. 24%+ baseline), and within
referral, almost entirely attributable to `youtube.com`, which drives 87.6% of
referral sessions at a 1.3% product-view rate and an 81.1% single-pageview
(bounce) rate — 2.5x the baseline bounce rate of 32.0%.

Two plausible, unconfirmed explanations for the youtube.com pattern:
1. Landing-page mismatch — visitors arrive expecting content related to a
   specific video and land on a generic homepage instead.
2. Automated/bot traffic misattributed as referral sessions — a known,
   common contaminant in referral data from video platforms.

Distinguishing between these would require user-agent or session-duration
data not available in this dataset. This is a stated limitation, not a gap
papered over with an assumption.

Fixes below target this specific, evidenced root cause — not generic
e-commerce best practices unrelated to what the data actually showed.

## Fix list

| # | Fix | What it addresses |
|---|---|---|
| 1 | Filter/exclude suspected bot traffic from analytics before reporting | Data-quality issue — if bots are inflating "referral sessions," the entire referral conversion rate is understated and could mislead business decisions |
| 2 | Build a dedicated landing page for top referral sources (starting with youtube.com) instead of sending them to the generic homepage | Landing-page mismatch hypothesis — give YouTube visitors content matching what they clicked from |
| 3 | Add UTM-level tracking to identify which specific videos/creators drive this traffic | Currently only the domain (youtube.com) is known, not the individual video — without this, fix #2 can't be properly targeted |
| 4 | A/B test a "video visitors" welcome banner or contextual CTA on the homepage | Lower-effort alternative to a full dedicated landing page |
| 5 | Investigate whether the Sessions → Product-View drop is also present on non-referral traffic (organic converts at only 34%) | This finding explains referral traffic specifically, but organic still only converts at 34% — worth flagging as a possible second, unrelated leak untouched by this fix |

## RICE scoring

Reach = sessions affected (out of ~1,711 daily sessions). Impact = 1 (low) /
2 (medium) / 3 (high), estimated effect on the target metric if the fix
works. Confidence = how sure the fix will work as intended. Effort =
person-weeks. Score = (Reach × Impact × Confidence) / Effort.

| Fix | Reach | Impact | Confidence | Effort | RICE score |
|---|---|---|---|---|---|
| 4. Contextual welcome banner | 381 | 2 | 60% | 0.5 wk | **~914** |
| 1. Filter bot traffic | 381 | 1 | 90% | 0.5 wk | **~686** |
| 3. UTM video-level tracking | 381 | 1 | 95% | 1 wk | **~362** |
| 2. Dedicated YouTube landing page | 381 | 3 | 50% | 2 wks | **~286** |
| 5. Investigate organic/direct leak | 362+ (unsized) | unknown | — | 1 wk | not scorable yet — needs its own investigation first |

## Recommendation

**Primary pick: Fix #4 — contextual welcome banner.** Cheapest, fastest to
ship, and testable within a week; even a partial improvement to the 81%
bounce rate has outsized impact relative to effort.

**Sequencing note:** Fix #1 (bot filtering) should be done before or
alongside Fix #4, not scored purely on its own merits as a "growth" fix. If
a meaningful share of the 381 youtube.com sessions are bots, any A/B test
on the banner would be measuring against noisy, partially non-human
traffic — the bot-filtering step is a prerequisite for trusting the test
result, not just an independent nice-to-have.
