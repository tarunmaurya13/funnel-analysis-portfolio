-- Query 4: Funnel counts, split by device

WITH session_flags AS (
  SELECT
    CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
    device.deviceCategory AS device_category,
    MAX(CASE WHEN hit.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END) AS viewed_product,
    MAX(CASE WHEN hit.eCommerceAction.action_type = '3' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN hit.eCommerceAction.action_type = '5' THEN 1 ELSE 0 END) AS started_checkout,
    MAX(CASE WHEN hit.eCommerceAction.action_type = '6' THEN 1 ELSE 0 END) AS completed_purchase
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`,
    UNNEST(hits) AS hit
  GROUP BY
    session_id, device_category
)
SELECT
  device_category,
  COUNT(*) AS total_sessions,
  SUM(viewed_product) AS product_views,
  ROUND(SAFE_DIVIDE(SUM(viewed_product), COUNT(*)) * 100, 1) AS pct_viewed_product,
  SUM(added_to_cart) AS add_to_carts,
  SUM(started_checkout) AS checkouts_started,
  SUM(completed_purchase) AS purchases
FROM session_flags
GROUP BY device_category
ORDER BY total_sessions DESC