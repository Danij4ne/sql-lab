
--------------------------------------------------------------------
-- HAVING vs WHERE
--------------------------------------------------------------------

-- HAVING = filters groups / aggregated results (for example those coming from COUNT()).
-- WHERE  = filters individual rows *before* grouping (raw data).

SELECT COUNT(age)
FROM users
HAVING COUNT(age) > 4;
-- Counts ages from users, keeping only groups where the count is > 4.
