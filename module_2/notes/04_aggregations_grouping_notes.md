# Module 2.4: Aggregations and Grouping - Study Notes

## Introduction to Aggregate Functions

Aggregate functions perform calculations on a set of values and return a single result. They are essential for data analysis, reporting, and business intelligence.

### Key Characteristics:
- Process multiple rows and return single value
- Ignore NULL values (except COUNT(*))
- Often used with GROUP BY clause
- Cannot be used in WHERE clause (use HAVING instead)

## Basic Aggregate Functions

### COUNT Function
Counts the number of rows or non-NULL values.

```sql
-- Count all rows (including NULLs)
SELECT COUNT(*) AS total_employees FROM employees;

-- Count non-NULL values in specific column
SELECT COUNT(manager_id) AS employees_with_managers FROM employees;

-- Count distinct values
SELECT COUNT(DISTINCT department_id) AS unique_departments FROM employees;
```

**Key Points:**
- `COUNT(*)` counts all rows including NULLs
- `COUNT(column)` counts only non-NULL values
- `COUNT(DISTINCT column)` counts unique non-NULL values

### SUM Function
Calculates the total of numeric values.

```sql
-- Total payroll
SELECT SUM(salary) AS total_payroll FROM employees;

-- Sum with condition (using CASE)
SELECT SUM(CASE WHEN department_id = 1 THEN salary ELSE 0 END) AS engineering_payroll
FROM employees;
```

**Important:** SUM ignores NULL values and returns NULL if all values are NULL.

### AVG Function
Calculates the average of numeric values.

```sql
-- Average salary
SELECT AVG(salary) AS average_salary FROM employees;

-- Average excluding NULLs
SELECT AVG(COALESCE(salary, 0)) AS average_including_zeros FROM employees;
```

**Note:** AVG automatically excludes NULL values from calculation.

### MIN and MAX Functions
Find minimum and maximum values.

```sql
SELECT 
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    MIN(hire_date) AS earliest_hire,
    MAX(hire_date) AS most_recent_hire
FROM employees;
```

**Versatile:** Work with numbers, dates, and strings (alphabetical order).

### Multiple Aggregates in One Query
```sql
SELECT 
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll,
    COUNT(DISTINCT department_id) AS departments_represented
FROM employees;
```

## GROUP BY Clause

GROUP BY divides result set into groups and applies aggregate functions to each group.

### Basic Grouping
```sql
-- Employee count and average salary by department
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;
```

### Multiple Column Grouping
```sql
-- Employees by department and hire year
SELECT 
    department_id,
    strftime('%Y', hire_date) AS hire_year,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id, strftime('%Y', hire_date)
ORDER BY department_id, hire_year;
```

### Grouping with Expressions
```sql
-- Group by calculated salary ranges
SELECT 
    CASE 
        WHEN salary < 60000 THEN 'Low (< 60K)'
        WHEN salary < 80000 THEN 'Medium (60K-80K)'
        ELSE 'High (80K+)'
    END AS salary_range,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary_in_range
FROM employees
GROUP BY 
    CASE 
        WHEN salary < 60000 THEN 'Low (< 60K)'
        WHEN salary < 80000 THEN 'Medium (60K-80K)'
        ELSE 'High (80K+)'
    END;
```

## HAVING Clause - Filtering Groups

HAVING filters groups after aggregation (WHERE filters rows before grouping).

### Basic HAVING
```sql
-- Departments with more than 2 employees
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;
```

### HAVING with Multiple Conditions
```sql
-- Departments with high average salary and multiple employees
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 2 AND AVG(salary) > 75000;
```

### WHERE vs HAVING
```sql
-- Filter rows first (WHERE), then filter groups (HAVING)
SELECT 
    department_id,
    COUNT(*) AS recent_hires,
    AVG(salary) AS avg_salary
FROM employees
WHERE hire_date >= '2020-01-01'  -- Filter individual rows
GROUP BY department_id
HAVING COUNT(*) >= 2;            -- Filter groups
```

**Key Difference:**
- **WHERE**: Filters rows before grouping
- **HAVING**: Filters groups after aggregation

## Advanced Grouping Examples

### Grouping with JOINs
```sql
-- Department statistics with department names
SELECT 
    d.department_name,
    d.location,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.location
ORDER BY avg_salary DESC;
```

### Time-Based Grouping
```sql
-- Monthly hiring trends
SELECT 
    strftime('%Y-%m', hire_date) AS hire_month,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_starting_salary
FROM employees
GROUP BY strftime('%Y-%m', hire_date)
ORDER BY hire_month;
```

### Percentage Calculations
```sql
-- Salary distribution with percentages
SELECT 
    CASE 
        WHEN salary < 65000 THEN '< 65K'
        WHEN salary < 75000 THEN '65K-75K'
        WHEN salary < 85000 THEN '75K-85K'
        ELSE '85K+'
    END AS salary_bracket,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 1) AS percentage
FROM employees
GROUP BY 
    CASE 
        WHEN salary < 65000 THEN '< 65K'
        WHEN salary < 75000 THEN '65K-75K'
        WHEN salary < 85000 THEN '75K-85K'
        ELSE '85K+'
    END
ORDER BY MIN(salary);
```

## Window Functions (Advanced Aggregations)

Window functions perform calculations across related rows without collapsing the result set.

### ROW_NUMBER()
Assigns unique sequential numbers to rows.

```sql
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS overall_rank,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank
FROM employees;
```

### RANK() and DENSE_RANK()
```sql
SELECT 
    first_name,
    last_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
FROM employees;
```

**Difference:**
- **RANK()**: Gaps in ranking (1, 2, 2, 4)
- **DENSE_RANK()**: No gaps in ranking (1, 2, 2, 3)

### Running Totals
```sql
SELECT 
    first_name,
    last_name,
    salary,
    SUM(salary) OVER (ORDER BY employee_id) AS running_total_payroll
FROM employees
ORDER BY employee_id;
```

### Moving Averages
```sql
SELECT 
    first_name,
    last_name,
    salary,
    AVG(salary) OVER (
        ORDER BY employee_id 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_salary
FROM employees
ORDER BY employee_id;
```

### LAG and LEAD Functions
```sql
SELECT 
    first_name,
    last_name,
    salary,
    LAG(salary, 1) OVER (ORDER BY salary) AS previous_salary,
    LEAD(salary, 1) OVER (ORDER BY salary) AS next_salary,
    salary - LAG(salary, 1) OVER (ORDER BY salary) AS salary_difference
FROM employees
ORDER BY salary;
```

## Conditional Aggregations

### Using CASE with Aggregates
```sql
SELECT 
    department_id,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 75000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date >= '2021-01-01' THEN 1 END) AS recent_hires,
    AVG(CASE WHEN salary > 75000 THEN salary END) AS avg_high_earner_salary
FROM employees
GROUP BY department_id;
```

### Pivot-Style Aggregations
```sql
SELECT 
    strftime('%Y', hire_date) AS hire_year,
    SUM(CASE WHEN department_id = 1 THEN salary ELSE 0 END) AS engineering_payroll,
    SUM(CASE WHEN department_id = 2 THEN salary ELSE 0 END) AS marketing_payroll,
    SUM(CASE WHEN department_id = 3 THEN salary ELSE 0 END) AS sales_payroll,
    COUNT(CASE WHEN department_id = 1 THEN 1 END) AS engineering_count,
    COUNT(CASE WHEN department_id = 2 THEN 1 END) AS marketing_count,
    COUNT(CASE WHEN department_id = 3 THEN 1 END) AS sales_count
FROM employees
GROUP BY strftime('%Y', hire_date);
```

## Statistical Functions

### Basic Statistics
```sql
-- Comprehensive statistics by department
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS mean_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_range
FROM employees
GROUP BY department_id;
```

### Percentile Approximations
```sql
-- Median salary approximation using window functions
SELECT 
    department_id,
    AVG(salary) AS mean_salary,
    (
        SELECT salary 
        FROM employees e2 
        WHERE e2.department_id = e1.department_id 
        ORDER BY salary 
        LIMIT 1 OFFSET (COUNT(*) / 2)
    ) AS median_salary_approx
FROM employees e1
GROUP BY department_id;
```

## Complex Aggregation Scenarios

### Multi-Level Aggregations
```sql
-- Project statistics with team information
SELECT 
    p.project_name,
    COUNT(ep.employee_id) AS team_size,
    SUM(ep.hours_allocated) AS total_hours,
    AVG(ep.hours_allocated) AS avg_hours_per_person,
    AVG(e.salary) AS avg_team_salary,
    SUM(e.salary * ep.hours_allocated / 40) AS estimated_weekly_cost
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id, p.project_name
ORDER BY estimated_weekly_cost DESC;
```

### Nested Aggregations with Subqueries
```sql
-- Departments with above-average employee count
SELECT 
    department_id,
    employee_count,
    avg_salary
FROM (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_stats
WHERE employee_count > (
    SELECT AVG(employee_count)
    FROM (
        SELECT COUNT(*) AS employee_count
        FROM employees
        GROUP BY department_id
    )
);
```

## Performance Considerations

### Indexing for Aggregations
```sql
-- Create indexes on GROUP BY columns
CREATE INDEX idx_employee_dept ON employees(department_id);
CREATE INDEX idx_employee_hire_date ON employees(hire_date);

-- Composite index for multiple GROUP BY columns
CREATE INDEX idx_employee_dept_date ON employees(department_id, hire_date);
```

### Optimizing Large Aggregations
```sql
-- Use covering indexes when possible
CREATE INDEX idx_employee_covering ON employees(department_id, salary, hire_date);

-- This query can use the covering index efficiently
SELECT 
    department_id,
    AVG(salary),
    COUNT(*)
FROM employees
WHERE hire_date >= '2020-01-01'
GROUP BY department_id;
```

### Query Execution Analysis
```sql
-- Analyze query performance
EXPLAIN QUERY PLAN
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;
```

## Common Mistakes and Solutions

### 1. Using Aggregates in WHERE Clause
**Wrong:**
```sql
SELECT department_id, COUNT(*)
FROM employees
WHERE COUNT(*) > 2  -- ERROR: Can't use aggregate in WHERE
GROUP BY department_id;
```

**Correct:**
```sql
SELECT department_id, COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;  -- Use HAVING for aggregate conditions
```

### 2. Mixing Aggregated and Non-Aggregated Columns
**Wrong:**
```sql
SELECT first_name, department_id, AVG(salary)  -- ERROR: first_name not in GROUP BY
FROM employees
GROUP BY department_id;
```

**Correct:**
```sql
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;
```

### 3. NULL Handling in Aggregations
**Problem:** Unexpected results due to NULL values
**Solution:** Use COALESCE or handle NULLs explicitly
```sql
-- Handle NULLs in calculations
SELECT 
    department_id,
    COUNT(*) AS total_employees,
    COUNT(manager_id) AS employees_with_managers,
    AVG(COALESCE(bonus, 0)) AS avg_bonus_including_zeros
FROM employees
GROUP BY department_id;
```

## Best Practices

### 1. Query Structure
- Always include non-aggregate columns in GROUP BY
- Use meaningful aliases for calculated columns
- Order results logically (usually by aggregate values)
- Use HAVING for filtering groups, WHERE for filtering rows

### 2. Performance
- Create appropriate indexes on GROUP BY columns
- Consider query execution order
- Use LIMIT when you don't need all groups
- Monitor query performance with EXPLAIN

### 3. Readability
- Format complex queries clearly
- Use comments for business logic
- Choose descriptive column aliases
- Break complex calculations into steps

### 4. Data Quality
- Handle NULL values appropriately
- Validate aggregate results make business sense
- Consider edge cases (empty groups, all NULL values)
- Document assumptions about data

## Real-World Applications

### 1. Sales Reporting
```sql
-- Monthly sales summary
SELECT 
    strftime('%Y-%m', order_date) AS month,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;
```

### 2. Employee Analytics
```sql
-- Department performance metrics
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS headcount,
    AVG(e.salary) AS avg_salary,
    SUM(e.salary) AS total_payroll,
    d.budget,
    ROUND((SUM(e.salary) / d.budget) * 100, 2) AS budget_utilization_pct
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.budget
ORDER BY budget_utilization_pct DESC;
```

### 3. Customer Segmentation
```sql
-- Customer value analysis
SELECT 
    CASE 
        WHEN total_spent >= 1000 THEN 'VIP'
        WHEN total_spent >= 500 THEN 'Premium'
        WHEN total_spent >= 100 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    AVG(total_spent) AS avg_spent,
    SUM(total_spent) AS segment_revenue
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
) customer_totals
GROUP BY 
    CASE 
        WHEN total_spent >= 1000 THEN 'VIP'
        WHEN total_spent >= 500 THEN 'Premium'
        WHEN total_spent >= 100 THEN 'Regular'
        ELSE 'New'
    END
ORDER BY avg_spent DESC;
```

## Key Takeaways

- **Aggregate functions summarize data** across multiple rows
- **GROUP BY creates groups** for aggregate calculations
- **HAVING filters groups** after aggregation (not individual rows)
- **Window functions provide advanced analytics** without collapsing rows
- **Conditional aggregations** enable complex business logic
- **Performance matters** - use appropriate indexes
- **Handle NULL values** carefully in aggregations
- **Practice with real data** to understand business applications
- **Combine with JOINs** for comprehensive analysis
- **Always validate results** for business logic correctness