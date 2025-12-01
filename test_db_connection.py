import os
import sys
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

from mycookbook import app, db

def test_connection():
    """Test database connection"""
    try:
        with app.app_context():
            # Print configuration
            print("=" * 60)
            print("🔧 DATABASE CONFIGURATION")
            print("=" * 60)
            print(f"USE_MYSQL: {os.getenv('USE_MYSQL')}")
            print(f"MYSQL_HOST: {os.getenv('MYSQL_HOST')}")
            print(f"MYSQL_PORT: {os.getenv('MYSQL_PORT')}")
            print(f"MYSQL_USER: {os.getenv('MYSQL_USER')}")
            print(f"MYSQL_DB: {os.getenv('MYSQL_DB')}")
            print(f"Database URI: {app.config['SQLALCHEMY_DATABASE_URI']}")
            print("=" * 60)
            print()
            
            # Try to execute a simple query
            result = db.session.execute(db.text("SELECT 1"))
            print("✅ Database connection successful!")
            print()
            
            # Check if tables exist
            from sqlalchemy import inspect
            inspector = inspect(db.engine)
            tables = inspector.get_table_names()
            print(f"📋 Found {len(tables)} tables:")
            for table in tables:
                print(f"   - {table}")
            print()
            
            # Count records
            from mycookbook import User, Recipe, Comment, Rating, Favorite
            user_count = User.query.count()
            recipe_count = Recipe.query.count()
            comment_count = Comment.query.count()
            rating_count = Rating.query.count()
            favorite_count = Favorite.query.count()
            
            print("📊 DATABASE STATISTICS")
            print("=" * 60)
            print(f"👥 Users: {user_count}")
            print(f"🍳 Recipes: {recipe_count}")
            print(f"💬 Comments: {comment_count}")
            print(f"⭐ Ratings: {rating_count}")
            print(f"❤️  Favorites: {favorite_count}")
            print("=" * 60)
            print()
            
            # Check database type
            db_type = db.engine.dialect.name
            if db_type == 'mysql':
                print("✅ Connected to MySQL database!")
            elif db_type == 'sqlite':
                print("⚠️  Connected to SQLite database (not MySQL)")
            else:
                print(f"ℹ️  Connected to {db_type} database")
            
            return True
    except Exception as e:
        print("❌ Database connection failed!")
        print(f"Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    test_connection()
