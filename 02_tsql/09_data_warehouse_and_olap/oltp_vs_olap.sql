
----------------
-- OLTP_VS_OLAP() = OLTP writes transactions; OLAP analyzes using SELECT and aggregations
----------------
SELECT 'OLTP = INSERT/UPDATE/DELETE (app)' AS idea;      -- OLTP = daily application operations
SELECT 'OLAP = SELECT/GROUP BY/SUM (reporting)' AS idea;-- OLAP = analytics, reporting, and BI

----------------
-- OLTP_WRITE_EXAMPLE() = typical OLTP write example
----------------
INSERT INTO TechHealthDb.dbo.Sales (sale_id, user_id, product_id, sale_date, total_amount) -- INSERT = the app records a sale
VALUES ('S001','TH001','P001','2024-01-01',120.00);      -- VALUES = sample operational data

----------------
-- OLAP_READ_EXAMPLE() = typical analytical query (read-only)
----------------
SELECT                                                     -- SELECT = analysis
    CONVERT(INT, FORMAT(sale_date,'yyyyMMdd')) AS date_key, -- date_key = transform date for grouping
    SUM(total_amount) AS total_sales                       -- SUM = total sales
FROM TechHealthDb.dbo.Sales                                -- FROM = source (quick example)
GROUP BY CONVERT(INT, FORMAT(sale_date,'yyyyMMdd'));       -- GROUP BY = group by day (example)
