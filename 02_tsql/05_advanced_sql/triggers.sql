
----------------
-- CREATE TRIGGER AFTER INSERT = execute logic after an insertion
----------------
CREATE TRIGGER trg_AfterOrderInsert                     -- CREATE TRIGGER = defines a trigger; trg_AfterOrderInsert = trigger name
ON Orders                                                -- ON Orders = table where the trigger fires
AFTER INSERT                                             -- AFTER INSERT = runs after an INSERT operation
AS                                                       -- AS = start of trigger body
BEGIN                                                    -- BEGIN = instruction block
    INSERT INTO OrderAudit (order_id, action_type, log_date) -- INSERT INTO OrderAudit = audit table; action and date
    SELECT inserted.order_id, 'INSERT', GETDATE()        -- inserted = newly inserted rows; GETDATE() = current timestamp
    FROM inserted;                                       -- FROM inserted = source of inserted rows
END;                                                     -- END = end of trigger


----------------
-- CREATE TRIGGER AFTER UPDATE = execute logic after an update
----------------
CREATE TRIGGER trg_AfterOrderUpdate                     -- CREATE TRIGGER = defines update trigger
ON Orders                                                -- ON Orders = monitored table
AFTER UPDATE                                             -- AFTER UPDATE = runs after UPDATE
AS                                                       -- AS = start of trigger body
BEGIN                                                    -- BEGIN = logical block
    INSERT INTO OrderAudit (order_id, action_type, log_date) -- INSERT INTO OrderAudit = log changes
    SELECT inserted.order_id, 'UPDATE', GETDATE()        -- inserted = new values; 'UPDATE' = action type
    FROM inserted;                                       -- FROM inserted = updated rows
END;                                                     -- END = end of trigger


----------------
-- CREATE TRIGGER AFTER DELETE = execute logic after a deletion
----------------
CREATE TRIGGER trg_AfterOrderDelete                     -- CREATE TRIGGER = defines delete trigger
ON Orders                                                -- ON Orders = affected table
AFTER DELETE                                             -- AFTER DELETE = runs after DELETE
AS                                                       -- AS = start of trigger body
BEGIN                                                    -- BEGIN = instruction block
    INSERT INTO OrderAudit (order_id, action_type, log_date) -- INSERT INTO OrderAudit = audit logging
    SELECT deleted.order_id, 'DELETE', GETDATE()         -- deleted = removed rows; 'DELETE' = action
    FROM deleted;                                        -- FROM deleted = deleted rows
END;                                                     -- END = end of trigger


----------------
-- inserted = access new values in INSERT and UPDATE
----------------
SELECT inserted.order_id                                 -- inserted.order_id = new row value
FROM inserted;                                          -- inserted = virtual table with new data


----------------
-- deleted = access old values in DELETE and UPDATE
----------------
SELECT deleted.order_id                                  -- deleted.order_id = value before change
FROM deleted;                                           -- deleted = virtual table with old data


----------------
-- Validation trigger = block invalid data
----------------
CREATE TRIGGER trg_ValidateOrderDates                   -- CREATE TRIGGER = validation trigger
ON Orders                                                -- ON Orders = validated table
AFTER INSERT, UPDATE                                     -- AFTER INSERT, UPDATE = validate on insert and update
AS                                                       -- AS = start of trigger body
BEGIN                                                    -- BEGIN = logical block
    IF EXISTS (                                          -- IF EXISTS = check invalid condition
        SELECT 1                                        -- SELECT 1 = boolean check
        FROM inserted                                   -- FROM inserted = new values
        WHERE order_date > delivery_date                -- invalid condition = order date after delivery date
    )
    BEGIN                                                -- BEGIN = error block
        RAISERROR ('Invalid order date', 16, 1)         -- RAISERROR = raise custom error
        ROLLBACK TRANSACTION                             -- ROLLBACK = undo the operation
    END                                                  -- END = end error block
END;                                                     -- END = end of trigger


----------------
-- Cascading trigger = update related data
----------------
CREATE TRIGGER trg_RestockAfterDelete                   -- CREATE TRIGGER = cascade trigger
ON OrderDetails                                         -- ON OrderDetails = detail table
AFTER DELETE                                             -- AFTER DELETE = after detail removal
AS                                                       -- AS = start of trigger body
BEGIN                                                    -- BEGIN = logical block
    UPDATE Products                                     -- UPDATE Products = products table
    SET stock = stock + deleted.quantity                -- stock + quantity = restock inventory
    FROM Products                                       -- FROM Products = target table
    INNER JOIN deleted                                  -- INNER JOIN deleted = removed rows
        ON Products.product_id = deleted.product_id;    -- JOIN by product_id
END;                                                     -- END = end of trigger
