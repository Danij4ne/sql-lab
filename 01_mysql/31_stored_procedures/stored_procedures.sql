
-----------------------
-- STORED PROCEDURE
----------------------

-- A stored procedure is like a saved query (or set of queries)
-- that we can call later.

DELIMITER //

CREATE PROCEDURE p_all_users()   -- procedure name
BEGIN
    SELECT * FROM users;
END//

DELIMITER ;

-- Call the stored procedure:
CALL p_all_users;


-- Procedure with a parameter:

DELIMITER //

CREATE PROCEDURE p_age_users(IN age_param INT)
BEGIN
    SELECT * FROM users
    WHERE age = age_param;
END//

DELIMITER ;

-- Call the procedure and query users with age 30:
CALL p_age_users(30);

-- Query users with age 20:
CALL p_age_users(20);

-- Drop the procedure:
DROP PROCEDURE p_age_users;
