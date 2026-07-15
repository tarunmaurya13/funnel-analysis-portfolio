-- 08_multiday_validation.sql
-- Validates the youtube.com bounce-rate finding across 7 days instead of 1

WITH session_data AS (
  SELECT
    _TABLE_SUFFIX AS session_date,
    CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
    trafficSource.source AS traffic_source,
    COUNT(CASE WHEN hit.type = 'PAGE' THEN 1 END) AS pageview_count,
    MAX(CASE WHEN hit.eCommerceAction.action_type = '2' THEN 1 ELSE 0 END) AS viewed_product
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hit
  WHERE
    _TABLE_SUFFIX BETWEEN '20160801' AND '20160807'
  GROUP BY
    session_date, session_id, traffic_source
)
SELECT
  session_date,
  CASE WHEN traffic_source = 'youtube.com' THEN 'youtube.com' ELSE 'all other sources' END AS source_group,
  COUNT(*) AS total_sessions,
  ROUND(SAFE_DIVIDE(SUM(viewed_product), COUNT(*)) * 100, 1) AS pct_viewed_product,
  COUNTIF(pageview_count = 1) AS single_pageview_sessions,
  ROUND(SAFE_DIVIDE(COUNTIF(pageview_count = 1), COUNT(*)) * 100, 1) AS pct_bounce
FROM
  session_data
GROUP BY
  session_date, source_group
ORDER BY
  session_date, source_group