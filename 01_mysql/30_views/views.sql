
-----------
-- VIEW
-----------

-- A VIEW in SQL is a virtual table that stores a query,
-- used to show data in a simplified way without duplicating it.

-- Basic syntax:
-- CREATE VIEW view_name AS
--   SELECT ...

CREATE VIEW v_adult_users AS
SELECT name, age
FROM users
WHERE age >= 18;


-- Query the view:

SELECT *
FROM v_adult_users;


-- Drop the view:

DROP VIEW v_adult_users;
