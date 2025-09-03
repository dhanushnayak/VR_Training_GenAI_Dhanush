-- =====================================================
-- Module 2.4: Aggregations and Grouping
-- =====================================================

-- =====================================================
-- Basic Aggregate Functions
-- =====================================================

-- COUNT - Count number of rows
SELECT COUNT(*) AS total_employees FROM employees;

-- Count non-NULL values in a specific column
SELECT COUNT(manager_id) AS employees_with_managers FROM employees;

-- Count distinct values
SELECT COUNT(DISTINCT department_id) AS unique_departments FROM employees;

-- SUM - Calculate total
SELECT SUM(salary) AS total_payroll FROM employees;

-- AVG - Calculate average
SELECT AVG(salary) AS average_salary FROM employees;

-- MIN and MAX - Find minimum and maximum values
SELECT 
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    MAX(hire_date) AS most_recent_hire,
    MIN(hire_date) AS earliest_hire
FROM employees;

-- Multiple aggregates in one query
SELECT 
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll
FROM employees;

-- =====================================================
-- GROUP BY Clause
-- =====================================================

-- Group by single column
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Group by multiple columns
SELECT 
    department_id,
    strftime('%Y', hire_date) AS hire_year,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id, strftime('%Y', hire_date);

-- Group with calculated fields
SELECT 
    CASE 
        WHEN salary < 70000 THEN 'Low'
        WHEN salary < 85000 THEN 'Medium'
        ELSE 'High'
    END AS salary_range,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary_in_range
FROM employees
GROUP BY 
    CASE 
        WHEN salary < 70000 THEN 'Low'
        WHEN salary < 85000 THEN 'Medium'
        ELSE 'High'
    END;

-- =====================================================
-- HAVING Clause - Filtering Groups
-- =====================================================

-- HAVING vs WHERE:
-- WHERE filters rows before grouping
-- HAVING filters groups after aggregation

-- Find departments with more than 2 employees
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Find departments with average salary > 75000
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 75000;

-- Combine WHERE and HAVING
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
WHERE hire_date >= '2020-01-01'  -- Filter rows first
GROUP BY department_id
HAVING COUNT(*) >= 2;            -- Then filter groups

-- =====================================================
-- Advanced Grouping Examples
-- =====================================================

-- Department statistics with department names
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    SUM(e.salary) AS total_payroll
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_salary DESC;

-- Monthly hiring trends
SELECT 
    strftime('%Y-%m', hire_date) AS hire_month,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_starting_salary
FROM employees
GROUP BY strftime('%Y-%m', hire_date)
ORDER BY hire_month;

-- Salary distribution analysis
SELECT 
    CASE 
        WHEN salary < 65000 THEN '< 65K'
        WHEN salary < 75000 THEN '65K - 75K'
        WHEN salary < 85000 THEN '75K - 85K'
        ELSE '85K+'
    END AS salary_bracket,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 1) AS percentage
FROM employees
GROUP BY 
    CASE 
        WHEN salary < 65000 THEN '< 65K'
        WHEN salary < 75000 THEN '65K - 75K'
        WHEN salary < 85000 THEN '75K - 85K'
        ELSE '85K+'
    END
ORDER BY MIN(salary);

-- =====================================================
-- Window Functions (Advanced Aggregations)
-- =====================================================

-- ROW_NUMBER() - Assign unique row numbers
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- RANK() and DENSE_RANK()
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
FROM employees;

-- Partition by department
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

-- Running totals with window functions
SELECT 
    first_name,
    last_name,
    salary,
    SUM(salary) OVER (ORDER BY employee_id) AS running_total_payroll
FROM employees
ORDER BY employee_id;

-- Moving averages
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

-- LAG and LEAD functions
SELECT 
    first_name,
    last_name,
    salary,
    LAG(salary, 1) OVER (ORDER BY salary) AS previous_salary,
    LEAD(salary, 1) OVER (ORDER BY salary) AS next_salary,
    salary - LAG(salary, 1) OVER (ORDER BY salary) AS salary_difference
FROM employees
ORDER BY salary;

-- =====================================================
-- Statistical Functions
-- =====================================================

-- Percentiles (if supported by your database)
-- Note: SQLite has limited statistical functions
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    -- Median approximation using window functions
    (
        SELECT salary 
        FROM employees e2 
        WHERE e2.department_id = e1.department_id 
        ORDER BY salary 
        LIMIT 1 OFFSET (COUNT(*) / 2)
    ) AS median_salary_approx
FROM employees e1
GROUP BY department_id;

-- Standard deviation (if available)
-- PostgreSQL/MySQL example:
-- SELECT 
--     department_id,
--     STDDEV(salary) AS salary_stddev,
--     VARIANCE(salary) AS salary_variance
-- FROM employees
-- GROUP BY department_id;

-- =====================================================
-- Complex Aggregation Scenarios
-- =====================================================

-- Project statistics with employee involvement
SELECT 
    p.project_name,
    COUNT(ep.employee_id) AS team_size,
    SUM(ep.hours_allocated) AS total_hours,
    AVG(ep.hours_allocated) AS avg_hours_per_person,
    AVG(e.salary) AS avg_team_salary
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id, p.project_name;

-- Department budget utilization
SELECT 
    d.department_name,
    d.budget AS department_budget,
    COALESCE(SUM(e.salary), 0) AS total_salaries,
    COALESCE(SUM(p.budget), 0) AS total_project_budgets,
    d.budget - COALESCE(SUM(e.salary), 0) - COALESCE(SUM(p.budget), 0) AS remaining_budget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name, d.budget;

-- Employee productivity metrics
SELECT 
    e.first_name,
    e.last_name,
    e.salary,
    COUNT(ep.project_id) AS projects_count,
    SUM(ep.hours_allocated) AS total_hours_allocated,
    CASE 
        WHEN SUM(ep.hours_allocated) > 0 
        THEN ROUND(e.salary / SUM(ep.hours_allocated), 2)
        ELSE 0 
    END AS cost_per_hour
FROM employees e
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.salary
ORDER BY cost_per_hour DESC;

-- =====================================================
-- Conditional Aggregations
-- =====================================================

-- Count with conditions using CASE
SELECT 
    department_id,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 75000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date >= '2021-01-01' THEN 1 END) AS recent_hires,
    AVG(CASE WHEN salary > 75000 THEN salary END) AS avg_high_earner_salary
FROM employees
GROUP BY department_id;

-- Sum with conditions
SELECT 
    strftime('%Y', hire_date) AS hire_year,
    SUM(CASE WHEN department_id = 1 THEN salary ELSE 0 END) AS engineering_payroll,
    SUM(CASE WHEN department_id = 2 THEN salary ELSE 0 END) AS marketing_payroll,
    SUM(CASE WHEN department_id = 3 THEN salary ELSE 0 END) AS sales_payroll
FROM employees
GROUP BY strftime('%Y', hire_date);

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: Find the department with the highest average salary
SELECT 
    department_id,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC
LIMIT 1;

-- Exercise 2: Count employees by hire year and show percentage of total
SELECT 
    strftime('%Y', hire_date) AS hire_year,
    COUNT(*) AS employees_hired,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 1) AS percentage
FROM employees
GROUP BY strftime('%Y', hire_date)
ORDER BY hire_year;

-- Exercise 3: Find departments where the salary gap (max - min) is greater than 20000
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_gap
FROM employees
GROUP BY department_id
HAVING MAX(salary) - MIN(salary) > 20000;

-- Exercise 4: Calculate the total project hours by department
SELECT 
    d.department_name,
    SUM(ep.hours_allocated) AS total_project_hours,
    COUNT(DISTINCT p.project_id) AS project_count,
    AVG(ep.hours_allocated) AS avg_hours_per_assignment
FROM departments d
JOIN projects p ON d.department_id = p.department_id
JOIN employee_projects ep ON p.project_id = ep.project_id
GROUP BY d.department_id, d.department_name;

-- Exercise 5: Rank employees within each department by salary
SELECT 
    first_name,
    last_name,
    department_id,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_salary_rank
FROM employees
ORDER BY department_id, dept_salary_rank;