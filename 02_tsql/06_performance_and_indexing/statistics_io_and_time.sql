

----------------
-- SET STATISTICS IO = show how much data SQL Server reads when running a query
----------------
SET STATISTICS IO ON;                     -- SET = configure option; STATISTICS IO = read metrics; ON = enable measurement
SELECT *                                 -- SELECT = query data
FROM Orders;                             -- FROM Orders = table being queried
SET STATISTICS IO OFF;                   -- OFF = disable the measurement when no longer needed


----------------
-- SET STATISTICS TIME = show query execution time
----------------
SET STATISTICS TIME ON;                  -- TIME = measures CPU and execution time; ON = enable
SELECT *                                 -- SELECT = run a query
FROM Orders;                            -- FROM Orders = table being analyzed
SET STATISTICS TIME OFF;                -- OFF = turn off time measurement


----------------
-- YEAR() = extract the year from a date
----------------
SELECT
    YEAR(o.order_date) AS year           -- YEAR() = extract year; order_date = date column; AS year = output column name
FROM Orders o;                          -- Orders = table; o = alias for shorter reference


----------------
-- MONTH() = extract the month from a date
----------------
SELECT
    MONTH(o.order_date) AS month         -- MONTH() = extract month (1–12); order_date = date column; AS month = output column name
FROM Orders o;                          -- Orders = table; o = alias
