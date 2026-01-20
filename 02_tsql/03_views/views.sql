
 ----------------
-- CREATE VIEW = create a stored view
----------------
CREATE VIEW dbo.View_EmployeeSales AS                      -- CREATE VIEW = create view; dbo = schema
SELECT
    e.FirstName,                                           -- FirstName = employee first name
    e.LastName,                                            -- LastName = employee last name
    SUM(i.Total) AS TotalSales                             -- SUM() = total sales; TotalSales = alias
FROM dbo.Employee e                                        -- dbo.Employee = base table; e = alias
JOIN dbo.Customer c                                        -- dbo.Customer = base table; c = alias
    ON e.EmployeeId = c.SupportRepId                       -- join employees to customers
JOIN dbo.Invoice i                                         -- dbo.Invoice = base table; i = alias
    ON c.CustomerId = i.CustomerId                         -- join customers to invoices
GROUP BY
    e.FirstName,                                           -- GROUP BY = required for non-aggregated columns
    e.LastName;                                            -- GROUP BY = required for non-aggregated columns


----------------
-- SELECT FROM VIEW = read data from a view
----------------
SELECT *
FROM dbo.View_EmployeeSales;                               -- SELECT * = read from the view


----------------
-- CREATE OR ALTER VIEW = safely create or update a view
----------------
CREATE OR ALTER VIEW dbo.View_EmployeeSales AS             -- CREATE OR ALTER = avoids "already exists" errors
SELECT
    e.FirstName,                                           -- FirstName = employee first name
    e.LastName,                                            -- LastName = employee last name
    e.Title,                                               -- Title = employee job title
    SUM(i.Total) AS TotalSales                             -- SUM() = total sales
FROM dbo.Employee e                                        -- dbo.Employee = base table
JOIN dbo.Customer c                                        -- dbo.Customer = base table
    ON e.EmployeeId = c.SupportRepId                       -- join condition
JOIN dbo.Invoice i                                         -- dbo.Invoice = base table
    ON c.CustomerId = i.CustomerId                         -- join condition
GROUP BY
    e.FirstName,                                           -- GROUP BY = required
    e.LastName,                                            -- GROUP BY = required
    e.Title;                                               -- GROUP BY = required


----------------
-- WITH SCHEMABINDING = bind a view to the schema of the base tables
----------------
-- It guarantees the table schema cannot change while the view exists
-- Used for critical reporting/BI objects and required for indexed views
CREATE VIEW dbo.View_EmployeeSales_SchemaBound
WITH SCHEMABINDING
AS
SELECT
    e.EmployeeId,                                          -- EmployeeId = stable key; helps indexed view patterns
    e.FirstName,                                           -- FirstName = employee first name
    e.LastName,                                            -- LastName = employee last name
    e.Title,                                               -- Title = employee title
    COUNT_BIG(*) AS RowCount,                              -- COUNT_BIG(*) = required in indexed view aggregates
    SUM(i.Total) AS TotalSales                             -- SUM() = aggregated sales
FROM dbo.Employee e                                        -- schema-qualified table required
JOIN dbo.Customer c                                        -- schema-qualified table required
    ON e.EmployeeId = c.SupportRepId                       -- join condition
JOIN dbo.Invoice i                                         -- schema-qualified table required
    ON c.CustomerId = i.CustomerId                         -- join condition
GROUP BY
    e.EmployeeId,                                          -- GROUP BY = required for non-aggregated columns
    e.FirstName,                                           -- GROUP BY = required
    e.LastName,                                            -- GROUP BY = required
    e.Title;                                               -- GROUP BY = required


----------------
-- INDEXED VIEW = why an INDEX is created on a SCHEMABOUND VIEW
----------------
-- The index materializes the view results for faster repeated analytics queries
-- UNIQUE CLUSTERED INDEX is the first required index for an indexed view
CREATE UNIQUE CLUSTERED INDEX IX_View_EmployeeSales_SB
ON dbo.View_EmployeeSales_SchemaBound (EmployeeId, Title); -- Unique key = must be unique in the view result


----------------
-- DROP VIEW = permanently delete a view
----------------
-- Keep DROP statements at the bottom so you do not accidentally delete objects
DROP VIEW dbo.View_EmployeeSales;                          -- DROP VIEW = removes the view
