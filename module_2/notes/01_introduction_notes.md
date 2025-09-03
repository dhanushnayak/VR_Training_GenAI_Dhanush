# Module 2.1: Introduction to SQL and Databases - Study Notes

## What is SQL?

**SQL (Structured Query Language)** is a standardized programming language designed for managing and manipulating relational databases. It's the universal language for working with data stored in tables.

### Key Characteristics:
- **Declarative Language**: You specify what you want, not how to get it
- **Standardized**: Works across different database systems (with minor variations)
- **Powerful**: Can handle simple queries to complex data analysis
- **Widely Used**: Essential skill for data professionals

## Database Fundamentals

### Core Concepts

#### 1. Database
- A structured collection of related data
- Organized to minimize redundancy and maximize efficiency
- Examples: Customer database, inventory system, financial records

#### 2. Table (Relation)
- The basic storage unit in a relational database
- Consists of rows and columns
- Represents a specific entity (customers, products, orders)

#### 3. Row (Record/Tuple)
- A single instance of data in a table
- Contains all attributes for one entity
- Example: One customer's complete information

#### 4. Column (Field/Attribute)
- A specific piece of information about an entity
- Has a defined data type
- Example: customer_name, email, phone_number

#### 5. Primary Key
- Unique identifier for each row in a table
- Cannot be NULL or duplicate
- Examples: customer_id, product_id, order_id

#### 6. Foreign Key
- A field that references the primary key of another table
- Creates relationships between tables
- Maintains referential integrity

## Database Design Principles

### 1. Normalization
**Purpose**: Eliminate data redundancy and improve data integrity

**Benefits**:
- Reduces storage space
- Prevents data inconsistencies
- Makes updates easier
- Improves data quality

**Normal Forms**:
- **1NF**: Each cell contains atomic (indivisible) values
- **2NF**: No partial dependencies on composite keys
- **3NF**: No transitive dependencies

### 2. Entity-Relationship (ER) Design
**Components**:
- **Entities**: Things we store data about (Customer, Product)
- **Attributes**: Properties of entities (name, price, date)
- **Relationships**: How entities connect (Customer places Order)

### 3. Relationship Types
- **One-to-One (1:1)**: Each record in Table A relates to one record in Table B
- **One-to-Many (1:M)**: One record in Table A relates to many in Table B
- **Many-to-Many (M:M)**: Many records in Table A relate to many in Table B

## SQL Categories

### 1. DDL (Data Definition Language)
**Purpose**: Define and modify database structure
**Commands**:
- `CREATE`: Create tables, databases, indexes
- `ALTER`: Modify existing structures
- `DROP`: Delete tables or databases
- `TRUNCATE`: Remove all data from table

### 2. DML (Data Manipulation Language)
**Purpose**: Manipulate data within tables
**Commands**:
- `SELECT`: Retrieve data
- `INSERT`: Add new data
- `UPDATE`: Modify existing data
- `DELETE`: Remove data

### 3. DCL (Data Control Language)
**Purpose**: Control access to data
**Commands**:
- `GRANT`: Give permissions
- `REVOKE`: Remove permissions

### 4. TCL (Transaction Control Language)
**Purpose**: Manage database transactions
**Commands**:
- `COMMIT`: Save changes permanently
- `ROLLBACK`: Undo changes
- `SAVEPOINT`: Create checkpoint in transaction

## Data Types

### Numeric Types
- **INTEGER**: Whole numbers (-2,147,483,648 to 2,147,483,647)
- **DECIMAL(p,s)**: Fixed-point numbers (p=precision, s=scale)
- **REAL/FLOAT**: Floating-point numbers
- **BOOLEAN**: True/False values

### String Types
- **VARCHAR(n)**: Variable-length strings (up to n characters)
- **CHAR(n)**: Fixed-length strings (exactly n characters)
- **TEXT**: Large text data

### Date/Time Types
- **DATE**: Date values (YYYY-MM-DD)
- **TIME**: Time values (HH:MM:SS)
- **DATETIME/TIMESTAMP**: Date and time combined

## Constraints

### 1. Primary Key Constraint
```sql
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);
```

### 2. Foreign Key Constraint
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### 3. Not Null Constraint
```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL
);
```

### 4. Unique Constraint
```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
```

### 5. Check Constraint
```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    price DECIMAL(10,2) CHECK (price > 0)
);
```

### 6. Default Constraint
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'pending'
);
```

## Database Schema Design Best Practices

### 1. Naming Conventions
- Use descriptive, meaningful names
- Be consistent (snake_case recommended)
- Avoid reserved words
- Use singular nouns for table names
- Use plural nouns for junction tables

### 2. Table Design
- Each table should represent one entity
- Include a primary key in every table
- Use appropriate data types
- Define constraints to ensure data integrity

### 3. Relationship Design
- Use foreign keys to maintain referential integrity
- Create junction tables for many-to-many relationships
- Consider cascading options (CASCADE, SET NULL, RESTRICT)

## Common Database Systems

### 1. SQLite
- **Pros**: Lightweight, serverless, zero-configuration
- **Cons**: Limited concurrent access, no user management
- **Use Cases**: Development, small applications, embedded systems

### 2. MySQL
- **Pros**: Fast, reliable, widely supported
- **Cons**: Limited advanced features in free version
- **Use Cases**: Web applications, e-commerce sites

### 3. PostgreSQL
- **Pros**: Advanced features, excellent standards compliance
- **Cons**: More complex setup, higher resource usage
- **Use Cases**: Complex applications, data warehousing

### 4. SQL Server
- **Pros**: Excellent integration with Microsoft ecosystem
- **Cons**: Expensive licensing, Windows-focused
- **Use Cases**: Enterprise applications, business intelligence

### 5. Oracle
- **Pros**: Extremely powerful, enterprise-grade features
- **Cons**: Very expensive, complex
- **Use Cases**: Large enterprise systems, mission-critical applications

## SQL Syntax Fundamentals

### Basic Structure
```sql
SELECT column1, column2
FROM table_name
WHERE condition
ORDER BY column1;
```

### Key Points
- SQL is case-insensitive for keywords (SELECT = select)
- String values must be enclosed in single quotes
- Statements end with semicolon
- Comments: `--` for single line, `/* */` for multi-line

## Database Development Lifecycle

### 1. Requirements Analysis
- Identify what data needs to be stored
- Understand business rules and relationships
- Define user requirements and use cases

### 2. Conceptual Design
- Create Entity-Relationship diagrams
- Identify entities, attributes, and relationships
- Define business rules and constraints

### 3. Logical Design
- Convert ER diagram to table structures
- Apply normalization rules
- Define primary and foreign keys

### 4. Physical Design
- Choose appropriate data types
- Create indexes for performance
- Consider storage and security requirements

### 5. Implementation
- Create database and tables
- Insert initial data
- Create views, stored procedures, triggers

### 6. Testing and Optimization
- Test all functionality
- Optimize query performance
- Ensure data integrity

## Study Tips

### 1. Practice Regularly
- Work with real datasets
- Try different database systems
- Build complete projects

### 2. Understand the Why
- Don't just memorize syntax
- Understand when to use different approaches
- Learn the reasoning behind best practices

### 3. Start Simple
- Begin with basic queries
- Gradually add complexity
- Master fundamentals before advanced topics

### 4. Use Visual Tools
- Draw ER diagrams
- Use database design tools
- Visualize table relationships

### 5. Learn from Examples
- Study well-designed databases
- Analyze real-world schemas
- Understand common patterns

## Common Mistakes to Avoid

### 1. Poor Naming
- Using abbreviations or cryptic names
- Inconsistent naming conventions
- Using reserved words as identifiers

### 2. Design Issues
- Not using primary keys
- Ignoring normalization principles
- Creating circular references

### 3. Data Type Problems
- Using inappropriate data types
- Not considering data size limits
- Ignoring NULL handling

### 4. Security Oversights
- Not implementing proper constraints
- Ignoring data validation
- Poor access control design

## Next Steps

After mastering these fundamentals:
1. Learn basic SQL queries (SELECT, WHERE, ORDER BY)
2. Practice data manipulation (INSERT, UPDATE, DELETE)
3. Master joins and relationships
4. Explore advanced features (subqueries, window functions)
5. Study performance optimization
6. Learn database administration basics

## Key Takeaways

- **SQL is essential** for working with relational databases
- **Good design** prevents problems later
- **Normalization** reduces redundancy and improves integrity
- **Constraints** ensure data quality
- **Practice** is crucial for mastering SQL
- **Understanding concepts** is more important than memorizing syntax