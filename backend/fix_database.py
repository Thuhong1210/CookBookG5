import os
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

# Import app và db từ mycookbook
from mycookbook import app, db

with app.app_context():
    try:
        # Cách 1: Sử dụng db.session để thực thi SQL
        db.session.execute("ALTER TABLE recipe ADD COLUMN category VARCHAR(100)")
        db.session.commit()
        print("✅ Đã thêm cột 'category' vào bảng recipe")
        
    except Exception as e:
        print(f"❌ Lỗi với db.session: {e}")
        db.session.rollback()
        
        try:
            # Cách 2: Sử dụng connection trực tiếp
            with db.engine.connect() as conn:
                conn.execute("ALTER TABLE recipe ADD COLUMN category VARCHAR(100)")
                conn.commit()
            print("✅ Đã thêm cột 'category' vào bảng recipe (sử dụng connection)")
        except Exception as e2:
            print(f"❌ Lỗi với connection: {e2}")
    
    # Kiểm tra lại cấu trúc bảng
    try:
        from sqlalchemy import inspect
        inspector = inspect(db.engine)
        columns = inspector.get_columns('recipe')
        print("\n📊 Các cột trong bảng recipe:")
        for column in columns:
            print(f"  - {column['name']}: {column['type']}")
    except Exception as e:
        print(f"❌ Lỗi khi kiểm tra cấu trúc: {e}")
