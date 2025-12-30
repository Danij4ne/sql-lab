

----------------
-- sys.dm_exec_query_stats = view query execution statistics
----------------
SELECT TOP 10                                  -- TOP 10 = only the top 10 most important queries
    qs.sql_handle,                             -- sql_handle = query identifier
    qs.execution_count,                       -- execution_count = how many times it ran
    qs.total_worker_time,                     -- total_worker_time = total CPU used
    qs.total_physical_reads                  -- total_physical_reads = disk reads
FROM
    sys.dm_exec_query_stats qs                -- internal DMV that stores query statistics
ORDER BY
    qs.total_worker_time DESC;                -- DESC = sort from highest to lowest CPU usage


----------------
-- execution_count = how many times a query ran
----------------
SELECT qs.execution_count                     -- execution_count = number of executions
FROM sys.dm_exec_query_stats qs;              -- DMV that stores performance statistics


----------------
-- total_worker_time = CPU used by a query
----------------
SELECT qs.total_worker_time                   -- total_worker_time = total CPU time
FROM sys.dm_exec_query_stats qs;              -- sys.dm_exec_query_stats = performance history



