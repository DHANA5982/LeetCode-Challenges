--- King wants to understand player retention patterns by analyzing how often players return after their previous gaming session.
--- Using Player Activity table, create a report that shows for each country:
--- Average gap (in days) between consecutive active days per player
--- Retention %: % of players who return the next day (1-day gap)
--- Churn %: % of players with no activity in the last 30 days

CREATE TABLE King_Players_Demographic1 (
    player_id INT PRIMARY KEY,
    country VARCHAR(30)
);

CREATE TABLE King_Player_Activity1 (
    player_id INT,
    activity_date DATE,
    sessions INT,
    minutes_played INT
);

INSERT INTO King_Players_Demographic1 (player_id, country) VALUES
(1, 'USA'), (2, 'USA'), (3, 'USA'), (4, 'India'), (5, 'India'),
(6, 'India'), (7, 'UK'), (8, 'UK'), (9, 'Brazil'), (10, 'Brazil');

INSERT INTO King_Player_Activity1 (player_id, activity_date, sessions, minutes_played) VALUES
(1, '2025-01-01', 3, 20),
(1, '2025-01-02', 2, 18),
(1, '2025-01-05', 4, 30),
(2, '2025-01-10', 1, 10),
(2, '2025-01-12', 2, 15),
(3, '2024-12-20', 1, 7),
(3, '2024-12-21', 1, 5),
(3, '2025-01-25', 2, 12),
(4, '2025-01-02', 2, 11),
(4, '2025-01-03', 3, 15),
(4, '2025-01-04', 1, 10),
(5, '2024-12-15', 3, 20),
(6, '2025-01-01', 2, 15),
(6, '2025-01-10', 1, 8),
(7, '2024-12-30', 1, 5),
(7, '2025-01-01', 2, 12),
(7, '2025-01-02', 2, 10),
(8, '2025-01-20', 1, 4),
(9, '2025-01-03', 3, 18),
(9, '2025-01-10', 1, 8),
(10, '2024-12-10', 3, 25),
(10, '2025-01-30', 1, 6);

WITH activity_gap AS (
    SELECT
        a.player_id,
        a.activity_date,
        d.country,
        LAG(a.activity_date) OVER (PARTITION BY a.player_id ORDER BY a.activity_date) AS prev_date
    FROM
        King_Player_Activity1 AS a
    LEFT JOIN
        King_Players_Demographic1 AS d
        ON a.player_id = d.player_id
),
gap_stats AS (
    SELECT
        country,
        player_id,
        ROUND(AVG(activity_date - prev_date), 1) AS avg_gap_days,
        MAX(CASE WHEN activity_date - prev_date = 1 THEN 1 ELSE 0 END) AS is_next_day_return
    FROM
        activity_gap
    WHERE
        prev_date IS NOT NULL
    GROUP BY country, player_id
    ORDER BY player_id, country
),
player_last_activity AS (
    SELECT
        d.country,
        a.player_id,
        MAX(a.activity_date) AS last_active_date
    FROM 
        King_Player_Activity1 AS a
    LEFT JOIN King_Players_Demographic1 AS d
        ON a.player_id = d.player_id
    GROUP BY d.country, a.player_id
),
country_retention_final AS (
    SELECT
        gs.country,
        ROUND(AVG(gs.avg_gap_days), 2) AS avg_days_between_sessions,
        ROUND(AVG(gs.is_next_day_return) * 100, 2) AS retention_rate_percent,
        ROUND(AVG(CASE WHEN '2025-02-01' - pla.last_active_date > 30 THEN 1 ELSE 0 END) * 100, 2) AS churn_rate_percent
    FROM 
        gap_stats gs
    LEFT JOIN 
        player_last_activity pla
        ON gs.player_id = pla.player_id
        AND gs.country = pla.country
    GROUP BY gs.country
)
SELECT *
FROM country_retention_final
ORDER BY country;