
-----------------------------------------------------------
-- IFNULL
-----------------------------------------------------------

-- IFNULL = if a value is NULL, replace it with the value you choose.

SELECT name, surname, IFNULL(age, 0)
FROM users;
-- Select name, surname and age.
-- If age is NULL, display 0 instead.
