
------------------------------------------
-- DELETE
------------------------------------------

-- DELETE = delete rows from a table

DELETE FROM users
WHERE user_id = 11;
-- Delete from users where user_id = 11.
-- If we do not write WHERE, ALL rows in the table would be deleted.
