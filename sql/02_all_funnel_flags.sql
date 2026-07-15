-- All 4 funnel flags per session

SELECT
  CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
  MAX(CASE WHEN hit.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END) AS viewed_product,
  MAX(CASE WHEN hit.eCommerceAction.action_type = '3' THEN 1 ELSE 0 END) AS added_to_cart,
  MAX(CASE WHEN hit.eCommerceAction.action_type = '5' THEN 1 ELSE 0 END) AS started_checkout,
  MAX(CASE WHEN hit.eCommerceAction.action_type = '6' THEN 1 ELSE 0 END) AS completed_purchase
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`,
  UNNEST(hits) AS hit
GROUP BY
  session_id