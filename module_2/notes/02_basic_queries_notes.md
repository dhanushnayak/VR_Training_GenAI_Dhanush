# Module 2.2: Basic SQL Queries - Study Notes

## The SELECT Statement

The `SELECT` statement is the foundation of SQL querying. It retrieves data from one or more tables and is the most frequently used SQL command.

### Basic Syntax
```sql
SELECT column1, column2, ...
FROM table_name;
```

### Key Components
1. **SELECT clause**: Specifies which columns to retrieve
2. **FROM clause**: Specifies which table(s) to query
3. **Optional clauses**: WHERE, ORDER BY, LIMIT, etc.

## Column Selection Techniques

### 1. Select All Columns
```sql
SELECT * FROM employees;
```
**When to use**: Quick data exploration, small tables
**Avoid in production**: Performance issues, unnecessary data transfer

### 2. Select Specific Columns
```sql
SELECT first_name, last_name, salary FROM employees;
```
**Benefits**: Better performance, clearer intent, reduced data transfer

### 3. Column Aliases
```sql
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name",
    salary AS "Annual Salary"
FROM employees;
```
**Purpose**: Make output more readable, rename calculated columns

### 4. Calculated Columns
```sql
SELECT 
    first_name,
    last_name,
    salary,
    salary * 12 AS annual_salary,
    salary / 12 AS monthly_salary
FROM employees;
```

## WHERE Clause - Filtering Data

The WHERE clause filters rows based on specified conditions.

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| = | Equal to | `salary = 75000` |
| != or <> | Not equal to | `department_id != 1` |
| > | Greater than | `salary > 70000` |
| >= | Greater than or equal | `salary >= 70000` |
| < | Less than | `salary < 80000` |
| <= | Less than or equal | `salary <= 80000` |

### String Comparisons

#### Exact Match
```sql
SELECT * FROM employees WHERE first_name = 'John';
```

#### Pattern Matching with LIKE
- `%` - Matches any sequence of characters
- `_` - Matches any single character

```sql
-- Names starting with 'J'
SELECT * FROM employees WHERE first_name LIKE 'J%';

-- Names ending with 'son'
SELECT * FROM employees WHERE last_name LIKE '%son';

-- Four-letter names starting with 'J'
SELECT * FROM employees WHERE first_name LIKE 'J___';
```

#### Case-Insensitive Searches
```sql
-- SQLite approach
SELECT * FROM employees WHERE UPPER(first_name) = 'JOHN';

-- Alternative approach
SELECT * FROM employees WHERE LOWER(first_name) = 'john';
```

### Date Comparisons
```sql
-- Employees hired after specific date
SELECT * FROM employees WHERE hire_date > '2020-01-01';

-- Date range
SELECT * FROM employees WHERE hire_date BETWEEN '2020-01-01' AND '2021-12-31';
```

### NULL Value Handling
```sql
-- Find records with NULL values
SELECT * FROM employees WHERE manager_id IS NULL;

-- Find records without NULL values
SELECT * FROM employees WHERE manager_id IS NOT NULL;
```

**Important**: Use `IS NULL` and `IS NOT NULL`, not `= NULL`

## Logical Operators

### AND Operator
```sql
SELECT * FROM employees 
WHERE department_id = 1 AND salary > 80000;
```
**Result**: Both conditions must be true

### OR Operator
```sql
SELECT * FROM employees 
WHERE department_id = 1 OR department_id = 2;
```
**Result**: At least one condition must be true

### NOT Operator
```sql
SELECT * FROM employees 
WHERE NOT department_id = 1;
```
**Result**: Negates the condition

### Complex Conditions with Parentheses
```sql
SELECT * FROM employees 
WHERE (department_id = 1 OR department_id = 2) 
  AND salary > 70000;
```
**Purpose**: Control order of operations, make logic clear

### IN Operator
```sql
-- Instead of multiple OR conditions
SELECT * FROM employees 
WHERE department_id IN (1, 2, 3);

-- Equivalent to:
SELECT * FROM employees 
WHERE department_id = 1 OR department_id = 2 OR department_id = 3;
```

### NOT IN Operator
```sql
SELECT * FROM employees 
WHERE department_id NOT IN (4, 5);
```

**Warning**: Be careful with NULL values in NOT IN lists

## ORDER BY Clause - Sorting Results

### Basic Sorting
```sql
-- Ascending order (default)
SELECT * FROM employees ORDER BY salary;

-- Descending order
SELECT * FROM employees ORDER BY salary DESC;
```

### Multiple Column Sorting
```sql
SELECT * FROM employees 
ORDER BY department_id ASC, salary DESC;
```
**Logic**: First sort by department_id ascending, then by salary descending within each department

### Sorting by Aliases
```sql
SELECT 
    first_name,
    last_name,
    salary * 12 AS annual_salary
FROM employees 
ORDER BY annual_salary DESC;
```

### Sorting by Column Position
```sql
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY 3 DESC;  -- Sort by 3rd column (salary)
```
**Note**: Not recommended for maintainability

## LIMIT and OFFSET - Pagination

### Basic LIMIT
```sql
-- Get first 5 records
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5;
```

### LIMIT with OFFSET
```sql
-- Get records 6-10 (skip first 5, take next 5)
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5 OFFSET 5;
```

### Pagination Pattern
```sql
-- Page 1 (records 1-10)
SELECT * FROM employees ORDER BY employee_id LIMIT 10 OFFSET 0;

-- Page 2 (records 11-20)
SELECT * FROM employees ORDER BY employee_id LIMIT 10 OFFSET 10;

-- Page 3 (records 21-30)
SELECT * FROM employees ORDER BY employee_id LIMIT 10 OFFSET 20;
```

## DISTINCT - Removing Duplicates

### Basic DISTINCT
```sql
-- Get unique department IDs
SELECT DISTINCT department_id FROM employees;
```

### DISTINCT with Multiple Columns
```sql
-- Get unique combinations
SELECT DISTINCT department_id, manager_id FROM employees;
```

### COUNT with DISTINCT
```sql
-- Count unique values
SELECT COUNT(DISTINCT department_id) AS unique_departments 
FROM employees;
```

## String Functions

### Concatenation
```sql
-- SQLite/PostgreSQL
SELECT first_name || ' ' || last_name AS full_name FROM employees;

-- MySQL/SQL Server
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;
```

### String Length
```sql
SELECT 
    first_name,
    LENGTH(first_name) AS name_length
FROM employees;
```

### Case Conversion
```sql
SELECT 
    UPPER(first_name) AS upper_name,
    LOWER(last_name) AS lower_name
FROM employees;
```

### Substring Extraction
```sql
-- Extract first 3 characters
SELECT SUBSTR(first_name, 1, 3) AS name_prefix FROM employees;

-- Extract username from email
SELECT SUBSTR(email, 1, INSTR(email, '@') - 1) AS username FROM employees;
```

## Mathematical Functions

### Basic Math Operations
```sql
SELECT 
    salary,
    salary * 1.05 AS salary_with_raise,
    salary / 12 AS monthly_salary,
    salary + 5000 AS salary_plus_bonus
FROM employees;
```

### Rounding Functions
```sql
SELECT 
    salary,
    ROUND(salary / 12, 2) AS monthly_salary,
    ROUND(salary * 1.05) AS rounded_raise
FROM employees;
```

### Other Math Functions
```sql
SELECT 
    ABS(-100) AS absolute_value,
    POWER(2, 3) AS power_result,
    SQRT(16) AS square_root;
```

## Date Functions

### Current Date/Time
```sql
-- SQLite
SELECT 
    DATE('now') AS current_date,
    DATETIME('now') AS current_datetime;

-- MySQL
SELECT 
    CURDATE() AS current_date,
    NOW() AS current_datetime;
```

### Date Arithmetic
```sql
-- Days between dates
SELECT 
    first_name,
    hire_date,
    JULIANDAY('now') - JULIANDAY(hire_date) AS days_employed
FROM employees;
```

### Date Part Extraction
```sql
-- SQLite
SELECT 
    hire_date,
    strftime('%Y', hire_date) AS hire_year,
    strftime('%m', hire_date) AS hire_month,
    strftime('%d', hire_date) AS hire_day
FROM employees;
```

## CASE Statements - Conditional Logic

### Simple CASE
```sql
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
```

### CASE with Specific Values
```sql
SELECT 
    first_name,
    last_name,
    CASE department_id
        WHEN 1 THEN 'Engineering'
        WHEN 2 THEN 'Marketing'
        WHEN 3 THEN 'Sales'
        ELSE 'Other'
    END AS department_name
FROM employees;
```

## Query Execution Order

Understanding the logical order of SQL operations:

1. **FROM** - Identify source tables
2. **WHERE** - Filter rows
3. **SELECT** - Choose columns
4. **ORDER BY** - Sort results
5. **LIMIT/OFFSET** - Limit results

## Performance Tips

### 1. Use Indexes
- Create indexes on frequently queried columns
- Especially important for WHERE and ORDER BY clauses

### 2. Limit Result Sets
- Use LIMIT when you don't need all results
- Specify only needed columns in SELECT

### 3. Optimize WHERE Clauses
- Put most selective conditions first
- Use appropriate data types
- Avoid functions in WHERE clauses when possible

### 4. Use EXPLAIN
```sql
EXPLAIN QUERY PLAN
SELECT * FROM employees WHERE salary > 75000;
```

## Common Mistakes and Solutions

### 1. Case Sensitivity Issues
**Problem**: Query returns no results due to case mismatch
**Solution**: Use UPPER() or LOWER() functions for case-insensitive comparisons

### 2. NULL Comparison Errors
**Problem**: Using `= NULL` instead of `IS NULL`
**Solution**: Always use `IS NULL` and `IS NOT NULL`

### 3. String Pattern Mistakes
**Problem**: Forgetting wildcards in LIKE patterns
**Solution**: Remember `%` for multiple characters, `_` for single character

### 4. Date Format Issues
**Problem**: Inconsistent date formats
**Solution**: Use standard ISO format (YYYY-MM-DD)

## Best Practices

### 1. Query Writing
- Use meaningful aliases
- Format queries for readability
- Comment complex logic
- Be consistent with naming conventions

### 2. Performance
- Select only needed columns
- Use appropriate WHERE clauses
- Consider index usage
- Test with realistic data volumes

### 3. Maintainability
- Avoid SELECT *
- Use explicit column names
- Document business logic
- Use consistent formatting

## Practice Exercises

### Exercise 1: Employee Analysis
Find all employees hired in 2021 with salaries above $70,000, ordered by salary descending.

### Exercise 2: Name Patterns
Find all employees whose first name starts with 'S' or 'M' and last name contains 'son'.

### Exercise 3: Salary Categories
Create a query that categorizes employees into salary bands and shows the count in each band.

### Exercise 4: Date Calculations
Calculate years of service for each employee and identify those with more than 2 years of service.

## Key Takeaways

- **SELECT is fundamental** - Master it thoroughly
- **WHERE filters rows** - Use appropriate operators and conditions
- **ORDER BY sorts results** - Essential for meaningful output
- **String functions** are powerful for text manipulation
- **CASE statements** add conditional logic to queries
- **Practice regularly** with real data to build proficiency
- **Performance matters** - Write efficient queries from the start
- **Readability counts** - Format queries for maintainability