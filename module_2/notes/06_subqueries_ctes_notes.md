# Module 2.6: Subqueries and Common Table Expressions (CTEs) - Study Notes

## Introduction to Subqueries

A subquery is a query nested inside another query. Subqueries allow you to break complex problems into smaller, manageable pieces and enable sophisticated data analysis that would be difficult or impossible with simple queries alone.

### Key Characteristics
- **Nested Structure**: Query within a query
- **Execution Order**: Inner query executes first (usually)
- **Flexibility**: Can be used in SELECT, FROM, WHERE, and HAVING clauses
- **Readability**: Can make complex logic more understandable
- **Performance**: May be slower than JOINs in some cases

### When to Use Subqueries
- When you need to filter based on aggregate values
- For step-by-step logical processing
- When JOINs become too complex
- For data validation and comparison
- To create derived tables

## Types of Subqueries

### 1. Scalar Subqueries
Return a single value (one row, one column).

```sql
-- Find employees earning more than average salary
SELECT 
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**Characteristics:**
- Must return exactly one value
- Can be used anywhere a single value is expected
- Often used in WHERE clauses for comparisons

**Common Use Cases:**
- Comparing against aggregate values
- Setting dynamic thresholds
- Calculating percentages of totals

### 2. Row Subqueries
Return a single row with multiple columns.

```sql
-- Find employee with specific combination of department and salary
SELECT first_name, last_name
FROM employees
WHERE (department_id, salary) = (
    SELECT department_id, MAX(salary)
    FROM employees
    WHERE department_id = 1
    GROUP BY department_id
);
```

**Note:** Not all databases support row subqueries equally well.

### 3. Table Subqueries
Return multiple rows and columns (result set).

```sql
-- Find employees in departments with high budgets
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE budget > 1000000
);
```

**Characteristics:**
- Return multiple rows and/or columns
- Used with IN, EXISTS, ANY, ALL operators
- Can be used in FROM clause as derived tables

### 4. Correlated Subqueries
Reference columns from the outer query.

```sql
-- Find employees earning above their department average
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);
```

**Characteristics:**
- Inner query depends on outer query
- Executes once for each row in outer query
- Can be slower than non-correlated subqueries
- More flexible for row-by-row comparisons

## Subquery Operators

### IN Operator
Tests if a value exists in a set of values.

```sql
-- Find employees working on projects
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT employee_id
    FROM employee_projects
);
```

**Important:** Be careful with NULL values in NOT IN subqueries.

### NOT IN Operator
Tests if a value does not exist in a set of values.

```sql
-- Find employees NOT working on any projects
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id
    FROM employee_projects
    WHERE employee_id IS NOT NULL  -- Handle NULLs explicitly
);
```

### EXISTS Operator
Tests if a subquery returns any rows.

```sql
-- Find employees who have project assignments (using EXISTS)
SELECT first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.employee_id = e.employee_id
);
```

**Advantages of EXISTS:**
- Often more efficient than IN
- Handles NULL values better
- Stops execution when first match is found
- More readable for correlated subqueries

### NOT EXISTS Operator
Tests if a subquery returns no rows.

```sql
-- Find employees without project assignments
SELECT first_name, last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.employee_id = e.employee_id
);
```

### ANY/SOME Operator
Tests if condition is true for any value in subquery result.

```sql
-- Find employees earning more than any employee in department 5
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department_id = 5
);
```

### ALL Operator
Tests if condition is true for all values in subquery result.

```sql
-- Find employees earning more than all employees in department 5
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department_id = 5
);
```

## Subqueries in Different Clauses

### Subqueries in SELECT Clause
```sql
-- Add calculated columns using subqueries
SELECT 
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg,
    salary - (SELECT AVG(salary) FROM employees) AS salary_diff,
    (
        SELECT COUNT(*)
        FROM employee_projects ep
        WHERE ep.employee_id = e.employee_id
    ) AS project_count
FROM employees e;
```

### Subqueries in FROM Clause (Derived Tables)
```sql
-- Use subquery results as a table
SELECT 
    dept_stats.department_id,
    d.department_name,
    dept_stats.employee_count,
    dept_stats.avg_salary
FROM (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_stats
JOIN departments d ON dept_stats.department_id = d.department_id
WHERE dept_stats.avg_salary > 75000;
```

### Subqueries in WHERE Clause
```sql
-- Filter based on subquery results
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > (
    SELECT AVG(hire_date)
    FROM employees
    WHERE department_id = 1
);
```

### Subqueries in HAVING Clause
```sql
-- Filter groups based on subquery results
SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);
```

## Common Table Expressions (CTEs)

CTEs provide a way to define temporary named result sets that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement.

### Basic CTE Syntax
```sql
WITH cte_name AS (
    -- CTE query definition
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
-- Main query using the CTE
SELECT *
FROM cte_name
WHERE another_condition;
```

### Simple CTE Example
```sql
-- Department statistics using CTE
WITH department_stats AS (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary,
        SUM(salary) AS total_payroll
    FROM employees
    GROUP BY department_id
)
SELECT 
    d.department_name,
    ds.employee_count,
    ROUND(ds.avg_salary, 2) AS avg_salary,
    ds.total_payroll
FROM department_stats ds
JOIN departments d ON ds.department_id = d.department_id
ORDER BY ds.avg_salary DESC;
```

### Multiple CTEs
```sql
-- Multiple CTEs in one query
WITH 
high_earners AS (
    SELECT employee_id, first_name, last_name, salary
    FROM employees
    WHERE salary > 75000
),
project_assignments AS (
    SELECT 
        employee_id,
        COUNT(*) AS project_count,
        SUM(hours_allocated) AS total_hours
    FROM employee_projects
    GROUP BY employee_id
)
SELECT 
    he.first_name,
    he.last_name,
    he.salary,
    COALESCE(pa.project_count, 0) AS project_count,
    COALESCE(pa.total_hours, 0) AS total_hours
FROM high_earners he
LEFT JOIN project_assignments pa ON he.employee_id = pa.employee_id;
```

### CTEs vs Subqueries

| Aspect | CTEs | Subqueries |
|--------|------|------------|
| **Readability** | More readable for complex queries | Can become nested and hard to read |
| **Reusability** | Can be referenced multiple times | Must be repeated if used multiple times |
| **Performance** | Similar performance | Similar performance |
| **Debugging** | Easier to debug step by step | Harder to debug nested structures |
| **Scope** | Available throughout the query | Limited to their specific context |

## Recursive CTEs

Recursive CTEs allow you to work with hierarchical or tree-structured data.

### Basic Recursive CTE Structure
```sql
WITH RECURSIVE cte_name AS (
    -- Base case (anchor member)
    SELECT initial_columns
    FROM table_name
    WHERE base_condition
    
    UNION ALL
    
    -- Recursive case (recursive member)
    SELECT recursive_columns
    FROM table_name
    JOIN cte_name ON join_condition
)
SELECT * FROM cte_name;
```

### Employee Hierarchy Example
```sql
-- Build organizational hierarchy
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: top-level managers (no manager)
    SELECT 
        employee_id,
        first_name,
        last_name,
        manager_id,
        0 AS level,
        first_name || ' ' || last_name AS hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: employees with managers
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        eh.level + 1,
        eh.hierarchy_path || ' -> ' || e.first_name || ' ' || e.last_name
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT 
    employee_id,
    first_name,
    last_name,
    level,
    hierarchy_path
FROM employee_hierarchy
ORDER BY level, last_name;
```

### Recursive CTE Use Cases
- **Organizational charts** and reporting structures
- **Bill of materials** in manufacturing
- **Category hierarchies** in e-commerce
- **File system structures**
- **Social network connections**
- **Route planning** and graph traversal

## Advanced Subquery Patterns

### Correlated Subqueries for Ranking
```sql
-- Find top 2 earners in each department (without window functions)
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e1
WHERE (
    SELECT COUNT(*)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
    AND e2.salary > e1.salary
) < 2
ORDER BY department_id, salary DESC;
```

### Subqueries for Data Validation
```sql
-- Find inconsistencies in data
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id
FROM employees e
WHERE department_id NOT IN (
    SELECT department_id
    FROM departments
    WHERE department_id IS NOT NULL
);
```

### Complex Filtering with Subqueries
```sql
-- Find employees in departments with above-average budgets
-- and who earn above their department average
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE budget > (SELECT AVG(budget) FROM departments)
)
AND salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
```

## Performance Considerations

### Subqueries vs JOINs
```sql
-- Subquery approach
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (
    SELECT employee_id
    FROM employee_projects
);

-- JOIN approach (often faster)
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id;
```

### Optimization Tips
1. **Use EXISTS instead of IN** when possible
2. **Consider JOINs** for better performance
3. **Avoid correlated subqueries** in large datasets when possible
4. **Use indexes** on columns used in subquery conditions
5. **Test different approaches** and measure performance

### Query Execution Plans
```sql
-- Analyze subquery performance
EXPLAIN QUERY PLAN
SELECT first_name, last_name
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = 1
);
```

## Common Mistakes and Solutions

### 1. Subquery Returns Multiple Values
**Problem:**
```sql
-- Error: subquery returns more than one row
SELECT first_name, last_name
FROM employees
WHERE salary = (
    SELECT salary
    FROM employees
    WHERE department_id = 1  -- Multiple employees in department 1
);
```

**Solution:**
```sql
-- Use IN for multiple values
SELECT first_name, last_name
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    WHERE department_id = 1
);
```

### 2. NULL Handling in NOT IN
**Problem:**
```sql
-- May not work as expected if subquery contains NULLs
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id
    FROM employees  -- manager_id can be NULL
);
```

**Solution:**
```sql
-- Handle NULLs explicitly
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);

-- Or use NOT EXISTS
SELECT first_name, last_name
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.manager_id = e1.employee_id
);
```

### 3. Correlated Subquery Performance
**Problem:** Slow performance with correlated subqueries
**Solution:** Consider using window functions or JOINs

```sql
-- Slow correlated subquery
SELECT 
    first_name,
    last_name,
    salary,
    (
        SELECT AVG(salary)
        FROM employees e2
        WHERE e2.department_id = e1.department_id
    ) AS dept_avg
FROM employees e1;

-- Faster with window function
SELECT 
    first_name,
    last_name,
    salary,
    AVG(salary) OVER (PARTITION BY department_id) AS dept_avg
FROM employees;
```

## Real-World Applications

### 1. Customer Analysis
```sql
-- Find customers who have spent more than average
WITH customer_totals AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(*) AS order_count
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
spending_stats AS (
    SELECT AVG(total_spent) AS avg_customer_spending
    FROM customer_totals
)
SELECT 
    c.first_name,
    c.last_name,
    ct.total_spent,
    ct.order_count,
    ss.avg_customer_spending
FROM customers c
JOIN customer_totals ct ON c.customer_id = ct.customer_id
CROSS JOIN spending_stats ss
WHERE ct.total_spent > ss.avg_customer_spending
ORDER BY ct.total_spent DESC;
```

### 2. Inventory Management
```sql
-- Products that need restocking (below average stock levels)
SELECT 
    product_name,
    stock_quantity,
    (SELECT AVG(stock_quantity) FROM products) AS avg_stock
FROM products
WHERE stock_quantity < (
    SELECT AVG(stock_quantity)
    FROM products
    WHERE stock_quantity > 0
)
ORDER BY stock_quantity;
```

### 3. Sales Performance
```sql
-- Sales representatives performing above team average
WITH rep_performance AS (
    SELECT 
        sr.rep_id,
        sr.rep_name,
        SUM(o.total_amount) AS total_sales,
        COUNT(o.order_id) AS order_count
    FROM sales_reps sr
    LEFT JOIN orders o ON sr.rep_id = o.rep_id
        AND o.order_date >= '2023-01-01'
        AND o.status = 'completed'
    GROUP BY sr.rep_id, sr.rep_name
)
SELECT 
    rep_name,
    total_sales,
    order_count,
    (SELECT AVG(total_sales) FROM rep_performance) AS team_avg
FROM rep_performance
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM rep_performance
)
ORDER BY total_sales DESC;
```

## Best Practices

### 1. Query Design
- **Use CTEs for complex queries** to improve readability
- **Break complex logic into steps** using multiple CTEs
- **Choose appropriate subquery type** for your needs
- **Consider performance implications** of correlated subqueries

### 2. Performance
- **Use EXISTS instead of IN** when checking for existence
- **Handle NULL values explicitly** in NOT IN subqueries
- **Consider JOINs as alternatives** to subqueries
- **Test performance** with realistic data volumes

### 3. Maintainability
- **Use meaningful names** for CTEs
- **Comment complex subquery logic**
- **Format queries** for readability
- **Test edge cases** thoroughly

### 4. Debugging
- **Test subqueries independently** before combining
- **Use CTEs to break down complex queries**
- **Verify intermediate results**
- **Check for NULL handling issues**

## Key Takeaways

- **Subqueries enable complex data analysis** by nesting queries
- **Different subquery types** serve different purposes
- **CTEs improve readability** and maintainability of complex queries
- **Recursive CTEs handle hierarchical data** effectively
- **Performance considerations** are important for large datasets
- **EXISTS is often better than IN** for existence checks
- **Handle NULL values carefully** in subqueries
- **Consider JOINs as alternatives** for better performance
- **Practice with real scenarios** to master these concepts
- **Use appropriate tools** (subqueries vs CTEs vs JOINs) for each situation