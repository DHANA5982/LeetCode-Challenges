--- Dual-Period Metrics:
--- Your current solution computes metrics using a fixed 30‑day period (and previously, an overall period).
--- Suppose the business now requires that you report metrics for both a 30‑day period and a 365‑day period
--- (instead of the ‘whole period’) in a single query.
--- This means your final output should include, for each country,
--- the average daily sessions, average minutes played, average success rate, and average score
--- Computed over the last 30 days and the last 365 days.

WITH player_activity_30 AS (
    SELECT d.country,
            ROUND(AVG(pa.session_count), 2) AS avg_session_count_30,
            ROUND(AVG(pa.minutes_played), 2) AS avg_minutes_played_30
    FROM King_Player_Activity AS pa
    JOIN King_Players_Demographic AS d
        ON pa.player_id = d.player_id
    WHERE pa.activity_date BETWEEN '2025-01-02' AND '2025-02-01'
    GROUP BY d.country
),
player_activity_365 AS (
    SELECT d.country,
            ROUND(AVG(pa.session_count), 2) AS avg_session_count_365,
            ROUND(AVG(pa.minutes_played), 2) AS avg_minutes_played_365
    FROM King_Player_Activity AS pa
    JOIN King_Players_Demographic AS d
        ON pa.player_id = d.player_id
    WHERE pa.activity_date BETWEEN '2024-02-01' AND '2025-02-01'
    GROUP BY d.country
),
first_success_attempt_upto_30 AS (
    SELECT *
    FROM (
        SELECT *,
                MIN(CASE WHEN success = 'TRUE' THEN attempt_id END) OVER (PARTITION BY player_id, level_id) AS first_success_attempt
        FROM King_Level_Attempt
        WHERE attempt_date BETWEEN '2025-01-02' and '2025-02-01'
    ) AS f
    WHERE attempt_id <= COALESCE(first_success_attempt, attempt_id)
),
first_success_attempt_upto_365 AS (
    SELECT *
    FROM (
        SELECT *,
                MIN(CASE WHEN success = 'TRUE' THEN attempt_id END) OVER (PARTITION BY player_id, level_id) AS first_success_attempt
        FROM King_Level_Attempt
        WHERE attempt_date BETWEEN '2024-02-01' AND '2025-02-01'
    ) AS f
    WHERE attempt_id <= COALESCE(first_success_attempt, attempt_id)
),
eligible_players_30 AS (
    SELECT player_id
    FROM first_success_attempt_upto_30
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 1
),
eligible_players_365 AS (
    SELECT player_id
    FROM first_success_attempt_upto_365
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 1
),
player_level_metrics_30 AS (
    SELECT fsa.player_id, d.country,
            ROUND(AVG(CASE WHEN fsa.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate_30,
            ROUND(AVG(fsa.score), 2) AS avg_score_30
    FROM first_success_attempt_upto_30 AS fsa
    JOIN King_Players_Demographic AS d
        ON fsa.player_id = d.player_id
    WHERE fsa.player_id IN (SELECT player_id FROM eligible_players_30)
    GROUP BY fsa.player_id, d.country 
),
player_level_metrics_365 AS (
    SELECT fsa.player_id, d.country,
            ROUND(AVG(CASE WHEN fsa.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate_365,
            ROUND(AVG(fsa.score), 2) AS avg_score_365
    FROM first_success_attempt_upto_365 AS fsa
    JOIN King_Players_Demographic AS d
        ON fsa.player_id = d.player_id
    WHERE fsa.player_id IN (SELECT player_id FROM eligible_players_365)
    GROUP BY fsa.player_id, d.country 
),
country_level_aggregation_30 AS (
    SELECT country,
            ROUND(AVG(avg_success_rate_30), 2) AS avg_success_rate_30,
            ROUND(AVG(avg_score_30), 2) AS avg_score_30
    FROM player_level_metrics_30
    GROUP BY country
),
country_level_aggregation_365 AS (
    SELECT country,
            ROUND(AVG(avg_success_rate_365), 2) AS avg_success_rate_365,
            ROUND(AVG(avg_score_365), 2) AS avg_score_365
    FROM player_level_metrics_365
    GROUP BY country
),
final_report AS (
    SELECT COALESCE(pa30.country, pa365.country, cg30.country, cg365.country) AS country,
            pa30.avg_session_count_30,
            pa30.avg_minutes_played_30,
            cg30.avg_success_rate_30,
            cg30.avg_score_30,

            pa365.avg_session_count_365,
            pa365.avg_minutes_played_365,
            cg365.avg_success_rate_365,
            cg365.avg_score_365
    FROM player_activity_30 AS pa30
    FULL OUTER JOIN player_activity_365 AS pa365
        ON pa30.country = pa365.country
    FULL OUTER JOIN country_level_aggregation_30 AS cg30
        ON pa30.country = cg30.country
    FULL OUTER JOIN country_level_aggregation_365 AS cg365
        ON pa30.country = cg365.country
)
SELECT * FROM final_report
ORDER BY country ASC;