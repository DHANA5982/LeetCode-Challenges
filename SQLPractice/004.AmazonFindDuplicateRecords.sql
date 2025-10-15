USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Amazon: Find duplicate records

SELECT ename, department, COUNT(*)
FROM Microsoft_Employee
WHERE salary IS NOT NULL
GROUP BY ename, department
HAVING COUNT(*) > 1;