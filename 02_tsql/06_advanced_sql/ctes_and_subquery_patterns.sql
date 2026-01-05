

--------------------------------------------------
-- WITH (CTE) = create a named result (like a temporary view)
-- It only exists for the query that comes right after the WITH
-- It is not a physical table, just a way to organize a complex query
--------------------------------------------------

;WITH CustomerOrders AS (                               -- WITH = defines a CTE; CustomerOrders = name of the result
    SELECT                                              -- SELECT = choose columns
        c.customer_id,                                 -- customer id
        c.first_name,                                  -- customer name
        o.order_id,                                    -- order id
        o.order_date                                   -- order date
    FROM Customers c                                   -- customer table
    JOIN Orders o                                      -- join with orders
        ON c.customer_id = o.customer_id               -- a customer owns their orders
)                                                      -- end of the CTE

SELECT                                                 -- main query (uses the CTE)
    customer_id,                                       -- customer id
    first_name,                                        -- name
    COUNT(order_id) AS total_orders                    -- count how many orders each customer has
FROM CustomerOrders                                    -- use the CTE like a table
GROUP BY customer_id, first_name;                      -- group by customer


--------------------------------------------------
-- WITH multiple CTEs = create chained steps (like a data pipeline)
--------------------------------------------------

;WITH OrderTotals AS (                                  -- 1st CTE: calculate total per order
    SELECT
        order_id,                                      -- order id
        SUM(price * quantity) AS order_total           -- sum price * quantity for that order
    FROM OrderItems                                    -- order line items
    GROUP BY order_id                                  -- one row per order
),
CustomerTotals AS (                                    -- 2nd CTE: total spent per customer
    SELECT
        o.customer_id,                                 -- customer id
        SUM(ot.order_total) AS total_spent              -- sum all orders for the customer
    FROM Orders o
    JOIN OrderTotals ot
        ON o.order_id = ot.order_id                    -- link orders to their totals
    GROUP BY o.customer_id                             -- one row per customer
)

SELECT
    customer_id,                                       -- customer
    total_spent                                        -- total money spent
FROM CustomerTotals;                                   -- use the second CTE


--------------------------------------------------
-- CROSS JOIN = combine every row from one table with every row from another
--------------------------------------------------

SELECT
    c.first_name,                                      -- customer name
    p.product_name                                     -- product name
FROM Customers c
CROSS JOIN Products p;                                 -- each customer appears with each product


--------------------------------------------------
-- CROSS JOIN with a single row = apply a global value to all rows
--------------------------------------------------

;WITH TaxRate AS (                                      -- CTE with a single row
    SELECT 0.21 AS tax                                  -- 21% VAT
)

SELECT
    p.product_name,                                    -- product
    p.price,                                           -- original price
    p.price * t.tax AS tax_amount,                      -- how much tax is paid
    p.price * (1 + t.tax) AS final_price                -- final price including tax
FROM Products p
CROSS JOIN TaxRate t;                                   -- the same VAT applies to all products
