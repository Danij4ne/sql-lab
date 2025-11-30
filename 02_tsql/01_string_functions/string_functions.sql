
----------------
-- UPPER() = convert text to UPPERCASE
----------------
SELECT UPPER(Name) AS Name_UPPER
FROM Artists;
-- UPPER() = convert text to UPPERCASE
-- Name = original column
-- AS Name_UPPER = result column name


----------------
-- LOWER() = convert text to lowercase
----------------
SELECT LOWER(Name) AS Name_lower
FROM Artists;
-- LOWER() = convert text to lowercase
-- Name = original column
-- AS Name_lower = result column name


----------------
-- SUBSTRING() = extract part of a string
----------------
SELECT SUBSTRING(LastName, 1, 4) AS Partial_LastName
FROM Customers;
-- SUBSTRING() = extract characters
-- LastName = original column
-- 1 = starting position
-- 4 = number of characters
