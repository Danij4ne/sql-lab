
------------------------------------------ 
-- Types of relationships 
--------------------------------------------

-- There are only 4 types of relationships in relational databases:

-- 1:1 relationship -> (example: employee - ID card)
-- Each element in table A can only be related to one element in table B and vice versa.
-- Primary key (PK) and foreign key (FK) -> a foreign key is a key that does not
-- belong to this table, but to another one where it is the primary key.

-- 1 : N relationship -> (example: company - employee)
-- One company can have many employees.

-- N : M or N : N relationship -> (example: programmers - programming languages)
-- Several programmers can have several programming languages.
-- Because it is many-to-many, we need a junction table to store the relationships
-- between programmers and languages.
-- The primary keys from both tables (programmers and languages) will be stored
-- in that intermediate table.


-----------------------------------
-- Self-reference (self-referencing)
-----------------------------------

-- Example: one table persons with a column boss (jefa)

-- name    boss
-------------
-- 1 - Ana   5
-- 2 - Olga  5
-- 3 - Ona   5
-- 4 - Noa   5
-- 5 - Sara  5 -> person 5 is the boss of all; it is self-referencing.
--                 (You could also set it to NULL to mean she has no boss)
-- 6 - Laia  5
