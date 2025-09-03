-- =====================================================
-- Module 2.9: Hands-on Practice & Case Studies
-- =====================================================

-- =====================================================
-- Case Study 1: E-commerce Database Analysis
-- =====================================================

-- Create e-commerce database schema
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE,
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INTEGER,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INTEGER,
    price DECIMAL(10,2),
    stock_quantity INTEGER DEFAULT 0,
    created_date DATE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample e-commerce data
INSERT INTO customers VALUES
(1, 'Alice', 'Johnson', 'alice.j@email.com', '2023-01-15', 'New York', 'USA'),
(2, 'Bob', 'Smith', 'bob.s@email.com', '2023-02-20', 'London', 'UK'),
(3, 'Carol', 'Davis', 'carol.d@email.com', '2023-01-30', 'Toronto', 'Canada'),
(4, 'David', 'Wilson', 'david.w@email.com', '2023-03-10', 'Sydney', 'Australia'),
(5, 'Emma', 'Brown', 'emma.b@email.com', '2023-02-05', 'Berlin', 'Germany'),
(6, 'Frank', 'Miller', 'frank.m@email.com', '2023-03-25', 'Tokyo', 'Japan'),
(7, 'Grace', 'Taylor', 'grace.t@email.com', '2023-01-08', 'Paris', 'France'),
(8, 'Henry', 'Anderson', 'henry.a@email.com', '2023-04-12', 'Mumbai', 'India');

INSERT INTO categories VALUES
(1, 'Electronics', NULL),
(2, 'Clothing', NULL),
(3, 'Books', NULL),
(4, 'Smartphones', 1),
(5, 'Laptops', 1),
(6, 'Men Clothing', 2),
(7, 'Women Clothing', 2),
(8, 'Fiction', 3),
(9, 'Non-Fiction', 3);

INSERT INTO products VALUES
(1, 'iPhone 14', 4, 999.99, 50, '2023-01-01'),
(2, 'Samsung Galaxy S23', 4, 899.99, 30, '2023-01-01'),
(3, 'MacBook Pro', 5, 1999.99, 20, '2023-01-01'),
(4, 'Dell XPS 13', 5, 1299.99, 25, '2023-01-01'),
(5, 'Men T-Shirt', 6, 29.99, 100, '2023-01-01'),
(6, 'Women Dress', 7, 79.99, 50, '2023-01-01'),
(7, 'The Great Gatsby', 8, 12.99, 200, '2023-01-01'),
(8, 'Python Programming', 9, 49.99, 75, '2023-01-01'),
(9, 'Wireless Earbuds', 1, 199.99, 80, '2023-01-01'),
(10, 'Jeans', 6, 59.99, 60, '2023-01-01');

INSERT INTO orders VALUES
(1, 1, '2023-04-01', 1029.98, 'completed'),
(2, 2, '2023-04-02', 899.99, 'completed'),
(3, 3, '2023-04-03', 109.98, 'completed'),
(4, 1, '2023-04-05', 1999.99, 'completed'),
(5, 4, '2023-04-06', 229.98, 'pending'),
(6, 5, '2023-04-07', 79.99, 'completed'),
(7, 6, '2023-04-08', 62.98, 'completed'),
(8, 7, '2023-04-09', 1299.99, 'shipped'),
(9, 8, '2023-04-10', 149.98, 'completed'),
(10, 2, '2023-04-11', 49.99, 'pending');

INSERT INTO order_items VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 5, 1, 29.99),
(3, 2, 2, 1, 899.99),
(4, 3, 7, 2, 12.99),
(5, 3, 5, 1, 29.99),
(6, 3, 10, 1, 59.99),
(7, 4, 3, 1, 1999.99),
(8, 5, 9, 1, 199.99),
(9, 5, 5, 1, 29.99),
(10, 6, 6, 1, 79.99),
(11, 7, 7, 1, 12.99),
(12, 7, 8, 1, 49.99),
(13, 8, 4, 1, 1299.99),
(14, 9, 9, 1, 199.99),
(15, 10, 8, 1, 49.99);

-- =====================================================
-- Case Study 1: Business Questions & Solutions
-- =====================================================

-- Question 1: What are the top 5 best-selling products by quantity?
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS number_of_orders
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Question 2: Which customers have spent the most money?
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.country,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('completed', 'shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.country
ORDER BY total_spent DESC;

-- Question 3: What's the monthly sales trend?
SELECT 
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
WHERE o.status IN ('completed', 'shipped')
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month;

-- Question 4: Category performance analysis
WITH category_sales AS (
    SELECT 
        c.category_name,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        SUM(oi.quantity) AS units_sold,
        COUNT(DISTINCT oi.order_id) AS orders_count,
        COUNT(DISTINCT p.product_id) AS products_count
    FROM categories c
    JOIN products p ON c.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY c.category_id, c.category_name
)
SELECT 
    category_name,
    revenue,
    units_sold,
    orders_count,
    products_count,
    ROUND(revenue / units_sold, 2) AS avg_price_per_unit,
    ROUND(revenue * 100.0 / SUM(revenue) OVER(), 2) AS revenue_percentage
FROM category_sales
ORDER BY revenue DESC;

-- Question 5: Customer segmentation based on purchase behavior
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        COUNT(o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spent,
        AVG(o.total_amount) AS avg_order_value,
        MAX(o.order_date) AS last_order_date,
        JULIANDAY('now') - JULIANDAY(MAX(o.order_date)) AS days_since_last_order
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status IN ('completed', 'shipped')
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT 
    customer_name,
    order_count,
    total_spent,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(days_since_last_order) AS days_since_last_order,
    CASE 
        WHEN order_count >= 3 AND total_spent >= 500 THEN 'VIP'
        WHEN order_count >= 2 AND total_spent >= 200 THEN 'Regular'
        WHEN order_count >= 1 THEN 'New'
        ELSE 'Inactive'
    END AS customer_segment
FROM customer_metrics
ORDER BY total_spent DESC;

-- =====================================================
-- Case Study 2: Library Management System
-- =====================================================

-- Create library database schema
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_year INTEGER,
    nationality VARCHAR(50)
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title VARCHAR(200),
    author_id INTEGER,
    isbn VARCHAR(20) UNIQUE,
    publication_year INTEGER,
    genre VARCHAR(50),
    pages INTEGER,
    available_copies INTEGER DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    join_date DATE,
    membership_type VARCHAR(20) DEFAULT 'standard'
);

CREATE TABLE loans (
    loan_id INTEGER PRIMARY KEY,
    book_id INTEGER,
    member_id INTEGER,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Insert sample library data
INSERT INTO authors VALUES
(1, 'George', 'Orwell', 1903, 'British'),
(2, 'Jane', 'Austen', 1775, 'British'),
(3, 'Mark', 'Twain', 1835, 'American'),
(4, 'Agatha', 'Christie', 1890, 'British'),
(5, 'Ernest', 'Hemingway', 1899, 'American'),
(6, 'Virginia', 'Woolf', 1882, 'British'),
(7, 'F. Scott', 'Fitzgerald', 1896, 'American');

INSERT INTO books VALUES
(1, '1984', 1, '978-0-452-28423-4', 1949, 'Dystopian Fiction', 328, 3),
(2, 'Animal Farm', 1, '978-0-452-28424-1', 1945, 'Political Satire', 112, 2),
(3, 'Pride and Prejudice', 2, '978-0-14-143951-8', 1813, 'Romance', 432, 4),
(4, 'Emma', 2, '978-0-14-143952-5', 1815, 'Romance', 474, 2),
(5, 'The Adventures of Tom Sawyer', 3, '978-0-14-350766-2', 1876, 'Adventure', 274, 3),
(6, 'Murder on the Orient Express', 4, '978-0-06-207350-4', 1934, 'Mystery', 256, 2),
(7, 'The Old Man and the Sea', 5, '978-0-684-80122-3', 1952, 'Literary Fiction', 127, 3),
(8, 'Mrs. Dalloway', 6, '978-0-15-662870-9', 1925, 'Modernist', 194, 1),
(9, 'The Great Gatsby', 7, '978-0-7432-7356-5', 1925, 'Literary Fiction', 180, 4);

INSERT INTO members VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-0101', '2023-01-15', 'premium'),
(2, 'Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', '2023-02-20', 'standard'),
(3, 'Mike', 'Brown', 'mike.b@email.com', '555-0103', '2023-01-30', 'standard'),
(4, 'Emily', 'Davis', 'emily.d@email.com', '555-0104', '2023-03-10', 'premium'),
(5, 'David', 'Wilson', 'david.w@email.com', '555-0105', '2023-02-05', 'standard'),
(6, 'Lisa', 'Anderson', 'lisa.a@email.com', '555-0106', '2023-03-25', 'student');

INSERT INTO loans VALUES
(1, 1, 1, '2023-04-01', '2023-04-15', '2023-04-12', 0),
(2, 3, 2, '2023-04-02', '2023-04-16', NULL, 0),
(3, 5, 3, '2023-04-03', '2023-04-17', '2023-04-20', 3.00),
(4, 7, 1, '2023-04-05', '2023-04-19', NULL, 0),
(5, 2, 4, '2023-04-06', '2023-04-20', '2023-04-18', 0),
(6, 6, 5, '2023-04-07', '2023-04-21', NULL, 0),
(7, 9, 6, '2023-04-08', '2023-04-22', '2023-04-25', 1.50),
(8, 4, 2, '2023-04-10', '2023-04-24', NULL, 0),
(9, 8, 3, '2023-04-12', '2023-04-26', NULL, 0),
(10, 1, 5, '2023-04-15', '2023-04-29', NULL, 0);

-- =====================================================
-- Case Study 2: Library Analysis Questions
-- =====================================================

-- Question 1: Most popular books and authors
SELECT 
    b.title,
    a.first_name || ' ' || a.last_name AS author_name,
    COUNT(l.loan_id) AS times_borrowed,
    b.available_copies,
    ROUND(COUNT(l.loan_id) * 1.0 / b.available_copies, 2) AS utilization_rate
FROM books b
JOIN authors a ON b.author_id = a.author_id
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name, b.available_copies
ORDER BY times_borrowed DESC, utilization_rate DESC;

-- Question 2: Overdue books and fines
SELECT 
    m.first_name || ' ' || m.last_name AS member_name,
    m.email,
    b.title,
    l.loan_date,
    l.due_date,
    JULIANDAY('now') - JULIANDAY(l.due_date) AS days_overdue,
    CASE 
        WHEN l.return_date IS NULL AND DATE('now') > l.due_date 
        THEN ROUND((JULIANDAY('now') - JULIANDAY(l.due_date)) * 0.50, 2)
        ELSE l.fine_amount
    END AS calculated_fine
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL AND DATE('now') > l.due_date
ORDER BY days_overdue DESC;

-- Question 3: Member activity analysis
SELECT 
    m.first_name || ' ' || m.last_name AS member_name,
    m.membership_type,
    COUNT(l.loan_id) AS total_loans,
    COUNT(CASE WHEN l.return_date IS NOT NULL THEN 1 END) AS returned_books,
    COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) AS current_loans,
    SUM(l.fine_amount) AS total_fines_paid,
    MAX(l.loan_date) AS last_loan_date
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.first_name, m.last_name, m.membership_type
ORDER BY total_loans DESC;

-- Question 4: Genre popularity and trends
SELECT 
    b.genre,
    COUNT(DISTINCT b.book_id) AS books_in_genre,
    COUNT(l.loan_id) AS total_loans,
    ROUND(AVG(b.pages), 0) AS avg_pages,
    MIN(b.publication_year) AS earliest_publication,
    MAX(b.publication_year) AS latest_publication
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.genre
ORDER BY total_loans DESC;

-- Question 5: Library efficiency metrics
WITH library_stats AS (
    SELECT 
        COUNT(DISTINCT b.book_id) AS total_books,
        SUM(b.available_copies) AS total_copies,
        COUNT(DISTINCT m.member_id) AS total_members,
        COUNT(l.loan_id) AS total_loans,
        COUNT(CASE WHEN l.return_date IS NULL THEN 1 END) AS current_loans,
        SUM(l.fine_amount) AS total_fines_collected
    FROM books b
    CROSS JOIN members m
    LEFT JOIN loans l ON 1=1
)
SELECT 
    total_books,
    total_copies,
    total_members,
    total_loans,
    current_loans,
    total_fines_collected,
    ROUND(current_loans * 100.0 / total_copies, 2) AS utilization_percentage,
    ROUND(total_loans * 1.0 / total_members, 2) AS avg_loans_per_member
FROM library_stats;

-- =====================================================
-- Case Study 3: Performance Optimization Challenge
-- =====================================================

-- Create a large dataset for performance testing
CREATE TABLE performance_test (
    id INTEGER PRIMARY KEY,
    category VARCHAR(50),
    value DECIMAL(10,2),
    date_created DATE,
    status VARCHAR(20)
);

-- Insert sample data (in practice, this would be much larger)
WITH RECURSIVE generate_data(id, category, value, date_created, status) AS (
    SELECT 1, 'A', 100.50, '2023-01-01', 'active'
    UNION ALL
    SELECT 
        id + 1,
        CASE (id % 5) 
            WHEN 0 THEN 'A'
            WHEN 1 THEN 'B'
            WHEN 2 THEN 'C'
            WHEN 3 THEN 'D'
            ELSE 'E'
        END,
        ROUND(RANDOM() % 1000 + 1, 2),
        DATE('2023-01-01', '+' || (id % 365) || ' days'),
        CASE (id % 3)
            WHEN 0 THEN 'active'
            WHEN 1 THEN 'inactive'
            ELSE 'pending'
        END
    FROM generate_data
    WHERE id < 10000
)
INSERT INTO performance_test SELECT * FROM generate_data;

-- Performance optimization examples

-- 1. Create indexes for better query performance
CREATE INDEX idx_performance_category ON performance_test(category);
CREATE INDEX idx_performance_date ON performance_test(date_created);
CREATE INDEX idx_performance_status ON performance_test(status);
CREATE INDEX idx_performance_composite ON performance_test(category, status, date_created);

-- 2. Analyze query performance
EXPLAIN QUERY PLAN
SELECT category, AVG(value), COUNT(*)
FROM performance_test
WHERE status = 'active' AND date_created >= '2023-06-01'
GROUP BY category;

-- 3. Optimized aggregation query
SELECT 
    category,
    status,
    COUNT(*) AS record_count,
    AVG(value) AS avg_value,
    MIN(value) AS min_value,
    MAX(value) AS max_value,
    SUM(value) AS total_value
FROM performance_test
WHERE date_created >= '2023-01-01'
GROUP BY category, status
ORDER BY category, status;

-- =====================================================
-- Advanced Practice Exercises
-- =====================================================

-- Exercise 1: Customer Lifetime Value (CLV) Calculation
WITH customer_clv AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent,
        AVG(o.total_amount) AS avg_order_value,
        JULIANDAY(MAX(o.order_date)) - JULIANDAY(MIN(o.order_date)) AS customer_lifespan_days
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT 
    customer_name,
    total_orders,
    total_spent,
    ROUND(avg_order_value, 2) AS avg_order_value,
    ROUND(customer_lifespan_days, 0) AS lifespan_days,
    CASE 
        WHEN customer_lifespan_days > 0 
        THEN ROUND(total_spent / (customer_lifespan_days / 30.0), 2)
        ELSE total_spent
    END AS monthly_value,
    CASE 
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment
FROM customer_clv
ORDER BY total_spent DESC;

-- Exercise 2: Inventory Management Analysis
SELECT 
    p.product_name,
    p.stock_quantity AS current_stock,
    COALESCE(SUM(oi.quantity), 0) AS total_sold,
    COALESCE(COUNT(DISTINCT o.order_id), 0) AS orders_containing_product,
    p.price,
    p.price * p.stock_quantity AS inventory_value,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity <= 10 THEN 'Low Stock'
        WHEN p.stock_quantity <= 30 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS stock_status,
    CASE 
        WHEN COALESCE(SUM(oi.quantity), 0) = 0 THEN 'No Sales'
        WHEN p.stock_quantity / COALESCE(SUM(oi.quantity), 1) > 10 THEN 'Overstocked'
        WHEN p.stock_quantity / COALESCE(SUM(oi.quantity), 1) < 2 THEN 'Understocked'
        ELSE 'Optimal'
    END AS inventory_status
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status IN ('completed', 'shipped')
GROUP BY p.product_id, p.product_name, p.stock_quantity, p.price
ORDER BY inventory_value DESC;

-- Exercise 3: Cohort Analysis for Customer Retention
WITH customer_cohorts AS (
    SELECT 
        c.customer_id,
        DATE(MIN(o.order_date), 'start of month') AS cohort_month,
        DATE(o.order_date, 'start of month') AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY c.customer_id, DATE(o.order_date, 'start of month')
),
cohort_data AS (
    SELECT 
        cohort_month,
        order_month,
        COUNT(DISTINCT customer_id) AS customers,
        (JULIANDAY(order_month) - JULIANDAY(cohort_month)) / 30 AS period_number
    FROM customer_cohorts
    GROUP BY cohort_month, order_month
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM customer_cohorts
    WHERE cohort_month = order_month
    GROUP BY cohort_month
)
SELECT 
    cd.cohort_month,
    cs.cohort_size,
    cd.period_number,
    cd.customers,
    ROUND(cd.customers * 100.0 / cs.cohort_size, 2) AS retention_rate
FROM cohort_data cd
JOIN cohort_sizes cs ON cd.cohort_month = cs.cohort_month
ORDER BY cd.cohort_month, cd.period_number;

-- =====================================================
-- Final Challenge: Complex Business Intelligence Query
-- =====================================================

-- Create a comprehensive business dashboard query
WITH monthly_metrics AS (
    SELECT 
        strftime('%Y-%m', o.order_date) AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.total_amount) AS revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY strftime('%Y-%m', o.order_date)
),
product_metrics AS (
    SELECT 
        strftime('%Y-%m', o.order_date) AS month,
        COUNT(DISTINCT oi.product_id) AS products_sold,
        SUM(oi.quantity) AS units_sold
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY strftime('%Y-%m', o.order_date)
),
customer_metrics AS (
    SELECT 
        strftime('%Y-%m', o.order_date) AS month,
        COUNT(DISTINCT CASE WHEN customer_orders.order_count = 1 THEN o.customer_id END) AS new_customers,
        COUNT(DISTINCT CASE WHEN customer_orders.order_count > 1 THEN o.customer_id END) AS returning_customers
    FROM orders o
    JOIN (
        SELECT customer_id, COUNT(*) AS order_count
        FROM orders
        WHERE status IN ('completed', 'shipped')
        GROUP BY customer_id
    ) customer_orders ON o.customer_id = customer_orders.customer_id
    WHERE o.status IN ('completed', 'shipped')
    GROUP BY strftime('%Y-%m', o.order_date)
)
SELECT 
    mm.month,
    mm.total_orders,
    mm.unique_customers,
    mm.revenue,
    ROUND(mm.avg_order_value, 2) AS avg_order_value,
    pm.products_sold,
    pm.units_sold,
    COALESCE(cm.new_customers, 0) AS new_customers,
    COALESCE(cm.returning_customers, 0) AS returning_customers,
    ROUND(COALESCE(cm.returning_customers, 0) * 100.0 / mm.unique_customers, 2) AS retention_rate,
    ROUND(mm.revenue / pm.units_sold, 2) AS revenue_per_unit
FROM monthly_metrics mm
LEFT JOIN product_metrics pm ON mm.month = pm.month
LEFT JOIN customer_metrics cm ON mm.month = cm.month
ORDER BY mm.month;

-- =====================================================
-- Cleanup and Best Practices
-- =====================================================

-- Clean up temporary tables
-- DROP TABLE IF EXISTS performance_test;

-- Best practices summary:
-- 1. Always use indexes on frequently queried columns
-- 2. Use EXPLAIN QUERY PLAN to analyze query performance
-- 3. Avoid SELECT * in production queries
-- 4. Use appropriate data types
-- 5. Normalize your database design
-- 6. Use transactions for data consistency
-- 7. Regular backup and maintenance
-- 8. Monitor query performance and optimize as needed

-- Example of creating a view for commonly used queries
CREATE VIEW customer_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.country,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status IN ('completed', 'shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.country;

-- Query the view
SELECT * FROM customer_summary ORDER BY total_spent DESC LIMIT 10;