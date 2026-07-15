-- 09_session_duration_analysis.sql
-- Uses ROW_NUMBER() and LAG() to compute time-between-hits and total
-- session duration, comparing youtube.com vs. baseline.

WITH hit_sequence AS (
  SELECT
    CONCAT(fullVisitorId, '-', CAST(visitId AS STRING)) AS session_id,
    trafficSource.source AS traffic_source,
    hit.time AS hit_time,
    ROW_NUMBER() OVER (
      PARTITION BY fullVisitorId, visitId
      ORDER BY hit.time
    ) AS hit_rank,
    LAG(hit.time) OVER (
      PARTITION BY fullVisitorId, visitId
      ORDER BY hit.time
    ) AS previous_hit_time
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`,
    UNNEST(hits) AS hit
),
session_durations AS (
  SELECT
    session_id,
    traffic_source,
    MAX(hit_time) AS session_duration_ms,
    COUNT(*) AS total_hits
  FROM
    hit_sequence
  GROUP BY
    session_id, traffic_source
)
SELECT
  CASE WHEN traffic_source = 'youtube.com' THEN 'youtube.com' ELSE 'all other sources' END AS source_group,
  COUNT(*) AS total_sessions,
  ROUND(AVG(session_duration_ms) / 1000, 1) AS avg_session_duration_seconds,
  ROUND(AVG(total_hits), 1) AS avg_hits_per_session
FROM
  session_durations
GROUP BY
  source_group