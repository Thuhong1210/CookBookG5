#!/usr/bin/env python3
"""
Database migration script to create Report, Category, and Tag tables
"""
import sys
import os

# Add backend to path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(BASE_DIR, 'backend')
sys.path.insert(0, BACKEND_DIR)

from mycookbook import app, db

def create_tables():
    """Create all new tables"""
    with app.app_context():
        print("Creating new database tables...")
        
        # This will create all tables defined in models
        db.create_all()
        
        print("✓ Tables created successfully!")
        print("\nVerifying tables...")
        
        # Verify tables exist
        from sqlalchemy import inspect
        inspector = inspect(db.engine)
        tables = inspector.get_table_names()
        
        required_tables = ['report', 'category', 'tag', 'recipe_tags']
        for table in required_tables:
            if table in tables:
                print(f"✓ Table '{table}' exists")
            else:
                print(f"✗ Table '{table}' NOT FOUND")
        
        print("\nAll done! Server can now be restarted.")

if __name__ == '__main__':
    create_tables()
