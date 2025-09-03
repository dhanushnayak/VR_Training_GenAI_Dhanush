# Module 2.7: Data Cleaning and Transformation - Study Notes

## Introduction to Data Cleaning

Data cleaning is the process of identifying and correcting (or removing) corrupt, inaccurate, or irrelevant parts of a dataset. In real-world scenarios, data is rarely perfect and often requires significant cleaning before analysis.

### Why Data Cleaning Matters
- **Data Quality**: Poor data leads to poor decisions
- **Analysis Accuracy**: Clean data ensures reliable insights
- **System Performance**: Clean data improves query performance
- **Compliance**: Many regulations require data accuracy
- **User Experience**: Clean data improves application usability

### Common Data Quality Issues
- **Missing Values**: NULL, empty strings, placeholder values
- **Inconsistent Formats**: Different date formats, case variations
- **Duplicates**: Exact or near-duplicate records
- **Invalid Data**: Values outside expected ranges
- **Inconsistent Naming**: Variations in names, addresses
- **Data Type Issues**: Numbers stored as strings, etc.

## String Functions and Text Cleaning

### Basic String Cleaning

#### TRIM Function
Removes leading and trailing whitespace.

```sql
-- Remove extra spaces
SELECT 
    full_name AS original,
    TRIM(full_name) AS cleaned,
    LENGTH(full_name) AS original_length,
    LENGTH(TRIM(full_name)) AS cleaned_length
FROM customers;
```

**Variations:**
- `LTRIM()`: Remove leading spaces only
- `RTRIM()`: Remove trailing spaces only
- `TRIM(characters FROM string)`: Remove specific characters

#### Case Conversion
Standardize text case for consistency.

```sql
-- Standardize case
SELECT 
    customer_name,
    UPPER(customer_name) AS uppercase,
    LOWER(customer_name) AS lowercase,
    -- Proper case (first letter uppercase)
    UPPER(SUBSTR(TRIM(customer_name), 1, 1)) || 
    LOWER(SUBSTR(TRIM(customer_name), 2)) AS proper_case
FROM customers;
```

#### REPLACE Function
Replace specific characters or patterns.

```sql
-- Clean phone numbers
SELECT 
    phone AS original_phone,
    REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '') AS digits_only,
    -- Format as (XXX) XXX-XXXX
    '(' || SUBSTR(clean_phone, 1, 3) || ') ' ||
    SUBSTR(clean_phone, 4, 3) || '-' ||
    SUBSTR(clean_phone, 7, 4) AS formatted_phone
FROM (
    SELECT 
        phone,
        REPLACE(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), ' ', '') AS clean_phone
    FROM customers
) WHERE LENGTH(clean_phone) = 10;
```

### Advanced String Manipulation

#### Extracting Parts of Strings
```sql
-- Extract first and last names from full name
SELECT 
    full_name,
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
FROM customers;
```

#### Email Validation and Cleaning
```sql
-- Clean and validate email addresses
SELECT 
    email AS original_email,
    LOWER(TRIM(email)) AS cleaned_email,
    CASE 
        WHEN INSTR(email, '@') > 0 AND INSTR(email, '.') > INSTR(email, '@')
        THEN 'Valid'
        ELSE 'Invalid'
    END AS email_status,
    -- Extract domain
    SUBSTR(LOWER(TRIM(email)), INSTR(LOWER(TRIM(email)), '@') + 1) AS domain
FROM customers;
```

#### Pattern Matching with LIKE
```sql
-- Find and clean specific patterns
SELECT 
    product_code,
    CASE 
        WHEN product_code LIKE 'PRD-%' THEN product_code
        WHEN product_code LIKE 'PRD%' THEN 'PRD-' || SUBSTR(product_code, 4)
        ELSE 'PRD-' || product_code
    END AS standardized_code
FROM products;
```

## Date and Time Cleaning

### Date Format Standardization
```sql
-- Handle multiple date formats
SELECT 
    registration_date AS original_date,
    CASE 
        -- Handle MM/DD/YYYY format
        WHEN registration_date LIKE '__/__/____' 
        THEN DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                  SUBSTR('0' || SUBSTR(registration_date, 1, INSTR(registration_date, '/') - 1), -2, 2) || '-' ||
                  SUBSTR('0' || SUBSTR(registration_date, INSTR(registration_date, '/') + 1, 2), -2, 2))
        -- Handle YYYY-MM-DD format (already correct)
        WHEN registration_date LIKE '____-__-__' 
        THEN DATE(registration_date)
        -- Handle DD/MM/YYYY format
        WHEN registration_date LIKE '__/__/____' AND SUBSTR(registration_date, 4, 1) = '/'
        THEN DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                  SUBSTR(registration_date, 4, 2) || '-' ||
                  SUBSTR(registration_date, 1, 2))
        ELSE NULL
    END AS standardized_date
FROM customers;
```

### Date Validation
```sql
-- Validate and clean dates
SELECT 
    date_field,
    CASE 
        WHEN DATE(date_field) IS NOT NULL THEN DATE(date_field)
        WHEN date_field = '0000-00-00' THEN NULL
        WHEN date_field = '' THEN NULL
        ELSE NULL
    END AS cleaned_date,
    CASE 
        WHEN DATE(date_field) IS NOT NULL THEN 'Valid'
        ELSE 'Invalid'
    END AS date_status
FROM data_table;
```

### Time Zone Handling
```sql
-- Standardize timestamps to UTC
SELECT 
    event_timestamp,
    -- Convert to UTC (example for EST)
    DATETIME(event_timestamp, '+5 hours') AS utc_timestamp,
    -- Extract components
    strftime('%Y', event_timestamp) AS year,
    strftime('%m', event_timestamp) AS month,
    strftime('%d', event_timestamp) AS day,
    strftime('%H', event_timestamp) AS hour
FROM events;
```

## Data Type Conversions

### String to Number Conversion
```sql
-- Convert string prices to numbers
SELECT 
    price_text,
    CASE 
        WHEN REPLACE(REPLACE(price_text, '$', ''), ',', '') GLOB '*[0-9]*'
        THEN CAST(REPLACE(REPLACE(price_text, '$', ''), ',', '') AS REAL)
        ELSE NULL
    END AS price_numeric,
    -- Validate conversion
    CASE 
        WHEN CAST(REPLACE(REPLACE(price_text, '$', ''), ',', '') AS REAL) > 0
        THEN 'Valid'
        ELSE 'Invalid'
    END AS price_status
FROM products;
```

### Percentage to Decimal Conversion
```sql
-- Convert percentage strings to decimals
SELECT 
    discount_text,
    CASE 
        WHEN discount_text LIKE '%'
        THEN CAST(REPLACE(discount_text, '%', '') AS REAL) / 100.0
        WHEN discount_text GLOB '*[0-9]*' AND CAST(discount_text AS REAL) <= 1
        THEN CAST(discount_text AS REAL)
        ELSE NULL
    END AS discount_decimal
FROM sales_data;
```

### Boolean Conversion
```sql
-- Standardize boolean values
SELECT 
    active_flag,
    CASE 
        WHEN LOWER(active_flag) IN ('true', 'yes', '1', 'active', 'y') THEN 1
        WHEN LOWER(active_flag) IN ('false', 'no', '0', 'inactive', 'n') THEN 0
        ELSE NULL
    END AS is_active
FROM customers;
```

## Handling NULL and Missing Values

### Identifying Missing Data
```sql
-- Comprehensive missing data analysis
SELECT 
    'customers' AS table_name,
    COUNT(*) AS total_records,
    COUNT(CASE WHEN first_name IS NULL OR TRIM(first_name) = '' THEN 1 END) AS missing_first_name,
    COUNT(CASE WHEN last_name IS NULL OR TRIM(last_name) = '' THEN 1 END) AS missing_last_name,
    COUNT(CASE WHEN email IS NULL OR TRIM(email) = '' THEN 1 END) AS missing_email,
    COUNT(CASE WHEN phone IS NULL OR TRIM(phone) = '' THEN 1 END) AS missing_phone
FROM customers;
```

### Filling Missing Values
```sql
-- Fill missing values with defaults or calculated values
SELECT 
    customer_id,
    COALESCE(NULLIF(TRIM(first_name), ''), 'Unknown') AS first_name,
    COALESCE(NULLIF(TRIM(last_name), ''), 'Customer') AS last_name,
    COALESCE(NULLIF(TRIM(email), ''), 'no-email@company.com') AS email,
    COALESCE(NULLIF(TRIM(phone), ''), 'Not Provided') AS phone,
    -- Fill with average for numeric values
    COALESCE(age, (SELECT ROUND(AVG(age)) FROM customers WHERE age IS NOT NULL)) AS age
FROM customers;
```

### NULL-Safe Operations
```sql
-- Handle NULLs in calculations
SELECT 
    customer_id,
    order_total,
    discount,
    -- NULL-safe calculation
    COALESCE(order_total, 0) - COALESCE(discount, 0) AS final_amount,
    -- Percentage calculation with NULL handling
    CASE 
        WHEN order_total > 0 THEN ROUND((COALESCE(discount, 0) / order_total) * 100, 2)
        ELSE 0
    END AS discount_percentage
FROM orders;
```

## Data Validation and Quality Checks

### Comprehensive Data Quality Assessment
```sql
-- Create data quality scorecard
WITH data_quality AS (
    SELECT 
        customer_id,
        -- Name validation
        CASE 
            WHEN first_name IS NOT NULL AND TRIM(first_name) != '' THEN 1
            ELSE 0
        END AS has_valid_first_name,
        -- Email validation
        CASE 
            WHEN email IS NOT NULL AND email LIKE '%@%.%' THEN 1
            ELSE 0
        END AS has_valid_email,
        -- Phone validation
        CASE 
            WHEN LENGTH(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')) = 10 THEN 1
            ELSE 0
        END AS has_valid_phone,
        -- Date validation
        CASE 
            WHEN registration_date IS NOT NULL AND DATE(registration_date) IS NOT NULL THEN 1
            ELSE 0
        END AS has_valid_date
    FROM customers
)
SELECT 
    customer_id,
    has_valid_first_name + has_valid_email + has_valid_phone + has_valid_date AS quality_score,
    CASE 
        WHEN has_valid_first_name + has_valid_email + has_valid_phone + has_valid_date >= 3
        THEN 'High Quality'
        WHEN has_valid_first_name + has_valid_email + has_valid_phone + has_valid_date >= 2
        THEN 'Medium Quality'
        ELSE 'Low Quality'
    END AS quality_rating
FROM data_quality;
```

### Range Validation
```sql
-- Validate data ranges
SELECT 
    product_id,
    price,
    quantity,
    CASE 
        WHEN price < 0 THEN 'Invalid: Negative price'
        WHEN price > 10000 THEN 'Warning: Very high price'
        WHEN price = 0 THEN 'Warning: Zero price'
        ELSE 'Valid'
    END AS price_validation,
    CASE 
        WHEN quantity < 0 THEN 'Invalid: Negative quantity'
        WHEN quantity > 1000 THEN 'Warning: Very high quantity'
        ELSE 'Valid'
    END AS quantity_validation
FROM products;
```

### Cross-Field Validation
```sql
-- Validate relationships between fields
SELECT 
    order_id,
    order_date,
    ship_date,
    CASE 
        WHEN ship_date < order_date THEN 'Invalid: Ship date before order date'
        WHEN ship_date > DATE(order_date, '+30 days') THEN 'Warning: Long shipping time'
        ELSE 'Valid'
    END AS date_validation
FROM orders;
```

## Duplicate Detection and Removal

### Finding Exact Duplicates
```sql
-- Find exact duplicate records
SELECT 
    first_name,
    last_name,
    email,
    COUNT(*) AS duplicate_count,
    GROUP_CONCAT(customer_id) AS duplicate_ids
FROM customers
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;
```

### Finding Similar Records
```sql
-- Find potential duplicates (case-insensitive, trimmed)
SELECT 
    LOWER(TRIM(first_name)) AS first_name_clean,
    LOWER(TRIM(last_name)) AS last_name_clean,
    LOWER(TRIM(email)) AS email_clean,
    COUNT(*) AS potential_duplicates,
    GROUP_CONCAT(customer_id) AS customer_ids
FROM customers
GROUP BY 
    LOWER(TRIM(first_name)),
    LOWER(TRIM(last_name)),
    LOWER(TRIM(email))
HAVING COUNT(*) > 1;
```

### Removing Duplicates
```sql
-- Keep only the first occurrence of duplicates
DELETE FROM customers 
WHERE customer_id NOT IN (
    SELECT MIN(customer_id)
    FROM customers
    GROUP BY LOWER(TRIM(first_name)), LOWER(TRIM(last_name)), LOWER(TRIM(email))
);
```

### Fuzzy Matching for Near-Duplicates
```sql
-- Find similar names (basic approach)
SELECT 
    c1.customer_id AS id1,
    c2.customer_id AS id2,
    c1.first_name AS name1,
    c2.first_name AS name2,
    c1.email AS email1,
    c2.email AS email2
FROM customers c1
JOIN customers c2 ON c1.customer_id < c2.customer_id
WHERE (
    -- Similar names
    LOWER(TRIM(c1.first_name)) = LOWER(TRIM(c2.first_name))
    AND LOWER(TRIM(c1.last_name)) = LOWER(TRIM(c2.last_name))
) OR (
    -- Same email
    LOWER(TRIM(c1.email)) = LOWER(TRIM(c2.email))
);
```

## Data Standardization Patterns

### Address Standardization
```sql
-- Standardize address formats
SELECT 
    address,
    -- Standardize street abbreviations
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(UPPER(TRIM(address)), ' ST.', ' STREET'),
                ' AVE.', ' AVENUE'
            ),
            ' RD.', ' ROAD'
        ),
        ' BLVD.', ' BOULEVARD'
    ) AS standardized_address
FROM customers;
```

### Name Standardization
```sql
-- Standardize name formats
SELECT 
    full_name,
    -- Convert to proper case and handle common issues
    REPLACE(
        REPLACE(
            REPLACE(
                UPPER(SUBSTR(TRIM(full_name), 1, 1)) || LOWER(SUBSTR(TRIM(full_name), 2)),
                ' Mc', ' Mc'  -- Handle Scottish names
            ),
            ' O''', ' O'''  -- Handle Irish names
        ),
        '  ', ' '  -- Remove double spaces
    ) AS standardized_name
FROM customers;
```

### Category Standardization
```sql
-- Standardize category names
SELECT 
    category,
    CASE 
        WHEN LOWER(category) IN ('electronics', 'electronic', 'tech') THEN 'Electronics'
        WHEN LOWER(category) IN ('clothing', 'clothes', 'apparel') THEN 'Clothing'
        WHEN LOWER(category) IN ('books', 'book', 'literature') THEN 'Books'
        ELSE UPPER(SUBSTR(TRIM(category), 1, 1)) || LOWER(SUBSTR(TRIM(category), 2))
    END AS standardized_category
FROM products;
```

## Data Transformation Techniques

### Pivoting Data
```sql
-- Convert rows to columns
SELECT 
    employee_id,
    employee_name,
    SUM(CASE WHEN project_name = 'Project A' THEN hours ELSE 0 END) AS project_a_hours,
    SUM(CASE WHEN project_name = 'Project B' THEN hours ELSE 0 END) AS project_b_hours,
    SUM(CASE WHEN project_name = 'Project C' THEN hours ELSE 0 END) AS project_c_hours
FROM employee_projects
GROUP BY employee_id, employee_name;
```

### Unpivoting Data
```sql
-- Convert columns to rows
SELECT employee_id, 'Project A' AS project, project_a_hours AS hours
FROM employee_summary WHERE project_a_hours > 0
UNION ALL
SELECT employee_id, 'Project B' AS project, project_b_hours AS hours
FROM employee_summary WHERE project_b_hours > 0
UNION ALL
SELECT employee_id, 'Project C' AS project, project_c_hours AS hours
FROM employee_summary WHERE project_c_hours > 0;
```

### Data Aggregation and Summarization
```sql
-- Create summary tables
CREATE VIEW customer_summary AS
SELECT 
    customer_id,
    TRIM(first_name) || ' ' || TRIM(last_name) AS full_name,
    LOWER(TRIM(email)) AS email,
    COUNT(order_id) AS total_orders,
    SUM(order_total) AS total_spent,
    AVG(order_total) AS avg_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_id, first_name, last_name, email;
```

## Creating Comprehensive Cleaning Views

### Master Cleaning View
```sql
-- Create a comprehensive cleaned data view
CREATE VIEW cleaned_customers AS
SELECT 
    customer_id,
    -- Standardized names
    CASE 
        WHEN TRIM(first_name) != '' THEN
            UPPER(SUBSTR(TRIM(first_name), 1, 1)) || LOWER(SUBSTR(TRIM(first_name), 2))
        ELSE 'Unknown'
    END AS first_name,
    CASE 
        WHEN TRIM(last_name) != '' THEN
            UPPER(SUBSTR(TRIM(last_name), 1, 1)) || LOWER(SUBSTR(TRIM(last_name), 2))
        ELSE 'Customer'
    END AS last_name,
    -- Cleaned email
    LOWER(TRIM(email)) AS email,
    -- Standardized phone
    CASE 
        WHEN LENGTH(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')) = 10
        THEN '(' || SUBSTR(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), 1, 3) || ') ' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), 4, 3) || '-' ||
             SUBSTR(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', ''), 7, 4)
        ELSE NULL
    END AS phone,
    -- Standardized date
    CASE 
        WHEN registration_date LIKE '__/__/____' 
        THEN DATE(SUBSTR(registration_date, 7, 4) || '-' || 
                  SUBSTR('0' || SUBSTR(registration_date, 1, 2), -2, 2) || '-' ||
                  SUBSTR('0' || SUBSTR(registration_date, 4, 2), -2, 2))
        WHEN registration_date LIKE '____-__-__' 
        THEN DATE(registration_date)
        ELSE NULL
    END AS registration_date,
    -- Data quality indicators
    CASE 
        WHEN first_name IS NOT NULL AND TRIM(first_name) != '' 
         AND last_name IS NOT NULL AND TRIM(last_name) != ''
         AND email LIKE '%@%.%'
         AND LENGTH(REPLACE(REPLACE(REPLACE(phone, '(', ''), ')', ''), '-', '')) = 10
        THEN 'High'
        ELSE 'Low'
    END AS data_quality
FROM customers;
```

## Performance Considerations

### Batch Processing for Large Datasets
```sql
-- Process data in batches
UPDATE large_table 
SET cleaned_field = TRIM(UPPER(original_field))
WHERE id BETWEEN 1 AND 10000;

-- Repeat for next batch
UPDATE large_table 
SET cleaned_field = TRIM(UPPER(original_field))
WHERE id BETWEEN 10001 AND 20000;
```

### Indexing for Cleaning Operations
```sql
-- Create indexes to speed up cleaning operations
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_customer_phone ON customers(phone);
CREATE INDEX idx_customer_name ON customers(first_name, last_name);
```

### Monitoring Cleaning Progress
```sql
-- Track cleaning progress
SELECT 
    'Before Cleaning' AS status,
    COUNT(*) AS total_records,
    COUNT(CASE WHEN email IS NULL OR email = '' THEN 1 END) AS missing_emails,
    COUNT(CASE WHEN phone IS NULL OR phone = '' THEN 1 END) AS missing_phones
FROM customers_raw

UNION ALL

SELECT 
    'After Cleaning' AS status,
    COUNT(*) AS total_records,
    COUNT(CASE WHEN email IS NULL OR email = '' THEN 1 END) AS missing_emails,
    COUNT(CASE WHEN phone IS NULL OR phone = '' THEN 1 END) AS missing_phones
FROM customers_cleaned;
```

## Best Practices

### 1. Planning and Documentation
- **Analyze data quality** before starting
- **Document cleaning rules** and business logic
- **Create data dictionaries** for standardized values
- **Plan for data validation** at each step

### 2. Incremental Approach
- **Start with critical fields** first
- **Clean in stages** rather than all at once
- **Test on small samples** before full processing
- **Validate results** at each step

### 3. Backup and Recovery
- **Always backup original data** before cleaning
- **Create audit trails** of changes made
- **Use transactions** for complex operations
- **Plan rollback procedures**

### 4. Automation and Monitoring
- **Create reusable cleaning functions**
- **Automate repetitive tasks**
- **Monitor data quality** continuously
- **Set up alerts** for quality issues

## Common Pitfalls and Solutions

### 1. Over-Cleaning
**Problem**: Removing valid data that looks suspicious
**Solution**: Validate cleaning rules with business users

### 2. Performance Issues
**Problem**: Cleaning operations taking too long
**Solution**: Use batch processing and appropriate indexing

### 3. Data Loss
**Problem**: Accidentally removing important information
**Solution**: Always backup and test on samples first

### 4. Inconsistent Standards
**Problem**: Different cleaning rules for similar data
**Solution**: Create and follow standardized procedures

## Key Takeaways

- **Data cleaning is essential** for reliable analysis
- **Plan thoroughly** before starting cleaning operations
- **Use appropriate string functions** for text cleaning
- **Handle NULL values** explicitly and consistently
- **Validate data** at multiple levels
- **Remove duplicates** carefully to avoid data loss
- **Standardize formats** for consistency
- **Monitor performance** and optimize as needed
- **Document all cleaning rules** for maintainability
- **Test thoroughly** before applying to production data
- **Create reusable patterns** for common cleaning tasks
- **Always backup original data** before cleaning