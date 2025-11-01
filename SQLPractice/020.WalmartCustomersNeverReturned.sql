--- Find customers who made purchase and never returned products

CREATE TABLE Walmart_Customers (
    customer_id INT,
    customer_name TEXT
);

INSERT INTO Walmart_Customers VALUES
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie'), (4, 'Diana'), (5, 'Ethan');

CREATE TABLE Walmart_Orders (
    order_id INT,
    customer_id INT,
    purchase_date DATE
)

INSERT INTO Walmart_Orders VALUES
(101, 1, '2023-01-10'), (102, 2, '2023-01-12'), (103, 3, '2023-01-15'), (104, 4, '2023-01-20'), (105, 5, '2023-01-25');

CREATE TABLE Walmart_Returns (
    order_id INT,
    returned_date DATE
)

INSERT INTO Walmart_Returns VALUES
(102, '2023-02-01'), (104, '2023-02-05');

SELECT DISTINCT c.customer_id, c.customer_name
FROM Walmart_Customers AS c
JOIN Walmart_Orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN Walmart_Returns AS r
    ON r.order_id = o.order_id
WHERE r.order_id IS NULL;

--- or

SELECT DISTINCT c.customer_id, c.customer_name
FROM Walmart_Customers AS c
JOIN Walmart_Orders AS o
    ON o.customer_id = c.customer_id
WHERE o.order_id NOT IN (SELECT order_id FROM Walmart_Returns);