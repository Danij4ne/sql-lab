
----------------
-- OLAP_QUERY() = typical analytical query (aggregation + dimensions)
----------------
SELECT                                                   -- SELECT = final analysis
    dp.product_category,                                -- product_category = dimension to group by
    SUM(fs.total_amount) AS total_sales                 -- SUM = total sales
FROM dbo.FactSales fs                                   -- FactSales = fact table
JOIN dbo.DimProduct dp ON fs.product_key = dp.product_key -- JOIN = join by key
GROUP BY dp.product_category;                           -- GROUP BY = report by category

----------------
-- INDEX_FACT_KEYS() = typical indexes on fact keys to speed up joins and filters
----------------
CREATE INDEX IDX_FactSales_DateKey 
ON dbo.FactSales(date_key);                              -- index = improves date filtering and joins
GO                                                      -- GO = execute
CREATE INDEX IDX_FactSales_CustomerKey 
ON dbo.FactSales(customer_key);                          -- index = improves joins with customer
GO                                                      -- GO = execute
CREATE INDEX IDX_FactSales_ProductKey 
ON dbo.FactSales(product_key);                           -- index = improves joins with product
GO                                                      -- GO = execute



