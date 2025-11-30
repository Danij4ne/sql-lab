
-----------------------------------------------------
-- LIKE
-----------------------------------------------------

-- LIKE = "similar to", something that is like this pattern.
-- '%gmail.com' -> % -> anything before 'gmail.com' is valid.

SELECT * 
FROM users 
WHERE email LIKE '%gmail.com';
-- Select all rows from users where email is LIKE '%gmail.com'
-- (%gmail.com means: anything + gmail.com)

SELECT * 
FROM users 
WHERE email LIKE '%@%';
-- '%@%' means: anything, then '@', then anything.
-- All emails that contain '@' will appear.
