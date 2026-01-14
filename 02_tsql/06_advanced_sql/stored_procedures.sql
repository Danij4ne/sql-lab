
----------------
-- CREATE PROCEDURE = define a stored procedure
----------------
CREATE PROCEDURE dbo.CalculateTotalSales              -- CREATE PROCEDURE = creates the procedure; dbo = schema; CalculateTotalSales = name
    @customerID INT                                   -- @customerID = input parameter; INT = data type
AS                                                    -- AS = separates the header (name + parameters) from the body
BEGIN                                                 -- BEGIN = starts the logical block of the procedure
    SELECT SUM(total_amount) AS TotalSales            -- SUM() = calculates the total; AS TotalSales = output column name
    FROM dbo.Orders                                   -- FROM = table where the sales data is stored
    WHERE customer_id = @customerID;                  -- WHERE = filters by the customer passed as a parameter
END;                                                  -- END = closes the procedure


----------------
-- EXEC = execute a stored procedure
----------------
EXEC dbo.CalculateTotalSales @customerID = 1;         -- EXEC = calls the procedure; @customerID = value passed to the parameter


----------------
-- CREATE PROCEDURE = procedure without parameters
----------------
CREATE PROCEDURE dbo.SyncDeviceData                   -- procedure name that does not receive parameters
AS                                                    -- AS = separates the definition from the body
BEGIN                                                 -- BEGIN = starts the instruction block
    UPDATE dbo.Devices                                -- UPDATE = modifies rows in the Devices table
    SET device_status = 'Active'                      -- SET = new value to be assigned
    WHERE last_sync_date < GETDATE();                 -- WHERE = only devices with last sync date earlier than now
END;                                                  -- END = closes the procedure


----------------
-- CREATE PROCEDURE = procedure with multiple parameters
----------------
CREATE PROCEDURE dbo.ResolveServiceTickets            -- procedure name
    @updateDate DATE,                                 -- @updateDate = date that will be assigned to the ticket
    @updateTicketStatus NVARCHAR(50)                  -- @updateTicketStatus = status used as a filter
AS                                                    -- AS = separates header from body
BEGIN                                                 -- BEGIN = opens the procedure block
    UPDATE dbo.Service_Tickets                        -- UPDATE = updates the Service_Tickets table
    SET ticket_status = 'Resolved',                   -- SET = changes the status to 'Resolved'
        resolution_date = @updateDate                -- assigns the date passed as a parameter
    WHERE ticket_status = @updateTicketStatus         -- only tickets with the given status
      AND resolution_date IS NULL;                   -- prevents updating tickets that are already resolved
END;                                                  -- END = closes the procedure


----------------
-- ALTER PROCEDURE = modify an existing stored procedure
----------------
ALTER PROCEDURE dbo.ResolveServiceTickets             -- ALTER PROCEDURE = updates an already created procedure
    @updateDate DATE,                                 -- date parameter
    @updateTicketStatus NVARCHAR(50)                  -- status parameter
AS                                                    -- separates header from body
BEGIN                                                 -- start of the procedure block
    UPDATE dbo.Service_Tickets                        -- UPDATE = table being modified
    SET ticket_status = 'Resolved',                   -- new status
        resolution_date = @updateDate                -- assigned date
    WHERE ticket_status = @updateTicketStatus         -- filters by the provided status
      AND resolution_date IS NULL;                   -- protects tickets that are already resolved
END;                                                  -- end of the procedure

