
----------------
-- BACKUP DATABASE = create a full backup of a database
----------------
BACKUP DATABASE DiscountTech                              -- BACKUP DATABASE = full database backup; DiscountTech = database name
TO DISK = 'C:\Backups\DiscountTech_full.bak'              -- TO DISK = file location; .bak = backup file
WITH INIT,                                                 -- WITH INIT = overwrite existing backup file
     STATS = 10;                                          -- STATS = show progress every 10%


----------------
-- BACKUP LOG = backup the transaction log
----------------
BACKUP LOG DiscountTech                                   -- BACKUP LOG = log backup; DiscountTech = database name
TO DISK = 'C:\Backups\DiscountTech_log.trn'               -- TO DISK = log backup file; .trn = transaction log backup
WITH INIT,                                                 -- WITH INIT = overwrite existing file
     STATS = 10;                                          -- STATS = show progress


----------------
-- RESTORE DATABASE = restore a full backup
----------------
RESTORE DATABASE DiscountTech                             -- RESTORE DATABASE = restore database; DiscountTech = target name
FROM DISK = 'C:\Backups\DiscountTech_full.bak'            -- FROM DISK = source backup file
WITH NORECOVERY;                                          -- NORECOVERY = keep database in restoring state


----------------
-- RESTORE LOG = restore a transaction log backup
----------------
RESTORE LOG DiscountTech                                  -- RESTORE LOG = restore log; DiscountTech = database name
FROM DISK = 'C:\Backups\DiscountTech_log.trn'             -- FROM DISK = source log backup
WITH NORECOVERY;                                          -- NORECOVERY = keep restoring to apply more logs


----------------
-- WITH RECOVERY = bring database online after restores
----------------
RESTORE DATABASE DiscountTech                             -- RESTORE DATABASE = finalize restore; DiscountTech = database name
WITH RECOVERY;                                            -- WITH RECOVERY = make database usable again






