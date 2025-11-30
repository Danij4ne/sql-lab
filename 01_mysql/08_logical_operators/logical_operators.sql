
---------------------------------------------------------
-- AND, OR, NOT
---------------------------------------------------------

-- NOT = negation, the opposite

SELECT * 
FROM users 
WHERE NOT email = 'sara@gmail.com';
-- Select all rows from users where the email is NOT equal to 'sara@gmail.com'

-- AND = logical AND

SELECT * 
FROM users 
WHERE NOT email = 'sara@gmail.com' 
  AND age = 15;
-- Email is not 'sara@gmail.com' AND age is 15

-- OR = logical OR

SELECT * 
FROM users 
WHERE NOT email = 'sara@gmail.com' 
   OR age = 15;
-- Email is not that OR age is equal to 15
