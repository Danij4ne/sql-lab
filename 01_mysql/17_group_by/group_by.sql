
---------------------------------------------------------------------
-- GROUP BY
---------------------------------------------------------------------

-- GROUP BY = groups rows that have the same values in one or more columns.

SELECT age 
FROM users 
GROUP BY age;
-- ERROR in some cases: GROUP BY usually needs an aggregate function
-- if you select other columns besides the grouped ones.

SELECT country, MAX(age)
FROM users
GROUP BY country;
-- Select country and the maximum age for that country.
-- Groups users by country.

SELECT COUNT(age), age
FROM users
GROUP BY age;
-- Groups all users that have the same age,
-- then counts how many there are in each age group.

SELECT COUNT(age), age
FROM users
WHERE age > 15
GROUP BY age
ORDER BY age ASC;
-- Select age and count of ages for users older than 15,
-- group by age and order the age ascending.
