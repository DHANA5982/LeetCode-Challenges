--- For each country, compute the change in average success rate and average score.
--- between the last 30 days and the previous 30 days (using first-time attempts only).

WITH first_attempt AS (
    SELECT player_id, level_id, MIN(attempt_id) AS first_success_attempt
    FROM King_Level_Attempt
    WHERE success = 'TRUE'
    GROUP BY player_id, level_id
),
attempt_upto AS (
    SELECT l.*,
            CASE WHEN l.attempt_date BETWEEN '2024-12-04' AND '2025-01-02' THEN 'prev30'
                 WHEN l.attempt_date BETWEEN '2025-01-03' AND '2025-02-01' THEN 'curr30'
            END AS period
    FROM King_Level_Attempt AS l
    LEFT JOIN first_attempt AS fs
    ON l.player_id = fs.player_id
    AND l.level_id = fs.level_id
    WHERE (fs.first_success_attempt IS NULL
    OR l.attempt_id <= fs.first_success_attempt)
    AND l.attempt_date BETWEEN '2024-12-04' AND '2025-02-01'
),
per_player_stats AS (
    SELECT player_id, level_id, period,
            ROUND(AVG(CASE WHEN success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate,
            ROUND(AVG(score), 2) AS avg_score
    FROM attempt_upto
    WHERE period IS NOT NULL
    GROUP BY player_id, level_id, period
), 
country_period_stats AS (
    SELECT d.country AS country,
            ROUND(AVG(CASE WHEN ps.period = 'curr30' THEN ps.avg_success_rate END), 2) AS avg_success_rate_curr30d,
            ROUND(AVG(CASE WHEN ps.period = 'prev30' THEN ps.avg_success_rate END), 2) AS avg_success_rate_prev30d,
            ROUND(AVG(CASE WHEN ps.period = 'curr30' THEN ps.avg_score END), 2) AS avg_score_curr30d,
            ROUND(AVG(CASE WHEN ps.period = 'prev30' THEN ps.avg_score END), 2) AS avg_score_prev30d 
    FROM per_player_stats AS ps
    LEFT JOIN King_Players_Demographic AS d
    ON ps.player_id = d.player_id
    GROUP BY d.country
)
SELECT country,
       avg_success_rate_curr30d,
       avg_success_rate_prev30d,
       (avg_success_rate_curr30d - avg_success_rate_prev30d) AS change_in_success,
       avg_score_curr30d,
       avg_score_prev30d,
       (avg_score_curr30d - avg_score_prev30d) AS change_in_score
FROM country_period_stats
ORDER BY country;