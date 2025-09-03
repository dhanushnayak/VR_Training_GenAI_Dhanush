-- =====================================================
-- Module 2.1: Introduction to SQL and Databases
-- =====================================================

-- What is SQL?
-- SQL (Structured Query Language) is a standard language for managing relational databases
-- It allows you to create, read, update, and delete data

-- Database Concepts:
-- - Database: Collection of related data
-- - Table: Structure that holds data in rows and columns
-- - Row/Record: Individual entry in a table
-- - Column/Field: Attribute of the data
-- - Primary Key: Unique identifier for each row
-- - Foreign Key: Reference to primary key in another table

-- =====================================================
-- Creating a Sample Database Schema
-- =====================================================

-- Create database tables for our course examples
-- We'll use a company database with employees, departments, and projects

-- Departments table
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(10,2)
);

-- Employees table
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary DECIMAL(8,2),
    department_id INTEGER,
    manager_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Projects table
CREATE TABLE projects (
    project_id INTEGER PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2),
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Employee_Projects junction table (many-to-many relationship)
CREATE TABLE employee_projects (
    employee_id INTEGER,
    project_id INTEGER,
    role VARCHAR(50),
    hours_allocated INTEGER,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- =====================================================
-- Sample Data Insertion
-- =====================================================

-- Insert departments
INSERT INTO departments (department_id, department_name, location, budget) VALUES
(1, 'Engineering', 'San Francisco', 2000000.00),
(2, 'Marketing', 'New York', 800000.00),
(3, 'Sales', 'Chicago', 1200000.00),
(4, 'HR', 'Austin', 500000.00),
(5, 'Finance', 'Boston', 600000.00);

-- Insert employees
INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, salary, department_id, manager_id) VALUES
(1, 'John', 'Smith', 'john.smith@company.com', '2020-01-15', 95000.00, 1, NULL),
(2, 'Sarah', 'Johnson', 'sarah.johnson@company.com', '2019-03-22', 87000.00, 1, 1),
(3, 'Mike', 'Brown', 'mike.brown@company.com', '2021-06-10', 72000.00, 1, 1),
(4, 'Emily', 'Davis', 'emily.davis@company.com', '2020-09-05', 68000.00, 2, NULL),
(5, 'David', 'Wilson', 'david.wilson@company.com', '2018-11-30', 78000.00, 2, 4),
(6, 'Lisa', 'Anderson', 'lisa.anderson@company.com', '2022-02-14', 85000.00, 3, NULL),
(7, 'Tom', 'Taylor', 'tom.taylor@company.com', '2021-08-20', 65000.00, 3, 6),
(8, 'Anna', 'Martinez', 'anna.martinez@company.com', '2020-04-12', 62000.00, 4, NULL),
(9, 'Chris', 'Garcia', 'chris.garcia@company.com', '2019-07-08', 89000.00, 5, NULL),
(10, 'Jessica', 'Lee', 'jessica.lee@company.com', '2021-12-03', 71000.00, 1, 1);

-- Insert projects
INSERT INTO projects (project_id, project_name, start_date, end_date, budget, department_id) VALUES
(1, 'Mobile App Development', '2023-01-01', '2023-12-31', 500000.00, 1),
(2, 'Website Redesign', '2023-03-15', '2023-09-30', 150000.00, 1),
(3, 'Marketing Campaign Q2', '2023-04-01', '2023-06-30', 200000.00, 2),
(4, 'Sales Training Program', '2023-02-01', '2023-05-31', 75000.00, 3),
(5, 'HR System Upgrade', '2023-06-01', '2023-11-30', 100000.00, 4);

-- Insert employee-project assignments
INSERT INTO employee_projects (employee_id, project_id, role, hours_allocated) VALUES
(1, 1, 'Project Manager', 40),
(2, 1, 'Senior Developer', 35),
(3, 1, 'Developer', 40),
(10, 1, 'Developer', 30),
(2, 2, 'Lead Developer', 25),
(3, 2, 'Developer', 20),
(4, 3, 'Campaign Manager', 40),
(5, 3, 'Marketing Specialist', 35),
(6, 4, 'Training Coordinator', 30),
(7, 4, 'Sales Trainer', 25),
(8, 5, 'Project Lead', 35);

-- =====================================================
-- Basic Database Information Queries
-- =====================================================

-- View table structure
-- Note: These commands vary by database system
-- For SQLite:
PRAGMA table_info(employees);

-- For PostgreSQL/MySQL:
-- DESCRIBE employees;
-- \d employees (PostgreSQL)

-- Show all tables in database
-- SQLite:
SELECT name FROM sqlite_master WHERE type='table';

-- PostgreSQL:
-- SELECT tablename FROM pg_tables WHERE schemaname='public';

-- MySQL:
-- SHOW TABLES;

-- =====================================================
-- Comments and Documentation
-- =====================================================

-- Single line comment starts with --

/*
Multi-line comment
can span multiple lines
like this
*/

-- Best Practices:
-- 1. Use meaningful table and column names
-- 2. Always use PRIMARY KEY constraints
-- 3. Define FOREIGN KEY relationships
-- 4. Use appropriate data types
-- 5. Add comments to complex queries
-- 6. Use consistent naming conventions (snake_case recommended)
-- 7. Normalize your database design to reduce redundancy