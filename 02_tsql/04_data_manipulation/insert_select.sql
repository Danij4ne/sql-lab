
----------------
-- INSERT INTO ... SELECT = insert rows by copying them from another table
----------------

INSERT INTO [dbo].[NewEmployees] (FirstName, LastName)      -- destination table and columns to insert into
SELECT FirstName, LastName                                  -- columns copied from the source table
FROM [dbo].[Employees]                                      -- source table
WHERE HireDate >= '2024-01-01';                             -- copy only employees hired on or after 2024
