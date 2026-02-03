# SQL Server DMV Cheat Sheet (General, didactic, copy/paste)

> Goal: **quickly find the query causing pain** (right now or in cache), grab **session_id + SQL text + a key metric**, and understand *why you’re running each query*.

---

## 0) First question (always)

**Is the problem happening RIGHT NOW, or did it happen earlier?**

- **RIGHT NOW (real-time):** use `sys.dm_exec_requests`
- **Earlier / overall impact (cached):** use `sys.dm_exec_query_stats`

Why this matters:

- `dm_exec_requests` = “what is running at this exact moment”
- `dm_exec_query_stats` = “what has been expensive since it got into cache”

---

## 1) Real-time: “What is running right now?”

### Why run this?

To see **active sessions** and quickly spot **who is consuming resources** *right now*.

```sql
SELECT TOP (25)
    r.session_id,
    DB_NAME(r.database_id) AS database_name,
    r.status,
    r.cpu_time,              -- CPU used so far (ms)
    r.logical_reads,         -- pages read from memory/buffer (often scans)
    r.reads,                 -- physical reads (disk-related)
    r.writes,
    r.total_elapsed_time,    -- how long it has been running (ms)
    r.wait_type,
    r.wait_time,
    r.blocking_session_id
FROM sys.dm_exec_requests AS r
WHERE r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;
```

How to interpret quickly:

- Big **logical_reads** → likely scanning lots of data
- Big **cpu_time** → CPU-heavy work (joins, aggregations, sorts)
- Big **total_elapsed_time** + wait_type/blocking → might be waiting or blocked

---

## 2) Real-time: “Give me the worst query RIGHT NOW” (TOP 1) + SQL text

### Why run this?

To answer: **“What is the single worst request at this moment?”** and get its **exact SQL**.

### 2A) Worst by logical reads (common for “it freezes”)

```sql
SELECT TOP (1)
    r.session_id,
    DB_NAME(r.database_id) AS database_name,
    r.cpu_time,
    r.logical_reads,
    r.reads,
    r.total_elapsed_time,
    r.wait_type,
    r.blocking_session_id,
    st.text AS sql_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id <> @@SPID
ORDER BY r.logical_reads DESC;
```

### 2B) Worst by CPU (common for “CPU spikes”)

```sql
SELECT TOP (1)
    r.session_id,
    DB_NAME(r.database_id) AS database_name,
    r.cpu_time,
    r.logical_reads,
    r.total_elapsed_time,
    st.text AS sql_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id <> @@SPID
ORDER BY r.cpu_time DESC;
```

What “CROSS APPLY …sql_text” is doing (1 line):

- It **translates** the internal `sql_handle` into human-readable **SQL text** (`st.text`).

---

## 3) Real-time: “Is it blocking?” (when “it’s stuck”)

### Why run this?

Sometimes it’s not a “slow query”, it’s **a query waiting on locks**.

```sql
SELECT TOP (25)
    r.session_id,
    r.blocking_session_id,
    r.status,
    r.wait_type,
    r.wait_time,
    r.total_elapsed_time,
    st.text AS sql_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.blocking_session_id <> 0
ORDER BY r.wait_time DESC;
```

Interpretation:

- If you see rows here, the victim query is blocked by `blocking_session_id`.

---

## 4) Cached: “Top CPU queries overall” (since they entered cache)

### Why run this?

To find **the worst offenders in aggregate** (not just right now). Great for reports.

```sql
SELECT TOP (25)
    qs.total_worker_time AS total_cpu,
    qs.execution_count,
    (qs.total_worker_time / NULLIF(qs.execution_count, 0)) AS avg_cpu_per_exec,
    qs.total_elapsed_time AS total_elapsed,
    qs.total_logical_reads AS total_logical_reads,
    qs.total_physical_reads AS total_physical_reads,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_worker_time DESC;
```

How to read it:

- **total_cpu** high → overall CPU heavy
- **avg_cpu_per_exec** high → expensive each time
- **execution_count** high → maybe not expensive, but called too often

---

## 5) Cached: “Top disk reads overall”

### Why run this?

To find queries causing **high physical I/O** (disk pressure).

```sql
SELECT TOP (25)
    qs.total_physical_reads AS total_disk_reads,
    qs.execution_count,
    (qs.total_physical_reads / NULLIF(qs.execution_count, 0)) AS avg_disk_reads_per_exec,
    qs.total_worker_time AS total_cpu,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_physical_reads DESC;
```

---

## 6) Cached: “Top logical reads overall” (memory/buffer reads)

### Why run this?

To find queries that **scan a lot** (even if disk isn’t high).

```sql
SELECT TOP (25)
    qs.total_logical_reads AS total_logical_reads,
    qs.execution_count,
    (qs.total_logical_reads / NULLIF(qs.execution_count, 0)) AS avg_logical_reads_per_exec,
    qs.total_worker_time AS total_cpu,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_logical_reads DESC;
```

---

## 7) Pattern search: “Do we have THIS query in cache?”

### Why run this?

To confirm a suspected query exists and check how expensive it is.

```sql
SELECT TOP (50)
    qs.total_worker_time AS total_cpu,
    qs.total_elapsed_time AS total_elapsed,
    qs.total_logical_reads AS total_logical_reads,
    qs.total_physical_reads AS total_physical_reads,
    qs.execution_count,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE st.text LIKE '%put_unique_snippet_here%'
ORDER BY qs.total_worker_time DESC;
```

Tip:

- Use **2–3 LIKE conditions** to make it unique (avoid too many false matches).

---

## 8) “Only one database” (general version)

### Why run this?

If the SQL Server hosts many DBs, you may want to focus on one DB during a slowdown.

### 8A) Real-time filter (recommended)

```sql
DECLARE @db sysname = 'YourDatabaseName';

SELECT TOP (25)
    r.session_id,
    DB_NAME(r.database_id) AS database_name,
    r.cpu_time,
    r.logical_reads,
    r.total_elapsed_time,
    st.text AS sql_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE DB_NAME(r.database_id) = @db
  AND r.session_id <> @@SPID
ORDER BY r.logical_reads DESC;
```

Note:

- Filtering **real-time** by database is reliable because `dm_exec_requests` has `database_id`.

---

## 9) “Something is running forever” (elapsed time focus)

### Why run this?

To find the query that is **running for a long time right now** (or has huge elapsed time in cache).

### 9A) Real-time: longest running requests (right now)

```sql
SELECT TOP (25)
    r.session_id,
    DB_NAME(r.database_id) AS database_name,
    r.total_elapsed_time,
    r.cpu_time,
    r.logical_reads,
    r.wait_type,
    r.blocking_session_id,
    st.text AS sql_text
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id <> @@SPID
ORDER BY r.total_elapsed_time DESC;
```

Simple meaning:

- “Show me the sessions that have been running the longest right now.”
- If a query is “stuck”, it will often appear at the top.

### 9B) Cached: queries with large total elapsed time (overall)

```sql
SELECT TOP (25)
    qs.total_elapsed_time AS total_elapsed,
    qs.execution_count,
    (qs.total_elapsed_time / NULLIF(qs.execution_count, 0)) AS avg_elapsed_per_exec,
    qs.total_worker_time AS total_cpu,
    qs.total_logical_reads AS total_logical_reads,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_elapsed_time DESC;
```

---

## 10) “Top 3 worst queries” (quick report template)

### Why run this?

To send a quick note with the **top 3** offenders and a metric that justifies it.

```sql
SELECT TOP (3)
    qs.total_worker_time AS total_cpu,
    qs.total_physical_reads AS total_disk_reads,
    qs.total_logical_reads AS total_logical_reads,
    qs.total_elapsed_time AS total_elapsed,
    qs.execution_count,
    st.text AS sql_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_worker_time DESC; -- change this metric as needed
```

---

## Mini decision guide (super short)

- Users say **“freezes”** → start with **logical_reads** (real-time TOP 1)
- **CPU spike** → cached top CPU + check executions
- **Disk high** → cached top physical reads
- **Only one DB** → filter real-time by `database_id`
- **Feels “stuck”** → elapsed time + blocking query

---

## Tiny glossary

- **session_id**: the connection/session running the request
- **sql_handle**: internal “pointer” to the SQL text
- **CROSS APPLY sql_text**: converts handle → readable SQL text
- **logical_reads**: pages read from memory/buffer (often scans)
- **physical_reads**: reads that hit disk
