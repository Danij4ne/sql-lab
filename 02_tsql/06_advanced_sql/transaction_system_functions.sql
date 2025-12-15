
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
-- @@ROWCOUNT = get the number of rows affected by the last operation
----------------
UPDATE Customers                                     -- UPDATE = modify records
SET SubscriptionType = 'Premium'                     -- New value for the subscription
WHERE UserId = 'TH015';                              -- Filter by specific customer

IF @@ROWCOUNT = 0                                    -- @@ROWCOUNT = number of affected rows
    THROW 50001, 'Customer not found', 1;            -- THROW = raise an error if no rows were updated
