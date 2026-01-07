--------------------------------------------------
-- HOW TO ANALYZE AND OPTIMIZE A QUERY USING INDEXES
--------------------------------------------------

1) MEASURE THE REAL COST OF A QUERY
----------------------------------
SET STATISTICS IO ON;      -- Measures how much data SQL Server reads (logical reads)
SET STATISTICS TIME ON;    -- Measures CPU time and total execution time


2) INTERPRET THE RESULTS
-----------------------
In the "Messages" tab you will see lines like:

Table 'Customers' ... logical reads 78  
Table 'Devices' ... logical reads 2  
Table 'HealthMetrics' ... logical reads 2  

-- logical reads = number of 8KB pages SQL Server had to read  
-- The higher the number, the more work and cost

Practical guideline:
- 0 to 500      → Excellent  
- 500 to 5,000  → Can be improved  
- 5,000+       → Real performance problem  


3) IDENTIFY IMPORTANT COLUMNS IN THE QUERY
------------------------------------------
Split the query columns into three groups:

A) FILTER columns (WHERE)
- d.device_status  
- hm.avg_daily_steps  
- c.subscription_type  

B) JOIN columns
- c.user_id = d.user_id  
- c.user_id = hm.user_id  

C) OUTPUT columns (SELECT only)
- c.gender  
- d.device_type  
- hm.total_active_days  


4) GOLDEN RULE FOR INDEX DESIGN
-------------------------------
Columns used in WHERE and JOIN go into the index key  
Columns used only in SELECT go into INCLUDE  


5) WHAT IS INCLUDE
-----------------
INCLUDE means: storing columns inside the index only to return them,  
but not to search or filter.

It prevents SQL Server from going back to the table (Key Lookup).

Practical rule:
- WHERE and JOIN columns → index key  
- SELECT columns → INCLUDE  


6) COLUMN ORDER INSIDE AN INDEX
-------------------------------
1) Equality columns (=, IN)  
2) Range columns (>, <, BETWEEN)  
3) JOIN columns (usually user_id)  


7) INDEXES PROPOSED FOR THIS QUERY
---------------------------------

TABLE: Devices  
Index:
- Key: (device_status, user_id)  
- INCLUDE: (device_type)  

TABLE: HealthMetrics  
Index:
- Key: (avg_daily_steps, user_id)  
- INCLUDE: (total_active_days)  

TABLE: Customers  
Index:
- Key: (subscription_type, user_id)  
- INCLUDE: (gender)  

-- INCLUDE allows the index to contain all required data  
-- so SQL Server does not need extra reads from the table  


8) CREATE THE INDEXES IN SQL SERVER
----------------------------------

CREATE NONCLUSTERED INDEX idx_devices_status_user  
ON Devices (device_status, user_id)  
INCLUDE (device_type);  


CREATE NONCLUSTERED INDEX idx_health_steps_user  
ON HealthMetrics (avg_daily_steps, user_id)  
INCLUDE (total_active_days);  


CREATE NONCLUSTERED INDEX idx_customers_subscription_user  
ON Customers (subscription_type, user_id)  
INCLUDE (gender);  


9) MEASURE AGAIN AFTER CREATING INDEXES
---------------------------------------
SET STATISTICS IO ON;  
SET STATISTICS TIME ON;  

-- Run the same query again  

Compare:
- logical reads before vs after  
- CPU and elapsed time before vs after  


10) WHEN NO IMPROVEMENT IS SEEN
------------------------------
If tables are small (for example fewer than 100 rows),  
SQL Server may prefer a Table Scan because it is cheaper.  
This is expected and correct behavior.  


11) COMMON MISTAKES
------------------
- Creating indexes on low-cardinality columns (e.g. gender)  
- Duplicating similar indexes  
- Creating too many unnecessary indexes  


12) PROFESSIONAL GOAL
--------------------
Use indexes to:
- Reduce logical reads  
- Convert Table Scans into Index Seeks  
- Speed up JOINs  
- Reduce CPU and execution time  
--------------------------------------------------
