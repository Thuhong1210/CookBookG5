#!/usr/bin/env python3
"""
Verify database tables and show their structure
"""
import sys
import os

# Add backend to path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(BASE_DIR, 'backend')
sys.path.insert(0, BACKEND_DIR)

from mycookbook import app, db
from sqlalchemy import inspect, text

def verify_tables():
    """Verify database tables structure"""
    with app.app_context():
        inspector = inspect(db.engine)
        
        print("Checking 'report' table structure...")
        if 'report' not in inspector.get_table_names():
            print("✗ 'report' table does NOT exist!")
            return
        
        columns = inspector.get_columns('report')
        print(f"\n✓ 'report' table exists with {len(columns)} columns:")
        for col in columns:
            print(f"  - {col['name']} ({col['type']})")
        
        # Try a simple query
        print("\nTesting query on 'report' table...")
        try:
            result = db.session.execute(text("SELECT COUNT(*) as cnt FROM report")).first()
            print(f"✓ Query successful! Found {result[0]} reports in database")
        except Exception as e:
            print(f"✗ Query failed: {e}")
        
        # Check other tables
        for table in ['category', 'tag', 'recipe_tags']:
            if table in inspector.get_table_names():
                cols = inspector.get_columns(table)
                print(f"\n✓ '{table}' table exists with {len(cols)} columns")
            else:
                print(f"\n✗ '{table}' table NOT FOUND")

if __name__ == '__main__':
    verify_tables()
