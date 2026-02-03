
----------------
-- CREATE MASTER KEY = create the master key in master (needed to protect certificates/keys)
----------------
USE master;                                               -- USE master = switch to the master database
GO                                                       -- GO = batch separator (runs the previous batch)

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'StrongPassword_ChangeMe!';      -- CREATE MASTER KEY = create master key; PASSWORD = protects the master key
GO                                                       -- GO = execute this batch


----------------
-- CREATE CERTIFICATE = create a server certificate used by TDE
----------------
CREATE CERTIFICATE TDE_ServerCert                         -- CREATE CERTIFICATE = create cert; TDE_ServerCert = certificate name
WITH SUBJECT = 'TDE Certificate for database encryption';  -- SUBJECT = description for identification
GO                                                       -- GO = execute this batch


----------------
-- BACKUP CERTIFICATE = backup the certificate (required for restore/move scenarios)
----------------
BACKUP CERTIFICATE TDE_ServerCert                         -- BACKUP CERTIFICATE = export certificate; TDE_ServerCert = cert to export
TO FILE = 'C:\Backups\TDE_ServerCert.cer'                 -- TO FILE = certificate public part file path
WITH PRIVATE KEY (                                       -- PRIVATE KEY = export private key too (critical)
    FILE = 'C:\Backups\TDE_ServerCert_PrivateKey.pvk',    -- FILE = private key file path
    ENCRYPTION BY PASSWORD = 'AnotherStrongPass_ChangeMe!'-- PASSWORD = encrypt the private key file
);
GO                                                       -- GO = execute this batch


----------------
-- CREATE DATABASE ENCRYPTION KEY = create the encryption key inside the target database (TDE)
----------------
USE DiscountTech;                                         -- USE DiscountTech = switch to the database you want to encrypt
GO                                                       -- GO = execute this batch

CREATE DATABASE ENCRYPTION KEY                            -- CREATE DATABASE ENCRYPTION KEY = create TDE key for this database
WITH ALGORITHM = AES_256                                  -- ALGORITHM = encryption algorithm; AES_256 = strong standard choice
ENCRYPTION BY SERVER CERTIFICATE TDE_ServerCert;          -- ENCRYPTION BY = protect key; SERVER CERTIFICATE = uses the cert from master
GO                                                       -- GO = execute this batch


----------------
-- ALTER DATABASE SET ENCRYPTION ON = enable TDE (encrypt data at rest)
----------------
ALTER DATABASE DiscountTech                               -- ALTER DATABASE = change database settings
SET ENCRYPTION ON;                                        -- SET ENCRYPTION ON = start/enable TDE encryption
GO                                                       -- GO = execute this batch


----------------
-- sys.dm_database_encryption_keys = check TDE status and progress
----------------
SELECT
    DB_NAME(database_id) AS database_name,                -- DB_NAME() = translate id to name; database_name = readable name
    encryption_state,                                     -- encryption_state = 0/1/2/3/4/5/6 (status values)
    percent_complete,                                     -- percent_complete = progress if currently encrypting/decrypting
    key_algorithm,                                        -- key_algorithm = algorithm used (e.g., AES_256)
    key_length                                            -- key_length = key size in bits
FROM sys.dm_database_encryption_keys;                     -- sys.dm_database_encryption_keys = TDE DMV for status




