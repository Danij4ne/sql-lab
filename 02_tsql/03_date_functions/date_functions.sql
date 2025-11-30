
----------------
-- FORMAT() = format a date as text
----------------
SELECT LastName, FORMAT(BirthDate, 'MM-dd-yyyy') AS Formatted_Date
FROM Employees;
-- FORMAT() = format date
-- BirthDate = column
-- 'MM-dd-yyyy' = month-day-year pattern


----------------
-- GETDATE() = get current date and time from server
----------------
SELECT GETDATE() AS CurrentDate
FROM Employees;
-- GETDATE() = returns current date and time


----------------
-- DATEDIFF() = difference between two dates (in days, months, years…)
----------------
SELECT DATEDIFF(day, BirthDate, GETDATE()) AS Days_Lived
FROM Employees;
-- DATEDIFF() = calculate difference
-- day = unit of measurement
-- BirthDate = starting date
-- GETDATE() = ending date (current date)
