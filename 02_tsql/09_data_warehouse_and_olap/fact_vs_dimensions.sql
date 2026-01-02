
----------------
-- FACT_TABLE_RULE() = facts are metrics that can be aggregated (SUM / AVG / COUNT)
----------------
SELECT                                                -- SELECT = example of typical metrics
    SUM(total_amount) AS total_sales,                 -- SUM = aggregate metric (fact)
    COUNT(*) AS sales_count                           -- COUNT = number of events (fact)
FROM dbo.FactSales;                                   -- FactSales = fact table

----------------
-- DIMENSION_RULE() = dimensions describe entities (text / categories / attributes)
----------------
SELECT                                                -- SELECT = example of descriptive attributes
    customer_key,                                     -- customer_key = internal key
    user_id,                                          -- user_id = original id (traceability)
    subscription_type                                 -- subscription_type = attribute for segmentation
FROM dbo.DimCustomer;                                 -- DimCustomer = dimension

----------------
-- STAR_SCHEMA_JOIN() = analytics = Fact + Dimensions (join by keys)
----------------
SELECT                                                -- SELECT = typical analytical query
    dp.product_category,                              -- product_category = dimension to group by
    SUM(fs.total_amount) AS total_sales               -- total_amount = fact metric
FROM dbo.FactSales fs                                 -- FactSales = facts
JOIN dbo.DimProduct dp ON fs.product_key = dp.product_key -- JOIN = join by surrogate key
GROUP BY dp.product_category;                         -- GROUP BY = report by category

