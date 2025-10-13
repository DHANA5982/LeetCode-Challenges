USE AzureSQLdb;

SELECT NAME FROM sys.tables;

CREATE TABLE uber_request_logs (
    request_id INT,
    request_date DATETIME,
    request_status VARCHAR(10),
    distance_to_travel FLOAT,
    monetory_cost FLOAT,
    driver_to_client_distance FLOAT
);

INSERT INTO uber_request_logs VALUES
(1,'2020-01-09','success', 70.59, 6.56,14.36), (2,'2020-01-24','success', 93.36, 22.68,19.9), 
(3,'2020-02-08','fail', 51.24, 11.39,21.32), (4,'2020-02-23','success', 61.58,8.04,44.26), 
(5,'2020-03-09','success', 25.04,7.19,1.74), (6,'2020-03-24','fail', 45.57, 4.68,24.19), 
(7,'2020-04-08','success', 24.45,12.69,15.91), (8,'2020-04-23','success', 48.22,11.2,48.82), 
(9,'2020-05-08','success', 56.63,4.04,16.08), (10,'2020-05-23','fail', 19.03,16.65,11.22), 
(11,'2020-06-07','fail', 81,6.56,26.6), (12,'2020-06-22','fail', 21.32,8.86,28.57), 
(13,'2020-07-07','fail', 14.74,17.76,19.33), (14,'2020-07-22','success',66.73,13.68,14.07), 
(15,'2020-08-06','success',32.98,16.17,25.34), (16,'2020-08-21','success',46.49,1.84,41.9), 
(17,'2020-09-05','fail', 45.98,12.2,2.46), (18,'2020-09-20','success',3.14,24.8,36.6), 
(19,'2020-10-05','success',75.33,23.04,29.99), (20,'2020-10-20','success', 53.76,22.94,18.74);

SELECT TOP 5 * FROM uber_request_logs;

WITH monthly_aggregates AS (
    SELECT FORMAT(request_date, 'yyyy-MM') AS year_month,
            SUM(distance_to_travel) AS sum_distance,
            ROUND(SUM(monetory_cost),2) AS sum_cost
    FROM uber_request_logs
    GROUP BY FORMAT(request_date, 'yyyy-MM')
),
distance_per_dollar AS (
    SELECT year_month, ROUND(sum_distance/sum_cost,2) AS dist_per_dollar
    FROM monthly_aggregates
),
naive_forcast AS (
    SELECT *,
            LAG(dist_per_dollar, 1) OVER (ORDER BY year_month) AS forcasted_value
    FROM distance_per_dollar
)
SELECT ROUND(SQRT(AVG(POWER((dist_per_dollar - forcasted_value), 2))), 2) AS rmse
FROM naive_forcast
WHERE dist_per_dollar IS NOT NULL;