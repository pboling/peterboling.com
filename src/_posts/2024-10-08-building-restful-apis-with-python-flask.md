---
layout: post
title: "Building RESTful APIs with Python Flask"
date: 2024-10-08 09:15:00 +0000
categories: python
---

Flask is a lightweight Python web framework perfect for building RESTful APIs. In this tutorial, we'll create a simple API.

## Why Flask?

Flask is minimalist and flexible, making it ideal for:
- Small to medium-sized applications
- RESTful API development
- Prototyping
- Learning web development

## Setting Up

First, install Flask:

```bash
pip install flask
```

## Creating a Simple API

Here's a basic Flask API:

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/api/users', methods=['GET'])
def get_users():
    users = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'}
    ]
    return jsonify(users)

@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    # Fetch user from database
    user = {'id': user_id, 'name': 'User ' + str(user_id)}
    return jsonify(user)

if __name__ == '__main__':
    app.run(debug=True)
```

## Running the API

Run your Flask application:

```bash
python app.py
```

Your API is now available at `http://localhost:5000/api/users`.

## Best Practices

- Use blueprints for larger applications
- Implement proper error handling
- Add authentication and authorization
- Document your API with Swagger/OpenAPI

Flask makes API development simple and enjoyable!
