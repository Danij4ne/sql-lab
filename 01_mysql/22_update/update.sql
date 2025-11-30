
------------------------------------------
-- UPDATE + SET
------------------------------------------

-- UPDATE = update existing data in a table
-- SET    = define the new values

UPDATE users
SET age = 23
WHERE user_id = 11;
-- Update users, set age = 23 where user_id = 11.
-- If we do not write a WHERE clause, all age values would be updated.

UPDATE users
SET age = 20, init_date = '2020-10-12'
WHERE user_id = 11;
-- Dates must be written inside quotes '' or it will throw an error.
