USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Airbnb: Find the total number of available beds per hosts' nationality.
-- Output the nationality along with the corresponding total number of available beds.
-- Sort records by the total available beds in descending order.

CREATE TABLE Airbnb_apartments (
    host_id INT,
    apartment_id VARCHAR(5),
    apartment_type VARCHAR(10),
    n_beds INT,
    n_bedrooms INT,
    country VARCHAR(20),
    city VARCHAR(20)
);

INSERT INTO Airbnb_apartments VALUES
(0,'A1','Room',1,1,'USA','NewYork'),(0,'A2','Room',1,1,'USA','NewJersey'),(0,'A3','Room',1,1,'USA','NewJersey'),
(1,'A4','Apartment',2,1,'USA','Houston'),(1,'A5','Apartment',2,1,'USA','LasVegas'),(3,'A7','Penthouse',3,3,'China','Tianjin'),
(3,'A8','Penthouse',5,5,'China','Beijing'),(4,'A9','Apartment',2,1,'Mali','Bamako'),(5,'A10','Room',3,1,'Mali','Segou');

CREATE TABLE Airbnb_hosts (
    host_id INT,
    nationality VARCHAR(15),
    gender VARCHAR(5),
    age INT
);

INSERT INTO Airbnb_hosts VALUES
(0,'USA','M',28),(1,'USA','F',29),(2,'China','F',31),(3,'China','M',24),(4,'Mali','M',30),(5,'Mali','F',30);

SELECT * FROM Airbnb_apartments;
SELECT * FROM Airbnb_hosts;

WITH aggregated_hosts AS (
    SELECT nationality, COUNT(host_id) AS total_hosts_per_nationality
    FROM Airbnb_hosts
    GROUP BY nationality
),
aggregated_apartments AS (
    SELECT country, SUM(n_beds) AS total_beds_per_nationality
    FROM Airbnb_apartments
    GROUP BY country
)
SELECT h.nationality, a.total_beds_per_nationality
FROM aggregated_apartments AS a
JOIN aggregated_hosts AS h
ON h.nationality = a.country
WHERE (h.total_hosts_per_nationality < a.total_beds_per_nationality) or (h.total_hosts_per_nationality = a.total_beds_per_nationality)
ORDER BY a.total_beds_per_nationality DESC;

-- or

SELECT h.nationality, SUM(a.n_beds) AS total_beds
FROM Airbnb_apartments AS a
JOIN Airbnb_hosts AS h
ON a.host_id = h.host_id
GROUP BY h.nationality
ORDER BY total_beds DESC;