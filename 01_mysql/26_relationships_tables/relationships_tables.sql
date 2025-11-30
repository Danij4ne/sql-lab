
-------------------------------------
-- Related Tables (creation)
--------------------------------------

-- TABLE 1:1  USERS <--> DNI (ONE TO ONE)

CREATE TABLE dni (
    dni_id INT AUTO_INCREMENT PRIMARY KEY,
    dni_number INT NOT NULL,
    user_id INT, -- user_id references the primary key in the users table
    UNIQUE(user_id), -- to ensure the 1:1 relationship, prevent multiple DNIs pointing to the same user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    -- FOREIGN KEY references users (table name) and its primary key user_id
);


-- TABLE 1:N  COMPANY <--> USERS   (ONE TO MANY)

CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Now the users table should have a new field for company_id
-- so that it is linked and has its foreign key.

ALTER TABLE users 
ADD company_id INT;

-- Once created, we need it to be a foreign key

ALTER TABLE users
ADD CONSTRAINT fk_users_companies
FOREIGN KEY (company_id) REFERENCES companies(company_id);
-- CONSTRAINT = "rule" that connects both tables and protects data integrity.

-- Now we have the 1:N relationship:
-- one company to many users.


-- TABLES N:M (many-to-many) -> we will always need a junction table.

-- We will do:
-- users ---> junction table ----> languages

-- First we create the languages table:

CREATE TABLE languages (
    languages_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Now we create the junction table
-- (usually named with both related tables):

CREATE TABLE users_languages (
    users_languages_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,       -- keys from the two tables we want to relate
    languages_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(user_id),            -- first foreign key
    FOREIGN KEY(languages_id) REFERENCES languages(languages_id), -- second foreign key
    UNIQUE (user_id, languages_id)
    -- UNIQUE ensures we do not repeat the same user-language combination
);
