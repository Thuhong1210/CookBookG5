from backend.mycookbook import app, db
from sqlalchemy import text, inspect
import datetime

def update_schema():
    with app.app_context():
        print("Updating database schema for MySQL...")
        print(f"Database URI: {app.config.get('SQLALCHEMY_DATABASE_URI', 'Not set')}")
        
        inspector = inspect(db.engine)
        
        # 1. Add is_online to user table if not exists
        try:
            columns = [col['name'] for col in inspector.get_columns('user')]
            if 'is_online' not in columns:
                print("Adding is_online column to user table...")
                with db.engine.connect() as conn:
                    conn.execute(text("ALTER TABLE user ADD COLUMN is_online TINYINT(1) DEFAULT 0"))
                    conn.commit()
                print("✓ is_online column added successfully.")
            else:
                print("✓ is_online column already exists.")
        except Exception as e:
            print(f"Error checking/adding is_online column: {e}")

        # 2. Create settings table if not exists
        try:
            tables = inspector.get_table_names()
            if 'settings' not in tables:
                print("Creating settings table...")
                create_settings_table_sql = """
                CREATE TABLE settings (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    `key` VARCHAR(100) NOT NULL UNIQUE,
                    value TEXT,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    created_by INT,
                    updated_by INT,
                    FOREIGN KEY (created_by) REFERENCES user(id) ON DELETE SET NULL,
                    FOREIGN KEY (updated_by) REFERENCES user(id) ON DELETE SET NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
                """
                
                with db.engine.connect() as conn:
                    conn.execute(text(create_settings_table_sql))
                    conn.commit()
                print("✓ Settings table created successfully.")
                
                # Seed default settings
                print("Seeding default settings...")
                default_settings = [
                    ('site_name', 'FlavorVerse'),
                    ('site_tagline', 'Share and Discover Amazing Recipes'),
                    ('theme_color', '#ff7b00'),
                    ('allow_registration', 'true'),
                    ('public_access', 'true'),
                    ('recipes_per_page', '12'),
                    ('auto_approve_recipes', 'false'),
                    ('allow_comments', 'true'),
                    ('allow_ratings', 'true'),
                    ('email_notifications', 'true'),
                    ('new_recipe_alerts', 'true'),
                    ('report_alerts', 'true'),
                    ('maintenance_mode', 'false'),
                    ('backup_frequency', 'weekly'),
                    ('debug_mode', 'false'),
                    ('log_level', 'INFO')
                ]
                
                with db.engine.connect() as conn:
                    for key, value in default_settings:
                        conn.execute(
                            text("INSERT INTO settings (`key`, value) VALUES (:key, :value)"),
                            {"key": key, "value": value}
                        )
                    conn.commit()
                print("✓ Default settings seeded successfully.")
            else:
                print("✓ Settings table already exists.")
        except Exception as e:
            print(f"Error creating settings table: {e}")
            
        print("\n✓ Schema update completed successfully!")

if __name__ == "__main__":
    update_schema()
