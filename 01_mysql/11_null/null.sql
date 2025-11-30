
------------------------------------------------------------
-- IS NULL / IS NOT NULL
------------------------------------------------------------

-- IS NULL = the value has no value, nothing was set

SELECT * 
FROM users 
WHERE email IS NULL;
-- Select all rows from users where email is NULL

SELECT * 
FROM users 
WHERE email IS NOT NULL;
-- Email is NOT null, meaning there is information stored
