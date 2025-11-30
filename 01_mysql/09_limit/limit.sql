
-----------------------------------------------------------
-- LIMIT
-----------------------------------------------------------

-- LIMIT = returns only the number of rows you specify

SELECT * 
FROM users 
LIMIT 3;
-- Selects all columns from users with a limit of 3 rows.
-- Only the first 3 rows will appear (by default ordered by id).
