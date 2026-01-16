

----------------
-- CREATE FUNCTION (Scalar) = create a function that returns a single value
----------------
CREATE FUNCTION dbo.CalculateDiscount                                  -- CREATE FUNCTION = defines the function; dbo = schema; CalculateDiscount = name
(
    @totalAmount DECIMAL(10,2),                                        -- @totalAmount = input parameter; DECIMAL = numeric type
    @discountRate DECIMAL(5,2)                                         -- @discountRate = discount percentage
)
RETURNS DECIMAL(10,2)                                                  -- RETURNS = data type returned by the function
AS                                                                     -- AS = start of function body
BEGIN                                                                  -- BEGIN = logical block
    RETURN @totalAmount * (@discountRate / 100);                       -- RETURN = calculated final value
END;                                                                   -- END = end of function
GO                                                                     -- GO = separates execution batches


----------------
-- Using a scalar UDF in SELECT = apply a function as a calculated column
----------------
SELECT
    product_id,                                                        -- product_id = product identifier
    price,                                                             -- price = original price
    dbo.CalculateDiscount(price, 10) AS price_discount                 -- dbo.CalculateDiscount() = calculates discount; 10 = fixed percentage
FROM Products;                                                         -- FROM Products = products table


----------------
-- CREATE FUNCTION (Table-Valued) = create a function that returns a table
----------------
CREATE FUNCTION dbo.GetHighActivityUsers()                             -- CREATE FUNCTION = defines TVF; GetHighActivityUsers = name
RETURNS TABLE                                                          -- RETURNS TABLE = function returns a table
AS                                                                     -- AS = start of definition
RETURN                                                                 -- RETURN = directly returns the SELECT result
(
    SELECT
        user_id,                                                       -- user_id = user identifier
        month_date,                                                    -- month_date = reference month
        workout_frequency,                                             -- workout_frequency = workouts in the month
        total_active_days,                                             -- total_active_days = active days
        avg_daily_steps,                                               -- avg_daily_steps = average daily steps
        avg_exercise_minutes,                                          -- avg_exercise_minutes = average exercise minutes
        achievement_rate                                               -- achievement_rate = achievement ratio
    FROM dbo.HealthMetrics                                             -- FROM HealthMetrics = health metrics table
    WHERE workout_frequency >= 5                                       -- filter = minimum 5 workouts
      AND total_active_days >= 15                                      -- filter = minimum 15 active days
);
GO                                                                     -- GO = separates execution batches


----------------
-- Using a table-valued UDF = treat the function as a virtual table
----------------
SELECT
    h.user_id,                                                         -- h.user_id = user returned by the function
    h.total_active_days,                                               -- total_active_days = active days
    h.workout_frequency                                                -- workout_frequency = workouts
FROM dbo.GetHighActivityUsers() h                                      -- FROM function() = used as a virtual table
JOIN Customers c ON h.user_id = c.user_id;                             -- JOIN Customers = join with real table


----------------
-- CREATE FUNCTION (Parameterized TVF) = configurable table-valued function
----------------
CREATE FUNCTION dbo.GetHighActivityUsersByThreshold                    -- function name
(
    @minWorkoutFrequency INT,                                          -- @minWorkoutFrequency = minimum workouts
    @minActiveDays INT                                                 -- @minActiveDays = minimum active days
)
RETURNS TABLE                                                          -- returns a table
AS
RETURN
(
    SELECT
        user_id,                                                       -- user_id = user identifier
        month_date,                                                    -- month_date = month
        workout_frequency,                                             -- workout_frequency = workouts
        total_active_days,                                             -- total_active_days = active days
        avg_daily_steps,                                               -- avg_daily_steps = daily steps
        avg_exercise_minutes,                                          -- avg_exercise_minutes = exercise minutes
        achievement_rate                                               -- achievement_rate = achievement ratio
    FROM dbo.HealthMetrics                                             -- source table
    WHERE workout_frequency >= @minWorkoutFrequency                    -- dynamic filter by parameter
      AND total_active_days >= @minActiveDays                          -- dynamic filter by parameter
);
GO                                                                     -- GO = separates execution batches


----------------
-- CREATE FUNCTION (Scalar BIT) = evaluate a business rule
----------------
CREATE FUNCTION dbo.IsEligibleForLoyaltyDiscount                       -- function that evaluates eligibility
(
    @userId INT                                                        -- @userId = customer identifier
)
RETURNS BIT                                                            -- RETURNS BIT = returns 0 or 1
AS
BEGIN
    DECLARE @totalSpent DECIMAL(10,2);                                 -- DECLARE = local variable to accumulate spending

    SELECT @totalSpent = COALESCE(SUM(total_amount), 0)                -- COALESCE = prevents NULL when no orders exist
    FROM dbo.Orders                                                    -- Orders = orders table
    WHERE customer_id = @userId;                                       -- filter by customer

    IF @totalSpent > 5000                                              -- IF = business condition
        RETURN 1;                                                      -- RETURN 1 = eligible
    RETURN 0;                                                          -- RETURN 0 = not eligible
END;
GO                                                                     -- GO = separates execution batches


----------------
-- Using a scalar business-rule UDF in SELECT
----------------
SELECT
    customer_id,                                                       -- customer_id = customer identifier
    dbo.IsEligibleForLoyaltyDiscount(customer_id) AS LoyaltyStatus     -- BIT UDF = 1 eligible, 0 not eligible
FROM dbo.Customers;                                                    -- FROM Customers = customers table
