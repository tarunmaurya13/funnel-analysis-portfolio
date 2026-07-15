-- The GA sample dataset gives you page-level hit data


WITH session_pageviews AS (
  SELECT
    CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
    trafficSource.source AS traffic_source,
    COUNT(CASE WHEN hit.type = 'PAGE' THEN 1 END) AS pageview_count
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`,
    UNNEST(hits) AS hit
  GROUP BY
    session_id, traffic_source
)
SELECT
  CASE WHEN traffic_source = 'youtube.com' THEN 'youtube.com' ELSE 'all other sources' END AS source_group,
  COUNT(*) AS total_sessions,
  COUNTIF(pageview_count = 1) AS single_pageview_sessions,
  ROUND(SAFE_DIVIDE(COUNTIF(pageview_count = 1), COUNT(*)) * 100, 1) AS pct_single_pageview
FROM session_pageviews
GROUP BY source_group