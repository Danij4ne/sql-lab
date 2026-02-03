
----------------
-- OLAP_DATABASE() = create a Data Warehouse for analytics
----------------
CREATE DATABASE TechHealthDW;                           -- TechHealthDW = separate analytics database
GO                                                      -- GO = execute batch
USE TechHealthDW;                                       -- USE = switch to the DW database
GO                                                      -- GO = execute batch

----------------
-- DIM_DATE() = time dimension to group by year / month / day
----------------
CREATE TABLE dbo.DimDate (                              -- DimDate = date table
    date_key INT PRIMARY KEY,                           -- date_key = yyyymmdd as INT
    date DATE NOT NULL,                                 -- date = real calendar date
    day INT NOT NULL,                                   -- day = day of month
    month INT NOT NULL,                                 -- month = month
    year INT NOT NULL                                   -- year = year
);                                                      -- end table

----------------
-- DIM_CUSTOMER() = dimension with descriptive customer data
----------------
CREATE TABLE dbo.DimCustomer (                          -- DimCustomer = descriptive customer table
    customer_key INT IDENTITY(1,1) PRIMARY KEY,         -- customer_key = internal surrogate key
    user_id VARCHAR(10) NOT NULL,                       -- user_id = OLTP business key for traceability
    subscription_type VARCHAR(50) NOT NULL              -- subscription_type = attribute for grouping / filtering
);                                                      -- end table

----------------
-- DIM_PRODUCT() = dimension with descriptive product data
----------------
CREATE TABLE dbo.DimProduct (                           -- DimProduct = descriptive product table
    product_key INT IDENTITY(1,1) PRIMARY KEY,          -- product_key = internal surrogate key
    product_id VARCHAR(20) NOT NULL,                    -- product_id = OLTP business key
    product_category VARCHAR(50) NOT NULL               -- product_category = attribute for grouping
);                                                      -- end table

----------------
-- FACT_SALES() = fact table with sales metrics and dimension keys
----------------
CREATE TABLE dbo.FactSales (                            -- FactSales = sales facts (metrics)
    sale_key INT IDENTITY(1,1) PRIMARY KEY,             -- sale_key = internal DW identifier
    sale_id VARCHAR(10) NOT NULL,                       -- sale_id = original OLTP id
    date_key INT NOT NULL,                              -- date_key = FK to DimDate
    customer_key INT NOT NULL,                          -- customer_key = FK to DimCustomer
    product_key INT NOT NULL,                           -- product_key = FK to DimProduct
    total_amount DECIMAL(10,2) NOT NULL,                -- total_amount = main metric
    CONSTRAINT FK_FactSales_DimDate
        FOREIGN KEY (date_key) REFERENCES dbo.DimDate(date_key),        -- FK = ensures valid date
    CONSTRAINT FK_FactSales_DimCustomer
        FOREIGN KEY (customer_key) REFERENCES dbo.DimCustomer(customer_key), -- FK = ensures valid customer
    CONSTRAINT FK_FactSales_DimProduct
        FOREIGN KEY (product_key) REFERENCES dbo.DimProduct(product_key)     -- FK = ensures valid product
);                                                      -- end table
