----------------
-- INSERT INTO ... SELECT = insert rows by copying them from another table
----------------
INSERT INTO [dbo].[NewEmployees] (FirstName, LastName)        -- target table and columns to insert into
SELECT FirstName, LastName                                    -- columns copied from the source table
FROM [dbo].[Employees]                                        -- source table
WHERE HireDate >= '2024-01-01';                               -- filter employees hired on or after 2024


----------------
-- TRANSACTION + INSERT = insert data with transaction control
----------------
BEGIN TRANSACTION;                                             -- start a manual transaction

INSERT INTO [dbo].[Sales] (sale_id, user_id, sale_date,        -- destination columns for the sale
    product_id, product_name, product_category, unit_price,    -- product details and unit price
    quantity, discount_applied, total_amount, payment_method,  -- quantity, discount, total, payment method
    subscription_plan, sales_channel, region, sales_rep_id)    -- subscription, channel, region, sales representative
VALUES
('S054', 'TH035', GETDATE(), 'SUB-001', 'Premium Subscription', -- first row inserted using GETDATE()
    'Subscription', 14.99, 12, 10.0, 161.89, 'Credit Card', 'Premium', 'Retail', 'Europe', 'REP005'),
('S055', 'TH035', GETDATE(), 'PRO-001', 'HealthTrack Lite',     -- second row inserted
    'Device', 199.99, 1, 20.0, 159.99, 'Credit Card', 'Premium', 'Retail', 'Europe', 'REP005');
GO                                                             -- execute the previous batch

SELECT * FROM [dbo].[Sales]                                   -- verify the new rows were added
WHERE user_id = 'TH035';                                      -- filter by user TH035
GO                                                             -- execute the query

COMMIT;                                                        -- commit the transaction and make changes permanent
GO                                                             -- execute the commit
