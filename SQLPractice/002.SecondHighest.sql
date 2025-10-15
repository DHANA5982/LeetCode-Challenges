USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Retrieve second highest salary

CREATE TABLE Microsoft_Employee (
    id INT,
    ename VARCHAR(20),
    department VARCHAR(20),
    salary FLOAT
);

INSERT INTO Microsoft_Employee VALUES
(1, 'Ryan Gallagher', 'Accounts', 9250), (2, 'Jon Cole', 'HR', 5138), (3, 'Rachel Davis', 'Marketing', 6140), (4, 'Russell Reynolds', 'HR', 8600), 
(5, 'April Griffin', 'HR', 8517), (6, 'Crystal Landry', 'HR', 3138), (7, 'Amanda Johnson', 'Marketing', 6052), (8, 'Teresa James', 'Logistics', 9043), 
(9, 'Javier Johnson', 'Logistics', 9017), (10, 'Jeffrey Simpson', 'HR', 2110), (11, 'David Robinson', 'Marketing', 9672), (12, 'Dylan Smith', 'Marketing', 8602), 
(13, 'Kristie May', 'Accounts', 6832), (14, 'Willie Heath', 'HR', 8939), (15, 'Gary Griffith', 'Accounts', 4698), (16, 'Taylor Henderson', 'Logistics', 4265), 
(17, 'Meagan Turner', 'Logistics', 1457), (18, 'Sonya Mathis', 'HR', 3036), (19, 'Leah Johnson', 'HR', 9177), (20, 'Robert Perry', 'Marketing', 3816);

SELECT * FROM Microsoft_Employee;

SELECT TOP 1 * FROM Microsoft_Employee
WHERE salary < (SELECT MAX(salary) 
                FROM Microsoft_Employee);

-- or 

SELECT * FROM Microsoft_Employee
WHERE salary = (SELECT salary 
                FROM Microsoft_Employee 
                ORDER BY salary DESC 
                OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);