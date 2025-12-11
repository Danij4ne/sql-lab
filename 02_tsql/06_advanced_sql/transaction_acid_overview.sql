-- BEGIN TRANSACTION = start a transaction

BEGIN TRANSACTION; -- Starts a work block; nothing is committed yet

-- COMMIT TRANSACTION = confirm changes

COMMIT TRANSACTION; -- Saves all changes made since BEGIN

-- ROLLBACK TRANSACTION = undo changes

ROLLBACK TRANSACTION; -- Reverts all changes made since BEGIN

-- @@ERROR = detect errors from the last operation

SELECT @@ERROR AS ErrorCode; -- 0 = no error; non-zero = an error occurred

-- FULL_TRANSACTION = execute multiple operations as a single block

BEGIN TRANSACTION; -- Start of transaction
UPDATE Accounts -- Accounts table
SET Balance = Balance - 100 -- Subtract 100
WHERE AccountID = 1; -- Source account

UPDATE Accounts -- Second operation
SET Balance = Balance + 100 -- Add 100
WHERE AccountID = 2; -- Destination account

IF @@ERROR <> 0 -- Error check
ROLLBACK TRANSACTION; -- Undo everything on failure
ELSE -- If no error
COMMIT TRANSACTION; -- Confirm changes

-- ATOMICITY = all or nothing

BEGIN TRANSACTION; -- Start of transaction
UPDATE Accounts
SET Balance = Balance - 100 -- Debit
WHERE AccountID = 1; -- Account 1

UPDATE Accounts
SET Balance = Balance + 100 -- Credit
WHERE AccountID = 2; -- Account 2

IF @@ERROR <> 0 -- Error detected
ROLLBACK TRANSACTION; -- Revert changes
ELSE
COMMIT TRANSACTION; -- Save everything

-- CONSISTENCY = keep the database in a valid state

BEGIN TRANSACTION; -- Consistency control

UPDATE Products
SET Quantity = Quantity - 5 -- Subtract 5 units
WHERE ProductID = 200; -- Target product

IF (SELECT Quantity FROM Products WHERE ProductID = 200) < 0 -- Business rule check
ROLLBACK TRANSACTION; -- Prevent negative inventory
ELSE
COMMIT TRANSACTION; -- Valid state → confirm

-- ISOLATION = transactions run without interfering with each other

-- User 1
BEGIN TRANSACTION; -- Starts transaction
UPDATE Inventory
SET Quantity = Quantity - 5 -- Decrease stock
WHERE ProductID = 101; -- Product 101
COMMIT; -- Confirm changes

-- User 2
BEGIN TRANSACTION; -- Independent transaction
UPDATE Inventory
SET Quantity = Quantity + 10 -- Increase stock
WHERE ProductID = 102; -- Product 102
COMMIT; -- No interference with user 1

-- DURABILITY = committed data survives system failures

BEGIN TRANSACTION; -- Start operation
INSERT INTO Orders (OrderID, CustomerID, Amount) -- Insert new order
VALUES (1050, 'C001', 250.00); -- Order details
COMMIT; -- Ensures data is stored on disk

-- SUMMARY = general transaction and ACID reminder

-- A transaction executes several operations as one unit.
-- If something fails → ROLLBACK.
-- If everything succeeds → COMMIT.
-- ACID guarantees accuracy, consistency, isolation, and durability.

-- TRANSACTION_COMMANDS = main transactional control functions

-- BEGIN TRANSACTION -- Start a transactional block
-- COMMIT TRANSACTION -- Confirm changes
-- ROLLBACK TRANSACTION -- Revert changes
-- @@ERROR -- Detect last-statement errors