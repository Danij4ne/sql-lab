
------------------------------------------------------------------ 
-- CONCAT()
------------------------------------------------------------------

-- CONCAT() = concatenate / join strings in a query result.

SELECT CONCAT(name, surname) 
FROM users;
-- The result shows name + surname together for all users.

SELECT CONCAT('Name: ', name, ' Surname: ', surname)
FROM users;
-- Creates a custom string in the result:
-- "Name: <user_name> Surname: <user_surname>" for each user.

-- Combined with AS to make the result column look nice:

SELECT CONCAT('Name: ', name, ' Surname: ', surname ) AS 'Full Name'
FROM users;
-- All that information appears in a single column named "Full Name".
