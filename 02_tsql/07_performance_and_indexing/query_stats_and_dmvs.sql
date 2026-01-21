

----------------
-- sys.dm_exec_query_stats = view query execution statistics
----------------
SELECT TOP 10                                  -- TOP 10 = only the top 10 most important queries
    qs.sql_handle,                             -- sql_handle = query identifier
    qs.execution_count,                        -- execution_count = how many times it ran
    qs.total_worker_time,                      -- total_worker_time = total CPU used
    qs.total_physical_reads                    -- total_physical_reads = disk reads
FROM sys.dm_exec_query_stats qs                -- sys.dm_exec_query_stats = cached query stats (historical)
ORDER BY qs.total_worker_time DESC;            -- sort by CPU usage (highest first)


----------------
-- execution_count = how many times a query ran
----------------
SELECT
    qs.execution_count                         -- execution_count = number of executions
FROM sys.dm_exec_query_stats qs;               -- sys.dm_exec_query_stats = performance history


----------------
-- total_worker_time = CPU used by a query
----------------
SELECT
    qs.total_worker_time                       -- total_worker_time = total CPU time consumed
FROM sys.dm_exec_query_stats qs;               -- sys.dm_exec_query_stats = performance history


----------------
-- sys.dm_exec_requests = view active requests in real time
----------------
SELECT *                                       -- SELECT * = return all request columns (status, waits, reads, etc.)
FROM sys.dm_exec_requests;                     -- sys.dm_exec_requests = requests currently running on the instance


----------------
-- logical_reads = find the active requests that read the most from memory
----------------
SELECT TOP 10                                  -- TOP 10 = show the 10 highest logical reads right now
    r.session_id,                              -- session_id = session executing the request
    r.logical_reads,                           -- logical_reads = pages read from buffer cache (memory)
    st.text                                    -- text = SQL text being executed
FROM sys.dm_exec_requests AS r                 -- dm_exec_requests = active requests
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st -- sql_text = get query text for each request
ORDER BY r.logical_reads DESC;                 -- sort by memory reads (highest first)


----------------
-- sys.dm_exec_query_stats + dm_exec_sql_text = show the most expensive cached queries (CPU/IO)
----------------
SELECT TOP 10
    st.text AS [SQL Text],                     -- SQL Text = full query text
    qs.total_elapsed_time,                     -- total_elapsed_time = total time (CPU + waits)
    qs.total_worker_time,                      -- total_worker_time = total CPU time
    qs.total_physical_reads,                   -- total_physical_reads = disk reads
    qs.total_logical_reads                     -- total_logical_reads = memory reads
FROM sys.dm_exec_query_stats AS qs             -- dm_exec_query_stats = aggregated stats per cached plan
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st -- dm_exec_sql_text = retrieve SQL from sql_handle
ORDER BY qs.total_worker_time DESC;            -- sort by CPU (highest first)


----------------
-- WHERE LIKE = filter cached queries by a text pattern
----------------
SELECT
    st.text AS [SQL Text],                     -- SQL Text = query text that matches the pattern
    qs.total_elapsed_time,                     -- total_elapsed_time = total runtime (including waits)
    qs.total_worker_time,                      -- total_worker_time = CPU time
    qs.total_physical_reads,                   -- total_physical_reads = disk reads
    qs.total_logical_reads                     -- total_logical_reads = memory reads
FROM sys.dm_exec_query_stats AS qs             -- query stats for cached plans
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st -- get SQL text
WHERE st.text LIKE '%p.product_name%'          -- LIKE = search for a substring inside the query text
ORDER BY qs.total_logical_reads DESC;          -- sort by memory reads (highest first)


----------------
-- DB_NAME() = filter active requests by database name
----------------
SELECT
    r.session_id,                              -- session_id = session executing the request
    r.logical_reads,                           -- logical_reads = pages read from memory by the request
    st.text,                                   -- text = SQL being executed
    DB_NAME(r.database_id) AS database_name    -- DB_NAME() = convert database_id into database name
FROM sys.dm_exec_requests r                    -- dm_exec_requests = active requests
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st -- dm_exec_sql_text = get SQL text
WHERE DB_NAME(r.database_id) = 'YourDatabaseName'; -- filter to only one database


