USE AzureSQLdb;

SELECT NAME FROM sys.tables;

CREATE TABLE users (
    user_id INT,
    user_name VARCHAR(20)
);

INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Gemma'), 
(5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');

CREATE TABLE friends (
    user_id INT, 
    friend_id INT
);

INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),
(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);

SELECT * FROM users;
SELECT * FROM friends;

WITH karl_friends AS (
    SELECT friend_id
    FROM friends
    WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Karl')
),
hans_friends AS (
    SELECT friend_id
    FROM friends
    WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Hans')
)
SELECT u.user_id, u.user_name
FROM users AS u
JOIN karl_friends AS kf ON kf.friend_id = u.user_id
JOIN hans_friends AS hf ON hf.friend_id = u.user_id;
