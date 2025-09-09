-- =====================================================
-- Module 2.2: Basic SQL Queries
-- =====================================================

-- =====================================================
-- SELECT Statement Basics
-- =====================================================

-- Select all columns from a table
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, salary FROM employees;

-- Select with column aliases
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name",
    salary AS "Annual Salary"
FROM employees;

-- Select with calculated columns
SELECT 
    first_name,
    last_name,
    salary,
    salary * 12 AS annual_salary,
    salary / 12 AS monthly_salary
FROM employees;

-- =====================================================
-- WHERE Clause - Filtering Data
-- =====================================================

-- Basic WHERE conditions
SELECT * FROM employees WHERE department_id = 1;

-- Numeric comparisons
SELECT * FROM employees WHERE salary > 75000;
SELECT * FROM employees WHERE salary >= 70000;
SELECT * FROM employees WHERE salary < 80000;
SELECT * FROM employees WHERE salary <= 85000;
SELECT * FROM employees WHERE salary != 75000;  -- or <> 75000

-- String comparisons (case-sensitive in most databases)
SELECT * FROM employees WHERE first_name = 'John';

-- LIKE operator for pattern matching
SELECT * FROM employees WHERE first_name LIKE 'J%';  -- Starts with 'J'
SELECT * FROM employees WHERE last_name LIKE '%son'; -- Ends with 'son'
SELECT * FROM employees WHERE email LIKE '%@company.com'; -- Contains pattern
SELECT * FROM employees WHERE first_name LIKE '_ohn'; -- Single character wildcard

-- Case-insensitive search (varies by database)
-- SQLite: Use UPPER() or LOWER()
SELECT * FROM employees WHERE UPPER(first_name) = 'JOHN';

-- Date comparisons
SELECT * FROM employees WHERE hire_date > '2020-01-01';
SELECT * FROM employees WHERE hire_date BETWEEN '2020-01-01' AND '2021-12-31';

-- NULL values
SELECT * FROM employees WHERE manager_id IS NULL;     -- Find employees with no manager
SELECT * FROM employees WHERE manager_id IS NOT NULL; -- Find employees with a manager

-- =====================================================
-- Logical Operators
-- =====================================================

-- AND operator
SELECT * FROM employees 
WHERE department_id = 1 AND salary > 80000;

-- OR operator
SELECT * FROM employees 
WHERE department_id = 1 OR department_id = 2;

-- NOT operator
SELECT * FROM employees 
WHERE NOT department_id = 1;

-- Complex conditions with parentheses
SELECT * FROM employees 
WHERE (department_id = 1 OR department_id = 2) 
  AND salary > 70000;

-- IN operator (shorthand for multiple OR conditions)
SELECT * FROM employees 
WHERE department_id IN (1, 2, 3);

-- NOT IN operator
SELECT * FROM employees 
WHERE department_id NOT IN (4, 5);

-- =====================================================
-- ORDER BY Clause - Sorting Results
-- =====================================================

-- Sort by single column (ascending by default)
SELECT * FROM employees ORDER BY salary;

-- Sort in descending order
SELECT * FROM employees ORDER BY salary DESC;

-- Sort by multiple columns
SELECT * FROM employees 
ORDER BY department_id ASC, salary DESC;

-- Sort by column alias
SELECT 
    first_name,
    last_name,
    salary * 12 AS annual_salary
FROM employees 
ORDER BY annual_salary DESC;

-- Sort by column position (not recommended, but possible)
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY 3 DESC;  -- Sort by 3rd column (salary)

-- =====================================================
-- LIMIT and OFFSET - Pagination
-- =====================================================

-- Get first 5 records
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5;

-- Get records 6-10 (pagination)
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5 OFFSET 5;

-- Alternative syntax (MySQL)
-- SELECT * FROM employees ORDER BY salary DESC LIMIT 5, 5;

-- =====================================================
-- DISTINCT - Remove Duplicates
-- =====================================================

-- Get unique department IDs
SELECT DISTINCT department_id FROM employees;

-- Get unique combinations
SELECT DISTINCT department_id, manager_id FROM employees;

-- Count unique values
SELECT COUNT(DISTINCT department_id) AS unique_departments FROM employees;

-- =====================================================
-- Basic String Functions
-- =====================================================

-- Concatenation
SELECT 
    first_name || ' ' || last_name AS full_name,  -- SQLite/PostgreSQL
    -- CONCAT(first_name, ' ', last_name) AS full_name,  -- MySQL/SQL Server
    email
FROM employees;

-- String length
SELECT 
    first_name,
    LENGTH(first_name) AS name_length  -- CHAR_LENGTH() in some databases
FROM employees;

-- Case conversion
SELECT 
    UPPER(first_name) AS upper_name,
    LOWER(last_name) AS lower_name
FROM employees;

-- Substring extraction
SELECT 
    email,
    SUBSTR(email, 1, INSTR(email, '@') - 1) AS username  -- Extract username from email
FROM employees;

-- =====================================================
-- Basic Math Functions
-- =====================================================

-- Rounding
SELECT 
    salary,
    ROUND(salary / 12, 2) AS monthly_salary,
    ROUND(salary * 1.05) AS salary_with_raise
FROM employees;

-- Absolute value
SELECT ABS(-100) AS absolute_value;

-- Power and square root
SELECT 
    salary,
    POWER(salary, 2) AS salary_squared,
    SQRT(salary) AS salary_sqrt
FROM employees;

-- =====================================================
-- Date Functions
-- =====================================================

-- Current date and time
SELECT 
    DATE('now') AS current_date,           -- SQLite
    DATETIME('now','+5 hours','+30 minutes') AS current_datetime;   -- SQLite for UTC +5:30

-- Date arithmetic
SELECT 
    first_name,
    hire_date,
    DATE('now') AS today,
    JULIANDAY('now') - JULIANDAY(hire_date) AS days_employed
FROM employees;

-- Extract parts of date
SELECT 
    hire_date,
    strftime('%Y', hire_date) AS hire_year,    -- SQLite
    strftime('%m', hire_date) AS hire_month,   -- SQLite
    strftime('%d', hire_date) AS hire_day      -- SQLite
FROM employees;

-- =====================================================
-- Conditional Logic with CASE
-- =====================================================

-- Simple CASE statement
SELECT 
    first_name,
    last_name,
    salary,
    CASE 
        WHEN salary >= 90000 THEN 'High'
        WHEN salary >= 70000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees;

-- CASE with multiple conditions
SELECT 
    first_name,
    last_name,
    department_id,
    CASE department_id
        WHEN 1 THEN 'Engineering'
        WHEN 2 THEN 'Marketing'
        WHEN 3 THEN 'Sales'
        WHEN 4 THEN 'HR'
        WHEN 5 THEN 'Finance'
        ELSE 'Unknown'
    END AS department_name
FROM employees;

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: Find all employees hired in 2021
SELECT * FROM employees 
WHERE strftime('%Y', hire_date) = '2021';

-- Exercise 2: Get top 3 highest paid employees
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- Exercise 3: Find employees whose names start with 'S' or 'M'
SELECT * FROM employees 
WHERE first_name LIKE 'S%' OR first_name LIKE 'M%';

-- Exercise 4: Calculate years of service for each employee
SELECT 
    first_name,
    last_name,
    hire_date,
    ROUND((JULIANDAY('now') - JULIANDAY(hire_date)) / 365.25, 1) AS years_of_service
FROM employees;

-- Exercise 5: Find employees with salaries between 70k and 85k
SELECT * FROM employees 
WHERE salary BETWEEN 70000 AND 85000
ORDER BY salary;