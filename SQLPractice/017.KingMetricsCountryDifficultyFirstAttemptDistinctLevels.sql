--- For each country and difficulty level, calculate the following metrics.
--- based only on first-time attempts (up to and including the first success):
--- Average success rate
--- Average score
--- Include only players who attempted at least 5 distinct levels.
--- Finally, order results by country, then by difficulty.

WITH first_success AS (
    SELECT player_id, level_id, MIN(attempt_id) AS first_success_attempt
    FROM King_Level_Attempt
    WHERE success = 'TRUE'
    GROUP BY player_id, level_id
),
attempt_upto AS (
    SELECT l.*
    FROM King_Level_Attempt AS l
    LEFT JOIN first_success AS fs
    ON l.player_id = fs.player_id
    AND l.level_id = fs.level_id
    WHERE fs.first_success_attempt IS NULL
    OR l.attempt_id <= fs.first_success_attempt
),
per_player_stats AS (
    SELECT player_id, level_id,
    ROUND(AVG(CASE WHEN success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS success_rate,
    ROUND(AVG(score), 2) as avg_score
    FROM attempt_upto
    GROUP BY player_id, level_id
),
eligible_players AS (
    SELECT player_id
    FROM per_player_stats
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 5
)
SELECT pd.country, li.difficulty, 
    ROUND(AVG(ps.success_rate), 2) AS avg_success_rate,
    ROUND(AVG(ps.avg_score), 2) AS avg_score
FROM per_player_stats AS ps
INNER JOIN eligible_players AS ep
ON ep.player_id = ps.player_id
LEFT JOIN King_Players_Demographic AS pd
ON ps.player_id = pd.player_id
LEFT JOIN King_Level_Info AS li
ON ps.level_id = li.level_id
GROUP BY pd.country, li.difficulty
ORDER BY pd.country, li.difficulty;