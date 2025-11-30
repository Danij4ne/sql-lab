
-----------------------------
-- ADVANCED CONCEPTS: INDEXES
------------------------------

-- INDEX = makes searches faster

-- PRIMARY INDEX = primary index = linked to the table's primary key
-- UNIQUE INDEX  = ensures that no two rows share the same value(s)
-- Composite index = index over 2 or more columns

CREATE INDEX idx_name
ON users (name);
-- Create an index named idx_name on the users table, using the name column.
-- (You could also associate the index to both name and surname at the same time,
-- or make it UNIQUE by using CREATE UNIQUE INDEX.)

CREATE UNIQUE INDEX idx_name
ON users (name, surname);
-- Unique composite index on (name, surname).

SELECT *
FROM users
WHERE name = 'Dani';
-- Now this query will be faster thanks to the index (though with few rows,
-- the difference may not be noticeable).


DROP INDEX idx_name ON users;
-- Delete the index idx_name from users.
