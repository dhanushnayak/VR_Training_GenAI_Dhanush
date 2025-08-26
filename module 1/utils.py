"""
Utility functions for Python learning module
"""

import math
import random
from datetime import datetime, timedelta

def calculate_area_circle(radius):
    """Calculate area of a circle"""
    return math.pi * radius ** 2

def calculate_area_rectangle(length, width):
    """Calculate area of a rectangle"""
    return length * width

def generate_random_data(size=10):
    """Generate random data for testing"""
    return [random.randint(1, 100) for _ in range(size)]

def format_currency(amount):
    """Format number as currency"""
    return f"${amount:,.2f}"

def days_until_date(target_date):
    """Calculate days until a target date"""
    if isinstance(target_date, str):
        target_date = datetime.strptime(target_date, '%Y-%m-%d').date()
    
    today = datetime.now().date()
    delta = target_date - today
    return delta.days

class Calculator:
    """Simple calculator class"""
    
    @staticmethod
    def add(a, b):
        return a + b
    
    @staticmethod
    def subtract(a, b):
        return a - b
    
    @staticmethod
    def multiply(a, b):
        return a * b
    
    @staticmethod
    def divide(a, b):
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b

if __name__ == "__main__":
    # Test the functions
    print("Testing utility functions:")
    print(f"Circle area (r=5): {calculate_area_circle(5):.2f}")
    print(f"Rectangle area (4x6): {calculate_area_rectangle(4, 6)}")
    print(f"Random data: {generate_random_data(5)}")
    print(f"Currency format: {format_currency(1234.56)}")
    
    calc = Calculator()
    print(f"Calculator test: 10 + 5 = {calc.add(10, 5)}")