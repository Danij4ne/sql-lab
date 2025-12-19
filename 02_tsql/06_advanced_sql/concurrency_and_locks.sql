
----------------
-- LCK_M_S = wait for shared lock (read) | Lock Mode: Shared
----------------
-- LCK_M_S occurs when a session wants to READ (SELECT) a row
-- but another session is holding an exclusive lock (UPDATE/DELETE)
-- The SELECT waits until the lock is released
SELECT *                                               -- SELECT = read operation that requires a Shared Lock (S)
FROM dbo.Devices                                      -- FROM dbo.Devices = table being read
WHERE device_id = 'DEV002';                            -- WHERE = specific row that may be locked by another session


----------------
-- LCK_M_X = wait for exclusive lock (write) | Lock Mode: Exclusive
----------------
-- LCK_M_X occurs when a session wants to WRITE (UPDATE/DELETE)
-- but another session already holds a lock on that row
-- The UPDATE waits until the other transaction finishes
UPDATE dbo.Devices                                    -- UPDATE = write operation that requires an Exclusive Lock (X)
SET gps_enabled = 0                                   -- SET = data modification requiring exclusivity
WHERE device_id = 'DEV002';                            -- WHERE = row that may be locked by another transaction


----------------
-- sys.dm_os_waiting_tasks = view waiting sessions (blocking)
----------------
-- This query shows WHO is blocked, WHO is blocking,
-- WHAT type of wait is happening, and WHICH query is waiting
SELECT                                                  -- wt = waiting tasks
    wt.session_id AS blocked_session,                  -- session_id = session that is blocked
    wt.blocking_session_id AS blocking_session,        -- blocking_session_id = session causing the block
    wt.wait_type,                                      -- wait_type = type of wait (e.g. LCK_M_S, LCK_M_X)
    wt.wait_duration_ms,                               -- wait_duration_ms = time waiting in milliseconds
    txt.text AS blocked_query                          -- text = SQL statement being executed by the blocked session
FROM sys.dm_os_waiting_tasks wt                        -- dm_os_waiting_tasks = active waits in SQL Server
JOIN sys.dm_exec_requests r                            -- dm_exec_requests = currently executing requests
    ON wt.session_id = r.session_id                    -- join to link waits with executing queries
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) txt     -- CROSS APPLY = retrieves the SQL text for the request
WHERE wt.blocking_session_id IS NOT NULL;              -- filters only real blocking scenarios


----------------
-- BLOCKING vs DEADLOCK = key difference
----------------
-- BLOCKING = one session waits while the other continues running
-- DEADLOCK = two sessions wait on each other and SQL Server kills one
BEGIN TRANSACTION;                                    -- BEGIN TRANSACTION = starts a transaction holding locks
UPDATE dbo.Devices                                    -- UPDATE = creates an exclusive lock
SET total_steps_recorded += 100                        -- modifies data inside the transaction
WHERE device_id = 'DEV002';                            -- row remains locked until COMMIT or ROLLBACK
-- COMMIT / ROLLBACK release locks                     -- without commit, other sessions remain blocked


----------------
-- PRACTICAL RULES TO AVOID BLOCKING
----------------
-- 1) Keep transactions short
-- 2) Always access tables in the same order
-- 3) Use indexes to avoid unnecessary locking
-- 4) Avoid overly strict isolation levels
-- 5) Use ROWLOCK or UPDLOCK only when justified
