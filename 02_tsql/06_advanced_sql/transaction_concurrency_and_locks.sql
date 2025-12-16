
----------------
-- ROWLOCK = lock individual rows only
----------------
SELECT *
FROM Orders WITH (ROWLOCK)                     -- ROWLOCK = forces row-level locking
WHERE OrderId = 10;                            -- Only this row is locked, not the page or the table

UPDATE Orders WITH (ROWLOCK)                   -- UPDATE using row-level locking
SET Status = 'Shipped'                         -- Changes the order status
WHERE OrderId = 10;                            -- Affects only one specific row

DELETE FROM Orders WITH (ROWLOCK)              -- DELETE with minimal locking
WHERE OrderId = 10;                            -- Other rows remain accessible


----------------
-- UPDLOCK = lock rows for read-then-update
----------------
BEGIN TRANSACTION                              -- Starts a transaction

SELECT *
FROM Products WITH (UPDLOCK)                   -- UPDLOCK = prevents other sessions from updating
WHERE ProductId = 5;                           -- This row cannot be modified by others

UPDATE Products                                -- Safe UPDATE
SET Stock = Stock - 1                          -- Decreases stock by one unit
WHERE ProductId = 5;                           -- Same row previously read

COMMIT                                        -- Commits and releases the lock



----------------
-- HOLDOCK = simulate SERIALIZABLE at query level
----------------
BEGIN TRANSACTION                              -- Starts a transaction

SELECT *
FROM Orders WITH (HOLDLOCK)                    -- HOLDLOCK = keeps locks until COMMIT
WHERE CustomerId = 20;                         -- Prevents changes and phantom rows

COMMIT                                        -- Releases the locks


----------------
-- HOLDOCK + UPDLOCK = precise control without changing global isolation
----------------
BEGIN TRANSACTION                              -- Starts a transaction

SELECT *
FROM Products WITH (UPDLOCK, HOLDLOCK)         -- UPDLOCK = update lock
WHERE ProductId = 3;                           -- HOLDLOCK = prevents changes and phantoms

UPDATE Products                                -- Protected update
SET Price = 99.99                              -- Sets a new price
WHERE ProductId = 3;                           -- Same record

COMMIT                                        -- Commits changes and releases locks



----------------
-- READ UNCOMMITTED = read uncommitted data (dirty reads allowed)
----------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;      -- READ UNCOMMITTED = lowest isolation level; allows dirty reads
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts the transaction
SELECT *                                               -- SELECT = read data
FROM Orders;                                           -- FROM Orders = reads rows even if not committed
COMMIT;                                                -- COMMIT = ends transaction


----------------
-- READ COMMITTED = read only committed data (default level)
----------------
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;        -- READ COMMITTED = default level; blocks dirty reads
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts the transaction
SELECT *                                               -- SELECT = read confirmed data only
FROM Orders;                                           -- FROM Orders = waits if rows are being modified
COMMIT;                                                -- COMMIT = ends transaction


----------------
-- REPEATABLE READ = prevent changes to already read rows
----------------
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;       -- REPEATABLE READ = locks rows that are read
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts the transaction
SELECT *                                               -- SELECT = read rows
FROM Orders                                            -- FROM Orders = rows cannot be updated by others
WHERE Amount > 100;                                   -- WHERE = selected rows stay locked
COMMIT;                                                -- COMMIT = releases row locks


----------------
-- SERIALIZABLE = highest isolation level
----------------
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;          -- SERIALIZABLE = maximum isolation; range locking
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts the transaction
SELECT *                                               -- SELECT = read data
FROM Orders                                            -- FROM Orders = locks rows and ranges
WHERE Amount > 100;                                   -- WHERE = prevents insert/update/delete in this range
COMMIT;                                                -- COMMIT = ends transaction and releases all locks


----------------
-- WAITFOR DELAY = pause execution for a defined amount of time
----------------
WAITFOR DELAY '00:00:10';                              -- WAITFOR DELAY = pauses execution; 00:00:10 = waits 10 seconds


----------------
-- WAITFOR DELAY = simulate a long process inside a transaction
----------------
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts a transaction
UPDATE Orders                                         -- UPDATE Orders = Orders table
SET Status = 'Processing'                              -- SET Status = updates the status column
WHERE OrderId = 10;                                   -- WHERE OrderId = affects only one order
WAITFOR DELAY '00:00:15';                              -- WAITFOR DELAY = keeps the transaction open for 15 seconds
COMMIT;                                               -- COMMIT = confirms the changes


----------------
-- WAITFOR DELAY = test concurrency locks
----------------
BEGIN TRANSACTION                                      -- BEGIN TRANSACTION = starts a transaction
SELECT *                                               -- SELECT = retrieves data
FROM Products WITH (UPDLOCK)                           -- UPDLOCK = locks rows for a future update
WHERE ProductId = 5;                                  -- WHERE = specific row
WAITFOR DELAY '00:01:00';                              -- WAITFOR DELAY = keeps the lock for 1 minute
COMMIT;                                               -- COMMIT = releases the locks


----------------
-- WAITFOR TIME = wait until a specific server time
----------------
WAITFOR TIME '15:30:00';                               -- WAITFOR TIME = waits until the server clock reaches this time


----------------
-- WAITFOR DELAY = control script flow
----------------
PRINT 'Process started';                               -- PRINT = displays a message
WAITFOR DELAY '00:00:05';                              -- WAITFOR DELAY = pauses before continuing
PRINT 'Process continued';                             -- PRINT = message after the wait
