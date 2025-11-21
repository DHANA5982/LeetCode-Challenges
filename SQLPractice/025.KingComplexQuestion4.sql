--- incorporating additional table: suppose a new table level_info is introduced with columns:
--- a. level_id(integer) b.difficulty (stringL: e.g, 'easy', 'medium', 'hard') c.release_date(date)
--- modify your solution so that, in addition to your current top levels report,
--- you break down the average success rate and average score by difficulty category for each country, using first-time attempts only.
--- describe additional joins and aggregations you would implement.

WITH player_activity_30 AS (
    SELECT d.country AS country,
        ROUND(AVG(a.session_count), 2) AS avg_session_count_30,
        ROUND(AVG(a.minutes_played), 2) AS avg_minutes_played_30
    FROM King_Player_Activity AS a
    JOIN King_Players_Demographic AS d
        ON a.player_id = d.player_id
    WHERE a.activity_date BETWEEN '2025-01-02' AND '2025-02-01'
    GROUP BY d.country
),
player_activity_365 AS (
    SELECT d.country AS country,
        ROUND(AVG(a.session_count), 2) AS avg_session_count_365,
        ROUND(AVG(a.minutes_played), 2) AS avg_minutes_played_365
    FROM king_Player_Activity AS a
    JOIN King_Players_Demographic AS d
        ON a.player_id = d.player_id
    WHERE a.activity_date BETWEEN '2024-02-01' AND '2025-02-01'
    GROUP BY d.country
),
first_success_attempt_upto_30 AS (
    SELECT fsa.player_id, fsa.level_id, fsa.difficulty, fsa.attempt_date, fsa.success, fsa.score
    FROM (
        SELECT la.*, li.difficulty,
            MIN(CASE WHEN la.success = 'TRUE' THEN la.attempt_id END) OVER (PARTITION BY la.player_id, la.level_id) AS first_success_attempt
        FROM King_Level_Attempt AS la
        JOIN King_Level_Info AS li
            ON la.level_id = li.level_id
        WHERE la.attempt_date BETWEEN '2025-01-02' AND '2025-02-01'
            AND la.attempt_date >= li.release_date
    ) AS fsa
    WHERE fsa.attempt_id <= COALESCE(fsa.first_success_attempt, fsa.attempt_id)
),
first_success_attempt_upto_365 AS (
    SELECT fsa.player_id, fsa.level_id, fsa.difficulty, fsa.attempt_date, fsa.success, fsa.score
    FROM (
        SELECT la.*, li.difficulty,
            MIN(CASE WHEN la.success = 'TRUE' THEN la.attempt_id END) OVER (PARTITION BY la.player_id, la.level_id) AS first_success_attempt
        FROM King_Level_Attempt AS la
        JOIN King_Level_Info AS li
            ON la.level_id = li.level_id
        WHERE la.attempt_date BETWEEN '2024-02-01' AND '2025-02-01'
            AND la.attempt_date >= li.release_date
    ) AS fsa
    WHERE fsa.attempt_id <= COALESCE(fsa.first_success_attempt, fsa.attempt_id)
),
eligible_player_30 AS (
    SELECT player_id
    FROM first_success_attempt_upto_30
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 1
),
eligible_player_365 AS (
    SELECT player_id
    FROM first_success_attempt_upto_365
    GROUP BY player_id
    HAVING COUNT(DISTINCT level_id) >= 1
),
player_level_metric_30 AS (
    SELECT fsa.player_id, d.country, fsa.difficulty,
        ROUND(AVG(CASE WHEN fsa.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate_30,
        ROUND(AVG(fsa.score), 2) AS avg_score_30
    FROM first_success_attempt_upto_30 AS fsa
    JOIN King_Players_Demographic AS d
        ON fsa.player_id = d.player_id
    WHERE fsa.player_id IN (SELECT player_id FROM eligible_player_30)
    GROUP BY fsa.player_id, d.country, fsa.difficulty
),
player_level_metric_365 AS (
    SELECT fsa.player_id, d.country, fsa.difficulty,
        ROUND(AVG(CASE WHEN fsa.success = 'TRUE' THEN 1.0 ELSE 0.0 END), 2) AS avg_success_rate_365,
        ROUND(AVG(fsa.score), 2) AS avg_score_365
    FROM first_success_attempt_upto_365 AS fsa
    JOIN King_Players_Demographic AS d
        ON fsa.player_id = d.player_id
    WHERE fsa.player_id IN (SELECT player_id FROM eligible_player_365)
    GROUP BY fsa.player_id, d.country, fsa.difficulty
),
country_difficulty_level_aggregation_30 AS (
    SELECT country, difficulty,
        ROUND(AVG(avg_success_rate_30), 2) AS avg_success_rate_30,
        ROUND(AVG(avg_score_30), 2) AS avg_score_30
    FROM player_level_metric_30
    GROUP BY country, difficulty
),
country_difficulty_level_aggregation_365 AS (
    SELECT country, difficulty,
        ROUND(AVG(avg_success_rate_365), 2) AS avg_success_rate_365,
        ROUND(AVG(avg_score_365), 2) AS avg_score_365
    FROM player_level_metric_365
    GROUP BY country, difficulty
),
final_report AS (
    SELECT COALESCE(pa30.country, pa365.country, cd30.country, cd365.country) AS country,
           COALESCE(cd30.difficulty, cd365.difficulty) AS difficulty,
           
           pa30.avg_session_count_30 AS avg_session_count_30,
           pa30.avg_minutes_played_30 AS avg_minutes_played_30,
           cd30.avg_success_rate_30 AS avg_success_rate_30,
           cd30.avg_score_30 AS avg_score_30,

           pa365.avg_session_count_365 AS avg_session_count_365,
           pa365.avg_minutes_played_365 AS avg_minutes_played_365,
           cd365.avg_success_rate_365 AS avg_success_rate_365,
           cd365.avg_score_365 AS avg_score_365

    FROM player_activity_30 AS pa30
    FULL OUTER JOIN player_activity_365 AS pa365
        ON pa30.country = pa365.country
    FULL OUTER JOIN country_difficulty_level_aggregation_30 AS cd30
        ON COALESCE(pa30.country, pa365.country) = cd30.country
    FULL OUTER JOIN country_difficulty_level_aggregation_365 AS cd365
        ON COALESCE(pa30.country, pa365.country, cd30.country) = cd365.country
    )
SELECT * FROM final_report ORDER BY country, difficulty;