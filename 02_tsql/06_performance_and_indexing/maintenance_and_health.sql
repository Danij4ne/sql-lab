

----------------
-- INDEX_FRAGMENTATION_CHECK() = detect index fragmentation
----------------
SELECT OBJECT_NAME(i.object_id) AS TableName              -- OBJECT_NAME() = table name
     , i.name AS IndexName                                -- i.name = index name
     , ps.avg_fragmentation_in_percent                   -- avg_fragmentation = fragmentation percentage
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ps  -- DMF returning physical index stats
JOIN sys.indexes i                                       -- JOIN to link index with its table
  ON ps.object_id = i.object_id                          -- join by object id
 AND ps.index_id = i.index_id                            -- join by index id
WHERE ps.avg_fragmentation_in_percent >= 5;              -- filters relevant fragmented indexes


----------------
-- INDEX_REBUILD() = rebuild a highly fragmented index
----------------
ALTER INDEX ALL ON dbo.YourTable REBUILD;                -- REBUILD = drops and recreates the index


----------------
-- INDEX_REORGANIZE() = reorganize a moderately fragmented index
----------------
ALTER INDEX ALL ON dbo.YourTable REORGANIZE;             -- REORGANIZE = reorders without full rebuild


----------------
-- UPDATE_STATISTICS() = update table statistics
----------------
UPDATE STATISTICS dbo.YourTable;                         -- recalculates optimizer statistics


----------------
-- ENABLE_ADVANCED_OPTIONS() = enable advanced engine options
----------------
EXEC sp_configure 'show advanced options', 1;            -- exposes advanced configuration options
RECONFIGURE;                                             -- applies the change


----------------
-- ENABLE_SQLSERVER_AGENT() = enable the job scheduling engine
----------------
EXEC sp_configure 'Agent XPs', 1;                         -- enables SQL Server Agent
RECONFIGURE;                                             -- applies the change


----------------
-- DATABASE_INTEGRITY_CHECK() = check database consistency and corruption
----------------
DBCC CHECKDB ('YourDatabase');                            -- checks pages, indexes, and system tables


----------------
-- MAINTENANCE_ROUTINE_OVERVIEW() = typical automated maintenance workflow
----------------
EXEC sp_start_job 'Daily_Maintenance';                    -- runs a scheduled maintenance job
-- This job usually includes:                             -- descriptive note
-- Database backup                                       -- safety copy
-- Index rebuild or reorganize                           -- performance optimization
-- Update statistics                                     -- query plan refresh
-- DBCC CHECKDB                                          -- integrity verification








