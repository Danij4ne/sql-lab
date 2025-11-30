
-------------------
-- WHERE
-------------------

-- WHERE = we are limiting the criteria for the rows we want to retrieve.

SELECT * FROM users WHERE age = 15;
-- Select all users WHERE age = 15
-- Here we get * (all columns) for those users whose age is 15

SELECT name FROM users WHERE age = 15;
-- Select the names of the users WHERE age = 15
-- Here we only see the names of the users who have age = 15

SELECT DISTINCT name FROM users WHERE age = 15;
-- Select the distinct names of all users WHERE age = 15
-- The only difference: if there are repeated names (e.g., 2 times 'Pablo'),
-- only one 'Pablo' will be shown.
