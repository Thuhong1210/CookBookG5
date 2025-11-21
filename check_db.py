import os
import sys
sys.path.insert(0, os.getcwd())

from mycookbook import app, db, User, Recipe

with app.app_context():
    users = User.query.all()
    print(f"Number of users: {len(users)}")
    for user in users:
        print(f"User: {user.username}, Email: {user.email}")

    recipes = Recipe.query.all()
    print(f"Number of recipes: {len(recipes)}")
