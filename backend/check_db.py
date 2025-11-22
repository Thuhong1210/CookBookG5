import os
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from mycookbook import app, db, User, Recipe

with app.app_context():
    users = User.query.all()
    print(f"Number of users: {len(users)}")
    for user in users:
        print(f"User: {user.username}, Email: {user.email}")

    recipes = Recipe.query.all()
    print(f"Number of recipes: {len(recipes)}")
