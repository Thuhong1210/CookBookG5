#!/usr/bin/env python3
"""
Seed sample data for Report and Category/Tag Management features
Ensures connection to XAMPP MySQL (Mycookbook_db)
"""
import sys
import os
from datetime import datetime

# Add backend to path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(BASE_DIR, 'backend')
sys.path.insert(0, BACKEND_DIR)

from mycookbook import app, db, Report, Category, Tag, Recipe, User

def verify_connection():
    """Verify database connection"""
    with app.app_context():
        try:
            # Test connection
            db.session.execute(db.text('SELECT 1'))
            db_url = str(db.engine.url)
            print(f"✓ Connected to database: {db_url}")
            return True
        except Exception as e:
            print(f"✗ Database connection failed: {e}")
            return False

def seed_data():
    """Seed sample data for testing"""
    with app.app_context():
        print("=" * 60)
        print("SEEDING SAMPLE DATA FOR ADMIN FEATURES")
        print("=" * 60)
        
        if not verify_connection():
            print("\n⚠️  Cannot connect to database! Check XAMPP MySQL service.")
            return
        
        # Create tables if they don't exist
        print("\nCreating tables if they don't exist...")
        db.create_all()
        print("✓ Tables checked/created")
        
        # Get admin user (ID 1)
        admin = User.query.filter_by(is_admin=True).first()
        if not admin:
            print("⚠️  No admin user found! Creating default admin...")
            from werkzeug.security import generate_password_hash
            admin = User(
                username='admin',
                email='admin@example.com',
                password_hash=generate_password_hash('123'),
                is_admin=True
            )
            db.session.add(admin)
            db.session.commit()
        
        print(f"\n✓ Using admin user: {admin.username} (ID: {admin.id})")
        
        # Get a regular user for testing
        regular_user = User.query.filter_by(is_admin=False).first()
        if not regular_user:
            print("⚠️  No regular user found! Using admin as reporter...")
            regular_user = admin
        
        # Get some recipes for testing
        recipes = Recipe.query.limit(5).all()
        
        # ============ SEED CATEGORIES ============
        print("\n" + "=" * 60)
        print("SEEDING CATEGORIES")
        print("=" * 60)
        
        categories_data = [
            {
                'name': 'Món Ăn Việt Nam',
                'slug': 'mon-an-viet-nam',
                'description': 'Các món ăn truyền thống Việt Nam như phở, bún, bánh mì',
                'icon': 'fa fa-bowl-rice',
                'color': '#FF6B6B'
            },
            {
                'name': 'Món Ý',
                'slug': 'mon-y',
                'description': 'Pizza, pasta và các món ăn Italy classics',
                'icon': 'fa fa-pizza-slice',
                'color': '#4ECDC4'
            },
            {
                'name': 'Món Nhật',
                'slug': 'mon-nhat',
                'description': 'Sushi, ramen và các món ăn Nhật Bản',
                'icon': 'fa fa-fish',
                'color': '#95E1D3'
            },
            {
                'name': 'Healthy Food',
                'slug': 'healthy-food',
                'description': 'Món ăn healthy, ít calo, nhiều dinh dưỡng',
                'icon': 'fa fa-leaf',
                'color': '#45B7D1'
            },
            {
                'name': 'Desserts',
                'slug': 'desserts',
                'description': 'Các loại bánh ngọt, tráng miệng',
                'icon': 'fa fa-ice-cream',
                'color': '#FFA07A'
            },
            {
                'name': 'Đồ Uống',
                'slug': 'do-uong',
                'description': 'Sinh tố, nước ép, cocktails',
                'icon': 'fa fa-mug-hot',
                'color': '#9B59B6'
            }
        ]
        
        for cat_data in categories_data:
            existing = Category.query.filter_by(slug=cat_data['slug']).first()
            if existing:
                print(f"  ⊙ Category '{cat_data['name']}' already exists (skipping)")
            else:
                category = Category(
                    name=cat_data['name'],
                    slug=cat_data['slug'],
                    description=cat_data['description'],
                    icon=cat_data['icon'],
                    color=cat_data['color'],
                    created_by=admin.id
                )
                db.session.add(category)
                print(f"  ✓ Created category: {cat_data['name']}")
        
        db.session.commit()
        print(f"\n✓ Categories seeded! Total: {Category.query.count()}")
        
        # ============ SEED TAGS ============
        print("\n" + "=" * 60)
        print("SEEDING TAGS")
        print("=" * 60)
        
        tags_data = [
            {'name': 'Vegetarian', 'slug': 'vegetarian', 'description': 'Món chay, không thịt'},
            {'name': 'Vegan', 'slug': 'vegan', 'description': 'Hoàn toàn thuần chay'},
            {'name': 'Quick & Easy', 'slug': 'quick-easy', 'description': 'Nấu nhanh dưới 30 phút'},
            {'name': 'Spicy', 'slug': 'spicy', 'description': 'Món ăn cay'},
            {'name': 'Gluten-Free', 'slug': 'gluten-free', 'description': 'Không chứa gluten'},
            {'name': 'Low Carb', 'slug': 'low-carb', 'description': 'Ít tinh bột'},
            {'name': 'High Protein', 'slug': 'high-protein', 'description': 'Nhiều protein'},
            {'name': 'Budget-Friendly', 'slug': 'budget-friendly', 'description': 'Tiết kiệm chi phí'},
            {'name': 'Party Food', 'slug': 'party-food', 'description': 'Món ăn tiệc tùng'},
            {'name': 'Comfort Food', 'slug': 'comfort-food', 'description': 'Món ăn dân dã, quen thuộc'}
        ]
        
        for tag_data in tags_data:
            existing = Tag.query.filter_by(slug=tag_data['slug']).first()
            if existing:
                print(f"  ⊙ Tag '{tag_data['name']}' already exists (skipping)")
            else:
                tag = Tag(
                    name=tag_data['name'],
                    slug=tag_data['slug'],
                    description=tag_data['description']
                )
                db.session.add(tag)
                print(f"  ✓ Created tag: {tag_data['name']}")
        
        db.session.commit()
        print(f"\n✓ Tags seeded! Total: {Tag.query.count()}")
        
        # ============ SEED REPORTS ============
        print("\n" + "=" * 60)
        print("SEEDING REPORTS")
        print("=" * 60)
        
        if recipes:
            reports_data = [
                {
                    'user_id': regular_user.id,
                    'recipe_id': recipes[0].id if len(recipes) > 0 else None,
                    'report_type': 'recipe',
                    'title': 'Hình ảnh không phù hợp',
                    'description': 'Công thức này có hình ảnh không liên quan đến món ăn, cần kiểm tra lại.',
                    'status': 'pending'
                },
                {
                    'user_id': regular_user.id,
                    'recipe_id': recipes[1].id if len(recipes) > 1 else None,
                    'report_type': 'recipe',
                    'title': 'Thông tin sai lệch',
                    'description': 'Nguyên liệu và cách làm không chính xác, có thể gây nguy hiểm cho người dùng.',
                    'status': 'pending'
                },
                {
                    'user_id': regular_user.id,
                    'recipe_id': recipes[2].id if len(recipes) > 2 else None,
                    'report_type': 'recipe',
                    'title': 'Vi phạm bản quyền',
                    'description': 'Công thức này copy từ nguồn khác mà không ghi nguồn.',
                    'status': 'resolved',
                    'resolved_by': admin.id,
                    'resolved_at': datetime.utcnow()
                },
                {
                    'user_id': regular_user.id,
                    'report_type': 'comment',
                    'title': 'Bình luận spam',
                    'description': 'Có người đang spam quảng cáo trong phần bình luận.',
                    'status': 'dismissed'
                },
                {
                    'user_id': regular_user.id,
                    'reported_user_id': User.query.filter(User.id != admin.id, User.id != regular_user.id).first().id if User.query.count() > 2 else None,
                    'report_type': 'user',
                    'title': 'Hành vi quấy rối',
                    'description': 'User này liên tục comment tiêu cực và quấy rối người dùng khác.',
                    'status': 'pending'
                }
            ]
            
            for report_data in reports_data:
                # Check if similar report exists
                existing = Report.query.filter_by(
                    user_id=report_data['user_id'],
                    title=report_data['title']
                ).first()
                
                if existing:
                    print(f"  ⊙ Report '{report_data['title']}' already exists (skipping)")
                else:
                    report = Report(**report_data)
                    db.session.add(report)
                    print(f"  ✓ Created report: {report_data['title']} ({report_data['status']})")
            
            db.session.commit()
            print(f"\n✓ Reports seeded! Total: {Report.query.count()}")
        else:
            print("  ⚠️  No recipes found! Skipping report seeding...")
        
        # ============ SUMMARY ============
        print("\n" + "=" * 60)
        print("SEEDING COMPLETED!")
        print("=" * 60)
        print(f"✓ Categories: {Category.query.count()}")
        print(f"✓ Tags: {Tag.query.count()}")
        print(f"✓ Reports: {Report.query.count()}")
        print("\nYou can now test the admin features at:")
        print("  - http://127.0.0.1:8000/admin/categories")
        print("  - http://127.0.0.1:8000/admin/reports")
        print("=" * 60)

if __name__ == '__main__':
    seed_data()
