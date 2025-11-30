
---------------------------
-- TRIGGER
---------------------------

-- TRIGGER -> "trigger", instructions that are executed automatically
-- when certain events occur on a table (like programming logic in the DB).

-- Example:
-- If a user updates their email, we want to store the old email
-- in another table called email_history.

-- First we create the table where we will store old emails:

CREATE TABLE email_history (
    email_history_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(100)
);

CREATE INDEX idx_email_history 
ON email_history (email_history_id);

-- After having the table, we create the trigger:

DELIMITER $$

CREATE TRIGGER tg_email   -- trigger name
BEFORE UPDATE             -- when? before or after an UPDATE
ON users                  -- on which table
FOR EACH ROW              -- execute for each affected row
BEGIN                     -- start of the trigger logic
    IF OLD.email <> NEW.email THEN
        -- if the new email is different from the old one
        INSERT INTO email_history(user_id, email)
        VALUES (OLD.user_id, OLD.email);
    END IF;
END$$                     -- end of trigger

DELIMITER ;

-- To delete the trigger:
DROP TRIGGER tg_email;
