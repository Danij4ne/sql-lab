
------------------
-- ORDER BY
------------------

-- ORDER BY = sort the data

SELECT * FROM users ORDER BY age;
-- Select all users and ORDER them by age

SELECT * FROM users ORDER BY age ASC;
-- Same as above, but ASC = ascending order

SELECT * FROM users ORDER BY age DESC;
-- DESC = descending order

SELECT * 
FROM users 
WHERE email = 'sara@gmail.com'
ORDER BY age ASC;
-- Select all users where email = 'sara@gmail.com'
-- and order them by age ascending
