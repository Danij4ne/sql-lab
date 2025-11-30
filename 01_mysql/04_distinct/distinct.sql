
----------------------------------------------------
-- Modifiers Part 1: DISTINCT
-----------------------------------------------------

-- DISTINCT returns unique results that do not have duplicates
-- according to the column(s) we specify.

SELECT DISTINCT * FROM users;
-- Selects distinct rows considering all columns from users

SELECT DISTINCT age FROM users;
-- Returns the distinct age values from the users table
