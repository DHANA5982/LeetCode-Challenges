USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Google: Top 3 highest paid employees

SELECT TOP 3 * FROM Microsoft_Employee
ORDER BY salary DESC;