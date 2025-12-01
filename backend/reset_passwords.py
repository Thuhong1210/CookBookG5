#!/usr/bin/env python3
"""
Password Reset Script for FlavorVerse
Resets all user passwords from incompatible scrypt format to PBKDF2 format.
"""
import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Add parent directory to path to import mycookbook
sys.path.insert(0, os.path.dirname(__file__))

from mycookbook import app, db, User
from werkzeug.security import generate_password_hash

# Default passwords for users
DEFAULT_PASSWORDS = {
    'admin': '123',
    'ChefGordon': 'password123',
    'JamieO': 'password123',
    'NigellaB': 'password123',
    'UncleRoger': 'password123',
    'Maangchi': 'password123',
    'Babish': 'password123',
    'JoshuaW': 'password123',
    'KenjiL': 'password123',
    'SaminN': 'password123',
    'DavidChang': 'password123',
    'JuliaChild': 'password123',
    'AnthonyB': 'password123',
    'MarthaS': 'password123',
    'GuyFieri': 'password123',
    'RachaelRay': 'password123',
}

def reset_passwords():
    """Reset all user passwords to PBKDF2 format"""
    print("=" * 70)
    print("FlavorVerse Password Reset Script")
    print("=" * 70)
    print()
    
    with app.app_context():
        # Get all users with scrypt hashes
        users = User.query.filter(User.password_hash.like('scrypt:%')).all()
        
        if not users:
            print("✅ No users with scrypt password hashes found.")
            print("All passwords are already in compatible format.")
            return
        
        print(f"Found {len(users)} user(s) with incompatible scrypt password hashes:")
        for user in users:
            print(f"  - {user.username} (ID: {user.id})")
        print()
        
        # Confirm action
        print("⚠️  This will reset passwords for all users listed above.")
        print()
        response = input("Do you want to proceed? (yes/no): ").strip().lower()
        
        if response not in ['yes', 'y']:
            print("❌ Password reset cancelled.")
            return
        
        print()
        print("Resetting passwords...")
        print("-" * 70)
        
        reset_count = 0
        for user in users:
            # Get default password for this user
            new_password = DEFAULT_PASSWORDS.get(user.username, 'password123')
            
            # Generate new PBKDF2 hash
            new_hash = generate_password_hash(new_password)
            
            # Update user password
            user.password_hash = new_hash
            
            print(f"✅ Reset password for: {user.username}")
            print(f"   New password: {new_password}")
            print(f"   Hash format: {new_hash[:20]}...")
            print()
            
            reset_count += 1
        
        # Commit changes
        try:
            db.session.commit()
            print("-" * 70)
            print(f"✅ Successfully reset {reset_count} password(s)!")
            print()
            print("📝 Login Credentials:")
            print("   Admin:")
            print("     Username: admin")
            print("     Password: 123")
            print()
            print("   Other users:")
            print("     Password: password123")
            print()
            print("🚀 You can now log in at http://localhost:8000/login")
            
        except Exception as e:
            db.session.rollback()
            print(f"❌ Error committing changes: {str(e)}")
            print("Database rolled back. No changes were made.")
            return
    
    print("=" * 70)

if __name__ == '__main__':
    reset_passwords()
