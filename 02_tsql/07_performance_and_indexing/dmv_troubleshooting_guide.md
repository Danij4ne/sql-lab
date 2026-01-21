# SQL Server DMV Troubleshooting Guide

## 1. The app is slow

**Check:** sys.dm_exec_requests
**Why:** Shows active queries in real time.
**Action:** Identify blocking, waits, and heavy queries.

## 2. CPU is high

**Check:** total_worker_time from sys.dm_exec_query_stats
**Why:** Finds CPU expensive queries.
**Action:** Review execution plans, optimize joins and filters.

## 3. Disk is slow

**Check:** total_physical_reads
**Why:** Indicates heavy disk I/O.
**Action:** Add indexes, reduce scans.

## 4. A specific query is slow

**Check:** WHERE st.text LIKE '%text%'
**Why:** Finds the query in cache.
**Action:** Analyze plan, optimize logic.

## 5. Memory pressure

**Check:** logical_reads
**Why:** Too many pages read from memory.
**Action:** Indexing, reduce SELECT \*.
