
-------------------------------------------------------------------
-- AS (alias)
-------------------------------------------------------------------

-- AS = try to give a temporary name to a column in a query result.

SELECT name, init_date AS 'Programming start date'
FROM users 
WHERE age BETWEEN 20 AND 30;
-- We select both columns, but init_date is temporarily renamed
-- as "Programming start date" in this query result.
