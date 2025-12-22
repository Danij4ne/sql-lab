
----------------
-- @@ROWCOUNT = get the number of rows affected by the last operation
----------------
UPDATE Customers                                     -- UPDATE = modify records
SET SubscriptionType = 'Premium'                     -- New value for the subscription
WHERE UserId = 'TH015';                              -- Filter by specific customer

IF @@ROWCOUNT = 0                                    -- @@ROWCOUNT = number of affected rows
    THROW 50001, 'Customer not found', 1;            -- THROW = raise an error if no rows were updated



----------------
-- @@ERROR = check if the last statement produced an error
----------------
BEGIN TRANSACTION;                                   -- Start a transaction

INSERT INTO Orders (OrderId, Amount)                 -- INSERT = insert a new row
VALUES (1, -100);                                    -- Invalid value that may break a CHECK constraint

IF @@ERROR <> 0                                      -- @@ERROR = error code of the last statement
BEGIN
    ROLLBACK TRANSACTION;                            -- ROLLBACK = undo the entire transaction
END
ELSE
BEGIN
    COMMIT TRANSACTION;                              -- COMMIT = save changes if no error occurred
END



----------------
-- @@TRANCOUNT = know how many transactions are currently open in the session
----------------
BEGIN TRANSACTION;                                                   -- BEGIN = increases @@TRANCOUNT by +1
PRINT 'After 1st BEGIN: ' + CAST(@@TRANCOUNT AS varchar(10));         -- @@TRANCOUNT = 1 (if there was no previous transaction)

BEGIN TRANSACTION;                                                   -- Nested BEGIN = increases @@TRANCOUNT by +1
PRINT 'After 2nd BEGIN: ' + CAST(@@TRANCOUNT AS varchar(10));         -- @@TRANCOUNT = 2 (nested transaction)

COMMIT;                                                              -- Inner COMMIT = decreases @@TRANCOUNT by -1 (no real commit yet)
PRINT 'After inner COMMIT: ' + CAST(@@TRANCOUNT AS varchar(10));      -- @@TRANCOUNT = 1 (outer transaction still open)

COMMIT;                                                              -- Outer COMMIT = decreases @@TRANCOUNT to 0 and actually commits
PRINT 'After outer COMMIT: ' + CAST(@@TRANCOUNT AS varchar(10));      -- @@TRANCOUNT = 0 (no active transaction)



----------------
-- SAVE TRANSACTION = create a rollback point inside a transaction
----------------
BEGIN TRANSACTION;                                    -- BEGIN TRANSACTION = starts an explicit transaction

UPDATE Customers                                     -- UPDATE = modify existing data
SET City = 'Cambridge'                               -- City = column; 'Cambridge' = new value
WHERE UserId = 'TH001';                              -- WHERE = filter affected customer

SAVE TRANSACTION SavePoint1;                          -- SAVE TRANSACTION = creates a savepoint named SavePoint1

UPDATE Customers                                     -- Second operation inside the same transaction
SET State = NULL                                     -- State = column; NULL = null value (may fail)
WHERE UserId = 'TH001';                              -- Same customer

IF @@ERROR <> 0                                      -- @@ERROR <> 0 = checks if last statement failed
    ROLLBACK TRANSACTION SavePoint1;                 -- ROLLBACK SavePoint1 = rollback only to the savepoint
ELSE
    COMMIT TRANSACTION;                              -- COMMIT = permanently save all changes


----------------
-- Nested transactions = BEGIN TRANSACTION can be nested, but only the outermost one truly commits/rolls back
----------------
USE TechHealthDb;                                                                 -- USE = select the database
GO                                                                                -- GO = batch separator

BEGIN TRANSACTION;                                                                -- Outer BEGIN = starts the real transaction scope
PRINT 'Outer BEGIN: @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10));           -- @@TRANCOUNT = shows active BEGIN count

INSERT INTO dbo.Customers (user_id, age, gender, city, state, country, occupation, income_bracket, registration_date, subscription_type)  -- Insert = create the customer
VALUES ('TH055', 33, 'F', 'Portland', 'OR', 'USA', 'Analyst', '75K-100K', GETDATE(), 'Basic');                                            -- GETDATE() = current date/time

BEGIN TRANSACTION;                                                                -- Inner BEGIN = increments @@TRANCOUNT (not an independent transaction)
PRINT 'Inner BEGIN: @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10));           -- @@TRANCOUNT = typically 2 here

INSERT INTO dbo.Sales (sale_id, user_id, sale_date, product_id, product_name, product_category, unit_price, quantity, discount_applied, total_amount, payment_method, subscription_plan, sales_channel, region, sales_rep_id)  -- Insert = related sale
VALUES ('S063', 'TH055', GETDATE(), 'PRO-001', 'HealthTrack Pro', 'Device', 199.99, 1, 0.00, 199.99, 'Credit Card', 'Basic', 'Online', 'West', 'REP003');                                                  -- Values = sale data

COMMIT;                                                                           -- Inner COMMIT = only decreases @@TRANCOUNT (does not persist yet)
PRINT 'Inner COMMIT: @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10));          -- @@TRANCOUNT = typically 1 here (outer still open)

-- ROLLBACK;                                                                      -- ROLLBACK anywhere = cancels the entire chain (sets @@TRANCOUNT to 0)

IF @@TRANCOUNT > 0                                                                -- IF = only commit if a transaction is still active
BEGIN                                                                             -- BEGIN = start IF block
    COMMIT;                                                                       -- Outer COMMIT = when @@TRANCOUNT reaches 0, changes are truly committed
    PRINT 'Outer COMMIT: @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10));      -- @@TRANCOUNT = 0 after the real commit
END                                                                               -- END = end IF block
ELSE                                                                              -- ELSE = no open transaction remains
BEGIN                                                                             -- BEGIN = start ELSE block
    PRINT 'Nothing to commit. @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS varchar(10)); -- @@TRANCOUNT = 0 means nothing is open
END;                                                                              -- END = end ELSE block


----------------
-- SET XACT_ABORT ON = automatic rollback when a runtime error occurs
----------------
USE TechHealthDb;                                                    -- USE = select the database
GO                                                                   -- GO = batch separator

SET XACT_ABORT ON;                                                   -- XACT_ABORT ON = SQL Server rolls back automatically on error

BEGIN TRANSACTION;                                                   -- BEGIN = start transaction
UPDATE dbo.Customers                                                 -- UPDATE = modify existing rows
SET income_bracket = '100K-125K'                                     -- SET = new column value
WHERE user_id = 'TH101';                                             -- WHERE = target specific customer

-- If any statement fails here, the whole transaction is rolled back -- Note = key XACT_ABORT behavior

COMMIT;                                                              -- COMMIT = persist changes if no errors
SET XACT_ABORT OFF;                                                  -- OFF = restore default behavior



----------------
-- XACT_STATE() = check whether a transaction can be committed after an error
----------------
USE TechHealthDb;                                                    -- USE = select the database
GO                                                                   -- GO = batch separator

BEGIN TRANSACTION;                                                   -- BEGIN = start transaction
BEGIN TRY                                                            -- TRY = operations that may fail
    -- Operation that may fail (constraint, FK, etc.)                 -- Comment = failure example
    INSERT INTO dbo.Sales (sale_id, user_id, sale_date, product_id, product_name, product_category, unit_price, quantity, discount_applied, total_amount, payment_method, subscription_plan, sales_channel, region, sales_rep_id)  -- INSERT = attempt insert
    VALUES ('S998', 'TH101', GETDATE(), 'PRO-001', 'HealthTrack Pro', 'Device', 199.99, 1, 0.00, -1.00, 'Credit Card', 'Basic', 'Online', 'West', 'REP003');                                               -- Negative total_amount = example error
    COMMIT;                                                           -- COMMIT = commit if no error occurred
END TRY                                                              -- END TRY = end try block
BEGIN CATCH                                                          -- CATCH = error handler
    PRINT 'XACT_STATE=' + CAST(XACT_STATE() AS varchar(10));          -- XACT_STATE() = 1 (committable), 0 (no transaction), -1 (uncommittable)
    IF XACT_STATE() = -1                                              -- -1 = transaction is doomed (only ROLLBACK allowed)
        ROLLBACK;                                                     -- ROLLBACK = safe exit
    ELSE IF XACT_STATE() = 1                                          -- 1 = transaction still committable
        ROLLBACK;                                                     -- ROLLBACK = choose to undo for safety
    PRINT 'Error: ' + ERROR_MESSAGE();                                 -- ERROR_MESSAGE() = detailed error text
END CATCH;                                                           -- END CATCH = end error handling


----------------
-- BEGIN DISTRIBUTED TRANSACTION = single transaction across multiple databases/servers (MSDTC)
----------------
USE master;                                                          -- USE = general context for the example
GO                                                                   -- GO = batch separator

BEGIN DISTRIBUTED TRANSACTION;                                       -- BEGIN DISTRIBUTED = escalates to MSDTC if multiple resources are involved

UPDATE OrderProcessing.dbo.Orders                                    -- UPDATE = modify data in another database
SET total_amount = total_amount + 50                                 -- SET = increase order total
WHERE order_id = 101;                                                -- WHERE = target order

UPDATE CustomerSupport.dbo.Tickets                                   -- UPDATE = modify data in a second database
SET status = 'Escalated'                                             -- SET = new ticket status
WHERE ticket_id = 7;                                                 -- WHERE = target ticket

COMMIT;                                                              -- COMMIT = commit across all resources if everything succeeds


