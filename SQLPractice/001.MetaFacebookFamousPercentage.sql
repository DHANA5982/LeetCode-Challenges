USE AzureSQLdb;

SELECT NAME FROM sys.databases;
SELECT NAME FROM sys.tables;

-- A table named "famous" has two columns called user_id and follower_id.
-- It represents each user ID has a particular follower ID. These follower IDs
-- are also users of #Facebook/#Meta. Compute famous percentage:
-- Famous Percentage = number of followers a user has / total number of users.

CREATE TABLE Meta_Facebook_Famous (
    user_id INT,
    follower_id INT
);

INSERT INTO Meta_Facebook_Famous VALUES 
(1, 2), (1, 3), (1, 5), (1, 8), (2, 4), (2, 1), (2, 12),
(3, 2), (3, 5), (4, 1), (5, 1), (5, 3), (6, 2), (6, 3),
(6,10), (7, 4), (7, 6), (8, 5), (8, 7), (8,15), (8, 3), 
(8, 2), (9, 8), (10, 1), (10, 2), (11, 7), (12, 8),
(13, 5), (13, 10), (14, 12), (14, 3), (15, 14), (15, 13);

SELECT * FROM Meta_Facebook_Famous;

WITH distinct_users AS (
    SELECT user_id FROM Meta_Facebook_Famous
    UNION
    SELECT follower_id FROM Meta_Facebook_Famous
),
follower_count AS (
    SELECT user_id, COUNT(follower_id) AS total_followers
    FROM Meta_Facebook_Famous
    GROUP BY user_id
)
SELECT f.user_id, 
        ROUND((f.total_followers * 100.0) / (SELECT COUNT(*) FROM distinct_users),2) AS famous_percentage
FROM follower_count AS f
ORDER BY famous_percentage DESC;