

----------------
-- PRIMARY_KEY_CLUSTERED() = definir el orden físico de la tabla
----------------
CREATE TABLE Orders (                                                   -- CREATE TABLE = crear tabla nueva llamada Orders
    order_id INT IDENTITY(1,1),                                          -- order_id = identificador único autoincremental
    customer_id INT,                                                    -- customer_id = columna que identifica al cliente
    order_date DATE,                                                    -- order_date = fecha del pedido
    total_amount DECIMAL(10,2),                                          -- total_amount = importe del pedido con 2 decimales
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (order_id)               -- PRIMARY KEY CLUSTERED = índice clustered con nombre profesional que define el orden físico
);                                                                      -- ; = final de la instrucción


----------------
-- NORMAL (NONCLUSTERED) INDEX = basic index to speed up searches (allows duplicates)
----------------
CREATE NONCLUSTERED INDEX IX_Users_Email       -- normal index: speed only, does not block duplicates
ON Users (email);                              -- email = column used for searches


----------------
-- UNIQUE INDEX = index with a no-duplicates rule (not a normal index)
----------------
CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Email -- UNIQUE = duplicate values are not allowed
ON Users (email);                               -- email = cannot be repeated


----------------
-- CLUSTERED INDEX = real physical order of the table (not a normal index)
----------------
CREATE CLUSTERED INDEX IX_Orders_OrderId      -- CLUSTERED = how rows are physically stored
ON Orders (order_id);                         -- order_id = column the table is ordered by


----------------
-- NORMAL (NONCLUSTERED) INDEX = list to find rows quickly
----------------
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId -- normal index to search by customer
ON Orders (customer_id);                      -- customer_id = column used in WHERE


----------------
-- NORMAL (COMPOSITE) INDEX = normal index with multiple columns
----------------
CREATE NONCLUSTERED INDEX IX_OrderItems_Join   -- composite normal index
ON OrderItems (order_id, product_id);          -- first order_id, then product_id


----------------
-- NORMAL (COVERING) INDEX = normal index that already contains the query data
----------------
CREATE NONCLUSTERED INDEX IX_Products_Cover    -- normal index that avoids going to the table
ON Products (product_id, price);               -- product_id = search; price = returned value


-- CLUSTERED     Orders the real data
-- NONCLUSTERED  Creates search lists


-----------------
-- FILTERED_INDEX() = index only rows that match a condition
----------------
CREATE NONCLUSTERED INDEX idx_filter_deviceactive   -- CREATE NONCLUSTERED INDEX = create nonclustered index
ON Devices (device_id)                              -- ON Devices = table; device_id = indexed column
WHERE device_status = 'Active';                     -- WHERE = only index rows with Active status


----------------
-- FILTERED_QUERY_USAGE() = query that uses a filtered index
----------------
SELECT *                                            -- SELECT * = return all columns
FROM Devices                                       -- FROM Devices = devices table
WHERE device_status = 'Active'                     -- WHERE = filter only active devices
  AND device_id = 123;                              -- AND device_id = search a specific device


----------------
-- REORGANIZE_INDEX() = reorder index with low fragmentation
----------------
ALTER INDEX idx_customer_orderdate                 -- ALTER INDEX = modify existing index
ON Orders                                          -- ON Orders = orders table
REORGANIZE;                                        -- REORGANIZE = reorganize pages without blocking


----------------
-- REBUILD_INDEX() = rebuild index with high fragmentation
----------------
ALTER INDEX idx_cover_productprice                 -- ALTER INDEX = modify index
ON Products                                        -- ON Products = products table
REBUILD;                                           -- REBUILD = fully rebuild the index


----------------
-- UPDATE_STATISTICS() = refresh optimizer statistics
----------------
UPDATE STATISTICS Orders;                          -- UPDATE STATISTICS = refresh statistics; Orders = analyzed table
