
----------------
-- TRY...CATCH + TRANSACTION = handle errors and control commits/rollbacks
----------------
BEGIN TRY                                                       -- start a TRY block to catch potential errors
    BEGIN TRANSACTION;                                          -- begin a manual transaction

    INSERT INTO [dbo].[Sales] (sale_id, user_id, sale_date,      -- target columns for the sale
        product_id, product_name, product_category, unit_price,  -- product details and pricing
        quantity, discount_applied, total_amount, payment_method,-- quantity, discount, total, payment
        subscription_plan, sales_channel, region, sales_rep_id)  -- plan, channel, region, sales rep
    VALUES
    ('S054', 'TH040', GETDATE(), 'SUB-003', 'Enterprise Subscription',  -- first sale attempt
        'Enterprise', 24.99, 12, 15.0, 254.90, 'Credit Card', 'Enterprise', 'Online', 'Canada', 'REP006'),
    ('S055', 'TH040', GETDATE(), 'PRO-001', 'HealthTrack Elite',        -- second sale attempt
        'Device', 499.99, 1, 0.0, 499.99, 'Credit Card', 'Premium', 'Online', 'Canada', 'REP006');

    COMMIT;                                                     -- if no error happens, commit the transaction
END TRY                                                         -- end TRY block
BEGIN CATCH                                                     -- if an error occurs, execute this block
    ROLLBACK;                                                   -- undo the transaction to avoid bad data
    PRINT 'Error message: ' + ERROR_MESSAGE();                  -- print the SQL Server error message
END CATCH;                                                      -- end CATCH block
GO                                                              -- execute the batch
