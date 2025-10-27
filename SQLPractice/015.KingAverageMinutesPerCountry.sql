--- Find the top 5 countries with the highest average minutes played per player.
--- in the last 30 days (2025-01-03 to 2025-02-01).

SELECT COALESCE(d.country, 'Unknown') AS country, ROUND(AVG(avg_minutes_per_player),2) AS player_avg_minutes
FROM (
    SELECT player_id, AVG(minutes_played) avg_minutes_per_player
    FROM King_Player_Activity
    WHERE activity_date >= '2025-01-03' AND activity_date < '2025-02-01'
    GROUP BY player_id
) AS a
JOIN King_Players_Demographic AS d
ON d.player_id = a.player_id
GROUP BY COALESCE(d.country, 'Unknown')
ORDER BY player_avg_minutes DESC
LIMIT 5;