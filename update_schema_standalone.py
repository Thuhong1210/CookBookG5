import pymysql
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def update_schema():
    print("Updating database schema for MySQL...")
    
    # Connect to MySQL
    connection = pymysql.connect(
        host=os.getenv('MYSQL_HOST', '127.0.0.1'),
        port=int(os.getenv('MYSQL_PORT', 3306)),
        user=os.getenv('MYSQL_USER', 'root'),
        password=os.getenv('MYSQL_PASSWORD', ''),
        database=os.getenv('MYSQL_DB', 'Mycookbook_db'),
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    
    try:
        with connection.cursor() as cursor:
            # 1. Check if is_online column exists in user table
            cursor.execute("""
                SELECT COUNT(*) as count 
                FROM information_schema.COLUMNS 
                WHERE TABLE_SCHEMA = %s 
                AND TABLE_NAME = 'user' 
                AND COLUMN_NAME = 'is_online'
            """, (os.getenv('MYSQL_DB', 'Mycookbook_db'),))
            
            result = cursor.fetchone()
            if result['count'] == 0:
                print("Adding is_online column to user table...")
                cursor.execute("ALTER TABLE user ADD COLUMN is_online TINYINT(1) DEFAULT 0")
                connection.commit()
                print("✓ is_online column added successfully.")
            else:
                print("✓ is_online column already exists.")
            
            # 2. Check if settings table exists
            cursor.execute("""
                SELECT COUNT(*) as count 
                FROM information_schema.TABLES 
                WHERE TABLE_SCHEMA = %s 
                AND TABLE_NAME = 'settings'
            """, (os.getenv('MYSQL_DB', 'Mycookbook_db'),))
            
            result = cursor.fetchone()
            if result['count'] == 0:
                print("Creating settings table...")
                cursor.execute("""
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
                """)
                connection.commit()
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
                
                for key, value in default_settings:
                    cursor.execute(
                        "INSERT INTO settings (`key`, value) VALUES (%s, %s)",
                        (key, value)
                    )
                connection.commit()
                print("✓ Default settings seeded successfully.")
            else:
                print("✓ Settings table already exists.")
                
        print("\n✓ Schema update completed successfully!")
        
    except Exception as e:
        print(f"Error updating schema: {e}")
        connection.rollback()
    finally:
        connection.close()

if __name__ == "__main__":
    update_schema()
