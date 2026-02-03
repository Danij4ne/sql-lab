
----------------
-- CREATE SERVER AUDIT = create an audit target to store audit events
----------------
USE master;                                               -- USE master = create server-level audit objects in master
GO                                                       -- GO = batch separator

CREATE SERVER AUDIT Audit_Security                         -- CREATE SERVER AUDIT = define audit; Audit_Security = audit name
TO FILE (FILEPATH = 'C:\AuditLogs\')                       -- TO FILE = write audit logs; FILEPATH = folder to store files
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);          -- QUEUE_DELAY = write delay (ms); ON_FAILURE = what to do if audit fails
GO                                                       -- GO = execute this batch

ALTER SERVER AUDIT Audit_Security WITH (STATE = ON);       -- STATE = ON = start collecting audit events
GO                                                       -- GO = execute this batch


----------------
-- CREATE DATABASE AUDIT SPECIFICATION = choose what to audit inside one database
----------------
USE DiscountTech;                                         -- USE DiscountTech = switch to the database you want to audit
GO                                                       -- GO = batch separator

CREATE DATABASE AUDIT SPECIFICATION AuditSpec_DiscountTech  -- CREATE ... SPECIFICATION = define what to capture; AuditSpec_DiscountTech = name
FOR SERVER AUDIT Audit_Security                             -- FOR SERVER AUDIT = send events to this server audit target
ADD (SCHEMA_OBJECT_ACCESS_GROUP),                           -- SCHEMA_OBJECT_ACCESS_GROUP = log object access (SELECT/INSERT/UPDATE/DELETE)
ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP)               -- ...PERMISSION_CHANGE... = log GRANT/REVOKE/DENY changes
WITH (STATE = ON);                                         -- STATE = ON = enable this specification
GO                                                       -- GO = execute this batch


----------------
-- sys.dm_exec_sessions = list active sessions (who is connected)
----------------
SELECT
    s.session_id,                                          -- session_id = unique session identifier
    s.login_name,                                          -- login_name = server login used
    s.host_name,                                           -- host_name = client machine name
    s.program_name,                                        -- program_name = application name (SSMS, app, etc.)
    s.status                                               -- status = running/sleeping/etc.
FROM sys.dm_exec_sessions AS s                              -- dm_exec_sessions = sessions DMV
WHERE s.is_user_process = 1;                               -- is_user_process = 1 = exclude system sessions


----------------
-- sys.dm_exec_connections = show connection details (IP, protocol, encryption)
----------------
SELECT
    c.session_id,                                          -- session_id = match to dm_exec_sessions
    c.client_net_address,                                  -- client_net_address = client IP address
    c.net_transport,                                       -- net_transport = TCP/Shared memory/etc.
    c.encrypt_option,                                      -- encrypt_option = TRUE/FALSE (connection encryption)
    c.auth_scheme                                          -- auth_scheme = SQL/NTLM/Kerberos
FROM sys.dm_exec_connections AS c;                         -- dm_exec_connections = connections DMV
