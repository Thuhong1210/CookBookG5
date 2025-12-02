#!/usr/bin/env python3
"""
Fix Database Schema and Seed Data in XAMPP MySQL
"""
import pymysql
import sys

# XAMPP MySQL connection settings
MYSQL_CONFIG = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': '',
    'database': 'Mycookbook_db',
    'port': 3306,
    'autocommit': True
}

def fix_and_seed():
    print("=" * 60)
    print("FIXING DATABASE SCHEMA IN XAMPP MYSQL")
    print("=" * 60)
    
    try:
        conn = pymysql.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()
        print(f"✓ Connected to {MYSQL_CONFIG['database']}")
        
        # 1. Disable Foreign Key Checks to allow dropping tables
        print("\n1. Disabling Foreign Key Checks...")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
        
        # 2. Drop incorrect tables
        print("2. Dropping tables with incorrect schema...")
        tables_to_drop = ['recipe_tags', 'report', 'category', 'tag']
        for table in tables_to_drop:
            cursor.execute(f"DROP TABLE IF EXISTS {table}")
            print(f"   - Dropped {table}")
            
        # 3. Recreate tables with CORRECT schema
        print("\n3. Recreating tables...")
        
        # Category
        cursor.execute("""
            CREATE TABLE category (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL UNIQUE,
                slug VARCHAR(100) NOT NULL UNIQUE,
                description TEXT NULL,
                icon VARCHAR(50) NULL,
                color VARCHAR(20) NULL,
                created_by INT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (created_by) REFERENCES user(id)
            )
        """)
        print("   ✓ Created 'category' table (with created_by)")

        # Tag
        cursor.execute("""
            CREATE TABLE tag (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(50) NOT NULL UNIQUE,
                slug VARCHAR(50) NOT NULL UNIQUE,
                description TEXT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        """)
        print("   ✓ Created 'tag' table")

        # Report
        cursor.execute("""
            CREATE TABLE report (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                recipe_id INT NULL,
                reported_user_id INT NULL,
                report_type VARCHAR(20) NOT NULL,
                title VARCHAR(200) NOT NULL,
                description TEXT NOT NULL,
                status VARCHAR(20) NOT NULL DEFAULT 'pending',
                resolved_by INT NULL,
                resolved_at DATETIME NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES user(id),
                FOREIGN KEY (recipe_id) REFERENCES recipe(id),
                FOREIGN KEY (reported_user_id) REFERENCES user(id),
                FOREIGN KEY (resolved_by) REFERENCES user(id)
            )
        """)
        print("   ✓ Created 'report' table (with user_id)")

        # Recipe Tags
        cursor.execute("""
            CREATE TABLE recipe_tags (
                recipe_id INT NOT NULL,
                tag_id INT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (recipe_id, tag_id),
                FOREIGN KEY (recipe_id) REFERENCES recipe(id) ON DELETE CASCADE,
                FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE
            )
        """)
        print("   ✓ Created 'recipe_tags' table")

        # 4. Re-enable Foreign Key Checks
        print("\n4. Re-enabling Foreign Key Checks...")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
        
        # 5. Seed Data
        print("\n5. Seeding Sample Data...")
        
        # Get admin ID
        cursor.execute("SELECT id FROM user WHERE is_admin = 1 LIMIT 1")
        admin_row = cursor.fetchone()
        admin_id = admin_row[0] if admin_row else 1
        
        # Seed Categories
        categories = [
            ('Món Ăn Việt Nam', 'mon-an-viet-nam', 'Các món ăn truyền thống Việt Nam', 'fa-bowl-rice', '#FF6B6B'),
            ('Món Ý', 'mon-y', 'Pizza, pasta và các món ăn Italy', 'fa-pizza-slice', '#4ECDC4'),
            ('Món Nhật', 'mon-nhat', 'Sushi, ramen và các món ăn Nhật Bản', 'fa-fish', '#95E1D3'),
            ('Healthy Food', 'healthy-food', 'Món ăn healthy, ít calo', 'fa-leaf', '#45B7D1'),
            ('Desserts', 'desserts', 'Các loại bánh ngọt, tráng miệng', 'fa-ice-cream', '#FFA07A'),
            ('Đồ Uống', 'do-uong', 'Sinh tố, nước ép, cocktails', 'fa-mug-hot', '#9B59B6')
        ]
        for c in categories:
            try:
                cursor.execute("INSERT INTO category (name, slug, description, icon, color, created_by) VALUES (%s, %s, %s, %s, %s, %s)", (*c, admin_id))
            except pymysql.IntegrityError:
                pass # Skip duplicates
        print(f"   ✓ Seeded {len(categories)} categories")

        # Seed Tags
        tags = [
            ('Vegetarian', 'vegetarian', 'Món chay, không thịt'),
            ('Vegan', 'vegan', 'Hoàn toàn thuần chay'),
            ('Quick & Easy', 'quick-easy', 'Nấu nhanh dưới 30 phút'),
            ('Spicy', 'spicy', 'Món ăn cay'),
            ('Gluten-Free', 'gluten-free', 'Không chứa gluten'),
            ('Low Carb', 'low-carb', 'Ít tinh bột'),
            ('High Protein', 'high-protein', 'Nhiều protein'),
            ('Budget-Friendly', 'budget-friendly', 'Tiết kiệm chi phí'),
            ('Party Food', 'party-food', 'Món ăn tiệc tùng'),
            ('Comfort Food', 'comfort-food', 'Món ăn dân dã')
        ]
        for t in tags:
            try:
                cursor.execute("INSERT INTO tag (name, slug, description) VALUES (%s, %s, %s)", t)
            except pymysql.IntegrityError:
                pass
        print(f"   ✓ Seeded {len(tags)} tags")

        # Seed Reports
        # Need valid user and recipe IDs
        cursor.execute("SELECT id FROM user LIMIT 1")
        user_res = cursor.fetchone()
        user_id = user_res[0] if user_res else admin_id
        
        cursor.execute("SELECT id FROM recipe LIMIT 1")
        recipe_res = cursor.fetchone()
        recipe_id = recipe_res[0] if recipe_res else None

        if recipe_id:
            reports = [
                (user_id, recipe_id, None, 'recipe', 'Hình ảnh không phù hợp', 'Công thức này có hình ảnh không liên quan', 'pending'),
                (user_id, recipe_id, None, 'recipe', 'Thông tin sai lệch', 'Nguyên liệu và cách làm không chính xác', 'pending'),
                (user_id, None, None, 'comment', 'Bình luận spam', 'Spam quảng cáo', 'dismissed')
            ]
            for r in reports:
                cursor.execute("INSERT INTO report (user_id, recipe_id, reported_user_id, report_type, title, description, status) VALUES (%s, %s, %s, %s, %s, %s, %s)", r)
            print(f"   ✓ Seeded {len(reports)} reports")
        else:
            print("   ⚠️ No recipes found, skipping report seeding")

        print("\n" + "=" * 60)
        print("✅ SUCCESS! Database schema fixed and data seeded.")
        print("=" * 60)
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"\n✗ Error: {e}")

if __name__ == '__main__':
    fix_and_seed()
