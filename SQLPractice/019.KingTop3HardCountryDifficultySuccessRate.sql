--- Using only first-time attempts (same logic as before).
--- find the top 3 hardest levels per country and difficulty based on success rate.

WITH first_success AS (
    SELECT player_id, level_id,
    MIN(attempt_id) AS first_success_attempt
    FROM King_Level_Attempt
    WHERE success = 'TRUE'
    GROUP BY player_id, level_id
),
attempt_upto AS (
    SELECT l.*
    FROM King_Level_Attempt AS l
    LEFT JOIN first_success as fs
    ON l.player_id = fs.player_id
    AND l.level_id = fs.level_id
    WHERE fs.first_success_attempt IS NULL
    OR l.attempt_id <= fs.first_success_attempt
),
per_player_stats AS (
    SELECT player_id, level_id,
            ROUND(AVG(CASE WHEN success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS success_rate
    FROM attempt_upto
    GROUP BY player_id, level_id
),
country_stats AS (
    SELECT d.country, ps.level_id, 
            ROUND(AVG(ps.success_rate), 2) avg_success_rate
    FROM per_player_stats AS ps
    LEFT JOIN King_Players_Demographic as d
    ON ps.player_id = d.player_id
    GROUP BY d.country, ps.level_id
),
country_level_difficulty AS (
    SELECT cs.country, li.difficulty, cs.level_id, cs.avg_success_rate
    FROM country_stats AS cs
    LEFT JOIN King_Level_Info AS li
    ON cs.level_id = li.level_id
),
ranked_levels AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY country, difficulty ORDER BY avg_success_rate ASC) AS rank_in_difficulty
    FROM country_level_difficulty
)
SELECT * FROM ranked_levels WHERE rank_in_difficulty <=3 ORDER BY country, difficulty, rank_in_difficulty;