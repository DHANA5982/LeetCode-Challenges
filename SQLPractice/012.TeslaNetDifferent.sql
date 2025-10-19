USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- You are given a table of product launches by company by year.
-- Write a query to count the net difference between the number of products
-- companies launched in 2020 with the number of products companies launched in the previous year.
-- Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

CREATE TABLE Tesla_Car_Launches(
    year INT,
    company_name VARCHAR(15),
    product_name VARCHAR(15)
);

INSERT INTO Tesla_Car_Launches VALUES
(2019,'Toyota','Avalon'),(2019,'Toyota','Camry'),(2020,'Toyota','Corolla'),(2019,'Honda','Accord'),
(2019,'Honda','Passport'),(2019,'Honda','CR-V'),(2020,'Honda','Pilot'),(2019,'Honda','Civic'),
(2020,'Chevrolet','Trailblazer'),(2020,'Chevrolet','Trax'),(2019,'Chevrolet','Traverse'),
(2020,'Chevrolet','Blazer'),(2019,'Ford','Figo'),(2020,'Ford','Aspire'),(2019,'Ford','Endeavour'),
(2020,'Jeep','Wrangler');

SELECT * FROM Tesla_Car_Launches;

WITH aggregated_2019 AS(
    SELECT company_name, COUNT(*) AS total_19
    FROM Tesla_Car_Launches
    WHERE year = 2019
    GROUP BY company_name
),
aggregated_2020 AS(
    SELECT company_name, COUNT(*) AS total_20
    FROM Tesla_Car_Launches
    WHERE year = 2020
    GROUP BY company_name
)
SELECT c.company_name, (c.total_20 - p.total_19) AS diff
FROM aggregated_2019 AS p
RIGHT JOIN aggregated_2020 AS c
ON c.company_name = p.company_name
ORDER BY diff DESC;

-- or

WITH products_counts AS(
    SELECT company_name,
            SUM(CASE WHEN year = 2020 THEN 1 ELSE 0 END) AS products_2020,
            SUM(CASE WHEN year = 2019 THEN 1 ELSE 0 END) AS products_2019
    FROM Tesla_Car_Launches
    WHERE year IN (2019, 2020)
    GROUP BY company_name
)
SELECT company_name, products_2020 - products_2019 AS net_diff
FROM products_counts
ORDER BY net_diff DESC, company_name;