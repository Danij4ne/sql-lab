
----------------------------------------------------------
-- RELATED DATA - JOINS  
----------------------------------------------------------

-- Now that we have more than one related table,
-- we can use SELECT to query data from multiple tables.

-- JOIN -> command used to relate two or more tables.


-- How we would build a JOIN between Users <-> DNI (1:1)
-------------------------------------------------------

-- 1) INNER JOIN --- returns only matching rows
--    ON          --- defines the join condition

SELECT * 
FROM users 
INNER JOIN dni;
-- This returns combinational data from users and dni,
-- but without ON the result is not filtered by the relationship.

SELECT * 
FROM users
INNER JOIN dni
ON users.user_id = dni.user_id
ORDER BY age ASC;
-- ON ensures we only get rows where user_id matches in both tables,
-- and we order by age ascending.

SELECT name, dni_number
FROM users
INNER JOIN dni
ON users.user_id = dni.user_id
ORDER BY age ASC;
-- Only show name and dni_number, joined by users.user_id = dni.user_id.


-------------------------
-- JOIN between Users <-> Companies (1:N)
-------------------------

-- 2) JOIN + ON

-- In all 1:1, 1:N, etc., we must use ON, otherwise the database
-- will mix all rows (Cartesian product). ON defines the column
-- that connects one table to the other.

SELECT *
FROM users
JOIN companies
ON users.company_id = companies.company_id;

SELECT *
FROM companies
JOIN users
ON companies.company_id = users.company_id;
-- Reversed order: first table is companies, then users.

SELECT companies.name, users.name
FROM companies
JOIN users
ON companies.company_id = users.company_id;
-- Shows the company name and next to it the name of
-- the worker that belongs to that company.


---------------------------
-- JOIN between Users <- users_languages -> languages (N:M, 3 tables)
---------------------------

-- 3) Two JOINs + two ONs

SELECT *
FROM users_languages              -- junction table
JOIN users 
  ON users_languages.user_id = users.user_id
JOIN languages 
  ON users_languages.languages_id = languages.languages_id;


-- Filter to show only specific columns

SELECT users.name, languages.name
FROM users_languages
JOIN users 
  ON users_languages.user_id = users.user_id
JOIN languages 
  ON users_languages.languages_id = languages.languages_id;
-- Get the user name and the language name for each relationship.


--------------------------------------
-- LEFT JOIN (second type of join)
--------------------------------------

-- LEFT JOIN -> keeps all rows from the left table (the one after FROM)
-- plus matching rows from the right table.
-- If there is no match, right-side columns are filled with NULL.

-- (1:1)
SELECT *
FROM users  -- left table
LEFT JOIN dni 
  ON users.user_id = dni.user_id;

SELECT name, dni_number
FROM users      -- left table
LEFT JOIN dni
  ON users.user_id = dni.user_id;
-- In a regular JOIN / INNER JOIN, only users with a DNI would appear.
-- With LEFT JOIN, we also get users without DNI, with NULL in dni_number.


-- (N:M)
SELECT users.name, languages.name
FROM users_languages
LEFT JOIN users 
  ON users_languages.user_id = users.user_id
LEFT JOIN languages
  ON users_languages.languages_id = languages.languages_id;
-- This returns all user names present in users_languages (left side)
-- and shows the languages each user knows.
-- If this were an INNER JOIN, we'd see only users that know at least one language.
-- With LEFT JOIN, we see all and languages will be NULL if any user has no language.


--------------------------------------
-- RIGHT JOIN (third type of join)
--------------------------------------

-- Same concept as LEFT JOIN, but using the right table as reference.

-- (1:1)
SELECT *
FROM users
RIGHT JOIN dni   -- right table
  ON users.user_id = dni.user_id;


--------------------------------------
-- FULL JOIN via UNION ALL (fourth type of join)
--------------------------------------

-- In some databases FULL JOIN exists.
-- In MySQL we can emulate something similar with UNION ALL.
-- UNION ALL keeps everything from both sides (be careful!).

SELECT 
    users.user_id AS u_user_id, 
    dni.user_id   AS d_user_id
FROM users
LEFT JOIN dni
  ON users.user_id = dni.user_id

UNION ALL

SELECT 
    users.user_id AS u_user_id, 
    dni.user_id   AS d_user_id
FROM users
RIGHT JOIN dni
  ON users.user_id = dni.user_id;


SELECT *
FROM users
LEFT JOIN dni
  ON users.user_id = dni.user_id

UNION ALL

SELECT *
FROM users
RIGHT JOIN dni
  ON users.user_id = dni.user_id;
