
----------------
-- CREATE DATABASE = create a new database
----------------
CREATE DATABASE TestDb;                        -- Creates a database named TestDb
GO                                             

----------------
-- USE = select the active database
----------------
USE TestDb;                                    -- Selects the database where all queries below will be executed
GO                                             -- Separates this batch from the others so each one runs independently

----------------
-- CREATE TABLE = create a table inside the dbo schema
----------------
CREATE TABLE dbo.Persons (                 -- Creates the Persons table inside the dbo schema = default main schema (“the general folder”)
    ID   int PRIMARY KEY,                      -- ID column of type int, primary key
    Name varchar(50),                          -- Name column as a string up to 50 characters
    Age  int                                   -- Age column as an integer
);
GO
