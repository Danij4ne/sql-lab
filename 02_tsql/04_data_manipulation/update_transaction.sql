
----------------
-- UPDATE + TRANSACTION = update rows safely with commit control
----------------
USE TechHealthDb;                                              -- switch to the target database
GO                                                             -- execute the batch

BEGIN TRANSACTION;                                             -- start a manual transaction

UPDATE [dbo].[Devices]                                         -- table to update
SET firmware_version = 'v3.1.2'                                -- new firmware version to apply
WHERE device_type = 'HealthTrack Lite';                        -- update only devices of this type

COMMIT;                                                        -- confirm the transaction if no error occurs
GO                                                             -- execute the commit batch

SELECT *                                                       -- verify the update
FROM [dbo].[Devices]                                           -- check the Devices table
WHERE device_type = 'HealthTrack Lite'                         -- filter same device type
  AND firmware_version = 'v3.1.2';                             -- confirm firmware was updated
GO                                                             -- execute the verification query
