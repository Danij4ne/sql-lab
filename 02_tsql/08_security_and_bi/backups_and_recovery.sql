----------------
-- BACKUP DATABASE (FULL) = create a full backup of a database
----------------
BACKUP DATABASE DiscountTech                              -- BACKUP DATABASE = full backup; DiscountTech = database name
TO DISK = 'C:\Backups\DiscountTech_full.bak'              -- TO DISK = file path; .bak = backup file
WITH INIT,                                                -- INIT = overwrite existing file
     FORMAT,                                              -- FORMAT = initialize media set (fresh backup chain)
     STATS = 10;                                          -- STATS = show progress every 10%


----------------
-- BACKUP DATABASE (DIFFERENTIAL) = backup only changes since last FULL
----------------
BACKUP DATABASE DiscountTech                              -- BACKUP DATABASE = database to back up
TO DISK = 'C:\Backups\DiscountTech_diff.bak'              -- TO DISK = differential backup file
WITH DIFFERENTIAL,                                        -- DIFFERENTIAL = changes since last FULL
     INIT,                                                -- INIT = overwrite existing file
     STATS = 10;                                          -- STATS = progress every 10%


----------------
-- BACKUP LOG = backup the transaction log
----------------
BACKUP LOG DiscountTech                                   -- BACKUP LOG = transaction log backup; DiscountTech = database
TO DISK = 'C:\Backups\DiscountTech_log.trn'               -- TO DISK = log backup file; .trn = transaction log backup
WITH INIT,                                                -- INIT = overwrite existing file
     STATS = 10;                                          -- STATS = progress every 10%


----------------
-- RESTORE DATABASE (FULL) WITH NORECOVERY = restore FULL and keep DB in restoring state
----------------
RESTORE DATABASE DiscountTech                             -- RESTORE DATABASE = restore database; DiscountTech = target name
FROM DISK = 'C:\Backups\DiscountTech_full.bak'            -- FROM DISK = source .bak file
WITH NORECOVERY;                                          -- NORECOVERY = keep DB restoring to apply more backups


----------------
-- RESTORE DATABASE (FULL) WITH RECOVERY = restore FULL and bring DB online
----------------
RESTORE DATABASE DiscountTech                             -- RESTORE DATABASE = restore database; DiscountTech = target name
FROM DISK = 'C:\Backups\DiscountTech_full.bak'            -- FROM DISK = source .bak file
WITH RECOVERY;                                            -- RECOVERY = finalize restore and make DB usable


----------------
-- RESTORE LOG WITH NORECOVERY = apply a log backup (can apply multiple in sequence)
----------------
RESTORE LOG DiscountTech                                  -- RESTORE LOG = restore log; DiscountTech = database
FROM DISK = 'C:\Backups\DiscountTech_log.trn'             -- FROM DISK = source .trn file
WITH NORECOVERY;                                          -- NORECOVERY = keep DB restoring for next logs


----------------
-- WITH RECOVERY = finalize a restore chain and bring the database online
----------------
RESTORE DATABASE DiscountTech                             -- RESTORE DATABASE = final restore command
WITH RECOVERY;                                            -- WITH RECOVERY = bring database online and usable




