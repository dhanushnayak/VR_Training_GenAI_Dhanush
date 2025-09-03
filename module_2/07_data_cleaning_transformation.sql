-- =====================================================
-- Module 2.7: Data Cleaning and Transformation
-- =====================================================

-- =====================================================
-- String Functions and Text Cleaning
-- =====================================================

-- Create a sample table with messy data for demonstration
CREATE TABLE messy_customer_data (
    id INTEGER PRIMARY KEY,
    full_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    registration_date TEXT,
    status TEXT
);

-- Insert sample messy data
INSERT INTO messy_customer_data VALUES
(1, '  John   Smith  ', 'JOHN.SMITH@EMAIL.COM', '(555) 123-4567', '123 Main St, New York, NY', '2023-01-15', 'active'),
(2, 'sarah johnson', 'sarah@email.com', '555.234.5678', '456 Oak Ave, Los Angeles, CA', '01/20/2023', 'INACTIVE'),
(3, 'Mike Brown Jr.', 'mike.brown@email.com', '555-345-6789', '789 Pine Rd, Chicago, IL', '2023-02-28', 'Active'),
(4, 'EMILY DAVIS', 'emily.davis@email.com', '(555)456-7890', '321 Elm St, Houston, TX', '03/15/2023', 'pending'),
(5, 'David Wilson', 'david@email.com', '555 567 8901', '654 Maple Dr, Phoenix, AZ', '2023-04-10', 'active'),
(6, '', 'invalid-email', '123', 'Incomplete Address', '2023-13-45', 'unknown');

-- =====================================================
-- Basic String Cleaning Functions
-- =====================================================

-- TRIM - Remove leading and trailing whitespace
SELECT 
    id,
    full_name AS original_name,
    TRIM(full_name) AS cleaned_name,
    LENGTH(full_name) AS original_length,
    LENGTH(TRIM(full_name)) AS cleaned_length
FROM messy_customer_data;

-- UPPER, LOWER, and proper case conversion
SELECT 
    id,
    full_name,
    UPPER(TRIM(full_name)) AS upper_name,
    LOWER(TRIM(full_name)) AS lower_name,
    -- Proper case (first letter uppercase, rest lowercase)
    UPPER(SUBSTR(TRIM(full_name), 1, 1)) || LOWER(SUBSTR(TRIM(full_name), 2)) AS proper_name
FROM messy_customer_data
WHERE TRIM(full_name) != '';

-- REPLACE - Replace specific characters or patterns
SELECT 
    id,
    phone AS original_phone,
    REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), '.', '') AS digits_only,
    REPLACE(REPLACE(phone, '(', ''), ')', '') AS no_parentheses
FROM messy_customer_data;

-- =====================================================
-- Advanced String Manipulation
-- =====================================================

-- Extract first and last names
SELECT 
    id,
    TRIM(full_name) AS full_name,
    CASE 
        WHEN INSTR(TRIM(full_name), ' ') > 0 
        THEN TRIM(SUBSTR(TRIM(full_name), 1, INSTR(TRIM(full_name), ' ') - 1))
        ELSE TRIM(full_name)
    END AS first_name,
    CASE 
        WHEN INSTR(TRIM(full_name), ' ') > 0 
        THEN TRIM(SUBSTR(TRIM(full_name), INSTR(TRIM(full_name), ' ') + 1))
        ELSE ''
    END AS last_name
FROM messy_customer_data
WHERE TRIM(full_name) != '';

-- Clean and standardize email addresses
SELECT 
    id,
    email AS original_email,
    LOWER(TRIM(email)) AS cleaned_email,
    CASE 
        WHEN INSTR(email, '@') > 0 AND INSTR(email, '.') > INSTR(email, '@')
        THEN 'Valid'
        ELSE 'Invalid'
    END AS email_status
FROM messy_customer_data;

-- Standardize phone numbers to (XXX) XXX-XXXX format
SELECT 
    id,
    phone AS original_phone,
    CASE 
        WHEN LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10
        THEN '(' || SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) || ') ' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) || '-' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
        ELSE 'Invalid Phone'
    END AS standardized_phone
FROM messy_customer_data;

-- =====================================================
-- Date and Time Cleaning
-- =====================================================

-- Standardize date formats
SELECT 
    id,
    registration_date AS original_date,
    CASE 
        -- Handle MM/DD/YYYY format
        WHEN registration_date LIKE '__/__/____' 
        THEN SUBSTR(registration_date, 7, 4) || '-' || 
             SUBSTR('0' || SUBSTR(registration_date, 1, INSTR(registration_date, '/') - 1), -2, 2) || '-' ||
             SUBSTR('0' || SUBSTR(registration_date, INSTR(registration_date, '/') + 1, 2), -2, 2)
        -- Handle YYYY-MM-DD format (already correct)
        WHEN registration_date LIKE '____-__-__' 
        THEN registration_date
        ELSE 'Invalid Date'
    END AS standardized_date,
    -- Validate date
    CASE 
        WHEN registration_date LIKE '____-__-__' 
        THEN DATE(registration_date)
        WHEN registration_date LIKE '__/__/____'
        THEN DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                  SUBSTR('0' || SUBSTR(registration_date, 1, INSTR(registration_date, '/') - 1), -2, 2) || '-' ||
                  SUBSTR('0' || SUBSTR(registration_date, INSTR(registration_date, '/') + 1, 2), -2, 2))
        ELSE NULL
    END AS validated_date
FROM messy_customer_data;

-- =====================================================
-- Data Type Conversions
-- =====================================================

-- Convert strings to numbers with validation
CREATE TABLE sales_data (
    id INTEGER PRIMARY KEY,
    product_name TEXT,
    price_text TEXT,
    quantity_text TEXT,
    discount_text TEXT
);

INSERT INTO sales_data VALUES
(1, 'Laptop', '$1,299.99', '5', '10%'),
(2, 'Mouse', '29.99', '10', '0.05'),
(3, 'Keyboard', '$89', '3', '15%'),
(4, 'Monitor', 'invalid', '2', 'N/A'),
(5, 'Headphones', '199.99', 'seven', '20%');

-- Clean and convert price data
SELECT 
    id,
    product_name,
    price_text,
    -- Remove currency symbols and commas, then convert to number
    CASE 
        WHEN REPLACE(REPLACE(price_text, '$', ''), ',', '') GLOB '*[0-9]*'
        THEN CAST(REPLACE(REPLACE(price_text, '$', ''), ',', '') AS REAL)
        ELSE NULL
    END AS price_numeric,
    quantity_text,
    -- Convert quantity to integer
    CASE 
        WHEN quantity_text GLOB '[0-9]*'
        THEN CAST(quantity_text AS INTEGER)
        ELSE NULL
    END AS quantity_numeric,
    discount_text,
    -- Convert percentage to decimal
    CASE 
        WHEN discount_text LIKE '%'
        THEN CAST(REPLACE(discount_text, '%', '') AS REAL) / 100.0
        WHEN discount_text GLOB '*[0-9]*' AND CAST(discount_text AS REAL) <= 1
        THEN CAST(discount_text AS REAL)
        ELSE NULL
    END AS discount_decimal
FROM sales_data;

-- =====================================================
-- Handling NULL and Missing Values
-- =====================================================

-- Identify and handle missing data
SELECT 
    id,
    full_name,
    email,
    phone,
    -- Check for various forms of missing data
    CASE 
        WHEN full_name IS NULL OR TRIM(full_name) = '' THEN 'Missing Name'
        ELSE 'Name Present'
    END AS name_status,
    CASE 
        WHEN email IS NULL OR TRIM(email) = '' OR email = 'N/A' THEN 'Missing Email'
        ELSE 'Email Present'
    END AS email_status,
    -- Fill missing values with defaults
    COALESCE(NULLIF(TRIM(full_name), ''), 'Unknown Customer') AS name_with_default,
    COALESCE(NULLIF(TRIM(email), ''), 'no-email@company.com') AS email_with_default
FROM messy_customer_data;

-- =====================================================
-- Data Validation and Quality Checks
-- =====================================================

-- Comprehensive data quality report
WITH data_quality AS (
    SELECT 
        id,
        full_name,
        email,
        phone,
        registration_date,
        status,
        -- Name validation
        CASE 
            WHEN full_name IS NULL OR TRIM(full_name) = '' THEN 0
            ELSE 1
        END AS has_valid_name,
        -- Email validation
        CASE 
            WHEN email IS NULL OR TRIM(email) = '' THEN 0
            WHEN INSTR(email, '@') > 0 AND INSTR(email, '.') > INSTR(email, '@') THEN 1
            ELSE 0
        END AS has_valid_email,
        -- Phone validation
        CASE 
            WHEN LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10 THEN 1
            ELSE 0
        END AS has_valid_phone,
        -- Date validation
        CASE 
            WHEN DATE(registration_date) IS NOT NULL THEN 1
            ELSE 0
        END AS has_valid_date,
        -- Status validation
        CASE 
            WHEN LOWER(status) IN ('active', 'inactive', 'pending') THEN 1
            ELSE 0
        END AS has_valid_status
    FROM messy_customer_data
)
SELECT 
    id,
    full_name,
    email,
    phone,
    registration_date,
    status,
    has_valid_name + has_valid_email + has_valid_phone + has_valid_date + has_valid_status AS quality_score,
    CASE 
        WHEN has_valid_name + has_valid_email + has_valid_phone + has_valid_date + has_valid_status >= 4
        THEN 'High Quality'
        WHEN has_valid_name + has_valid_email + has_valid_phone + has_valid_date + has_valid_status >= 2
        THEN 'Medium Quality'
        ELSE 'Low Quality'
    END AS quality_rating
FROM data_quality;

-- =====================================================
-- Duplicate Detection and Removal
-- =====================================================

-- Create table with duplicates for demonstration
CREATE TABLE customer_duplicates (
    id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT
);

INSERT INTO customer_duplicates VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-123-4567'),
(2, 'John', 'Smith', 'john.smith@email.com', '555-123-4567'),  -- Exact duplicate
(3, 'John', 'Smith', 'j.smith@email.com', '555-123-4567'),     -- Similar
(4, 'Sarah', 'Johnson', 'sarah@email.com', '555-234-5678'),
(5, 'SARAH', 'JOHNSON', 'sarah@email.com', '555-234-5678');    -- Case difference

-- Find exact duplicates
SELECT 
    first_name,
    last_name,
    email,
    phone,
    COUNT(*) as duplicate_count
FROM customer_duplicates
GROUP BY first_name, last_name, email, phone
HAVING COUNT(*) > 1;

-- Find potential duplicates (case-insensitive)
SELECT 
    LOWER(first_name) as first_name_lower,
    LOWER(last_name) as last_name_lower,
    LOWER(email) as email_lower,
    COUNT(*) as potential_duplicates,
    GROUP_CONCAT(id) as duplicate_ids
FROM customer_duplicates
GROUP BY LOWER(first_name), LOWER(last_name), LOWER(email)
HAVING COUNT(*) > 1;

-- Remove duplicates keeping the first occurrence
DELETE FROM customer_duplicates 
WHERE id NOT IN (
    SELECT MIN(id)
    FROM customer_duplicates
    GROUP BY LOWER(first_name), LOWER(last_name), LOWER(email)
);

-- =====================================================
-- Data Standardization
-- =====================================================

-- Create a comprehensive cleaning view
CREATE VIEW cleaned_customer_data AS
SELECT 
    id,
    -- Standardized name
    CASE 
        WHEN TRIM(full_name) != '' THEN
            UPPER(SUBSTR(TRIM(full_name), 1, 1)) || 
            LOWER(SUBSTR(TRIM(full_name), 2))
        ELSE 'Unknown Customer'
    END AS standardized_name,
    
    -- Extract first and last names
    CASE 
        WHEN INSTR(TRIM(full_name), ' ') > 0 
        THEN UPPER(SUBSTR(TRIM(SUBSTR(TRIM(full_name), 1, INSTR(TRIM(full_name), ' ') - 1)), 1, 1)) ||
             LOWER(SUBSTR(TRIM(SUBSTR(TRIM(full_name), 1, INSTR(TRIM(full_name), ' ') - 1)), 2))
        ELSE UPPER(SUBSTR(TRIM(full_name), 1, 1)) || LOWER(SUBSTR(TRIM(full_name), 2))
    END AS first_name,
    
    CASE 
        WHEN INSTR(TRIM(full_name), ' ') > 0 
        THEN UPPER(SUBSTR(TRIM(SUBSTR(TRIM(full_name), INSTR(TRIM(full_name), ' ') + 1)), 1, 1)) ||
             LOWER(SUBSTR(TRIM(SUBSTR(TRIM(full_name), INSTR(TRIM(full_name), ' ') + 1)), 2))
        ELSE ''
    END AS last_name,
    
    -- Standardized email
    LOWER(TRIM(email)) AS standardized_email,
    
    -- Standardized phone
    CASE 
        WHEN LENGTH(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '')) = 10
        THEN '(' || SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) || ') ' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) || '-' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
        ELSE NULL
    END AS standardized_phone,
    
    -- Standardized date
    CASE 
        WHEN registration_date LIKE '__/__/____' 
        THEN DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                  SUBSTR('0' || SUBSTR(registration_date, 1, INSTR(registration_date, '/') - 1), -2, 2) || '-' ||
                  SUBSTR('0' || SUBSTR(registration_date, INSTR(registration_date, '/') + 1, 2), -2, 2))
        WHEN registration_date LIKE '____-__-__' 
        THEN DATE(registration_date)
        ELSE NULL
    END AS standardized_date,
    
    -- Standardized status
    CASE 
        WHEN LOWER(TRIM(status)) IN ('active', 'inactive', 'pending')
        THEN LOWER(TRIM(status))
        ELSE 'unknown'
    END AS standardized_status
FROM messy_customer_data;

-- Query the cleaned data
SELECT * FROM cleaned_customer_data;

-- =====================================================
-- Data Transformation Patterns
-- =====================================================

-- Pivot data (convert rows to columns)
-- Example: Convert project assignments to a pivot table
WITH project_pivot AS (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS employee_name,
        SUM(CASE WHEN p.project_name = 'Mobile App Development' THEN ep.hours_allocated ELSE 0 END) AS mobile_app_hours,
        SUM(CASE WHEN p.project_name = 'Website Redesign' THEN ep.hours_allocated ELSE 0 END) AS website_hours,
        SUM(CASE WHEN p.project_name = 'Marketing Campaign Q2' THEN ep.hours_allocated ELSE 0 END) AS marketing_hours,
        SUM(CASE WHEN p.project_name = 'Sales Training Program' THEN ep.hours_allocated ELSE 0 END) AS sales_training_hours,
        SUM(CASE WHEN p.project_name = 'HR System Upgrade' THEN ep.hours_allocated ELSE 0 END) AS hr_system_hours
    FROM employees e
    LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
    LEFT JOIN projects p ON ep.project_id = p.project_id
    GROUP BY e.employee_id, e.first_name, e.last_name
)
SELECT * FROM project_pivot;

-- Unpivot data (convert columns to rows) - simulation since SQLite doesn't have UNPIVOT
SELECT employee_id, employee_name, 'Mobile App Development' AS project, mobile_app_hours AS hours
FROM (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS employee_name,
        SUM(CASE WHEN p.project_name = 'Mobile App Development' THEN ep.hours_allocated ELSE 0 END) AS mobile_app_hours
    FROM employees e
    LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
    LEFT JOIN projects p ON ep.project_id = p.project_id
    GROUP BY e.employee_id, e.first_name, e.last_name
) WHERE mobile_app_hours > 0

UNION ALL

SELECT employee_id, employee_name, 'Website Redesign' AS project, website_hours AS hours
FROM (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS employee_name,
        SUM(CASE WHEN p.project_name = 'Website Redesign' THEN ep.hours_allocated ELSE 0 END) AS website_hours
    FROM employees e
    LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
    LEFT JOIN projects p ON ep.project_id = p.project_id
    GROUP BY e.employee_id, e.first_name, e.last_name
) WHERE website_hours > 0;

-- =====================================================
-- Practice Exercises
-- =====================================================

-- Exercise 1: Clean and standardize the messy customer data
SELECT 
    id,
    TRIM(full_name) AS cleaned_name,
    LOWER(TRIM(email)) AS cleaned_email,
    CASE 
        WHEN LENGTH(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')) = 10
        THEN REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')
        ELSE 'Invalid'
    END AS cleaned_phone,
    CASE 
        WHEN registration_date LIKE '____-__-__' THEN DATE(registration_date)
        WHEN registration_date LIKE '__/__/____' THEN 
            DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                 SUBSTR('0' || SUBSTR(registration_date, 1, 2), -2, 2) || '-' ||
                 SUBSTR('0' || SUBSTR(registration_date, 4, 2), -2, 2))
        ELSE NULL
    END AS cleaned_date,
    LOWER(TRIM(status)) AS cleaned_status
FROM messy_customer_data;

-- Exercise 2: Create a data quality score for each record
SELECT 
    id,
    full_name,
    (CASE WHEN full_name IS NOT NULL AND TRIM(full_name) != '' THEN 1 ELSE 0 END +
     CASE WHEN email LIKE '%@%.%' THEN 1 ELSE 0 END +
     CASE WHEN LENGTH(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')) = 10 THEN 1 ELSE 0 END +
     CASE WHEN DATE(registration_date) IS NOT NULL THEN 1 ELSE 0 END +
     CASE WHEN LOWER(status) IN ('active', 'inactive', 'pending') THEN 1 ELSE 0 END) AS quality_score
FROM messy_customer_data;

-- Exercise 3: Find and flag potential duplicate customers
WITH customer_similarity AS (
    SELECT 
        c1.id AS id1,
        c2.id AS id2,
        c1.full_name AS name1,
        c2.full_name AS name2,
        c1.email AS email1,
        c2.email AS email2
    FROM messy_customer_data c1
    JOIN messy_customer_data c2 ON c1.id < c2.id
    WHERE LOWER(TRIM(c1.full_name)) = LOWER(TRIM(c2.full_name))
       OR LOWER(TRIM(c1.email)) = LOWER(TRIM(c2.email))
)
SELECT * FROM customer_similarity;