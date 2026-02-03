
----------------
-- ETL_EXTRACT() = extract data from OLTP (read-only)
----------------
SELECT *                                              -- SELECT = view source data
FROM TechHealthDb.dbo.Sales;                          -- Sales = operational table (OLTP)

----------------
-- ETL_TRANSFORM_DATEKEY() = transform date into date_key (yyyymmdd)
----------------
SELECT                                                -- SELECT = prepare data for loading
    sale_id,                                          -- sale_id = traceability to the source
    CONVERT(INT, FORMAT(sale_date,'yyyyMMdd')) AS date_key, -- date_key = date in DW format
    user_id,                                          -- user_id = customer business key
    product_id,                                       -- product_id = product business key
    total_amount                                      -- total_amount = metric
FROM TechHealthDb.dbo.Sales;                          -- FROM = OLTP source

----------------
-- ETL_LOAD_DIMCUSTOMER() = load customer dimension first
----------------
INSERT INTO dbo.DimCustomer (user_id, subscription_type) -- INSERT = load customer dimension
SELECT user_id, subscription_type                        -- SELECT = attributes for analysis
FROM TechHealthDb.dbo.Customers;                         -- Customers = OLTP source

----------------
-- ETL_LOAD_DIMPRODUCT() = load product dimension
----------------
INSERT INTO dbo.DimProduct (product_id, product_category) -- INSERT = load product dimension
SELECT product_id, product_category                       -- SELECT = attributes for analysis
FROM TechHealthDb.dbo.Products;                           -- Products = OLTP source

----------------
-- ETL_LOAD_FACTSALES() = load facts using business_key → surrogate_key mapping
----------------
INSERT INTO dbo.FactSales (sale_id, date_key, customer_key, product_key, total_amount) -- INSERT = load facts
SELECT                                                -- SELECT = data ready for the DW
    s.sale_id,                                        -- sale_id = original id
    CONVERT(INT, FORMAT(s.sale_date,'yyyyMMdd')) AS date_key, -- date_key = FK to DimDate
    dc.customer_key,                                  -- customer_key = mapped from user_id
    dp.product_key,                                   -- product_key = mapped from product_id
    s.total_amount                                    -- total_amount = metric
FROM TechHealthDb.dbo.Sales s                          -- Sales = OLTP source
JOIN dbo.DimCustomer dc ON s.user_id = dc.user_id      -- JOIN = map user_id → customer_key
JOIN dbo.DimProduct dp ON s.product_id = dp.product_id;-- JOIN = map product_id → product_key
