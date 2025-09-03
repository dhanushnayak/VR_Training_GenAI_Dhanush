"""
Module 2.8: Database Connectivity with Python
=====================================================

This module demonstrates how to connect to databases using Python,
execute SQL queries, and handle results programmatically.
"""

import sqlite3
import pandas as pd
from sqlalchemy import create_engine, text
import os
from datetime import datetime, date
from typing import List, Dict, Any, Optional

# =====================================================
# Basic SQLite Connection
# =====================================================

def create_sample_database():
    """Create a sample SQLite database with our company data."""
    
    # Connect to SQLite database (creates file if it doesn't exist)
    conn = sqlite3.connect('company_database.db')
    cursor = conn.cursor()
    
    # Create tables
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS departments (
            department_id INTEGER PRIMARY KEY,
            department_name VARCHAR(50) NOT NULL,
            location VARCHAR(50),
            budget DECIMAL(10,2)
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS employees (
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
        )
    ''')
    
    # Insert sample data
    departments_data = [
        (1, 'Engineering', 'San Francisco', 2000000.00),
        (2, 'Marketing', 'New York', 800000.00),
        (3, 'Sales', 'Chicago', 1200000.00),
        (4, 'HR', 'Austin', 500000.00),
        (5, 'Finance', 'Boston', 600000.00)
    ]
    
    cursor.executemany('''
        INSERT OR REPLACE INTO departments 
        (department_id, department_name, location, budget) 
        VALUES (?, ?, ?, ?)
    ''', departments_data)
    
    employees_data = [
        (1, 'John', 'Smith', 'john.smith@company.com', '2020-01-15', 95000.00, 1, None),
        (2, 'Sarah', 'Johnson', 'sarah.johnson@company.com', '2019-03-22', 87000.00, 1, 1),
        (3, 'Mike', 'Brown', 'mike.brown@company.com', '2021-06-10', 72000.00, 1, 1),
        (4, 'Emily', 'Davis', 'emily.davis@company.com', '2020-09-05', 68000.00, 2, None),
        (5, 'David', 'Wilson', 'david.wilson@company.com', '2018-11-30', 78000.00, 2, 4),
        (6, 'Lisa', 'Anderson', 'lisa.anderson@company.com', '2022-02-14', 85000.00, 3, None),
        (7, 'Tom', 'Taylor', 'tom.taylor@company.com', '2021-08-20', 65000.00, 3, 6),
        (8, 'Anna', 'Martinez', 'anna.martinez@company.com', '2020-04-12', 62000.00, 4, None),
        (9, 'Chris', 'Garcia', 'chris.garcia@company.com', '2019-07-08', 89000.00, 5, None),
        (10, 'Jessica', 'Lee', 'jessica.lee@company.com', '2021-12-03', 71000.00, 1, 1)
    ]
    
    cursor.executemany('''
        INSERT OR REPLACE INTO employees 
        (employee_id, first_name, last_name, email, hire_date, salary, department_id, manager_id) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', employees_data)
    
    # Commit changes and close connection
    conn.commit()
    conn.close()
    
    print("Sample database created successfully!")

# =====================================================
# Basic Database Operations
# =====================================================

class DatabaseManager:
    """A class to manage database connections and operations."""
    
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.connection = None
    
    def connect(self):
        """Establish database connection."""
        try:
            self.connection = sqlite3.connect(self.db_path)
            self.connection.row_factory = sqlite3.Row  # Enable column access by name
            print(f"Connected to database: {self.db_path}")
        except sqlite3.Error as e:
            print(f"Error connecting to database: {e}")
    
    def disconnect(self):
        """Close database connection."""
        if self.connection:
            self.connection.close()
            print("Database connection closed.")
    
    def execute_query(self, query: str, params: tuple = None) -> List[Dict]:
        """Execute a SELECT query and return results."""
        if not self.connection:
            self.connect()
        
        try:
            cursor = self.connection.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            # Convert rows to list of dictionaries
            columns = [description[0] for description in cursor.description]
            results = []
            for row in cursor.fetchall():
                results.append(dict(zip(columns, row)))
            
            return results
        
        except sqlite3.Error as e:
            print(f"Error executing query: {e}")
            return []
    
    def execute_non_query(self, query: str, params: tuple = None) -> int:
        """Execute INSERT, UPDATE, or DELETE query."""
        if not self.connection:
            self.connect()
        
        try:
            cursor = self.connection.cursor()
            if params:
                cursor.execute(query, params)
            else:
                cursor.execute(query)
            
            self.connection.commit()
            return cursor.rowcount
        
        except sqlite3.Error as e:
            print(f"Error executing non-query: {e}")
            self.connection.rollback()
            return 0
    
    def execute_many(self, query: str, params_list: List[tuple]) -> int:
        """Execute query with multiple parameter sets."""
        if not self.connection:
            self.connect()
        
        try:
            cursor = self.connection.cursor()
            cursor.executemany(query, params_list)
            self.connection.commit()
            return cursor.rowcount
        
        except sqlite3.Error as e:
            print(f"Error executing batch query: {e}")
            self.connection.rollback()
            return 0

# =====================================================
# Using the Database Manager
# =====================================================

def demonstrate_basic_operations():
    """Demonstrate basic database operations."""
    
    # Create database manager
    db = DatabaseManager('company_database.db')
    
    try:
        # Connect to database
        db.connect()
        
        # Query all employees
        print("All Employees:")
        employees = db.execute_query("SELECT * FROM employees")
        for emp in employees[:3]:  # Show first 3
            print(f"  {emp['first_name']} {emp['last_name']} - ${emp['salary']:,.2f}")
        
        # Query with parameters (safe from SQL injection)
        print("\nEmployees in Engineering Department:")
        eng_employees = db.execute_query(
            "SELECT first_name, last_name, salary FROM employees WHERE department_id = ?",
            (1,)
        )
        for emp in eng_employees:
            print(f"  {emp['first_name']} {emp['last_name']} - ${emp['salary']:,.2f}")
        
        # Insert new employee
        print("\nInserting new employee...")
        rows_affected = db.execute_non_query(
            """INSERT INTO employees 
               (first_name, last_name, email, hire_date, salary, department_id) 
               VALUES (?, ?, ?, ?, ?, ?)""",
            ('Alice', 'Cooper', 'alice.cooper@company.com', '2023-06-01', 75000.00, 2)
        )
        print(f"Rows inserted: {rows_affected}")
        
        # Update employee salary
        print("\nUpdating employee salary...")
        rows_affected = db.execute_non_query(
            "UPDATE employees SET salary = salary * 1.05 WHERE department_id = ?",
            (1,)
        )
        print(f"Rows updated: {rows_affected}")
        
        # Aggregate query
        print("\nDepartment Statistics:")
        dept_stats = db.execute_query("""
            SELECT 
                d.department_name,
                COUNT(e.employee_id) as employee_count,
                AVG(e.salary) as avg_salary,
                SUM(e.salary) as total_payroll
            FROM departments d
            LEFT JOIN employees e ON d.department_id = e.department_id
            GROUP BY d.department_id, d.department_name
            ORDER BY avg_salary DESC
        """)
        
        for dept in dept_stats:
            print(f"  {dept['department_name']}: {dept['employee_count']} employees, "
                  f"Avg: ${dept['avg_salary']:,.2f}, Total: ${dept['total_payroll']:,.2f}")
    
    finally:
        db.disconnect()

# =====================================================
# Using Pandas for Database Operations
# =====================================================

def demonstrate_pandas_integration():
    """Demonstrate using pandas with database operations."""
    
    # Create connection
    conn = sqlite3.connect('company_database.db')
    
    try:
        # Read data into DataFrame
        print("Reading data with pandas:")
        
        # Simple query
        df_employees = pd.read_sql_query(
            "SELECT * FROM employees", 
            conn
        )
        print(f"Loaded {len(df_employees)} employees")
        print(df_employees.head())
        
        # Complex query with joins
        df_employee_dept = pd.read_sql_query("""
            SELECT 
                e.first_name,
                e.last_name,
                e.salary,
                d.department_name,
                d.location
            FROM employees e
            JOIN departments d ON e.department_id = d.department_id
            ORDER BY e.salary DESC
        """, conn)
        
        print("\nEmployee-Department Data:")
        print(df_employee_dept.head())
        
        # Perform pandas operations
        print("\nPandas Analysis:")
        print(f"Average salary: ${df_employee_dept['salary'].mean():,.2f}")
        print(f"Salary by department:")
        dept_salary = df_employee_dept.groupby('department_name')['salary'].agg(['mean', 'count'])
        print(dept_salary)
        
        # Write DataFrame back to database
        print("\nCreating summary table...")
        summary_df = df_employee_dept.groupby('department_name').agg({
            'salary': ['mean', 'min', 'max', 'count']
        }).round(2)
        
        # Flatten column names
        summary_df.columns = ['avg_salary', 'min_salary', 'max_salary', 'employee_count']
        summary_df = summary_df.reset_index()
        
        # Write to new table
        summary_df.to_sql('department_summary', conn, if_exists='replace', index=False)
        print("Summary table created successfully!")
        
        # Verify the new table
        verification = pd.read_sql_query("SELECT * FROM department_summary", conn)
        print("\nDepartment Summary Table:")
        print(verification)
    
    finally:
        conn.close()

# =====================================================
# Using SQLAlchemy (Advanced ORM)
# =====================================================

def demonstrate_sqlalchemy():
    """Demonstrate SQLAlchemy for database operations."""
    
    # Create engine
    engine = create_engine('sqlite:///company_database.db')
    
    try:
        # Execute raw SQL
        print("SQLAlchemy Raw SQL:")
        with engine.connect() as conn:
            result = conn.execute(text("""
                SELECT 
                    d.department_name,
                    COUNT(e.employee_id) as employee_count,
                    AVG(e.salary) as avg_salary
                FROM departments d
                LEFT JOIN employees e ON d.department_id = e.department_id
                GROUP BY d.department_id, d.department_name
            """))
            
            for row in result:
                print(f"  {row.department_name}: {row.employee_count} employees, "
                      f"Avg: ${row.avg_salary:.2f}")
        
        # Use pandas with SQLAlchemy
        print("\nPandas + SQLAlchemy:")
        df = pd.read_sql_query("""
            SELECT 
                e.first_name || ' ' || e.last_name as full_name,
                e.salary,
                d.department_name,
                CASE 
                    WHEN e.salary >= 80000 THEN 'Senior'
                    WHEN e.salary >= 70000 THEN 'Mid-level'
                    ELSE 'Junior'
                END as level
            FROM employees e
            JOIN departments d ON e.department_id = d.department_id
            ORDER BY e.salary DESC
        """, engine)
        
        print(df)
        
        # Group by level
        print("\nEmployees by Level:")
        level_summary = df.groupby('level').agg({
            'full_name': 'count',
            'salary': ['mean', 'min', 'max']
        })
        print(level_summary)
    
    except Exception as e:
        print(f"SQLAlchemy error: {e}")

# =====================================================
# Error Handling and Best Practices
# =====================================================

class SafeDatabaseManager:
    """Database manager with comprehensive error handling."""
    
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.connection = None
    
    def __enter__(self):
        """Context manager entry."""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        self.disconnect()
    
    def connect(self):
        """Establish connection with error handling."""
        try:
            self.connection = sqlite3.connect(self.db_path)
            self.connection.row_factory = sqlite3.Row
            # Enable foreign key constraints
            self.connection.execute("PRAGMA foreign_keys = ON")
        except sqlite3.Error as e:
            print(f"Connection error: {e}")
            raise
    
    def disconnect(self):
        """Safely close connection."""
        if self.connection:
            try:
                self.connection.close()
            except sqlite3.Error as e:
                print(f"Error closing connection: {e}")
    
    def execute_transaction(self, operations: List[Dict[str, Any]]) -> bool:
        """Execute multiple operations in a transaction."""
        if not self.connection:
            raise RuntimeError("No database connection")
        
        try:
            # Start transaction
            cursor = self.connection.cursor()
            
            for operation in operations:
                query = operation['query']
                params = operation.get('params', ())
                
                if isinstance(params, list):
                    cursor.executemany(query, params)
                else:
                    cursor.execute(query, params)
            
            # Commit all operations
            self.connection.commit()
            return True
            
        except sqlite3.Error as e:
            print(f"Transaction error: {e}")
            self.connection.rollback()
            return False
    
    def get_table_info(self, table_name: str) -> List[Dict]:
        """Get table schema information."""
        try:
            cursor = self.connection.cursor()
            cursor.execute(f"PRAGMA table_info({table_name})")
            
            columns = []
            for row in cursor.fetchall():
                columns.append({
                    'name': row[1],
                    'type': row[2],
                    'not_null': bool(row[3]),
                    'default': row[4],
                    'primary_key': bool(row[5])
                })
            
            return columns
            
        except sqlite3.Error as e:
            print(f"Error getting table info: {e}")
            return []

# =====================================================
# Performance Optimization
# =====================================================

def demonstrate_performance_tips():
    """Demonstrate database performance optimization techniques."""
    
    with SafeDatabaseManager('company_database.db') as db:
        
        # 1. Use indexes for frequently queried columns
        print("Creating indexes...")
        db.connection.execute("CREATE INDEX IF NOT EXISTS idx_employee_dept ON employees(department_id)")
        db.connection.execute("CREATE INDEX IF NOT EXISTS idx_employee_salary ON employees(salary)")
        
        # 2. Use prepared statements for repeated queries
        print("Using prepared statements...")
        cursor = db.connection.cursor()
        
        # Prepare statement
        query = "SELECT first_name, last_name, salary FROM employees WHERE department_id = ?"
        
        # Execute multiple times with different parameters
        for dept_id in [1, 2, 3]:
            cursor.execute(query, (dept_id,))
            results = cursor.fetchall()
            print(f"Department {dept_id}: {len(results)} employees")
        
        # 3. Use batch operations for multiple inserts
        print("Batch insert example...")
        new_employees = [
            ('Bob', 'Wilson', 'bob.wilson@company.com', '2023-07-01', 70000, 3),
            ('Carol', 'Davis', 'carol.davis@company.com', '2023-07-15', 72000, 3),
            ('Dan', 'Miller', 'dan.miller@company.com', '2023-08-01', 68000, 4)
        ]
        
        cursor.executemany("""
            INSERT OR IGNORE INTO employees 
            (first_name, last_name, email, hire_date, salary, department_id)
            VALUES (?, ?, ?, ?, ?, ?)
        """, new_employees)
        
        db.connection.commit()
        print(f"Inserted {cursor.rowcount} employees in batch")
        
        # 4. Use EXPLAIN QUERY PLAN to analyze performance
        print("\nQuery execution plan:")
        cursor.execute("""
            EXPLAIN QUERY PLAN
            SELECT e.first_name, e.last_name, d.department_name
            FROM employees e
            JOIN departments d ON e.department_id = d.department_id
            WHERE e.salary > 75000
        """)
        
        for row in cursor.fetchall():
            print(f"  {row[3]}")

# =====================================================
# Data Export and Import
# =====================================================

def export_to_csv():
    """Export database data to CSV files."""
    
    conn = sqlite3.connect('company_database.db')
    
    try:
        # Export employees to CSV
        df_employees = pd.read_sql_query("""
            SELECT 
                e.employee_id,
                e.first_name,
                e.last_name,
                e.email,
                e.hire_date,
                e.salary,
                d.department_name
            FROM employees e
            LEFT JOIN departments d ON e.department_id = d.department_id
        """, conn)
        
        df_employees.to_csv('employees_export.csv', index=False)
        print("Employees exported to employees_export.csv")
        
        # Export department summary
        df_summary = pd.read_sql_query("""
            SELECT 
                d.department_name,
                d.location,
                d.budget,
                COUNT(e.employee_id) as employee_count,
                AVG(e.salary) as avg_salary,
                SUM(e.salary) as total_payroll
            FROM departments d
            LEFT JOIN employees e ON d.department_id = e.department_id
            GROUP BY d.department_id, d.department_name, d.location, d.budget
        """, conn)
        
        df_summary.to_csv('department_summary_export.csv', index=False)
        print("Department summary exported to department_summary_export.csv")
        
    finally:
        conn.close()

def import_from_csv():
    """Import data from CSV files."""
    
    # Create sample CSV data
    sample_data = pd.DataFrame({
        'first_name': ['Alex', 'Jordan', 'Taylor'],
        'last_name': ['Johnson', 'Smith', 'Brown'],
        'email': ['alex.j@company.com', 'jordan.s@company.com', 'taylor.b@company.com'],
        'hire_date': ['2023-09-01', '2023-09-15', '2023-10-01'],
        'salary': [75000, 78000, 73000],
        'department_id': [2, 3, 1]
    })
    
    sample_data.to_csv('new_employees.csv', index=False)
    
    # Import the CSV
    conn = sqlite3.connect('company_database.db')
    
    try:
        # Read CSV
        df_new = pd.read_csv('new_employees.csv')
        
        # Import to database
        df_new.to_sql('employees', conn, if_exists='append', index=False)
        print(f"Imported {len(df_new)} new employees from CSV")
        
        # Verify import
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM employees")
        total_count = cursor.fetchone()[0]
        print(f"Total employees in database: {total_count}")
        
    finally:
        conn.close()

# =====================================================
# Main Execution
# =====================================================

if __name__ == "__main__":
    print("=== Database Connectivity Demo ===\n")
    
    # Create sample database
    create_sample_database()
    
    # Demonstrate basic operations
    print("\n1. Basic Database Operations:")
    demonstrate_basic_operations()
    
    # Demonstrate pandas integration
    print("\n2. Pandas Integration:")
    demonstrate_pandas_integration()
    
    # Demonstrate SQLAlchemy
    print("\n3. SQLAlchemy Demo:")
    demonstrate_sqlalchemy()
    
    # Demonstrate performance tips
    print("\n4. Performance Optimization:")
    demonstrate_performance_tips()
    
    # Demonstrate export/import
    print("\n5. Data Export/Import:")
    export_to_csv()
    import_from_csv()
    
    print("\n=== Demo Complete ===")

# =====================================================
# Additional Utility Functions
# =====================================================

def backup_database(source_db: str, backup_path: str):
    """Create a backup of the database."""
    
    source_conn = sqlite3.connect(source_db)
    backup_conn = sqlite3.connect(backup_path)
    
    try:
        source_conn.backup(backup_conn)
        print(f"Database backed up to {backup_path}")
    finally:
        source_conn.close()
        backup_conn.close()

def get_database_stats(db_path: str) -> Dict[str, Any]:
    """Get comprehensive database statistics."""
    
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        stats = {}
        
        # Get all tables
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
        tables = [row[0] for row in cursor.fetchall()]
        stats['tables'] = tables
        
        # Get row counts for each table
        table_counts = {}
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table}")
            table_counts[table] = cursor.fetchone()[0]
        stats['row_counts'] = table_counts
        
        # Get database size
        cursor.execute("PRAGMA page_count")
        page_count = cursor.fetchone()[0]
        cursor.execute("PRAGMA page_size")
        page_size = cursor.fetchone()[0]
        stats['size_bytes'] = page_count * page_size
        
        return stats
        
    finally:
        conn.close()

# Example usage of utility functions
def demonstrate_utilities():
    """Demonstrate utility functions."""
    
    print("Database Statistics:")
    stats = get_database_stats('company_database.db')
    
    print(f"Tables: {', '.join(stats['tables'])}")
    print("Row counts:")
    for table, count in stats['row_counts'].items():
        print(f"  {table}: {count} rows")
    print(f"Database size: {stats['size_bytes']:,} bytes")
    
    # Create backup
    backup_database('company_database.db', 'company_database_backup.db')