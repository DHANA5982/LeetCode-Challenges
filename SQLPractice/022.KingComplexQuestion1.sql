--- King wants to generate a comprehensive report for Candy Crush Saga that combines
--- information on daily player activity, player demographics, and level attempt outcomes.
--- However, to avoid bias from repeat plays, only first-time level attempts will be used when computing
--- difficulty, success rate, and related metrics.
--- For each player and level, only the attempts made until (and including) the first success are considered.
--- (If a player never succeeds on a level, then all of their attempts are kept.)
--- Write a code (free choice: SQL, Python, R, other) that generates a country-level report for Candy Crush Saga
--- using data from a fixed 30‑calendar‑day period (2025‑01‑03 to 2025‑02‑01).
--- The query must:
--- Optimize Performance: Apply early date filters on both player_activity and level_attempts to restrict scanning to the period.
--- Daily Activity: Join player_activity (filtered to the period) with players to compute, per country, average sessions and average minutes played.
--- Level Attempts: From level_attempts, compute first-time attempts (up to and including the first success) for each (player, level) within the period.
--- Player Filtering: Only consider players who attempted at least 5 distinct levels (based on first-time attempts).
--- Performance Metrics: For these players, compute per-player average success rate and average score from level attempts, then aggregate these metrics to the country level.
--- Final Output: Produce a report for each country including:
--- Average daily sessions (fixed period)
--- Average minutes played (fixed period)
--- Country‑level average success rate (from level attempts)
--- Country‑level average score (from level attempts)

WITH filtered_daily_activities_by_country AS (
    SELECT d.country,
            ROUND(AVG(a.session_count), 2) AS avg_session_count,
            ROUND(AVG(a.minutes_played), 2) AS avg_minutes_played
    FROM King_Player_Activity AS a
    JOIN King_Players_Demographic as d
        ON a.player_id = d.player_id
    WHERE a.activity_date BETWEEN '2025-01-03' AND '2025-02-01'
    GROUP BY d.country
),
level_attempts AS (
    SELECT la.* 
    FROM (
        SELECT *,
            MIN(CASE WHEN success = 'TRUE' THEN attempt_id END) OVER (PARTITION BY player_id, level_id) AS first_success_attempt
        FROM king_Level_Attempt
        WHERE attempt_date BETWEEN '2025-01-03' AND '2025-02-01'
        ) AS la
    WHERE la.attempt_id <= COALESCE(la.first_success_attempt, la.attempt_id)
),
eligible_players AS (
    SELECT player_id
    FROM level_attempts
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 5
),
player_metrics AS (
    SELECT la.player_id, d.country,
        ROUND(AVG(CASE WHEN la.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate,
        ROUND(AVG(la.score), 2) AS avg_score
    FROM level_attempts AS la
    LEFT JOIN King_Players_Demographic as d
        ON la.player_id = d.player_id
    WHERE la.player_id IN (SELECT player_id FROM eligible_players)
    GROUP BY la.player_id, d.country
),
country_level_metrics AS (
    SELECT country,
        ROUND(AVG(avg_success_rate), 2) AS avg_success_rate,
        ROUND(AVG(avg_score), 2) AS avg_score
    FROM player_metrics
    GROUP BY country
)
SELECT fda.country,
       fda.avg_session_count,
       fda.avg_minutes_played,
       cm.avg_success_rate,
       cm.avg_score
FROM filtered_daily_activities_by_country AS fda
JOIN country_level_metrics AS cm
    ON fda.country = cm.country
ORDER BY cm.country;