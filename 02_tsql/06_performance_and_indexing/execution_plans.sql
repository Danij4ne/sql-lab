

----------------
-- SET SHOWPLAN_TEXT ON = display the execution plan without running the query
----------------
SET SHOWPLAN_TEXT ON;                      -- SET = configure SQL Server; SHOWPLAN_TEXT = show the plan; ON = enable mode


----------------
-- SELECT = query that is analyzed but not executed
----------------
SELECT *                                  -- SELECT * = select all columns
FROM Orders                               -- FROM Orders = Orders table
WHERE total_amount > 500;                 -- WHERE = filter; total_amount > 500 = only orders greater than 500


----------------
-- GO = execute the previous batch
----------------
GO                                        -- GO = send the batch to the SQL Server engine


----------------
-- SET SHOWPLAN_TEXT OFF = return to normal execution mode
----------------
SET SHOWPLAN_TEXT OFF;                    -- OFF = disable show plan mode


