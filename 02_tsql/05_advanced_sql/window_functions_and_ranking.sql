
-------------------
-- ROW_NUMBER() + OVER (Always) + used in SELECT
-------------------
-- Assigns a unique sequential number to each row in the result set.
-- No ties: every row always gets a different number.

ROW_NUMBER() OVER(ORDER BY name ASC) AS row
-- Numbers the rows ordered by name in ascending order

SELECT 
    ROW_NUMBER() OVER(ORDER BY name ASC) AS row,
    name,
    recovery_level
FROM sys.databases

ROW_NUMBER() OVER(PARTITION BY compatibility_level ORDER BY name ASC) AS row
-- Resets the numbering every time the compatibility_level changes
-- and orders rows by name inside each group

SELECT
    ROW_NUMBER() OVER(PARTITION BY compatibility_level ORDER BY name ASC) AS row,
    name,
    recovery_model_desc
FROM sys.databases


-------------------
-- RANK() + OVER (Always) + used in SELECT
-------------------
-- Assigns ranking positions based on order.
-- If there are ties, they get the same rank and gaps appear in the ranking.

RANK() OVER(ORDER BY sales DESC) AS rank_pos
-- Ranks rows from highest to lowest sales (competition-style ranking)

SELECT 
    RANK() OVER(ORDER BY total_amount DESC) AS rank_pos,
    customer_name,
    total_amount
FROM sales

-- If two customers have the same total_amount:
-- both get the same rank
-- and the next rank is skipped (1, 2, 2, 4...)

RANK() OVER(PARTITION BY country ORDER BY total_amount DESC) AS rank_pos
-- Creates a separate ranking for each country
-- customers are ranked by sales inside their country



-------------------
-- DENSE_RANK() + OVER (Always) + used in SELECT
-------------------
-- Assigns ranking positions based on order.
-- If there are ties, they get the same rank but NO gaps appear.

DENSE_RANK() OVER(ORDER BY sales DESC) AS dense_rank_pos
-- Ranks rows from highest to lowest sales without skipping numbers

SELECT 
    DENSE_RANK() OVER(ORDER BY total_amount DESC) AS dense_rank_pos,
    customer_name,
    total_amount
FROM sales

-- If two customers have the same total_amount:
-- both get the same rank
-- but the next rank is NOT skipped (1, 2, 2, 3...)

DENSE_RANK() OVER(PARTITION BY country ORDER BY total_amount DESC) AS dense_rank_pos
-- Creates ranking levels per country without gaps
-- useful for grouping customers into sales tiers



 

