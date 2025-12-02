from backend.mycookbook import app, db, User, Setting

def verify_backend():
    print("Verifying backend code...")
    try:
        with app.app_context():
            # Check User model
            if hasattr(User, 'is_online'):
                print("User model has is_online field.")
            else:
                print("ERROR: User model missing is_online field.")
            
            # Check Setting model
            settings_count = Setting.query.count()
            print(f"Setting model is accessible. Count: {settings_count}")
            
            print("Backend verification successful.")
    except Exception as e:
        print(f"Backend verification failed: {e}")

if __name__ == "__main__":
    verify_backend()
