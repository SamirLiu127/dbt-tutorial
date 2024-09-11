{{ config(
  materialized = 'table',
) }}

WITH days AS (
  {{ dbt_utils.date_spine("day", "DATE(2000, 1, 1)", "DATE(2027, 1, 1)") }}
),
final AS (
  SELECT
    CAST(date_day AS DATE) AS date_day
  FROM
    days
)
SELECT
  *
FROM
  final
