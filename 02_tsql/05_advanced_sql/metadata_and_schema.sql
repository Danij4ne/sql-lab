
----------------
-- SP_COLUMNS() = show the structure of a table
----------------
EXEC sp_columns @table_name = 'Customers';      -- EXEC = runs a system stored procedure; Customers = table to inspect
EXEC sp_columns @table_name = 'Products';       -- Products = products table; returns column names and data types
EXEC sp_columns @table_name = 'Orders';         -- Orders = orders table; used to review keys and fields
EXEC sp_columns @table_name = 'OrderItems';     -- OrderItems = bridge table; shows columns that link orders and products

----------------
-- SP_HELPCONSTRAINT() = show all constraints of a table
----------------
EXEC sp_helpconstraint 'dbo.Customers';      -- EXEC = runs a system stored procedure; dbo.Customers = table to inspect
EXEC sp_helpconstraint 'dbo.Products';       -- Products = products table; shows PK, FK, UNIQUE, CHECK and DEFAULT rules
EXEC sp_helpconstraint 'dbo.Orders';         -- Orders = orders table; used to verify foreign keys and business rules
EXEC sp_helpconstraint 'dbo.OrderItems';     -- OrderItems = bridge table; shows keys and relationships between tables

