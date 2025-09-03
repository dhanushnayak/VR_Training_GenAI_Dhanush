# Module 2.3: Working with Data (DML Operations) - Study Notes

## Data Manipulation Language (DML) Overview

DML operations allow you to modify data within existing database tables. The four primary DML operations are:
- **INSERT**: Add new data
- **UPDATE**: Modify existing data
- **DELETE**: Remove data
- **SELECT**: Retrieve data (covered in previous module)

## INSERT Statement - Adding New Data

### Basic INSERT Syntax
```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

### Single Row Insert
```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id)
VALUES ('John', 'Doe', 'john.doe@company.com', '2023-06-01', 75000.00, 1);
```

### Multiple Row Insert
```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary, department_id) VALUES
('Alice', 'Smith', 'alice.smith@company.com', '2023-06-01', 72000.00, 2),
('Bob', 'Johnson', 'bob.johnson@company.com', '2023-06-02', 68000.00, 3),
('Carol', 'Williams', 'carol.williams@company.com', '2023-06-03', 71000.00, 1);
```

**Benefits of multiple row insert**:
- Better performance than individual inserts
- Atomic operation (all succeed or all fail)
- Reduced network overhead

### INSERT with SELECT (Copying Data)
```sql
-- Copy all engineering employees to backup table
INSERT INTO employees_backup 
SELECT * FROM employees WHERE department_id = 1;

-- Copy specific columns with transformation
INSERT INTO employee_summary (full_name, department_id, salary_category)
SELECT 
    first_name || ' ' || last_name,
    department_id,
    CASE 
        WHEN salary >= 80000 THEN 'High'
        WHEN salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END
FROM employees;
```

### INSERT with Default Values
```sql
-- Specify only required columns, let others use defaults
INSERT INTO products (product_name, price)
VALUES ('New Product', 29.99);
-- Other columns will use their default values
```

### Handling Auto-Increment Columns
```sql
-- Don't specify auto-increment column
INSERT INTO customers (first_name, last_name, email)
VALUES ('Jane', 'Doe', 'jane.doe@email.com');
-- customer_id will be automatically generated
```

## UPDATE Statement - Modifying Existing Data

### Basic UPDATE Syntax
```sql
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;
```

**⚠️ Warning**: Always include WHERE clause unless you want to update ALL rows!

### Single Column Update
```sql
UPDATE employees 
SET salary = 80000.00 
WHERE employee_id = 5;
```

### Multiple Column Update
```sql
UPDATE employees 
SET salary = 85000.00, 
    email = 'new.email@company.com',
    last_modified = CURRENT_TIMESTAMP
WHERE employee_id = 3;
```

### Update with Calculations
```sql
-- Give 5% raise to all employees in department 1
UPDATE employees 
SET salary = salary * 1.05 
WHERE department_id = 1;

-- Add bonus based on years of service
UPDATE employees 
SET salary = salary + (JULIANDAY('now') - JULIANDAY(hire_date)) / 365 * 1000
WHERE hire_date < '2020-01-01';
```

### Conditional Updates with CASE
```sql
UPDATE employees 
SET salary = CASE 
    WHEN salary < 60000 THEN salary * 1.10  -- 10% raise for low salaries
    WHEN salary < 80000 THEN salary * 1.07  -- 7% raise for medium salaries
    ELSE salary * 1.05                      -- 5% raise for high salaries
END
WHERE department_id IN (1, 2, 3);
```

### Update with Subqueries
```sql
-- Set salary to department average plus 10%
UPDATE employees 
SET salary = (
    SELECT AVG(salary) * 1.1 
    FROM employees e2 
    WHERE e2.department_id = employees.department_id
)
WHERE employee_id = 10;
```

### Update with JOIN (Advanced)
```sql
-- Update employee salary based on department budget
UPDATE employees 
SET salary = salary * 1.05
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE budget > 1000000
);
```

## DELETE Statement - Removing Data

### Basic DELETE Syntax
```sql
DELETE FROM table_name
WHERE condition;
```

**⚠️ Critical Warning**: DELETE without WHERE removes ALL rows!

### Single Row Delete
```sql
DELETE FROM employees 
WHERE employee_id = 15;
```

### Conditional Delete
```sql
-- Delete employees from specific department with low salary
DELETE FROM employees 
WHERE department_id = 5 AND salary < 50000;
```

### Delete with Subquery
```sql
-- Delete employees who are not assigned to any projects
DELETE FROM employees 
WHERE employee_id NOT IN (
    SELECT DISTINCT employee_id 
    FROM employee_projects 
    WHERE employee_id IS NOT NULL
);
```

### Delete All Rows (Truncate Alternative)
```sql
-- Delete all data but keep table structure
DELETE FROM temp_table;

-- Better alternative for large tables (if supported)
TRUNCATE TABLE temp_table;
```

## Data Types and Constraints

### Common Data Types

#### Numeric Types
- **INTEGER**: Whole numbers
- **DECIMAL(p,s)**: Fixed-point decimal (p=precision, s=scale)
- **REAL/FLOAT**: Floating-point numbers
- **BOOLEAN**: True/False values

#### String Types
- **VARCHAR(n)**: Variable-length string (max n characters)
- **CHAR(n)**: Fixed-length string (exactly n characters)
- **TEXT**: Large text data

#### Date/Time Types
- **DATE**: Date only (YYYY-MM-DD)
- **TIME**: Time only (HH:MM:SS)
- **DATETIME/TIMESTAMP**: Date and time combined

### Constraint Types

#### 1. PRIMARY KEY
```sql
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);
```
**Purpose**: Uniquely identifies each row, cannot be NULL

#### 2. FOREIGN KEY
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```
**Purpose**: Maintains referential integrity between tables

#### 3. NOT NULL
```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
```
**Purpose**: Ensures column always has a value

#### 4. UNIQUE
```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50) UNIQUE
);
```
**Purpose**: Ensures no duplicate values in column

#### 5. CHECK
```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    price DECIMAL(10,2) CHECK (price > 0),
    quantity INTEGER CHECK (quantity >= 0)
);
```
**Purpose**: Validates data meets specific conditions

#### 6. DEFAULT
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'pending',
    is_active BOOLEAN DEFAULT 1
);
```
**Purpose**: Provides default value when none specified

## Working with NULL Values

### Understanding NULL
- NULL represents missing or unknown data
- NULL is not the same as empty string ('') or zero (0)
- Any arithmetic operation with NULL results in NULL
- Comparisons with NULL require special operators

### Inserting NULL Values
```sql
-- Explicit NULL
INSERT INTO employees (first_name, last_name, manager_id)
VALUES ('John', 'Doe', NULL);

-- Implicit NULL (omit column)
INSERT INTO employees (first_name, last_name)
VALUES ('Jane', 'Smith');
```

### Handling NULL in Updates
```sql
-- Set column to NULL
UPDATE employees 
SET manager_id = NULL 
WHERE employee_id = 5;

-- Replace NULL with default value
UPDATE employees 
SET phone = COALESCE(phone, 'Not Provided') 
WHERE phone IS NULL;
```

### NULL-Safe Functions
```sql
-- COALESCE returns first non-NULL value
SELECT 
    first_name,
    COALESCE(phone, 'No phone') AS phone_display,
    COALESCE(manager_id, 0) AS manager_id_safe
FROM employees;

-- IFNULL (SQLite specific)
SELECT 
    first_name,
    IFNULL(manager_id, 'No Manager') AS manager_status
FROM employees;
```

## Transactions and Data Integrity

### What is a Transaction?
A transaction is a sequence of database operations that are treated as a single unit of work. Transactions follow ACID properties:

- **Atomicity**: All operations succeed or all fail
- **Consistency**: Database remains in valid state
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed changes are permanent

### Basic Transaction Syntax
```sql
BEGIN TRANSACTION;
-- Multiple operations here
COMMIT;  -- Save changes

-- OR

ROLLBACK;  -- Undo changes
```

### Transaction Example
```sql
BEGIN TRANSACTION;

-- Transfer money between accounts
UPDATE accounts SET balance = balance - 1000 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 2;

-- Check if both operations succeeded
-- If any error occurred, ROLLBACK
-- If all successful, COMMIT
COMMIT;
```

### Error Handling in Transactions
```sql
BEGIN TRANSACTION;

INSERT INTO departments (department_name, location, budget)
VALUES ('New Dept', 'City', 500000);

INSERT INTO employees (first_name, last_name, department_id)
VALUES ('New', 'Employee', LAST_INSERT_ROWID());

-- If any error occurs above, rollback
-- Otherwise commit
COMMIT;
```

## UPSERT Operations

### INSERT OR REPLACE (SQLite)
```sql
-- If record exists, replace it; otherwise insert
INSERT OR REPLACE INTO products (product_id, product_name, price)
VALUES (1, 'Updated Product', 29.99);
```

### INSERT OR IGNORE (SQLite)
```sql
-- If record exists, ignore; otherwise insert
INSERT OR IGNORE INTO customers (email, first_name, last_name)
VALUES ('existing@email.com', 'John', 'Doe');
```

### ON CONFLICT (PostgreSQL Style)
```sql
-- PostgreSQL/MySQL equivalent
INSERT INTO products (product_id, product_name, price)
VALUES (1, 'New Product', 25.99)
ON CONFLICT (product_id) 
DO UPDATE SET 
    product_name = EXCLUDED.product_name,
    price = EXCLUDED.price;
```

## Bulk Operations

### Bulk Insert Performance Tips
```sql
-- Use single INSERT with multiple VALUES
INSERT INTO large_table (col1, col2, col3) VALUES
(val1, val2, val3),
(val4, val5, val6),
-- ... many more rows
(val7, val8, val9);
```

### Bulk Update Strategies
```sql
-- Update multiple records efficiently
UPDATE employees 
SET salary = salary * 1.05 
WHERE department_id IN (1, 2, 3);

-- Use CASE for different updates
UPDATE products 
SET price = CASE category_id
    WHEN 1 THEN price * 0.9   -- 10% discount for category 1
    WHEN 2 THEN price * 0.95  -- 5% discount for category 2
    ELSE price
END
WHERE category_id IN (1, 2);
```

### Bulk Delete Considerations
```sql
-- Delete in batches for large tables
DELETE FROM large_table 
WHERE created_date < '2020-01-01' 
LIMIT 1000;
-- Repeat until no more rows to delete
```

## Data Validation Strategies

### Input Validation
```sql
-- Validate before insert
INSERT INTO products (product_name, price, category_id)
SELECT 'New Product', 29.99, 1
WHERE NOT EXISTS (
    SELECT 1 FROM products 
    WHERE product_name = 'New Product'
);
```

### Constraint Violations
```sql
-- Handle constraint violations gracefully
INSERT OR IGNORE INTO unique_table (unique_column, other_data)
VALUES ('duplicate_value', 'some_data');
```

### Data Quality Checks
```sql
-- Check data quality after operations
SELECT 
    COUNT(*) AS total_records,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS missing_emails,
    COUNT(CASE WHEN salary <= 0 THEN 1 END) AS invalid_salaries
FROM employees;
```

## Performance Optimization

### Indexing for DML Operations
```sql
-- Create indexes on frequently updated columns
CREATE INDEX idx_employee_dept ON employees(department_id);
CREATE INDEX idx_employee_salary ON employees(salary);
```

### Batch Processing
```sql
-- Process large updates in batches
UPDATE large_table 
SET processed = 1 
WHERE id BETWEEN 1 AND 1000 AND processed = 0;
```

### Avoiding Full Table Scans
```sql
-- Good: Uses index
UPDATE employees SET salary = salary * 1.05 WHERE employee_id = 123;

-- Bad: Full table scan
UPDATE employees SET salary = salary * 1.05 WHERE UPPER(first_name) = 'JOHN';
```

## Common Mistakes and Solutions

### 1. Missing WHERE Clause
**Problem**: Accidentally updating/deleting all rows
**Solution**: Always double-check WHERE clauses, test with SELECT first

### 2. Constraint Violations
**Problem**: INSERT/UPDATE fails due to constraints
**Solution**: Validate data before operations, handle violations gracefully

### 3. Data Type Mismatches
**Problem**: Inserting wrong data types
**Solution**: Use appropriate data types, validate inputs

### 4. Transaction Management
**Problem**: Forgetting to commit or rollback
**Solution**: Use proper transaction handling, implement error checking

## Best Practices

### 1. Safety First
- Always test DML operations on sample data first
- Use transactions for related operations
- Backup data before major changes
- Include WHERE clauses to limit scope

### 2. Performance
- Use batch operations for large datasets
- Create appropriate indexes
- Monitor query execution plans
- Consider timing of operations

### 3. Data Integrity
- Use constraints to enforce business rules
- Validate data before insertion
- Handle NULL values appropriately
- Maintain referential integrity

### 4. Maintainability
- Document complex operations
- Use meaningful column names
- Follow consistent naming conventions
- Comment business logic

## Troubleshooting Common Issues

### Foreign Key Violations
```sql
-- Check for orphaned records
SELECT * FROM orders 
WHERE customer_id NOT IN (
    SELECT customer_id FROM customers 
    WHERE customer_id IS NOT NULL
);
```

### Duplicate Key Errors
```sql
-- Find duplicates before inserting
SELECT email, COUNT(*) 
FROM customers 
GROUP BY email 
HAVING COUNT(*) > 1;
```

### Data Type Conversion Issues
```sql
-- Safe data type conversion
UPDATE products 
SET price = CAST(price_text AS DECIMAL(10,2))
WHERE price_text IS NOT NULL 
  AND price_text != '';
```

## Key Takeaways

- **DML operations modify data** - INSERT, UPDATE, DELETE
- **Always use WHERE clauses** to limit scope of operations
- **Transactions ensure data integrity** for related operations
- **Constraints prevent invalid data** from entering the database
- **NULL values require special handling** in all operations
- **Performance matters** - use indexes and batch operations
- **Test thoroughly** before running on production data
- **Backup is essential** before major data modifications