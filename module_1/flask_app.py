"""
Simple Flask web application example
Run with: python flask_app.py
"""

from flask import Flask, render_template_string, request, jsonify
import json
from datetime import datetime

app = Flask(__name__)

# Sample data
users = [
    {"id": 1, "name": "Alice", "email": "alice@example.com", "age": 25},
    {"id": 2, "name": "Bob", "email": "bob@example.com", "age": 30},
    {"id": 3, "name": "Charlie", "email": "charlie@example.com", "age": 35}
]

# HTML template
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Python Learning - Flask Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .user-card { border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .nav { background: #333; padding: 10px; margin-bottom: 20px; }
        .nav a { color: white; text-decoration: none; margin-right: 20px; }
        form { background: #f5f5f5; padding: 20px; border-radius: 5px; }
        input, button { margin: 5px 0; padding: 8px; }
        button { background: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="/">Home</a>
            <a href="/users">Users</a>
            <a href="/add-user">Add User</a>
            <a href="/api/users">API</a>
        </div>
        
        {% if page == 'home' %}
        <h1>Welcome to Flask Demo</h1>
        <p>This is a simple Flask application demonstrating:</p>
        <ul>
            <li>Routing and templates</li>
            <li>Form handling</li>
            <li>JSON API endpoints</li>
            <li>Data management</li>
        </ul>
        <p>Current time: {{ current_time }}</p>
        
        {% elif page == 'users' %}
        <h1>User List</h1>
        {% for user in users %}
        <div class="user-card">
            <h3>{{ user.name }}</h3>
            <p>Email: {{ user.email }}</p>
            <p>Age: {{ user.age }}</p>
        </div>
        {% endfor %}
        
        {% elif page == 'add_user' %}
        <h1>Add New User</h1>
        <form method="POST">
            <div>
                <label>Name:</label><br>
                <input type="text" name="name" required>
            </div>
            <div>
                <label>Email:</label><br>
                <input type="email" name="email" required>
            </div>
            <div>
                <label>Age:</label><br>
                <input type="number" name="age" required>
            </div>
            <div>
                <button type="submit">Add User</button>
            </div>
        </form>
        {% if message %}
        <p style="color: green;">{{ message }}</p>
        {% endif %}
        {% endif %}
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_TEMPLATE, 
                                page='home', 
                                current_time=datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

@app.route('/users')
def show_users():
    return render_template_string(HTML_TEMPLATE, 
                                page='users', 
                                users=users)

@app.route('/add-user', methods=['GET', 'POST'])
def add_user():
    message = None
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        age = int(request.form.get('age'))
        
        new_user = {
            "id": len(users) + 1,
            "name": name,
            "email": email,
            "age": age
        }
        users.append(new_user)
        message = f"User {name} added successfully!"
    
    return render_template_string(HTML_TEMPLATE, 
                                page='add_user', 
                                message=message)

# API Endpoints
@app.route('/api/users', methods=['GET'])
def api_get_users():
    return jsonify({"users": users, "count": len(users)})

@app.route('/api/users/<int:user_id>', methods=['GET'])
def api_get_user(user_id):
    user = next((u for u in users if u['id'] == user_id), None)
    if user:
        return jsonify({"user": user})
    return jsonify({"error": "User not found"}), 404

@app.route('/api/users', methods=['POST'])
def api_add_user():
    data = request.get_json()
    if not data or not all(k in data for k in ['name', 'email', 'age']):
        return jsonify({"error": "Missing required fields"}), 400
    
    new_user = {
        "id": len(users) + 1,
        "name": data['name'],
        "email": data['email'],
        "age": data['age']
    }
    users.append(new_user)
    return jsonify({"user": new_user, "message": "User created"}), 201

@app.route('/api/stats')
def api_stats():
    if not users:
        return jsonify({"message": "No users found"})
    
    ages = [user['age'] for user in users]
    stats = {
        "total_users": len(users),
        "average_age": sum(ages) / len(ages),
        "min_age": min(ages),
        "max_age": max(ages)
    }
    return jsonify(stats)

if __name__ == '__main__':
    print("Starting Flask application...")
    print("Visit http://localhost:5000 to see the app")
    print("API endpoints:")
    print("  GET /api/users - Get all users")
    print("  GET /api/users/<id> - Get specific user")
    print("  POST /api/users - Add new user")
    print("  GET /api/stats - Get user statistics")
    
    app.run(debug=True, host='0.0.0.0', port=5000)