-- : Did each session view a product page?


SELECT
  CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
  MAX(CASE WHEN hit.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END) AS viewed_product
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`,
  UNNEST(hits) AS hit
GROUP BY
  session_id
LIMIT 20
