-- =====================================================
-- Module 2.6: Subqueries and Common Table Expressions (CTEs)
-- =====================================================

-- =====================================================
-- Introduction to Subqueries
-- =====================================================

-- A subquery is a query nested inside another query
-- Types of subqueries:
-- 1. Scalar subqueries - return single value
-- 2. Row subqueries - return single row
-- 3. Table subqueries - return multiple rows/columns
-- 4. Correlated subqueries - reference outer query

-- =====================================================
-- Scalar Subqueries
-- =====================================================

-- Find employees earning more than the average salary
SELECT 
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find the highest paid employee in each department
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e1
WHERE salary = (
    SELECT MAX(salary) 
    FROM employees e2 
    WHERE e2.department_id = e1.department_id
);

-- Calculate salary as percentage of total payroll
SELECT 
    first_name,
    last_name,
    salary,
    ROUND(salary * 100.0 / (SELECT SUM(salary) FROM employees), 2) AS salary_percentage
FROM employees;

-- =====================================================
-- Subqueries with IN/NOT IN
-- =====================================================

-- Find employees working on projects
SELECT 
    first_name,
    last_name,
    department_id
FROM employees
WHERE employee_id IN (
    SELECT DISTINCT employee_id 
    FROM employee_projects
);

-- Find employees NOT working on any projects
SELECT 
    first_name,
    last_name,
    department_id
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id 
    FROM employee_projects
    WHERE employee_id IS NOT NULL  -- Important: handle NULLs with NOT IN
);

-- Find departments with active projects
SELECT 
    department_name,
    location,
    budget
FROM departments
WHERE department_id IN (
    SELECT DISTINCT department_id 
    FROM projects
    WHERE end_date >= DATE('now')
);

-- =====================================================
-- Subqueries with EXISTS/NOT EXISTS
-- =====================================================

-- EXISTS is often more efficient than IN for large datasets
-- Find employees who have project assignments
SELECT 
    first_name,
    last_name,
    salary
FROM employees e
WHERE EXISTS (
    SELECT 1 
    FROM employee_projects ep 
    WHERE ep.employee_id = e.employee_id
);

-- Find employees without project assignments
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 
    FROM employee_projects ep 
    WHERE ep.employee_id = e.employee_id
);

-- Find departments with employees earning > 80k
SELECT 
    department_name,
    location
FROM departments d
WHERE EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.department_id = d.department_id 
    AND e.salary > 80000
);

-- =====================================================
-- Correlated Subqueries
-- =====================================================

-- Find employees earning above their department average
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    (
        SELECT AVG(salary) 
        FROM employees e2 
        WHERE e2.department_id = e1.department_id
    ) AS dept_avg_salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees e2 
    WHERE e2.department_id = e1.department_id
);

-- Find the second highest salary in each department
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees e1
WHERE 2 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
    AND e2.salary >= e1.salary
);

-- Find employees with above-average project hours
SELECT 
    e.first_name,
    e.last_name,
    (
        SELECT SUM(hours_allocated) 
        FROM employee_projects ep 
        WHERE ep.employee_id = e.employee_id
    ) AS total_hours
FROM employees e
WHERE (
    SELECT COALESCE(SUM(hours_allocated), 0) 
    FROM employee_projects ep 
    WHERE ep.employee_id = e.employee_id
) > (
    SELECT AVG(hours_allocated) 
    FROM employee_projects
);

-- =====================================================
-- Subqueries in FROM Clause (Derived Tables)
-- =====================================================

-- Department statistics using subquery in FROM
SELECT 
    dept_stats.department_id,
    d.department_name,
    dept_stats.employee_count,
    dept_stats.avg_salary,
    dept_stats.total_payroll
FROM (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary,
        SUM(salary) AS total_payroll
    FROM employees
    GROUP BY department_id
) dept_stats
JOIN departments d ON dept_stats.department_id = d.department_id;

-- Find top 3 departments by average salary
SELECT 
    d.department_name,
    top_depts.avg_salary,
    top_depts.employee_count
FROM (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 3
) top_depts
JOIN departments d ON top_depts.department_id = d.department_id;

-- =====================================================
-- Common Table Expressions (CTEs)
-- =====================================================

-- Basic CTE syntax
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

-- Multiple CTEs
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

-- CTE with window functions
WITH ranked_employees AS (
    SELECT 
        first_name,
        last_name,
        salary,
        department_id,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
)
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    salary_rank
FROM ranked_employees
WHERE salary_rank <= 2;  -- Top 2 earners per department

-- =====================================================
-- Recursive CTEs
-- =====================================================

-- Recursive CTE to build organizational hierarchy
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: employees with no manager (top level)
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

-- Recursive CTE to calculate running totals
WITH RECURSIVE running_totals AS (
    -- Base case: first employee by ID
    SELECT 
        employee_id,
        first_name,
        last_name,
        salary,
        salary AS running_total,
        1 AS position
    FROM employees
    WHERE employee_id = (SELECT MIN(employee_id) FROM employees)
    
    UNION ALL
    
    -- Recursive case: add next employee
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.salary,
        rt.running_total + e.salary,
        rt.position + 1
    FROM employees e
    JOIN running_totals rt ON e.employee_id = (
        SELECT MIN(employee_id) 
        FROM employees 
        WHERE employee_id > rt.employee_id
    )
)
SELECT 
    employee_id,
    first_name,
    last_name,
    salary,
    running_total
FROM running_totals
ORDER BY position;

-- =====================================================
-- Advanced Subquery Patterns
-- =====================================================

-- Subquery with aggregation in SELECT
SELECT 
    d.department_name,
    d.budget,
    (
        SELECT COUNT(*) 
        FROM employees e 
        WHERE e.department_id = d.department_id
    ) AS employee_count,
    (
        SELECT AVG(salary) 
        FROM employees e 
        WHERE e.department_id = d.department_id
    ) AS avg_salary,
    (
        SELECT COUNT(*) 
        FROM projects p 
        WHERE p.department_id = d.department_id
    ) AS project_count
FROM departments d;

-- Subquery for ranking without window functions
SELECT 
    first_name,
    last_name,
    salary,
    (
        SELECT COUNT(*) 
        FROM employees e2 
        WHERE e2.salary > e1.salary
    ) + 1 AS salary_rank
FROM employees e1
ORDER BY salary DESC;

-- Complex nested subqueries
SELECT 
    first_name,
    last_name,
    salary
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE budget > (
        SELECT AVG(budget)
        FROM departments
        WHERE department_id IN (
            SELECT DISTINCT department_id
            FROM employees
            WHERE salary > 70000
        )
    )
);

-- =====================================================
-- Performance Considerations
-- =====================================================

-- Subquery vs JOIN performance comparison
-- Often JOINs are more efficient than subqueries

-- Subquery approach (may be slower)
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

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: Find employees earning more than their manager
WITH employee_manager AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.salary,
        e.manager_id,
        m.salary AS manager_salary
    FROM employees e
    LEFT JOIN employees m ON e.manager_id = m.employee_id
)
SELECT 
    first_name,
    last_name,
    salary,
    manager_salary,
    salary - manager_salary AS salary_difference
FROM employee_manager
WHERE salary > manager_salary;

-- Exercise 2: Find departments with above-average project budgets
SELECT 
    d.department_name,
    (
        SELECT AVG(budget) 
        FROM projects p 
        WHERE p.department_id = d.department_id
    ) AS avg_project_budget
FROM departments d
WHERE (
    SELECT AVG(budget) 
    FROM projects p 
    WHERE p.department_id = d.department_id
) > (
    SELECT AVG(budget) 
    FROM projects
);

-- Exercise 3: Create a report of employees and their project workload
WITH employee_workload AS (
    SELECT 
        employee_id,
        COUNT(*) AS project_count,
        SUM(hours_allocated) AS total_hours,
        AVG(hours_allocated) AS avg_hours_per_project
    FROM employee_projects
    GROUP BY employee_id
)
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    COALESCE(ew.project_count, 0) AS project_count,
    COALESCE(ew.total_hours, 0) AS total_hours,
    COALESCE(ew.avg_hours_per_project, 0) AS avg_hours_per_project
FROM employees e
LEFT JOIN employee_workload ew ON e.employee_id = ew.employee_id
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY total_hours DESC;

-- Exercise 4: Find the most recent hire in each department
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date = (
    SELECT MAX(hire_date)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- Exercise 5: Calculate department efficiency (total project hours / employee count)
WITH department_efficiency AS (
    SELECT 
        d.department_id,
        d.department_name,
        COUNT(DISTINCT e.employee_id) AS employee_count,
        COALESCE(SUM(ep.hours_allocated), 0) AS total_project_hours,
        CASE 
            WHEN COUNT(DISTINCT e.employee_id) > 0 
            THEN COALESCE(SUM(ep.hours_allocated), 0) * 1.0 / COUNT(DISTINCT e.employee_id)
            ELSE 0 
        END AS hours_per_employee
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
    GROUP BY d.department_id, d.department_name
)
SELECT 
    department_name,
    employee_count,
    total_project_hours,
    ROUND(hours_per_employee, 2) AS hours_per_employee,
    CASE 
        WHEN hours_per_employee > (SELECT AVG(hours_per_employee) FROM department_efficiency)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS efficiency_rating
FROM department_efficiency
ORDER BY hours_per_employee DESC;