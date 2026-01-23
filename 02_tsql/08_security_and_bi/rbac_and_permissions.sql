

----------------
-- CREATE USER = create a database user
----------------
CREATE USER dev_ana FOR LOGIN dev_ana;                  -- CREATE USER = create user; dev_ana = name; FOR LOGIN = link to server login
                                                         -- dev_ana = existing login on the server

----------------
-- CREATE ROLE = create a security role
----------------
CREATE ROLE analyst_role;                                -- CREATE ROLE = create role; analyst_role = role name


----------------
-- ALTER ROLE = assign a user to a role
----------------
ALTER ROLE analyst_role ADD MEMBER dev_ana;              -- ALTER ROLE = modify role; ADD MEMBER = add user; dev_ana = user


----------------
-- GRANT = give permissions
----------------
GRANT SELECT ON dbo.Customers TO analyst_role;           -- GRANT = give permission; SELECT = read; dbo.Customers = table; analyst_role = role


----------------
-- REVOKE = remove permissions
----------------
REVOKE SELECT ON dbo.Customers FROM analyst_role;        -- REVOKE = remove permission; SELECT = read; dbo.Customers = table; analyst_role = role


----------------
-- DENY = block a permission even if inherited
----------------
DENY DELETE ON dbo.Customers TO analyst_role;            -- DENY = block; DELETE = remove rows; dbo.Customers = table; analyst_role = role


----------------
-- DROP USER = delete a user
----------------
DROP USER dev_ana;                                       -- DROP USER = delete user; dev_ana = name


 
 
