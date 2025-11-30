
----------------------------------------------------------------
-- Database Administration (Database)
-------------------------------------------------------------

-- How to create and drop a database

-- Create a database called test
CREATE DATABASE test;

-- Drop (delete) the entire database test
DROP DATABASE test;


----------------------------------
-- Tables
-----------------------------------

CREATE TABLE persons (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(50),
    created DATETIME DEFAULT CURRENT_TIMESTAMP(),
    UNIQUE(id),
    PRIMARY KEY(id),
    CHECK(age >= 18)
);

-- NOT NULL -> mandatory information, cannot be left blank
-- UNIQUE(id) -> ensures id is unique and no two rows share the same id
-- PRIMARY KEY(id) -> indicates that id is the primary key of the table,
-- the main identifier of each record; when creating relationships
-- with other tables this is the key we will reference.
-- CHECK(age >= 18) -> constraint that prevents inserting a user under 18
-- DEFAULT -> default value; if you do not provide a value, this is used
-- CURRENT_TIMESTAMP() -> returns the current system date and time
-- AUTO_INCREMENT -> auto-increments if you do not specify a value


-------------------------------

DROP TABLE persons;
-- Drops the whole table persons


------------------------------- 

-- ALTER TABLE = alter / modify the table


-- Different ways to modify it: (adding, modifying, removing columns)

ALTER TABLE persons
ADD surname VARCHAR(50);
-- Add a surname column with capacity up to 50 characters

-------

ALTER TABLE persons
RENAME COLUMN surname TO description;
-- Rename column surname to description

------

ALTER TABLE persons
MODIFY COLUMN description VARCHAR(250);
-- Change column description to a VARCHAR(250) instead of 50

------

ALTER TABLE persons
DROP COLUMN description;
-- Remove the description column
