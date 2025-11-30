
-----------------------------------------------------------------
-- IN
-----------------------------------------------------------------

-- IN = filtering where we explicitly know which values we want.

SELECT * 
FROM users 
WHERE name IN ('brais', 'sara');
-- Select all information from the users table
-- where the name is 'brais' OR 'sara'.
