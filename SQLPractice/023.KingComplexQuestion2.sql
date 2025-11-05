--- Modify your query so that instead of a fixed 30‑calendar‑day period,
--- each player’s ‘active window’ is defined as their 30 most recent active days
--- but only considering days within the last 365 calendar days (ending on 2025‑02‑01).

WITH player_recent_activity AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY activity_date DESC) AS active_days
    FROM King_Player_Activity
    WHERE activity_date BETWEEN '2024-02-01' AND '2025-02-01'
),
filtered_activities_by_country AS (
    SELECT d.country,
            ROUND(AVG(a.session_count), 2) AS avg_session_count,
            ROUND(AVG(a.minutes_played), 2) AS avg_minutes_played
    FROM player_recent_activity AS a
    JOIN King_Players_Demographic AS d
        ON d.player_id = a.player_id
    WHERE a.active_days <= 30
    GROUP BY d.country
),
player_active_window AS (
    SELECT player_id,
            MIN(activity_date) AS min_active_date,
            MAX(activity_date) AS max_active_date
    FROM player_recent_activity
    WHERE active_days <= 30
    GROUP BY player_id
),
level_attempts_first_success_and_upto AS (
    SELECT f.player_id, f.level_id, f.attempt_date, f.attempt_id, f.success, f.score, f.first_success_attempt
    FROM (
        SELECT la.*,
            MIN(CASE WHEN la.success = 'TRUE' THEN la.attempt_id END) over (PARTITION BY la.player_id, la.level_id) AS first_success_attempt
        FROM King_Level_Attempt AS la
        JOIN player_active_window AS aw
            ON la.player_id = aw.player_id
            AND la.attempt_date BETWEEN aw.min_active_date AND aw.max_active_date
    ) AS f
    WHERE f.attempt_id <= COALESCE(f.first_success_attempt, f.attempt_id)
),
eligible_players AS (
    SELECT player_id
    FROM level_attempts_first_success_and_upto
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 5
),
player_metrics AS (
    SELECT fsu.player_id, d.country,
            ROUND(AVG(CASE WHEN fsu.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate,
            ROUND(AVG(fsu.score), 2) AS avg_score
    FROM level_attempts_first_success_and_upto AS fsu
    JOIN King_Players_Demographic AS d
        ON fsu.player_id = d.player_id
    WHERE fsu.player_id IN (SELECT player_id FROM eligible_players)
    GROUP BY fsu.player_id, d.country
),
country_level_metrics AS (
    SELECT country,
            ROUND(AVG(avg_success_rate), 2) AS avg_success_rate,
            ROUND(AVG(avg_score), 2) AS avg_score
    FROM player_metrics
    GROUP BY country
)
SELECT fac.country,
       fac.avg_session_count,
       fac.avg_minutes_played,
       cm.avg_success_rate,
       cm.avg_score
FROM filtered_activities_by_country AS fac
JOIN country_level_metrics AS cm
    ON fac.country = cm.country
ORDER BY fac.country;