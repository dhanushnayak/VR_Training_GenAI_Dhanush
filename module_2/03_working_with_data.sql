-- =====================================================
-- Module 2.3: Working with Data (DDL Operations)
-- =====================================================

-- =====================================================
-- INSERT Statement - Adding New Data
-- =====================================================

-- Basic INSERT syntax
INSERT INTO departments (department_id, department_name, location, budget)
VALUES (6, 'Research', 'Seattle', 750000.00);

-- Insert multiple rows at once
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id) VALUES
(11, 'Robert', 'Clark', 'robert.clark@company.com', '2023-01-15', 73000.00, 6),
(12, 'Maria', 'Rodriguez', 'maria.rodriguez@company.com', '2023-02-20', 69000.00, 6),
(13, 'Kevin', 'White', 'kevin.white@company.com', '2023-03-10', 81000.00, 2);

-- Insert with SELECT (copying data)
-- Create a backup table first
CREATE TABLE employees_backup AS SELECT * FROM employees WHERE 1=0; -- Empty copy

-- Insert selected data
INSERT INTO employees_backup 
SELECT * FROM employees WHERE department_id = 1;

-- Insert with default values
-- First, let's modify our table to have default values
-- (This is just for demonstration - in practice, you'd set defaults during table creation)

-- =====================================================
-- UPDATE Statement - Modifying Existing Data
-- =====================================================

-- Basic UPDATE syntax
UPDATE employees 
SET salary = 75000.00 
WHERE employee_id = 3;

-- Update multiple columns
UPDATE employees 
SET salary = 95000.00, 
    email = 'mike.brown.updated@company.com'
WHERE employee_id = 3;

-- Update with calculations
UPDATE employees 
SET salary = salary * 1.05  -- 5% raise
WHERE department_id = 1;

-- Update with conditions
UPDATE employees 
SET salary = salary * 1.03  -- 3% raise for employees hired before 2021
WHERE hire_date < '2021-01-01';

-- Update using subquery
UPDATE employees 
SET salary = (
    SELECT AVG(salary) * 1.1 
    FROM employees e2 
    WHERE e2.department_id = employees.department_id
)
WHERE employee_id = 13;

-- Conditional UPDATE with CASE
UPDATE employees 
SET salary = CASE 
    WHEN salary < 70000 THEN salary * 1.08  -- 8% raise for lower salaries
    WHEN salary < 85000 THEN salary * 1.05  -- 5% raise for medium salaries
    ELSE salary * 1.03                      -- 3% raise for higher salaries
END
WHERE department_id IN (2, 3);

-- =====================================================
-- DELETE Statement - Removing Data
-- =====================================================

-- Basic DELETE syntax
DELETE FROM employees WHERE employee_id = 13;

-- Delete with conditions
DELETE FROM employees 
WHERE department_id = 6 AND salary < 70000;

-- Delete using subquery
DELETE FROM employees 
WHERE employee_id IN (
    SELECT employee_id 
    FROM employee_projects 
    WHERE project_id = 5
);

-- Delete all records (be careful!)
-- DELETE FROM employees_backup;

-- =====================================================
-- Data Types and Constraints
-- =====================================================

-- Create table with various data types and constraints
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    quantity_in_stock INTEGER DEFAULT 0,
    category_id INTEGER,
    is_active BOOLEAN DEFAULT 1,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME,
    UNIQUE(product_name),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Create categories table
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Insert sample categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Apparel and fashion items'),
(3, 'Books', 'Books and educational materials'),
(4, 'Home & Garden', 'Home improvement and gardening supplies');

-- Insert sample products
INSERT INTO products (product_name, description, price, quantity_in_stock, category_id) VALUES
('Laptop Pro 15"', 'High-performance laptop for professionals', 1299.99, 25, 1),
('Wireless Headphones', 'Noise-canceling wireless headphones', 199.99, 50, 1),
('Cotton T-Shirt', 'Comfortable cotton t-shirt', 24.99, 100, 2),
('Programming Book', 'Learn Python programming', 39.99, 30, 3),
('Garden Hose', '50ft expandable garden hose', 29.99, 15, 4);

-- =====================================================
-- Working with NULL Values
-- =====================================================

-- Insert records with NULL values
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id, manager_id)
VALUES (14, 'Alex', 'Johnson', 'alex.johnson@company.com', '2023-04-01', 67000.00, NULL, NULL);

-- Update NULL values
UPDATE employees 
SET department_id = 2 
WHERE employee_id = 14;

-- Handle NULL in calculations (NULL + anything = NULL)
SELECT 
    first_name,
    last_name,
    salary,
    COALESCE(manager_id, 0) AS manager_id_safe,  -- Replace NULL with 0
    IFNULL(manager_id, 'No Manager') AS manager_status  -- SQLite function
FROM employees;

-- =====================================================
-- Transactions and Data Integrity
-- =====================================================

-- Begin a transaction
BEGIN TRANSACTION;

-- Perform multiple operations
INSERT INTO departments (department_id, department_name, location, budget)
VALUES (7, 'Legal', 'Denver', 400000.00);

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id)
VALUES (15, 'Sarah', 'Legal', 'sarah.legal@company.com', '2023-05-01', 85000.00, 7);

-- If everything is successful, commit the transaction
COMMIT;

-- If there's an error, rollback the transaction
-- ROLLBACK;

-- Example of rollback scenario
BEGIN TRANSACTION;

UPDATE employees SET salary = salary * 2 WHERE department_id = 1;  -- Accidental double salary

-- Oops, that was a mistake! Let's rollback
ROLLBACK;

-- =====================================================
-- Upsert Operations (INSERT OR REPLACE/ON CONFLICT)
-- =====================================================

-- SQLite syntax for UPSERT
INSERT OR REPLACE INTO departments (department_id, department_name, location, budget)
VALUES (1, 'Engineering', 'San Francisco', 2200000.00);  -- Updates existing record

-- Alternative UPSERT using INSERT OR IGNORE
INSERT OR IGNORE INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id)
VALUES (1, 'John', 'Smith', 'john.smith@company.com', '2020-01-15', 95000.00, 1);  -- Ignores if exists

-- PostgreSQL/MySQL style (for reference)
-- INSERT INTO departments (department_id, department_name, location, budget)
-- VALUES (1, 'Engineering', 'San Francisco', 2200000.00)
-- ON CONFLICT (department_id) 
-- DO UPDATE SET budget = EXCLUDED.budget;

-- =====================================================
-- Bulk Operations
-- =====================================================

-- Bulk insert from another table
INSERT INTO employees_backup 
SELECT * FROM employees 
WHERE hire_date >= '2023-01-01';

-- Bulk update
UPDATE products 
SET price = price * 0.9  -- 10% discount
WHERE category_id = 2;   -- All clothing items

-- Bulk delete
DELETE FROM employee_projects 
WHERE project_id IN (
    SELECT project_id 
    FROM projects 
    WHERE end_date < '2023-01-01'
);

-- =====================================================
-- Data Validation and Constraints
-- =====================================================

-- Try to insert invalid data (will fail due to constraints)
-- INSERT INTO products (product_name, price, category_id)
-- VALUES ('Invalid Product', -10.00, 1);  -- Fails: price must be > 0

-- INSERT INTO products (product_name, price, category_id)
-- VALUES (NULL, 29.99, 1);  -- Fails: product_name cannot be NULL

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: Add a new department 'Customer Service' in 'Miami' with budget 350000
INSERT INTO departments (department_id, department_name, location, budget)
VALUES (8, 'Customer Service', 'Miami', 350000.00);

-- Exercise 2: Give all employees in Engineering department a 7% raise
UPDATE employees 
SET salary = salary * 1.07 
WHERE department_id = 1;

-- Exercise 3: Delete all projects that ended before 2023
DELETE FROM projects 
WHERE end_date < '2023-01-01';

-- Exercise 4: Insert a new employee and assign them to a project in one transaction
BEGIN TRANSACTION;

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id, manager_id)
VALUES (16, 'Jennifer', 'Adams', 'jennifer.adams@company.com', '2023-06-01', 72000.00, 8, NULL);

INSERT INTO employee_projects (employee_id, project_id, role, hours_allocated)
VALUES (16, 3, 'Customer Support Lead', 40);

COMMIT;

-- Exercise 5: Update all products to have updated_date as current timestamp
UPDATE products 
SET updated_date = CURRENT_TIMESTAMP;