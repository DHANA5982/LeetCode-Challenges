-- Active: 1761408174101@@localhost@5432@PostgreSQLDB
USE PostgreSQLDB;

CREATE TABLE King_Players_Demographic (
    player_id INTEGER PRIMARY KEY,
    registration_date DATE,
    country TEXT,
    age INTEGER,
    gender TEXT
);

INSERT INTO King_Players_Demographic VALUES
(1, '2024-01-19', 'Spain', 24, 'O'), (2, '2024-12-22', 'Japan', 20, 'F'), (3, '2025-07-26', 'United Kingdom', 20, 'M'), 
(4, '2025-06-21', 'Brazil', 20, 'M'), (5, '2025-05-22', 'Italy', 21, 'M'), (6, '2023-11-25', 'France', 24, 'O'), 
(7, '2024-04-22', 'Saudi Arabia', 20, 'M'), (8, '2024-01-06', 'Saudi Arabia', 23, 'M'), (9, '2024-10-25', 'Australia', 23, 'M'), 
(10, '2025-05-20', 'Japan', 22, 'F'), (11, '2024-09-20', 'Brazil', 21, 'O'), (12, '2024-10-07', 'France', 25, 'F'), 
(13, '2025-02-24', 'Spain', 22, 'O'), (14, '2024-07-27', 'United Kingdom', 20, 'O'), (15, '2025-06-10', 'United States', 23, 'M'), 
(16, '2024-03-18', 'Canada', 21, 'O'), (17, '2023-12-18', 'France', 18, 'F'), (18, '2024-10-19', 'Russia', 20, 'M'), 
(19, '2023-10-29', 'Italy', 23, 'O'), (20, '2025-08-30', 'Spain', 19, 'F'), (21, '2025-07-17', 'India', 25, 'F'), 
(22, '2024-08-04', 'Saudi Arabia', 23, 'F'), (23, '2024-09-07', 'Canada', 22, 'F'), (24, '2025-01-20', 'Australia', 21, 'O'), 
(25, '2025-05-21', 'Spain', 21, 'O'), (26, '2025-05-24', 'Italy', 19, 'M'), (27, '2023-10-08', 'Australia', 25, 'O'), 
(28, '2025-03-30', 'France', 25, 'M'), (29, '2024-09-16', 'United States', 25, 'F'), (30, '2024-04-30', 'Saudi Arabia', 21, 'F');

CREATE TABLE King_Player_Activity (
    player_id INT,
    activity_date DATE,
    session_count INT,
    minutes_played INT
);

INSERT INTO King_Player_Activity VALUES 
(1, '2024-11-27', 4, 30), (2, '2025-05-15', 4, 47), (3, '2025-08-31', 5, 16), (4, '2025-08-13', 5, 42), (5, '2025-07-29', 5, 36), 
(6, '2024-10-30', 5, 20), (7, '2025-01-13', 5, 29), (8, '2024-11-20', 3, 68), (9, '2025-04-16', 3, 9), (10, '2025-07-28', 2, 60), 
(11, '2025-03-29', 9, 8), (12, '2025-04-07', 2, 94), (13, '2025-06-16', 7, 82), (14, '2025-03-02', 7, 32), (15, '2025-08-08', 7, 63), 
(16, '2024-12-26', 5, 24), (17, '2024-11-11', 5, 94), (18, '2025-04-13', 4, 37), (19, '2024-10-17', 9, 38), (20, '2025-09-17', 8, 32), 
(21, '2025-08-26', 8, 85), (22, '2025-03-06', 9, 86), (23, '2025-03-23', 8, 32), (24, '2025-05-29', 6, 46), (25, '2025-07-29', 7, 38), 
(26, '2025-07-30', 3, 97), (27, '2024-10-06', 4, 74), (28, '2025-07-03', 8, 88), (29, '2025-03-27', 6, 7), (30, '2025-01-17', 4, 97);

CREATE TABLE King_Level_Attempt (
    attempt_id INT, 
    player_id INT,
    level_id INT,
    attempt_date DATE,
    score INT,
    success VARCHAR(10),
    attempts INT
);

INSERT INTO King_Level_Attempt VALUES
(101,1,1,'2025-01-03',500,'FALSE',1),(102,1,1,'2025-01-03',700,'TRUE',2),(103,2,2,'2025-01-05',400,'FALSE',1),
(104,2,2,'2025-01-05',450,'FALSE',2),(105,3,3,'2025-01-06',300,'TRUE',1),(106,4,1,'2025-01-07',600,'TRUE',1),
(107,5,2,'2025-01-09',550,'FALSE',1),(108,5,2,'2025-01-09',650,'TRUE',2),(109,6,3,'2025-01-10',720,'FALSE',1),
(110,6,3,'2025-01-10',830,'TRUE',2),(111,7,4,'2025-01-11',900,'FALSE',1),(112,8,5,'2025-01-12',400,'TRUE',1),
(113,9,1,'2025-01-14',520,'FALSE',1),(114,10,2,'2025-01-15',710,'FALSE',1),(115,11,3,'2025-01-17',630,'TRUE',1);

CREATE TABLE King_Level_Info (
    level_id INT,
    difficulty VARCHAR(10),
    release_date DATE
);

INSERT INTO King_Level_Info VALUES
(1, 'Easy', '2024-12-01'), (2, 'Medium', '2024-12-15'), (3, 'Hard', '2025-01-01'),
(4,	'Easy',	'2025-01-02'), (5, 'Medium', '2025-01-03'), (6,	'Hard',	'2025-01-05');

--- Find the total number of players per country.

SELECT COALESCE(country, 'Unknown') AS country, COUNT(*) AS total_players
FROM King_Players_Demographic
GROUP BY COALESCE(country, 'Unknown');