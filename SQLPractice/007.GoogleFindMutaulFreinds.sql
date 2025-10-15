USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Google: You are analyzing a social network dataset at Google.
-- Your task is to find mutual friends between two users, Karl and Hans.
-- There is only one user named Karl and one named Hans in the dataset.
-- The output should contain 'user_id' and 'user_name' columns.

CREATE TABLE Google_Users (
    user_id INT,
    user_name VARCHAR(20)
);

INSERT INTO Google_Users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Gemma'), 
(5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE Google_Friends (
    user_id INT, 
    friend_id INT
);

INSERT INTO Google_Friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),
(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);

SELECT * FROM Google_Users;
SELECT * FROM Google_Friends;

WITH karl_friends AS (
    SELECT friend_id
    FROM Google_Friends
    WHERE user_id = (SELECT user_id FROM Google_Users WHERE user_name = 'Karl')
),
hans_friends AS (
    SELECT friend_id
    FROM Google_Friends
    WHERE user_id = (SELECT user_id FROM Google_Users WHERE user_name = 'Hans')
)
SELECT u.user_id, u.user_name
FROM Google_Users AS u
JOIN karl_friends AS kf ON kf.friend_id = u.user_id
JOIN hans_friends AS hf ON hf.friend_id = u.user_id;
