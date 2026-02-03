
----------------
-- CHECK = restringe valores según una condición
----------------
ALTER TABLE HealthMetrics                              -- ALTER TABLE = modificar tabla existente
ADD CONSTRAINT chk_sleep_hours                         -- CONSTRAINT = nombre de la regla
CHECK (avg_sleep_hours BETWEEN 0 AND 24);              -- CHECK = condición válida; BETWEEN = rango permitido


----------------
-- NOT NULL = impide valores vacíos
----------------
ALTER TABLE Employees                                  -- ALTER TABLE = modificar tabla
ALTER COLUMN email NVARCHAR(255) NOT NULL;             -- NOT NULL = no permite NULL en la columna


----------------
-- UNIQUE = evita valores duplicados
----------------
ALTER TABLE Employees                                  -- ALTER TABLE = modificar tabla
ADD CONSTRAINT UQ_GeoLocation                           -- UQ_ = nombre de restricción única
UNIQUE (GeoLocation);                                  -- UNIQUE = no permite duplicados


----------------
-- FOREIGN KEY = asegura relación válida entre tablas
----------------
ALTER TABLE Orders                                     -- ALTER TABLE = tabla hija
ADD CONSTRAINT FK_Orders_Customers                     -- FK_ = clave foránea
FOREIGN KEY (customer_id)                              -- customer_id = columna que referencia
REFERENCES Customers(customer_id);                     -- REFERENCES = tabla y columna padre


----------------
-- TRIGGER = valida reglas complejas automáticamente
----------------
CREATE TRIGGER trg_ValidateDate                        -- CREATE TRIGGER = crear disparador
ON Coach_Customer                                      -- ON = tabla donde se ejecuta
AFTER INSERT, UPDATE                                   -- AFTER = se ejecuta tras insertar o actualizar
AS                                                     -- AS = inicio del bloque
BEGIN                                                  -- BEGIN = inicio lógica
    IF EXISTS (                                        -- IF EXISTS = comprobar si existe error
        SELECT 1                                      -- SELECT 1 = no devuelve datos, solo valida
        FROM inserted                                 -- inserted = tabla virtual de filas nuevas
        WHERE start_date > end_date                   -- condición inválida
    )
    BEGIN
        RAISERROR ('End date cannot be before start date', 16, 1);  -- RAISERROR = lanza error; 16 = error controlable
        ROLLBACK TRANSACTION;                          -- ROLLBACK = deshace la operación
    END
END;


----------------
-- RAISERROR() = lanza un error personalizado
----------------
RAISERROR('No staff member with such id.', 16, 1);     -- texto = mensaje; 16 = error; 1 = estado


----------------
-- CHECK con rango numérico
----------------
ALTER TABLE Devices                                    -- ALTER TABLE = modificar tabla
ADD CONSTRAINT chk_battery_life                        -- nombre de la restricción
CHECK (battery_life_days >= 0);                        -- CHECK = no permite negativos


----------------
-- ALTER COLUMN = cambiar tipo de dato con validación
----------------
ALTER TABLE HealthMetrics                              -- ALTER TABLE = modificar tabla
ALTER COLUMN avg_heart_rate INT                        -- INT = solo números enteros
CHECK (avg_heart_rate BETWEEN 30 AND 200);             -- CHECK = rango permitido


