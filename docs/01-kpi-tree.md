# Funnel analysis — problem statement, KPI tree, and initial finding

## Problem statement

The Google Merchandise Store, accessed via Google Analytics's public GA360 sample dataset (Aug 2016–Aug 2017 session logs), is a mid-size online retailer with a multi-stage purchase funnel. Overall purchase conversion is low relative to top-of-funnel traffic, and it's unclear which stage of the funnel is responsible for the largest drop-off. This analysis identifies the highest-leakage funnel stage — segmented by device and traffic source — and recommends the highest-confidence fix to test first.

## KPI tree

Sessions → Product Page Views → Add-to-Cart → Checkout Started → Purchase Completed

| Stage | Definition (field mapping) |
|---|---|
| Sessions | One row per `(fullVisitorId, visitId)` pair |
| Product Page Views | Session has ≥1 hit where `hits.eCommerceAction.action_type = '2'` |
| Add-to-Cart | Session has ≥1 hit where `hits.eCommerceAction.action_type = '3'` |
| Checkout Started | Session has ≥1 hit where `hits.eCommerceAction.action_type = '5'` |
| Purchase Completed | Session has ≥1 hit where `hits.eCommerceAction.action_type = '6'` |

## Initial hypothesis (pre-data)

The biggest suspected leak is Add-to-Cart → Checkout Started. Product-page-view and add-to-cart events are typically low-friction browsing actions, while reaching the checkout page requires intent plus a working cart/session-continuity path — this is where GA-tracked e-commerce sites usually show the steepest device-split drop (mobile checkout friction is a known pattern). This was a hypothesis to test in Week 1's SQL, not a finding.

## Actual result (Aug 1, 2016 — single day, `ga_sessions_20160801`)

| Stage | Count | Conversion from previous stage |
|---|---|---|
| Total sessions | 1,711 | — |
| Product views | 415 | 24.3% |
| Add to cart | 132 | 31.8% |
| Checkout started | 56 | 42.4% |
| Purchases | 34 | 60.7% |

Query: [`sql/03_funnel_stage_counts.sql`](../sql/03_funnel_stage_counts.sql)

## Revised finding

**Hypothesis was Add-to-Cart → Checkout; actual data shows Sessions → Product-View is the largest leak. Revising focus accordingly.**

The two largest relative drop-offs are:
1. **Sessions → Product Views** (75.7% of sessions never view a single product)
2. **Product Views → Add-to-Cart** (68.2% of product-viewers never add to cart)

Checkout → Purchase is the *strongest*-converting stage in the funnel (60.7%), not a leak — this directly contradicts the original hypothesis.

## Caveat / next step

This result is based on a single day (Aug 1, 2016) and has not yet been validated across a wider date range or segmented by device/traffic source. Before treating "Sessions → Product-View" as the headline finding, the next step is to rerun this query across multiple dates to confirm the pattern is stable, then segment by device type (mobile vs. desktop) and traffic source to root-cause the drop.
