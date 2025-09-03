-- =====================================================
-- Module 2.5: Joins - Combining Data from Multiple Tables
-- =====================================================

-- =====================================================
-- Understanding Joins
-- =====================================================

-- Joins allow us to combine data from multiple tables based on relationships
-- Types of joins:
-- 1. INNER JOIN - Returns only matching records from both tables
-- 2. LEFT JOIN (LEFT OUTER JOIN) - Returns all records from left table, matching from right
-- 3. RIGHT JOIN (RIGHT OUTER JOIN) - Returns all records from right table, matching from left
-- 4. FULL OUTER JOIN - Returns all records from both tables
-- 5. CROSS JOIN - Returns Cartesian product of both tables
-- 6. SELF JOIN - Joins a table with itself

-- =====================================================
-- INNER JOIN
-- =====================================================

-- Basic INNER JOIN - employees with their department names
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- Alternative syntax (implicit join) - not recommended
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

-- Multiple INNER JOINs
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    p.project_name,
    ep.role,
    ep.hours_allocated
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN employee_projects ep ON e.employee_id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.project_id;

-- INNER JOIN with conditions
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 75000
ORDER BY e.salary DESC;

-- =====================================================
-- LEFT JOIN (LEFT OUTER JOIN)
-- =====================================================

-- LEFT JOIN - all employees, with department info if available
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- LEFT JOIN to find employees without projects
SELECT 
    e.first_name,
    e.last_name,
    e.department_id,
    ep.project_id
FROM employees e
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL;

-- LEFT JOIN with aggregation
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- =====================================================
-- RIGHT JOIN (Not supported in SQLite, but shown for completeness)
-- =====================================================

-- RIGHT JOIN - all departments, with employee info if available
-- Note: SQLite doesn't support RIGHT JOIN, but here's the concept:
-- SELECT 
--     e.first_name,
--     e.last_name,
--     d.department_name
-- FROM employees e
-- RIGHT JOIN departments d ON e.department_id = d.department_id;

-- Equivalent using LEFT JOIN (swap table order)
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id;

-- =====================================================
-- FULL OUTER JOIN (Not supported in SQLite)
-- =====================================================

-- FULL OUTER JOIN would return all records from both tables
-- SQLite doesn't support FULL OUTER JOIN, but you can simulate it with UNION:

SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id

UNION

SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- =====================================================
-- CROSS JOIN
-- =====================================================

-- CROSS JOIN - Cartesian product (every employee with every department)
-- Use with caution - can produce very large result sets!
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
CROSS JOIN departments d
LIMIT 20;  -- Limiting results for demonstration

-- Practical use of CROSS JOIN - creating a matrix
SELECT 
    d.department_name,
    p.project_name,
    'Not Assigned' AS status
FROM departments d
CROSS JOIN projects p
WHERE NOT EXISTS (
    SELECT 1 FROM projects p2 
    WHERE p2.project_id = p.project_id 
    AND p2.department_id = d.department_id
);

-- =====================================================
-- SELF JOIN
-- =====================================================

-- Self join to find employees and their managers
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.salary AS employee_salary,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.salary AS manager_salary
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Find employees who earn more than their managers
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.salary AS employee_salary,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.salary AS manager_salary,
    e.salary - m.salary AS salary_difference
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- Find all employees in the same department
SELECT 
    e1.first_name || ' ' || e1.last_name AS employee1,
    e2.first_name || ' ' || e2.last_name AS employee2,
    e1.department_id
FROM employees e1
INNER JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id < e2.employee_id  -- Avoid duplicates and self-matches
ORDER BY e1.department_id;

-- =====================================================
-- Complex Join Scenarios
-- =====================================================

-- Multiple joins with aggregations
SELECT 
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    COUNT(DISTINCT p.project_id) AS project_count,
    SUM(ep.hours_allocated) AS total_allocated_hours,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN projects p ON d.department_id = p.department_id
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
GROUP BY d.department_id, d.department_name;

-- Join with subquery
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    dept_avg.avg_dept_salary,
    ROUND(e.salary - dept_avg.avg_dept_salary, 2) AS salary_vs_dept_avg
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN (
    SELECT 
        department_id,
        AVG(salary) AS avg_dept_salary
    FROM employees
    GROUP BY department_id
) dept_avg ON e.department_id = dept_avg.department_id;

-- =====================================================
-- Join Performance Considerations
-- =====================================================

-- Using table aliases for readability and performance
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    p.project_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE e.salary > 70000;

-- Join with indexes (conceptual - actual index creation varies by database)
-- CREATE INDEX idx_employee_dept ON employees(department_id);
-- CREATE INDEX idx_employee_projects_emp ON employee_projects(employee_id);

-- =====================================================
-- Advanced Join Patterns
-- =====================================================

-- Conditional joins using CASE in ON clause
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    CASE 
        WHEN e.salary > 80000 THEN 'Senior'
        ELSE 'Regular'
    END AS level
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
    AND e.salary > 70000;  -- Additional condition in JOIN

-- Join with date ranges
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    p.project_name,
    p.start_date,
    p.end_date
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE e.hire_date <= p.start_date;  -- Employees hired before project start

-- =====================================================
-- Join with Window Functions
-- =====================================================

-- Rank employees within their department and show department info
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    RANK() OVER (PARTITION BY d.department_id ORDER BY e.salary DESC) AS dept_salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- =====================================================
-- Troubleshooting Joins
-- =====================================================

-- Check for missing relationships
SELECT 
    'Employees without departments' AS issue,
    COUNT(*) AS count
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL

UNION ALL

SELECT 
    'Departments without employees' AS issue,
    COUNT(*) AS count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- Find duplicate relationships
SELECT 
    employee_id,
    project_id,
    COUNT(*) AS duplicate_count
FROM employee_projects
GROUP BY employee_id, project_id
HAVING COUNT(*) > 1;

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: List all employees with their department and manager information
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    d.location,
    COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Exercise 2: Find all projects with their assigned employees and roles
SELECT 
    p.project_name,
    p.start_date,
    p.end_date,
    e.first_name || ' ' || e.last_name AS employee_name,
    ep.role,
    ep.hours_allocated
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.employee_id
ORDER BY p.project_name, e.last_name;

-- Exercise 3: Calculate total project hours by department
SELECT 
    d.department_name,
    SUM(ep.hours_allocated) AS total_hours,
    COUNT(DISTINCT ep.employee_id) AS unique_employees,
    COUNT(DISTINCT p.project_id) AS project_count
FROM departments d
JOIN projects p ON d.department_id = p.department_id
JOIN employee_projects ep ON p.project_id = ep.project_id
GROUP BY d.department_id, d.department_name;

-- Exercise 4: Find employees who are working on multiple projects
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    COUNT(ep.project_id) AS project_count,
    SUM(ep.hours_allocated) AS total_hours
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
HAVING COUNT(ep.project_id) > 1;

-- Exercise 5: Create a report showing department budget utilization
SELECT 
    d.department_name,
    d.budget AS total_budget,
    SUM(e.salary) AS salary_costs,
    SUM(p.budget) AS project_budgets,
    d.budget - SUM(e.salary) - COALESCE(SUM(p.budget), 0) AS remaining_budget,
    ROUND((SUM(e.salary) + COALESCE(SUM(p.budget), 0)) * 100.0 / d.budget, 1) AS utilization_percentage
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name, d.budget;