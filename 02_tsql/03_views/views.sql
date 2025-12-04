
----------------
-- CREATE VIEW = create a stored view
----------------
CREATE VIEW View_EmployeeSales AS
SELECT e.FirstName,                     -- e.FirstName = employee first name
       e.LastName,                      -- e.LastName = employee last name
       SUM(i.Total) AS TotalSales       -- SUM(i.Total) = total sales; AS TotalSales = alias
FROM Employee e                         -- Employee table with alias e
JOIN Customer c ON e.EmployeeId = c.SupportRepId     -- link employees with customers
JOIN Invoice i ON c.CustomerId = i.CustomerId        -- link customers with invoices
GROUP BY e.FirstName, e.LastName;       -- group by first and last name


----------------
-- SELECT FROM VIEW = read data from a view
----------------
SELECT *
FROM View_EmployeeSales;                -- query the stored view


----------------
-- ALTER VIEW = modify an existing view
----------------
ALTER VIEW View_EmployeeSales AS
SELECT e.FirstName,                     -- employee first name
       e.LastName,                      -- employee last name
       e.Title,                         -- NEW: employee job title
       SUM(i.Total) AS TotalSales       -- total sales
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.FirstName, e.LastName, e.Title;   -- group by all non-aggregated columns


----------------
-- CREATE OR ALTER VIEW = safely create or update a view
----------------
CREATE OR ALTER VIEW View_EmployeeSales AS
SELECT e.FirstName,                     -- employee first name
       e.LastName,                      -- employee last name
       e.Title,                         -- employee job title
       SUM(i.Total) AS TotalSales       -- total sales
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.FirstName, e.LastName, e.Title;


----------------
-- DROP VIEW = permanently delete a view
----------------
DROP VIEW View_EmployeeSales;
