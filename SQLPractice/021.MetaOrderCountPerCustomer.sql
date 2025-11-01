--- Count of orders per customer

CREATE TABLE Meta_Customers (
    customer_id INT,
    customer_name TEXT
);

INSERT INTO Meta_Customers VALUES
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie'), (4, 'Diana');

CREATE TABLE Meta_Orders (
    order_id INT,
    customer_id INT,
    purchase_date DATE
);

INSERT INTO Meta_Orders VALUES
(101, 1, '2023-01-10'), (102, 2, '2023-01-12'), (103, 1, '2023-01-15'), (104, 3, '2023-01-20'), (105, 1, '2023-01-25'), (106, 2, '2023-02-01');

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) total_orders
FROM Meta_Customers AS c
JOIN Meta_Orders AS o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY COUNT(o.order_id) DESC;