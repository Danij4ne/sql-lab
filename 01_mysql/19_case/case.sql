
------------------------------------------------- 
-- CASE
-------------------------------------------------

-- CASE = applies specific logic depending on a condition.

SELECT *,
CASE
    WHEN age > 18 THEN 'Is an adult'
    ELSE 'Is a minor'
END AS 'Is adult?'
FROM users;
-- SELECT * = select all columns, and the comma is important,
-- otherwise it will throw an error.

SELECT *,
CASE
    WHEN age > 17 THEN TRUE
    ELSE FALSE
END AS 'Is adult?'
FROM users;
-- Same logic but using TRUE/FALSE instead of text.
-- Will return 1 if adult, 0 if minor (in some clients).

SELECT *,
CASE
    WHEN age > 18 THEN 'Is an adult'
    WHEN age = 18 THEN 'Just reached adulthood'
    ELSE 'Is a minor'
END AS 'Is adult?'
FROM users;
-- If the condition was "age > 17" above, someone with exactly 18
-- would match the first WHEN and the second WHEN would never run.
