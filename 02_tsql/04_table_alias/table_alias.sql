
----------------
-- TABLE ALIAS = assign a short name to a table
----------------
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customers c;
-- c. = alias for Customers


----------------
-- TABLE ALIAS = using aliases with multiple tables
----------------
SELECT c.CustomerId, i.Total
FROM Customers c
JOIN Invoices i ON c.CustomerId = i.CustomerId;
-- c. = Customers
-- i. = Invoices
-- ON defines the relationship


----------------
-- TABLE ALIAS = more descriptive aliases
----------------
SELECT cust.FirstName, cust.LastName
FROM Customers cust;
-- cust = more descriptive alias


----------------
-- TABLE ALIAS = required when both tables have the same column name
----------------
SELECT c.CustomerId, i.CustomerId
FROM Customers c
JOIN Invoices i ON c.CustomerId = i.CustomerId;
-- Both tables contain CustomerId
-- alias avoids conflicts


----------------
-- TABLE ALIAS = using AS (optional)
----------------
SELECT c.FirstName AS Name
FROM Customers AS c;
-- AS c = explicit alias
-- AS Name = rename result column


----------------
-- TABLE ALIAS = alias only exists inside the query
----------------
SELECT c.CustomerId
FROM Customers c;
-- c. only exists inside this SELECT
-- outside the query the table is still called Customers
