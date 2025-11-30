
-----------------------------------------------------------
-- MAX(), MIN()
-----------------------------------------------------------

SELECT MAX(age) FROM users;
-- Selects the maximum age from users -> who has the highest age

SELECT MIN(age) FROM users;
-- Selects the minimum age from users -> who has the lowest age


------------------------------------------------------------
-- COUNT() -> COUNT
------------------------------------------------------------

SELECT COUNT(age) FROM users;
-- Counts how many rows have a non-null age

SELECT COUNT(*) FROM users;
-- Counts all users (rows) in the table


------------------------------------------------------------
-- SUM() -> SUM
------------------------------------------------------------

SELECT SUM(age) FROM users;
-- Sums all ages together and returns the total


----------------------------------------------------------------
-- AVG() -> average
----------------------------------------------------------------

SELECT AVG(age) FROM users;
-- Calculates the average age (mean) of all users
