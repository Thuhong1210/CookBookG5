#!/usr/bin/env python3
"""
Seed data directly to XAMPP MySQL database (Mycookbook_db)
This script explicitly connects to XAMPP MySQL, ignoring .env
"""
import pymysql
from datetime import datetime

# XAMPP MySQL connection settings
MYSQL_CONFIG = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': '',
    'database': 'Mycookbook_db',
    'port': 3306,
    'autocommit': True
}

def execute_sql(cursor, sql):
    """Execute SQL and handle errors"""
    try:
        cursor.execute(sql)
        return True
    except Exception as e:
        print(f"  ⚠️  Error: {e}")
        return False

def seed_xampp_mysql():
    """Seed data directly to XAMPP MySQL"""
    print("=" * 60)
    print("CONNECTING TO XAMPP MYSQL (Mycookbook_db)")
    print("=" * 60)
    
    try:
        conn = pymysql.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()
        print(f"✓ Connected to XAMPP MySQL at {MYSQL_CONFIG['host']}:{MYSQL_CONFIG['port']}")
        print(f"✓ Database: {MYSQL_CONFIG['database']}")
        
        # Get admin user ID
        cursor.execute("SELECT id FROM user WHERE is_admin = 1 LIMIT 1")
        admin_row = cursor.fetchone()
        admin_id = admin_row[0] if admin_row else 1
        print(f"\n✓ Using admin ID: {admin_id}")
        
        # ============ SEED CATEGORIES ============
        print("\n" + "=" * 60)
        print("SEEDING CATEGORIES")
        print("=" * 60)
        
        categories = [
            ('Món Ăn Việt Nam', 'mon-an-viet-nam', 'Các món ăn truyền thống Việt Nam như phở, bún, bánh mì', 'fa-bowl-rice', '#FF6B6B'),
            ('Món Ý', 'mon-y', 'Pizza, pasta và các món ăn Italy classics', 'fa-pizza-slice', '#4ECDC4'),
            ('Món Nhật', 'mon-nhat', 'Sushi, ramen và các món ăn Nhật Bản', 'fa-fish', '#95E1D3'),
            ('Healthy Food', 'healthy-food', 'Món ăn healthy, ít calo, nhiều dinh dưỡng', 'fa-leaf', '#45B7D1'),
            ('Desserts', 'desserts', 'Các loại bánh ngọt, tráng miệng', 'fa-ice-cream', '#FFA07A'),
            ('Đồ Uống', 'do-uong', 'Sinh tố, nước ép, cocktails', 'fa-mug-hot', '#9B59B6')
        ]
        
        for name, slug, desc, icon, color in categories:
            # Check if exists
            cursor.execute("SELECT id FROM category WHERE slug = %s", (slug,))
            if cursor.fetchone():
                print(f"  ⊙ Category '{name}' already exists (skipping)")
            else:
                sql = """
                INSERT INTO category (name, slug, description, icon, color, created_by)
                VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (name, slug, desc, icon, color, admin_id))
                print(f"  ✓ Created category: {name}")
        
        # Count categories
        cursor.execute("SELECT COUNT(*) FROM category")
        cat_count = cursor.fetchone()[0]
        print(f"\n✓ Categories in database: {cat_count}")
        
        # ============ SEED TAGS ============
        print("\n" + "=" * 60)
        print("SEEDING TAGS")
        print("=" * 60)
        
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
            ('Comfort Food', 'comfort-food', 'Món ăn dân dã, quen thuộc')
        ]
        
        for name, slug, desc in tags:
            cursor.execute("SELECT id FROM tag WHERE slug = %s", (slug,))
            if cursor.fetchone():
                print(f"  ⊙ Tag '{name}' already exists (skipping)")
            else:
                sql = "INSERT INTO tag (name, slug, description) VALUES (%s, %s, %s)"
                cursor.execute(sql, (name, slug, desc))
                print(f"  ✓ Created tag: {name}")
        
        # Count tags
        cursor.execute("SELECT COUNT(*) FROM tag")
        tag_count = cursor.fetchone()[0]
        print(f"\n✓ Tags in database: {tag_count}")
        
        # ============ SEED REPORTS ============
        print("\n" + "=" * 60)
        print("SEEDING REPORTS")
        print("=" * 60)
        
        # Get first 3 recipe IDs
        cursor.execute("SELECT id FROM recipe LIMIT 3")
        recipe_ids = [row[0] for row in cursor.fetchall()]
        
        # Get a non-admin user ID
        cursor.execute("SELECT id FROM user WHERE is_admin = 0 LIMIT 1")
        user_row = cursor.fetchone()
        user_id = user_row[0] if user_row else admin_id
        
        if recipe_ids:
            reports = [
                (user_id, recipe_ids[0] if len(recipe_ids) > 0 else None, None, 'recipe', 'Hình ảnh không phù hợp', 'Công thức này có hình ảnh không liên quan đến món ăn, cần kiểm tra lại.', 'pending'),
                (user_id, recipe_ids[1] if len(recipe_ids) > 1 else None, None, 'recipe', 'Thông tin sai lệch', 'Nguyên liệu và cách làm không chính xác, có thể gây nguy hiểm cho người dùng.', 'pending'),
                (user_id, recipe_ids[2] if len(recipe_ids) > 2 else None, None, 'recipe', 'Vi phạm bản quyền', 'Công thức này copy từ nguồn khác mà không ghi nguồn.', 'resolved'),
                (user_id, None, None, 'comment', 'Bình luận spam', 'Có người đang spam quảng cáo trong phần bình luận.', 'dismissed'),
                (user_id, None, None, 'user', 'Hành vi quấy rối', 'User này liên tục comment tiêu cực và quấy rối người dùng khác.', 'pending')
            ]
            
            for uid, rid, ruid, rtype, title, desc, status in reports:
                # Check if exists
                cursor.execute("SELECT id FROM report WHERE user_id = %s AND title = %s", (uid, title))
                if cursor.fetchone():
                    print(f"  ⊙ Report '{title}' already exists (skipping)")
                else:
                    sql = """
                    INSERT INTO report (user_id, recipe_id, reported_user_id, report_type, title, description, status)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    """
                    cursor.execute(sql, (uid, rid, ruid, rtype, title, desc, status))
                    print(f"  ✓ Created report: {title} ({status})")
        else:
            print("  ⚠️  No recipes found! Skipping report seeding...")
        
        # Count reports
        cursor.execute("SELECT COUNT(*) FROM report")
        report_count = cursor.fetchone()[0]
        print(f"\n✓ Reports in database: {report_count}")
        
        # ============ SUMMARY ============
        print("\n" + "=" * 60)
        print("SEEDING COMPLETED!")
        print("=" * 60)
        print(f"✓ Categories: {cat_count}")
        print(f"✓ Tags: {tag_count}")
        print(f"✓ Reports: {report_count}")
        print("\nXAMPP MySQL (Mycookbook_db) has been seeded successfully!")
        print("\nRefresh your browser and test the admin features at:")
        print("  - http://127.0.0.1:8000/admin/categories")
        print("  - http://127.0.0.1:8000/admin/reports")
        print("=" * 60)
        
        cursor.close()
        conn.close()
        
    except pymysql.Error as e:
        print(f"\n✗ MySQL Error: {e}")
        print("\n⚠️  Make sure XAMPP MySQL is running!")
        print("⚠️  Make sure database 'Mycookbook_db' exists!")
        return False
    
    return True

if __name__ == '__main__':
    seed_xampp_mysql()
