--- Find the top 5 hardest levels (lowest success rate) across all players. 
--- considering first-time attempts only, and include their difficulty from level_info.

SELECT l.level_id, li.difficulty,
        ROUND(AVG(CASE WHEN l.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS success_rate,
        count(*) AS total_attempts
FROM King_Level_Attempt AS l
JOIN King_Level_Info AS li
ON l.level_id = li.level_id
GROUP BY l.level_id, li.difficulty
ORDER BY success_rate ASC
LIMIT 5;

--- or

WITH first_success AS (
    SELECT player_id, level_id,
    MIN(attempt_id) AS first_success_attempt
    FROM King_Level_Attempt
    WHERE success = 'TRUE'
    GROUP BY player_id, level_id
),
first_time_attempt AS (
    SELECT l.*
    FROM King_Level_Attempt AS l
    LEFT JOIN first_success AS fs
    ON l.player_id = fs.player_id
    AND l.level_id = fs.level_id
    WHERE fs.first_success_attempt IS NULL
    OR l.attempt_id <= fs.first_success_attempt
)
SELECT fta.level_id, li.difficulty,
    ROUND(AVG(CASE WHEN fta.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS success_rate,
    COUNT(*) AS total_attempts
FROM first_time_attempt fta
JOIN King_Level_Info li 
ON fta.level_id = li.level_id
GROUP BY fta.level_id, li.difficulty
ORDER BY success_rate ASC
LIMIT 5;