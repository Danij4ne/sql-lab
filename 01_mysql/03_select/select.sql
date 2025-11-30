
----------------------------------------
-- Querying data
----------------------------------------

-- Statements (sequences of commands that we can run) can be written in lowercase,
-- but the best practice is to write SQL keywords in uppercase.

-- SELECT -> select data

-- I want to query all data from my table:

SELECT * FROM users; 
-- SELECT = select
-- * refers to all columns
-- FROM indicates from which table
-- users = all information of all users

SELECT name FROM users;
-- Shows only the names from the users table

SELECT user_id, name FROM users;
-- Shows the id and the name of the users
