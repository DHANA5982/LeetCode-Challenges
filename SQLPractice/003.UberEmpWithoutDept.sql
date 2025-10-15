USE AzureSQLdb;

SELECT NAME FROM sys.tables;

-- Uber: Find employees without department

INSERT INTO Microsoft_Employee VALUES
(21, 'Ryan Gallagher', NULL, 1515), (22, 'Jon Cole', 'Logistics', 5527), (23, 'Rachel Davis', NULL, 3973), (24, 'Russell Reynolds', 'HR', 9833), 
(25, 'April Griffin', 'Marketing', 7397), (26, 'Crystal Landry', 'Logistics', 7620), (27, 'Amanda Johnson', 'HR', 3530), (28, 'Teresa James', 'Accounts', 3371), 
(29, 'Javier Johnson', 'Marketing', 8589), (30, 'Jeffrey Simpson', 'Logistics', 9559), (31, 'David Robinson', 'Marketing', 9359), 
(32, 'Dylan Smith', 'Marketing', 5021), (33, 'Kristie May', NULL, 5446), (34, 'Willie Heath', 'Logistics', 4314), (35, 'Gary Griffith', 'HR', 2085), 
(36, 'Taylor Henderson', 'Logistics', 3308), (37, 'Meagan Turner', 'Logistics', 2688), (38, 'Sonya Mathis', 'Logistics', 1066), (39, 'Leah Johnson', NULL, 1578), 
(40, 'Robert Perry', 'Logistics', 2971);

SELECT * FROM Microsoft_Employee;

SELECT * FROM Microsoft_Employee
WHERE department IS NULL;