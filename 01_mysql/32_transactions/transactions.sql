
---------------------------
-- TRANSACTIONS
--------------------------

-- Basic transaction commands:

START TRANSACTION;
-- Execute queries here...
COMMIT;
-- Or ROLLBACK; to undo the transaction

-- Example structure:
-- START TRANSACTION;
--   UPDATE ...;
--   INSERT ...;
--   DELETE ...;
-- COMMIT;
-- or:
-- ROLLBACK;
