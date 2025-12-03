#!/usr/bin/env python3
import sys
import os
from pprint import pprint

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from mycookbook import app, db, User, Recipe, Comment, generate_password_hash


def ensure_test_data():
    # Ensure at least one user and one recipe exist
    user = User.query.filter_by(username='apitestuser').first()
    if not user:
        user = User(username='apitestuser', email='apitest@example.com', password_hash=generate_password_hash('testpass'))
        db.session.add(user)
        db.session.commit()

    recipe = Recipe.query.first()
    if not recipe:
        recipe = Recipe(title='API Test Recipe', description='For API tests', ingredients='ing', instructions='do', cooking_time=10, difficulty='easy', category='test', recipe_type='food', image_url='', user_id=user.id, status='approved')
        db.session.add(recipe)
        db.session.commit()

    return user, recipe


def run_tests():
    results = []
    with app.app_context():
        user, recipe = ensure_test_data()

        client = app.test_client()

        # Public endpoints
        r = client.get('/')
        results.append(('/', r.status_code))

        r = client.get('/allrecipes.html')
        results.append(('/allrecipes.html', r.status_code))

        r = client.get(f'/recipe/{recipe.id}')
        results.append((f'/recipe/{recipe.id}', r.status_code))

        # Protected endpoints should redirect to login when not authenticated
        r = client.get('/admin/comments')
        results.append(('/admin/comments (no auth)', r.status_code))

        r = client.get('/api/notifications')
        results.append(('/api/notifications (no auth)', r.status_code))

        # Try posting a comment without login -> expect redirect (302)
        r = client.post(f'/recipe/{recipe.id}/comment', data={'comment': 'Unauth comment test'})
        results.append((f'POST /recipe/{recipe.id}/comment (no auth)', r.status_code))

        # Login
        login_data = {'identifier': user.username, 'password': 'testpass'}
        r = client.post('/login', data=login_data, follow_redirects=True)
        results.append(('/login (post)', r.status_code))

        # Now post comment authenticated
        r = client.post(f'/recipe/{recipe.id}/comment', data={'comment': 'API test comment'}, follow_redirects=False)
        results.append((f'POST /recipe/{recipe.id}/comment (auth)', r.status_code))

        # If comment created, list latest comment for recipe
        latest_comment = Comment.query.filter_by(recipe_id=recipe.id).order_by(Comment.created_at.desc()).first()
        results.append(('latest_comment_found', bool(latest_comment)))

    print('\nAPI Test Results:')
    for name, status in results:
        print(f'- {name}: {status}')


if __name__ == '__main__':
    run_tests()
