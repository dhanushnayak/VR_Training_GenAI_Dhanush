"""
Data Analysis Example using NumPy, Pandas, and Matplotlib
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta
import random

def generate_sample_data():
    """Generate sample sales data"""
    # Set seed for reproducible results
    np.random.seed(42)
    random.seed(42)
    
    # Generate dates for the last 30 days
    end_date = datetime.now()
    dates = [end_date - timedelta(days=x) for x in range(30, 0, -1)]
    
    # Generate sample data
    products = ['Laptop', 'Phone', 'Tablet', 'Headphones', 'Mouse']
    regions = ['North', 'South', 'East', 'West']
    
    data = []
    for date in dates:
        for _ in range(random.randint(5, 15)):  # 5-15 sales per day
            data.append({
                'date': date.strftime('%Y-%m-%d'),
                'product': random.choice(products),
                'region': random.choice(regions),
                'quantity': random.randint(1, 5),
                'price': round(random.uniform(50, 1000), 2),
                'customer_age': random.randint(18, 65)
            })
    
    return pd.DataFrame(data)

def analyze_sales_data():
    """Perform comprehensive data analysis"""
    print("=== Sales Data Analysis ===\n")
    
    # Generate and load data
    df = generate_sample_data()
    df['date'] = pd.to_datetime(df['date'])
    df['total_sales'] = df['quantity'] * df['price']
    
    print(f"Dataset shape: {df.shape}")
    print(f"Date range: {df['date'].min()} to {df['date'].max()}")
    print("\nFirst 5 rows:")
    print(df.head())
    
    print("\n=== Basic Statistics ===")
    print(df.describe())
    
    # Sales by product
    print("\n=== Sales by Product ===")
    product_sales = df.groupby('product').agg({
        'total_sales': ['sum', 'mean', 'count'],
        'quantity': 'sum'
    }).round(2)
    print(product_sales)
    
    # Sales by region
    print("\n=== Sales by Region ===")
    region_sales = df.groupby('region')['total_sales'].sum().sort_values(ascending=False)
    print(region_sales)
    
    # Daily sales trend
    daily_sales = df.groupby('date')['total_sales'].sum()
    
    # Create visualizations
    create_visualizations(df, product_sales, region_sales, daily_sales)
    
    return df

def create_visualizations(df, product_sales, region_sales, daily_sales):
    """Create various charts and visualizations"""
    plt.style.use('default')
    fig, axes = plt.subplots(2, 2, figsize=(15, 12))
    fig.suptitle('Sales Data Analysis Dashboard', fontsize=16, fontweight='bold')
    
    # 1. Daily sales trend
    axes[0, 0].plot(daily_sales.index, daily_sales.values, marker='o', linewidth=2)
    axes[0, 0].set_title('Daily Sales Trend')
    axes[0, 0].set_xlabel('Date')
    axes[0, 0].set_ylabel('Total Sales ($)')
    axes[0, 0].tick_params(axis='x', rotation=45)
    axes[0, 0].grid(True, alpha=0.3)
    
    # 2. Sales by product (bar chart)
    product_totals = df.groupby('product')['total_sales'].sum().sort_values(ascending=True)
    axes[0, 1].barh(product_totals.index, product_totals.values, color='skyblue')
    axes[0, 1].set_title('Total Sales by Product')
    axes[0, 1].set_xlabel('Total Sales ($)')
    
    # 3. Sales by region (pie chart)
    axes[1, 0].pie(region_sales.values, labels=region_sales.index, autopct='%1.1f%%', startangle=90)
    axes[1, 0].set_title('Sales Distribution by Region')
    
    # 4. Customer age distribution
    axes[1, 1].hist(df['customer_age'], bins=15, color='lightgreen', alpha=0.7, edgecolor='black')
    axes[1, 1].set_title('Customer Age Distribution')
    axes[1, 1].set_xlabel('Age')
    axes[1, 1].set_ylabel('Frequency')
    axes[1, 1].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.show()
    
    # Additional analysis
    print("\n=== Advanced Analysis ===")
    
    # Correlation analysis
    numeric_cols = ['quantity', 'price', 'customer_age', 'total_sales']
    correlation_matrix = df[numeric_cols].corr()
    
    plt.figure(figsize=(8, 6))
    plt.imshow(correlation_matrix, cmap='coolwarm', aspect='auto')
    plt.colorbar()
    plt.title('Correlation Matrix')
    plt.xticks(range(len(numeric_cols)), numeric_cols, rotation=45)
    plt.yticks(range(len(numeric_cols)), numeric_cols)
    
    # Add correlation values to the plot
    for i in range(len(numeric_cols)):
        for j in range(len(numeric_cols)):
            plt.text(j, i, f'{correlation_matrix.iloc[i, j]:.2f}', 
                    ha='center', va='center', color='white' if abs(correlation_matrix.iloc[i, j]) > 0.5 else 'black')
    
    plt.tight_layout()
    plt.show()

def numpy_examples():
    """Demonstrate NumPy capabilities"""
    print("\n=== NumPy Examples ===")
    
    # Array operations
    arr = np.array([1, 2, 3, 4, 5])
    print(f"Original array: {arr}")
    print(f"Squared: {arr ** 2}")
    print(f"Mean: {np.mean(arr)}")
    print(f"Standard deviation: {np.std(arr)}")
    
    # Matrix operations
    matrix1 = np.array([[1, 2], [3, 4]])
    matrix2 = np.array([[5, 6], [7, 8]])
    print(f"\nMatrix 1:\n{matrix1}")
    print(f"Matrix 2:\n{matrix2}")
    print(f"Matrix multiplication:\n{np.dot(matrix1, matrix2)}")
    
    # Random data generation
    random_data = np.random.normal(100, 15, 1000)  # Normal distribution
    print(f"\nRandom data stats:")
    print(f"Mean: {np.mean(random_data):.2f}")
    print(f"Std: {np.std(random_data):.2f}")
    print(f"Min: {np.min(random_data):.2f}")
    print(f"Max: {np.max(random_data):.2f}")

if __name__ == "__main__":
    try:
        # Run NumPy examples
        numpy_examples()
        
        # Run data analysis
        df = analyze_sales_data()
        
        print("\n=== Summary ===")
        print(f"Total records analyzed: {len(df)}")
        print(f"Total sales amount: ${df['total_sales'].sum():,.2f}")
        print(f"Average order value: ${df['total_sales'].mean():.2f}")
        print(f"Best selling product: {df.groupby('product')['total_sales'].sum().idxmax()}")
        print(f"Top region: {df.groupby('region')['total_sales'].sum().idxmax()}")
        
    except ImportError as e:
        print(f"Missing required library: {e}")
        print("Please install required packages:")
        print("pip install numpy pandas matplotlib")
    except Exception as e:
        print(f"An error occurred: {e}")