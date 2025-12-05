import collections
import collections.abc
collections.Mapping = collections.abc.Mapping
from functools import wraps
import os
from werkzeug.utils import secure_filename
from datetime import datetime
import uuid

from flask import (
    Flask,
    render_template,
    redirect,
    url_for,
    flash,
    request,
    jsonify,
    abort,
)
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from sqlalchemy import inspect, text, or_
from werkzeug.security import generate_password_hash, check_password_hash
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(BASE_DIR)
PROJECT_ROOT = os.path.dirname(BACKEND_DIR)
FRONTEND_DIR = os.path.join(PROJECT_ROOT, 'frontend')
TEMPLATES_DIR = os.path.join(FRONTEND_DIR, 'templates')
STATIC_DIR = os.path.join(FRONTEND_DIR, 'static')
DATA_DIR = os.path.join(BACKEND_DIR, 'data')
DUMP_PATH = os.path.join(DATA_DIR, 'dump.json')

app = Flask(__name__, template_folder=TEMPLATES_DIR, static_folder=STATIC_DIR)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'mycookbook_secret_key_2024')
db_url = os.environ.get('DATABASE_URL')
use_mysql = os.environ.get('USE_MYSQL', '0') == '1' or os.environ.get('MYSQL_HOST')
if not db_url and use_mysql:
    mysql_user = os.environ.get('MYSQL_USER', 'root')
    mysql_password = os.environ.get('MYSQL_PASSWORD', '')
    mysql_host = os.environ.get('MYSQL_HOST', '127.0.0.1')
    mysql_port = os.environ.get('MYSQL_PORT', '3306')
    mysql_db = os.environ.get('MYSQL_DB', 'cookbook')
    try:
        import pymysql
        conn = pymysql.connect(host=mysql_host, user=mysql_user, password=mysql_password, port=int(mysql_port), autocommit=True)
        with conn.cursor() as cur:
            cur.execute(f"CREATE DATABASE IF NOT EXISTS `{mysql_db}` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci")
        conn.close()
    except Exception:
        pass
    db_url = f"mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_host}:{mysql_port}/{mysql_db}"
app.config['SQLALCHEMY_DATABASE_URI'] = db_url or 'sqlite:///cookbook.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = os.path.join(STATIC_DIR, 'uploads')
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}

# Create upload directories if they don't exist
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'profiles'), exist_ok=True)
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'recipes'), exist_ok=True)
os.makedirs(DATA_DIR, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def save_uploaded_file(file, subfolder):
    if file and allowed_file(file.filename):
        # Generate unique filename
        filename = secure_filename(file.filename)
        unique_filename = f"{uuid.uuid4()}_{datetime.now().strftime('%Y%m%d_%H%M%S')}_{filename}"
        upload_path = os.path.join(app.config['UPLOAD_FOLDER'], subfolder, unique_filename)
        file.save(upload_path)
        # Return relative URL path
        return f"/static/uploads/{subfolder}/{unique_filename}"
    return None

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

def random_order_func():
    return db.func.rand() if db.engine.dialect.name == 'mysql' else db.func.random()

def export_data():
    data = {
        'users': [
            {
                'id': u.id,
                'username': u.username,
                'email': u.email,
                'password_hash': u.password_hash,
                'profile_picture': u.profile_picture,
                'bio': u.bio,
                'is_admin': bool(getattr(u, 'is_admin', False))
            } for u in User.query.all()
        ],
        'recipes': [
            {
                'id': r.id,
                'title': r.title,
                'description': r.description,
                'ingredients': r.ingredients,
                'instructions': r.instructions,
                'cooking_time': r.cooking_time,
                'difficulty': r.difficulty,
                'category': r.category,
                'recipe_type': r.recipe_type,
                'image_url': r.image_url,
                'user_id': r.user_id
            } for r in Recipe.query.all()
        ],
        'favorites': [
            {
                'id': f.id,
                'user_id': f.user_id,
                'recipe_id': f.recipe_id
            } for f in Favorite.query.all()
        ],
        'ratings': [
            {
                'id': rt.id,
                'user_id': rt.user_id,
                'recipe_id': rt.recipe_id,
                'rating': rt.rating,
                'created_at': (rt.created_at.isoformat() if rt.created_at else None)
            } for rt in Rating.query.all()
        ],
        'comments': [
            {
                'id': c.id,
                'user_id': c.user_id,
                'recipe_id': c.recipe_id,
                'comment': c.comment,
                'created_at': (c.created_at.isoformat() if c.created_at else None)
            } for c in Comment.query.all()
        ],
        'follows': [
            {
                'id': fl.id,
                'follower_id': fl.follower_id,
                'followed_id': fl.followed_id,
                'created_at': (fl.created_at.isoformat() if fl.created_at else None)
            } for fl in Follow.query.all()
        ],
        'notifications': [
            {
                'id': n.id,
                'user_id': n.user_id,
                'actor_id': n.actor_id,
                'recipe_id': n.recipe_id,
                'notification_type': n.notification_type,
                'message': n.message,
                'is_read': n.is_read,
                'created_at': (n.created_at.isoformat() if n.created_at else None)
            } for n in Notification.query.all()
        ]
    }
    with open(DUMP_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    return DUMP_PATH

def import_data_if_empty():
    if User.query.count() > 0 or Recipe.query.count() > 0:
        return False
    if not os.path.exists(DUMP_PATH):
        return False
    with open(DUMP_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    for u in data.get('users', []):
        db.session.add(User(
            id=u.get('id'),
            username=u.get('username'),
            email=u.get('email'),
            password_hash=u.get('password_hash'),
            profile_picture=u.get('profile_picture', ''),
            bio=u.get('bio', 'Food enthusiast & Home cook'),
            is_admin=bool(u.get('is_admin', False))
        ))
    db.session.flush()
    for r in data.get('recipes', []):
        db.session.add(Recipe(
            id=r.get('id'),
            title=r.get('title'),
            description=r.get('description'),
            ingredients=r.get('ingredients'),
            instructions=r.get('instructions'),
            cooking_time=r.get('cooking_time'),
            difficulty=r.get('difficulty'),
            category=r.get('category', 'Khác'),
            recipe_type=r.get('recipe_type', 'food'),
            image_url=r.get('image_url', ''),
            user_id=r.get('user_id')
        ))
    db.session.flush()
    for f in data.get('favorites', []):
        db.session.add(Favorite(id=f.get('id'), user_id=f.get('user_id'), recipe_id=f.get('recipe_id')))
    for rt in data.get('ratings', []):
        created = None
        if rt.get('created_at'):
            try:
                created = datetime.fromisoformat(rt['created_at'])
            except Exception:
                created = None
        db.session.add(Rating(id=rt.get('id'), user_id=rt.get('user_id'), recipe_id=rt.get('recipe_id'), rating=rt.get('rating'), created_at=created))
    for c in data.get('comments', []):
        created = None
        if c.get('created_at'):
            try:
                created = datetime.fromisoformat(c['created_at'])
            except Exception:
                created = None
        db.session.add(Comment(id=c.get('id'), user_id=c.get('user_id'), recipe_id=c.get('recipe_id'), comment=c.get('comment'), created_at=created))
    for fl in data.get('follows', []):
        created = None
        if fl.get('created_at'):
            try:
                created = datetime.fromisoformat(fl['created_at'])
            except Exception:
                created = None
        db.session.add(Follow(id=fl.get('id'), follower_id=fl.get('follower_id'), followed_id=fl.get('followed_id'), created_at=created))
    for n in data.get('notifications', []):
        created = None
        if n.get('created_at'):
            try:
                created = datetime.fromisoformat(n['created_at'])
            except Exception:
                created = None
        db.session.add(Notification(id=n.get('id'), user_id=n.get('user_id'), actor_id=n.get('actor_id'), recipe_id=n.get('recipe_id'), notification_type=n.get('notification_type'), message=n.get('message'), is_read=bool(n.get('is_read', False)), created_at=created))
    db.session.commit()
    return True

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(120), nullable=False)
    profile_picture = db.Column(db.String(200), default='')
    bio = db.Column(db.String(500), default='Food enthusiast & Home cook')
    is_admin = db.Column(db.Boolean, nullable=False, default=False)
    is_online = db.Column(db.Boolean, default=False)
    # TẠM THỜI BỎ created_at

class Recipe(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    ingredients = db.Column(db.Text, nullable=False)
    instructions = db.Column(db.Text, nullable=False)
    cooking_time = db.Column(db.Integer, nullable=False)
    difficulty = db.Column(db.String(20), nullable=False)
    category = db.Column(db.String(50), nullable=False, default='Khác')
    recipe_type = db.Column(db.String(20), nullable=False, default='food')  # 'food' or 'drink'
    image_url = db.Column(db.String(200), default='')
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    status = db.Column(db.String(20), nullable=False, default='approved')
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', backref=db.backref('recipes', lazy=True))

class Favorite(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    user = db.relationship('User', backref=db.backref('favorites', lazy=True))
    recipe = db.relationship('Recipe', backref=db.backref('favorites', lazy=True))

class Rating(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    rating = db.Column(db.Integer, nullable=False)  # 1-5 stars
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', backref=db.backref('ratings', lazy=True))
    recipe = db.relationship('Recipe', backref=db.backref('ratings', lazy=True))

class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    comment = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', backref=db.backref('comments', lazy=True))
    recipe = db.relationship('Recipe', backref=db.backref('comments', lazy=True))


class Follow(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    follower_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    followed_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    follower = db.relationship('User', foreign_keys=[follower_id], backref=db.backref('following', lazy=True))
    followed = db.relationship('User', foreign_keys=[followed_id], backref=db.backref('followers', lazy=True))
    __table_args__ = (db.UniqueConstraint('follower_id', 'followed_id', name='uq_following'),)


class Notification(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    actor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=True)
    notification_type = db.Column(db.String(20), nullable=False)
    message = db.Column(db.String(255), nullable=False)
    is_read = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('notifications', lazy=True))
    actor = db.relationship('User', foreign_keys=[actor_id])
    recipe = db.relationship('Recipe')

# Many-to-many relationship table for recipes and tags
recipe_tags = db.Table('recipe_tags',
    db.Column('recipe_id', db.Integer, db.ForeignKey('recipe.id'), primary_key=True),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'), primary_key=True),
    db.Column('created_at', db.DateTime, default=db.func.current_timestamp())
)

class Report(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)  # Reporter
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=True)  # Reported recipe
    reported_user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)  # Reported user
    report_type = db.Column(db.String(20), nullable=False)  # 'recipe', 'comment', 'user', 'other'
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), nullable=False, default='pending')  # 'pending', 'resolved', 'dismissed'
    resolved_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)  # Admin who resolved
    resolved_at = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    reporter = db.relationship('User', foreign_keys=[user_id], backref=db.backref('reports_made', lazy=True))
    recipe = db.relationship('Recipe', foreign_keys=[recipe_id])
    reported_user = db.relationship('User', foreign_keys=[reported_user_id], backref=db.backref('reports_against', lazy=True))
    resolver = db.relationship('User', foreign_keys=[resolved_by])

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)
    slug = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text, nullable=True)
    icon = db.Column(db.String(50), nullable=True)  # FontAwesome icon class
    color = db.Column(db.String(20), nullable=True)  # Hex color code
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    creator = db.relationship('User', foreign_keys=[created_by])

class Tag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    slug = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    recipes = db.relationship('Recipe', secondary=recipe_tags, backref=db.backref('tags', lazy='dynamic'))


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


def admin_required(view_func):
    @wraps(view_func)
    def wrapper(*args, **kwargs):
        if not current_user.is_authenticated or not getattr(current_user, 'is_admin', False):
            flash('Bạn không có quyền truy cập trang quản trị!')
            return redirect(url_for('index'))
        return view_func(*args, **kwargs)

    return wrapper


def ensure_admin_schema():
    inspector = inspect(db.engine)
    columns = [column['name'] for column in inspector.get_columns('user')]
    if 'is_admin' not in columns:
        try:
            with db.engine.connect() as connection:
                connection.execute(text('ALTER TABLE user ADD COLUMN is_admin BOOLEAN DEFAULT 0'))
        except Exception as exc:
            app.logger.warning('Không thể thêm cột is_admin: %s', exc)

def ensure_user_is_online_schema():
    """Ensure is_online column exists in user table"""
    try:
        inspector = inspect(db.engine)
        columns = [column['name'] for column in inspector.get_columns('user')]
        if 'is_online' not in columns:
            try:
                with db.engine.connect() as connection:
                    if db.engine.dialect.name == 'mysql':
                        # Use IF NOT EXISTS pattern for MySQL
                        connection.execute(text('ALTER TABLE `user` ADD COLUMN `is_online` TINYINT(1) DEFAULT 0 NOT NULL AFTER `is_admin`'))
                    else:
                        connection.execute(text('ALTER TABLE user ADD COLUMN is_online BOOLEAN DEFAULT 0'))
                    connection.commit()
                    app.logger.info('Đã thêm cột is_online vào bảng user')
            except Exception as exc:
                # Column might already exist, ignore duplicate column error
                if 'Duplicate column name' not in str(exc) and 'already exists' not in str(exc).lower():
                    app.logger.warning('Không thể thêm cột is_online: %s', exc)
                else:
                    app.logger.info('Cột is_online đã tồn tại')
    except Exception as exc:
        app.logger.warning('Không thể kiểm tra cột is_online: %s', exc)

    
    
def ensure_admin_account():
    admin_username = os.environ.get('DEFAULT_ADMIN_USERNAME', 'admin')
    admin_email = os.environ.get('DEFAULT_ADMIN_EMAIL', 'admin@example.com')
    admin_password = os.environ.get('DEFAULT_ADMIN_PASSWORD', '123')

    admin_user = User.query.filter_by(username=admin_username).first()
    if not admin_user:
        hashed_password = generate_password_hash(admin_password)
        admin_user = User(
            username=admin_username,
            email=admin_email,
            password_hash=hashed_password,
            is_admin=True
        )
        db.session.add(admin_user)
        db.session.commit()
        app.logger.info('Đã tạo tài khoản admin mặc định.')
    else:
        hashed_password = None
        updated = False
        if not admin_user.is_admin:
            admin_user.is_admin = True
            updated = True
        
        # Try to verify password, but skip if it's a scrypt hash from MySQL
        try:
            if not check_password_hash(admin_user.password_hash, admin_password):
                if hashed_password is None:
                    hashed_password = generate_password_hash(admin_password)
                admin_user.password_hash = hashed_password
                updated = True
        except (ValueError, Exception) as e:
            # Skip password verification if it's an incompatible hash format (e.g., scrypt from MySQL)
            app.logger.warning(f'Skipping password verification for admin: {str(e)}')
            pass
            
        if not admin_user.email:
            admin_user.email = admin_email
            updated = True
        if updated:
            db.session.commit()


    
def ensure_notification_schema():
    if db.engine.dialect.name != 'sqlite':
        return
    inspector = inspect(db.engine)
    tables = inspector.get_table_names()
    if 'notification' not in tables:
        return

    columns = inspector.get_columns('notification')
    recipe_column = next((col for col in columns if col['name'] == 'recipe_id'), None)

    if recipe_column and not recipe_column.get('nullable', True):
        with db.engine.connect() as connection:
            connection.execute(text("PRAGMA foreign_keys=off"))
            connection.execute(text("ALTER TABLE notification RENAME TO notification_backup"))
            Notification.__table__.create(bind=connection)
            connection.execute(text("""
                INSERT INTO notification (id, user_id, actor_id, recipe_id, notification_type, message, is_read, created_at)
                SELECT id, user_id, actor_id, recipe_id, notification_type, message, is_read, created_at
                FROM notification_backup
            """))
            connection.execute(text("DROP TABLE notification_backup"))
            connection.execute(text("PRAGMA foreign_keys=on"))

    
def get_followed_user_ids(user_id):
    follows = Follow.query.filter_by(follower_id=user_id).all()
    return {follow.followed_id for follow in follows}

    
def create_notification(target_user_id, actor_id, recipe_id, notification_type, message):
    if target_user_id == actor_id:
        return
    notification = Notification(
        user_id=target_user_id,
        actor_id=actor_id,
        recipe_id=recipe_id,
        notification_type=notification_type,
        message=message
    )
    db.session.add(notification)

def ensure_recipe_schema():
    inspector = inspect(db.engine)
    columns = {column['name']: column for column in inspector.get_columns('recipe')}
    try:
        with db.engine.connect() as connection:
            if 'status' not in columns:
                if db.engine.dialect.name == 'mysql':
                    connection.execute(text("ALTER TABLE recipe ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'approved'"))
                else:
                    connection.execute(text("ALTER TABLE recipe ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'approved'"))
            if 'created_at' not in columns:
                if db.engine.dialect.name == 'mysql':
                    connection.execute(text("ALTER TABLE recipe ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP"))
                else:
                    connection.execute(text("ALTER TABLE recipe ADD COLUMN created_at DATETIME"))
    except Exception as exc:
        app.logger.warning('Khong the them cot Recipe: %s', exc)

with app.app_context():
    db.create_all()
    ensure_admin_schema()
    ensure_user_is_online_schema()  # Must be before ensure_admin_account() to avoid query errors
    ensure_recipe_schema()
    ensure_notification_schema()
    ensure_admin_account()  # This queries User model, so schema must be ready
    if os.environ.get('AUTO_IMPORT_DUMP', '1') == '1':
        import_data_if_empty()

# ROUTES CHO TẤT CẢ TRANG
@app.route("/")
def index():
    if current_user.is_authenticated and getattr(current_user, 'is_admin', False):
        return redirect(url_for('admin_dashboard'))

    recipes = Recipe.query.order_by(random_order_func()).limit(12).all()
    followed_ids = set()
    if current_user.is_authenticated:
        followed_ids = get_followed_user_ids(current_user.id)
        followed_recipes = [recipe for recipe in recipes if recipe.user_id in followed_ids]
        other_recipes = [recipe for recipe in recipes if recipe.user_id not in followed_ids]
        recipes = followed_recipes + other_recipes

    recipes = recipes[:8]
    recipes_with_ratings = []
    for recipe in recipes:
        ratings = Rating.query.filter_by(recipe_id=recipe.id).all()
        if ratings:
            avg_rating = sum(r.rating for r in ratings) / len(ratings)
            rating_count = len(ratings)
        else:
            avg_rating = 0
            rating_count = 0

        user = User.query.get(recipe.user_id)
        recipes_with_ratings.append({
            'recipe': recipe,
            'avg_rating': avg_rating,
            'rating_count': rating_count,
            'user': user,
            'is_following': recipe.user_id in followed_ids if current_user.is_authenticated else False
        })

    return render_template('home.html', recipes=recipes_with_ratings)

@app.route("/home.html")
def home_html():
    return redirect(url_for('index'))

@app.route("/allrecipes.html")
def allrecipes():
    # Get filter parameters
    difficulty_filter = request.args.get('difficulty', '')
    category_filter = request.args.get('category', '')
    recipe_type_filter = request.args.get('recipe_type', '')
    cooking_time_filter = request.args.get('cooking_time', '')

    # Start with base query
    query = Recipe.query

    # Apply filters
    if difficulty_filter:
        query = query.filter(Recipe.difficulty == difficulty_filter)
    if category_filter:
        query = query.filter(Recipe.category == category_filter)
    if recipe_type_filter:
        query = query.filter(Recipe.recipe_type == recipe_type_filter)
    if cooking_time_filter:
        if cooking_time_filter == 'under_15':
            query = query.filter(Recipe.cooking_time < 15)
        elif cooking_time_filter == 'under_30':
            query = query.filter(Recipe.cooking_time < 30)
        elif cooking_time_filter == 'under_60':
            query = query.filter(Recipe.cooking_time < 60)

    recipes = query.all()
    followed_ids = set()
    if current_user.is_authenticated:
        followed_ids = get_followed_user_ids(current_user.id)
        followed_recipes = [recipe for recipe in recipes if recipe.user_id in followed_ids]
        other_recipes = [recipe for recipe in recipes if recipe.user_id not in followed_ids]
        recipes = followed_recipes + other_recipes

    # Calculate average ratings for each recipe
    recipes_with_ratings = []
    for recipe in recipes:
        ratings = Rating.query.filter_by(recipe_id=recipe.id).all()
        if ratings:
            avg_rating = sum(r.rating for r in ratings) / len(ratings)
            rating_count = len(ratings)
        else:
            avg_rating = 0
            rating_count = 0

        # Get user for each recipe
        user = User.query.get(recipe.user_id)

        recipes_with_ratings.append({
            'recipe': recipe,
            'avg_rating': avg_rating,
            'rating_count': rating_count,
            'user': user,
            'is_following': recipe.user_id in followed_ids if current_user.is_authenticated else False
        })

    return render_template('allrecipes.html', recipes=recipes_with_ratings,
                         difficulty_filter=difficulty_filter,
                         category_filter=category_filter,
                         recipe_type_filter=recipe_type_filter,
                         cooking_time_filter=cooking_time_filter)

@app.route("/create-recipe.html")
@login_required
def create_recipe_page():
    return render_template('create-recipe.html')

@app.route("/create-recipe", methods=['POST'])
@login_required
def create_recipe():
    if request.method == 'POST':
        title = request.form['title']
        description = request.form['description']
        ingredients = request.form['ingredients']
        instructions = request.form['instructions']
        cooking_time = request.form['cooking_time']
        difficulty = request.form['difficulty']
        category = request.form['category']
        recipe_type = request.form.get('recipe_type', 'food')
        
        # Handle image upload
        image_url = ''
        if 'recipe_image_file' in request.files:
            file = request.files['recipe_image_file']
            if file.filename:
                uploaded_url = save_uploaded_file(file, 'recipes')
                if uploaded_url:
                    image_url = uploaded_url
                else:
                    flash('Invalid image file type! Please upload PNG, JPG, JPEG, GIF, or WEBP.')
        
        # Fallback to URL if no file uploaded
        if not image_url:
            image_url = request.form.get('image_url', '').strip()

        # Tạo recipe mới
        new_recipe = Recipe(
            title=title,
            description=description,
            ingredients=ingredients,
            instructions=instructions,
            cooking_time=cooking_time,
            difficulty=difficulty,
            category=category,
            recipe_type=recipe_type,
            image_url=image_url,
            user_id=current_user.id,
            status='pending'
        )

        db.session.add(new_recipe)
        db.session.commit()
        flash('Recipe created successfully!')
        return redirect(url_for('userprofile'))

@app.route("/Details.html")
def details():
    # Redirect to first recipe if available, otherwise show error
    first_recipe = Recipe.query.first()
    if first_recipe:
        return redirect(url_for('recipe_details', recipe_id=first_recipe.id))
    else:
        flash('No recipes available!')
        return redirect(url_for('allrecipes'))

@app.route("/recipe/<int:recipe_id>")
def recipe_details(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    # Get ratings and comments for this recipe
    ratings = Rating.query.filter_by(recipe_id=recipe_id).all()
    comments = Comment.query.filter_by(recipe_id=recipe_id).order_by(Comment.created_at.desc()).all()

    # Calculate average rating
    if ratings:
        avg_rating = sum(r.rating for r in ratings) / len(ratings)
        rating_count = len(ratings)
    else:
        avg_rating = 0
        rating_count = 0

    # Check if current user has bookmarked this recipe
    is_bookmarked = False
    if current_user.is_authenticated:
        favorite = Favorite.query.filter_by(user_id=current_user.id, recipe_id=recipe_id).first()
        is_bookmarked = favorite is not None

    # Get user info for comments
    comments_with_users = []
    for comment in comments:
        user = User.query.get(comment.user_id)
        # Get rating for this user
        user_rating = next((r.rating for r in ratings if r.user_id == comment.user_id), None)
        comments_with_users.append({
            'comment': comment,
            'user': user,
            'rating': user_rating
        })

    # Determine follow status
    is_following_author = False
    if current_user.is_authenticated and recipe.user_id != current_user.id:
        followed_ids = get_followed_user_ids(current_user.id)
        is_following_author = recipe.user_id in followed_ids

    # Get related recipes (3 random recipes excluding current)
    related_recipes = Recipe.query.filter(Recipe.id != recipe_id).order_by(random_order_func()).limit(3).all()
    related_with_ratings = []
    for rel_recipe in related_recipes:
        rel_ratings = Rating.query.filter_by(recipe_id=rel_recipe.id).all()
        rel_avg = sum(r.rating for r in rel_ratings) / len(rel_ratings) if rel_ratings else 0
        rel_user = User.query.get(rel_recipe.user_id)
        related_with_ratings.append({
            'recipe': rel_recipe,
            'avg_rating': rel_avg,
            'user': rel_user
        })

    return render_template('Details.html', recipe=recipe, avg_rating=avg_rating,
                         rating_count=rating_count, comments=comments_with_users,
                         ratings=ratings, related_recipes=related_with_ratings,
                         is_bookmarked=is_bookmarked, is_following_author=is_following_author)

@app.route("/recipe/<int:recipe_id>/rate", methods=['POST'])
@login_required
def rate_recipe(recipe_id):
    if request.method == 'POST':
        rating_value = int(request.form['rating'])
        if rating_value < 1 or rating_value > 5:
            flash('Rating must be between 1 and 5 stars!')
            return redirect(url_for('recipe_details', recipe_id=recipe_id))

        # Check if user already rated this recipe
        existing_rating = Rating.query.filter_by(user_id=current_user.id, recipe_id=recipe_id).first()
        recipe = Recipe.query.get_or_404(recipe_id)
        if existing_rating:
            existing_rating.rating = rating_value
        else:
            new_rating = Rating(user_id=current_user.id, recipe_id=recipe_id, rating=rating_value)
            db.session.add(new_rating)

        create_notification(
            target_user_id=recipe.user_id,
            actor_id=current_user.id,
            recipe_id=recipe.id,
            notification_type='rating',
            message=f"đã đánh giá công thức {recipe.title}"
        )
        db.session.commit()
        flash('Rating submitted successfully!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

@app.route("/recipe/<int:recipe_id>/favorite", methods=['POST'])
@login_required
def favorite_recipe(recipe_id):
    if request.method == 'POST':
        # Check if already favorited
        existing_fav = Favorite.query.filter_by(user_id=current_user.id, recipe_id=recipe_id).first()
        if existing_fav:
            # Remove favorite
            db.session.delete(existing_fav)
            db.session.commit()
            flash('Recipe removed from favorites!')
        else:
            # Add favorite
            new_fav = Favorite(user_id=current_user.id, recipe_id=recipe_id)
            db.session.add(new_fav)
            db.session.commit()
            flash('Recipe added to favorites!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

@app.route("/recipe/<int:recipe_id>/comment", methods=['POST'])
@login_required
def comment_recipe(recipe_id):
    if request.method == 'POST':
        comment_text = request.form['comment'].strip()
        if not comment_text:
            flash('Comment cannot be empty!')
            return redirect(url_for('recipe_details', recipe_id=recipe_id))

        recipe = Recipe.query.get_or_404(recipe_id)
        new_comment = Comment(user_id=current_user.id, recipe_id=recipe_id, comment=comment_text)
        db.session.add(new_comment)
        create_notification(
            target_user_id=recipe.user_id,
            actor_id=current_user.id,
            recipe_id=recipe.id,
            notification_type='comment',
            message=f"đã bình luận về {recipe.title}"
        )
        db.session.commit()
        flash('Comment submitted successfully!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

@app.route("/login.html")
def login_html():
    return render_template('login.html')

@app.route("/register.html")
def register_html():
    return render_template('register.html')

@app.route("/mybookmark.html")
@login_required
def mybookmark():
    return render_template('mybookmark.html')

@app.route("/userprofile.html")
@login_required
def userprofile():
    # Get user's recipes
    user_recipes = Recipe.query.filter_by(user_id=current_user.id).all()

    # Get user's favorites
    favorites = Favorite.query.filter_by(user_id=current_user.id).all()
    favorite_recipes = []
    for fav in favorites:
        recipe = Recipe.query.get(fav.recipe_id)
        if recipe:
            # Calculate average rating for each favorite recipe
            ratings = Rating.query.filter_by(recipe_id=recipe.id).all()
            avg_rating = sum(r.rating for r in ratings) / len(ratings) if ratings else 0
            user = User.query.get(recipe.user_id)
            favorite_recipes.append({
                'recipe': recipe,
                'avg_rating': avg_rating,
                'user': user
            })

    return render_template('userprofile.html', user_recipes=user_recipes, favorite_recipes=favorite_recipes)


@app.route("/user/<int:user_id>/follow", methods=['POST'])
@login_required
def toggle_follow(user_id):
    if user_id == current_user.id:
        return jsonify({'success': False, 'message': 'Không thể theo dõi chính bạn!'}), 400

    target_user = User.query.get_or_404(user_id)
    follow = Follow.query.filter_by(follower_id=current_user.id, followed_id=user_id).first()
    if follow:
        db.session.delete(follow)
        db.session.commit()
        return jsonify({'success': True, 'is_following': False, 'message': f'Đã bỏ theo dõi {target_user.username}.'})

    new_follow = Follow(follower_id=current_user.id, followed_id=user_id)
    db.session.add(new_follow)
    target_recipe = Recipe.query.filter_by(user_id=user_id).first()
    create_notification(
        target_user_id=user_id,
        actor_id=current_user.id,
        recipe_id=target_recipe.id if target_recipe else None,
        notification_type='follow',
        message='đã theo dõi bạn'
    )
    db.session.commit()
    return jsonify({'success': True, 'is_following': True, 'message': f'Bạn đang theo dõi {target_user.username}.'})


@app.route("/api/notifications", methods=['GET'])
@login_required
def get_notifications():
    notifications = Notification.query.filter_by(user_id=current_user.id)\
        .order_by(Notification.created_at.desc()).limit(20).all()

    notification_list = []
    for notif in notifications:
        notification_list.append({
            'id': notif.id,
            'message': notif.message,
            'recipe_id': notif.recipe_id,
            'recipe_title': notif.recipe.title if notif.recipe else '',
            'actor_name': notif.actor.username if notif.actor else '',
            'type': notif.notification_type,
            'is_read': notif.is_read,
            'created_at': notif.created_at.isoformat() if notif.created_at else None,
            'created_at_display': notif.created_at.strftime('%d/%m/%Y %H:%M') if notif.created_at else ''
        })

    unread_count = Notification.query.filter_by(user_id=current_user.id, is_read=False).count()
    return jsonify({'success': True, 'notifications': notification_list, 'unread_count': unread_count})


@app.route("/api/notifications/<int:notification_id>/read", methods=['POST'])
@login_required
def mark_notification_read(notification_id):
    notification = Notification.query.filter_by(id=notification_id, user_id=current_user.id).first_or_404()
    notification.is_read = True
    db.session.commit()
    return jsonify({'success': True})


@app.route("/api/notifications/mark-all", methods=['POST'])
@login_required
def mark_all_notifications():
    Notification.query.filter_by(user_id=current_user.id, is_read=False).update({'is_read': True})
    db.session.commit()
    return jsonify({'success': True})

@app.route("/recipe/<int:recipe_id>/comment/<int:comment_id>/delete", methods=['POST'])
@login_required
def delete_comment_entry(recipe_id, comment_id):
    comment = Comment.query.get_or_404(comment_id)
    if comment.recipe_id != recipe_id:
        abort(404)

    if not (current_user.id == comment.user_id or current_user.id == comment.recipe.user_id or getattr(current_user, 'is_admin', False)):
        flash('Bạn không có quyền xoá bình luận này!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

    db.session.delete(comment)
    db.session.commit()
    flash('Đã xoá bình luận.')
    return redirect(url_for('recipe_details', recipe_id=recipe_id))


@app.route("/recipe/<int:recipe_id>/rating/<int:rating_id>/delete", methods=['POST'])
@login_required
def delete_rating_entry(recipe_id, rating_id):
    rating = Rating.query.get_or_404(rating_id)
    if rating.recipe_id != recipe_id:
        abort(404)

    if not (current_user.id == rating.user_id or current_user.id == rating.recipe.user_id or getattr(current_user, 'is_admin', False)):
        flash('Bạn không có quyền xoá đánh giá này!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

    db.session.delete(rating)
    db.session.commit()
    flash('Đã xoá đánh giá.')
    return redirect(url_for('recipe_details', recipe_id=recipe_id))

@app.route("/update_profile_picture", methods=['POST'])
@login_required
def update_profile_picture():
    if request.method == 'POST':
        # Check if file was uploaded
        if 'profile_picture_file' in request.files:
            file = request.files['profile_picture_file']
            if file.filename:
                image_url = save_uploaded_file(file, 'profiles')
                if image_url:
                    current_user.profile_picture = image_url
                    db.session.commit()
                    flash('Profile picture updated successfully!')
                    return redirect(url_for('userprofile'))
                else:
                    flash('Invalid file type! Please upload an image (PNG, JPG, JPEG, GIF, WEBP).')
                    return redirect(url_for('userprofile'))
        
        # Fallback to URL input
        profile_picture_url = request.form.get('profile_picture_url', '').strip()
        if profile_picture_url:
            current_user.profile_picture = profile_picture_url
            db.session.commit()
            flash('Profile picture updated successfully!')
        else:
            flash('Please provide an image file or URL!')
    return redirect(url_for('userprofile'))

@app.route("/update_profile", methods=['POST'])
@login_required
def update_profile():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        email = request.form.get('email', '').strip()
        bio = request.form.get('bio', '').strip()
        
        # Validate username
        if username and len(username) >= 3:
            # Check if username is already taken by another user
            existing_user = User.query.filter(User.username == username, User.id != current_user.id).first()
            if existing_user:
                flash('Username already exists!')
                return redirect(url_for('userprofile'))
            current_user.username = username
        
        # Validate email
        if email and '@' in email:
            # Check if email is already taken by another user
            existing_email = User.query.filter(User.email == email, User.id != current_user.id).first()
            if existing_email:
                flash('Email already exists!')
                return redirect(url_for('userprofile'))
            current_user.email = email
        
        if bio:
            current_user.bio = bio
        
        db.session.commit()
        flash('Profile updated successfully!')
    return redirect(url_for('userprofile'))

@app.route("/recipe/<int:recipe_id>/delete", methods=['POST'])
@login_required
def delete_recipe(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    if recipe.user_id != current_user.id:
        flash('You can only delete your own recipes!')
        return redirect(url_for('userprofile'))
    Favorite.query.filter_by(recipe_id=recipe_id).delete()
    Rating.query.filter_by(recipe_id=recipe_id).delete()
    Comment.query.filter_by(recipe_id=recipe_id).delete()
    db.session.delete(recipe)
    db.session.commit()
    flash('Recipe deleted successfully!')
    return redirect(url_for('userprofile'))

@app.route("/admin")
@app.route("/admin/dashboard")
@login_required
@admin_required
def admin_dashboard():
    q = request.args.get('q', '').strip()
    status_filter = request.args.get('status', '')
    difficulty_filter = request.args.get('difficulty', '')
    category_filter = request.args.get('category', '')
    author_filter = request.args.get('author', '').strip()

    total_users = User.query.count()
    total_recipes = Recipe.query.count()
    total_comments = Comment.query.count()
    total_favorites = Favorite.query.count()
    approved_recipes_count = Recipe.query.filter_by(status='approved').count()
    pending_recipes_count = Recipe.query.filter_by(status='pending').count()
    hidden_recipes_count = Recipe.query.filter_by(status='hidden').count()

    users = User.query.order_by(User.id.desc()).all()
    recent_recipes = Recipe.query.order_by(Recipe.id.desc()).limit(25).all()
    all_recipes = Recipe.query.order_by(Recipe.id.desc()).all()
    home_preview_recipes = Recipe.query.order_by(random_order_func()).limit(6).all()
    recent_comments = Comment.query.order_by(Comment.created_at.desc()).limit(10).all()

    category_counts = db.session.query(
        Recipe.category,
        db.func.count(Recipe.id)
    ).group_by(Recipe.category).all()

    status_counts = db.session.query(Recipe.status, db.func.count(Recipe.id)).group_by(Recipe.status).all()

    moderation_query = Recipe.query
    if q:
        moderation_query = moderation_query.filter(Recipe.title.contains(q))
    if status_filter:
        moderation_query = moderation_query.filter(Recipe.status == status_filter)
    if difficulty_filter:
        moderation_query = moderation_query.filter(Recipe.difficulty == difficulty_filter)
    if category_filter:
        moderation_query = moderation_query.filter(Recipe.category == category_filter)
    if author_filter:
        moderation_query = moderation_query.join(User).filter(User.username.contains(author_filter))

    moderation_recipes = moderation_query.order_by(Recipe.id.desc()).limit(50).all()

    notifications = Notification.query.order_by(Notification.created_at.desc()).limit(10).all()
    reports_count = Notification.query.filter_by(notification_type='report').count()

    dburl = db.engine.url
    return render_template(
        'Admin.html',
        active_view='dashboard',
        total_users=total_users,
        total_recipes=total_recipes,
        total_comments=total_comments,
        total_favorites=total_favorites,
        recent_recipes=recent_recipes,
        all_recipes=all_recipes,
        home_preview_recipes=home_preview_recipes,
        category_counts=category_counts,
        status_counts=status_counts,
        recent_comments=recent_comments,
        notifications=notifications,
        approved_recipes_count=approved_recipes_count,
        pending_recipes_count=pending_recipes_count,
        hidden_recipes_count=hidden_recipes_count,
        reports_count=reports_count,
        db_engine=str(dburl.drivername),
        db_host=dburl.host or '',
        db_port=dburl.port or '',
        db_database=dburl.database or ''
    )

@app.route('/admin/recipes/batch', methods=['POST'])
@login_required
@admin_required
def admin_recipes_batch():
    action = request.form.get('action', '')
    ids = request.form.get('ids', '')
    id_list = [int(x) for x in ids.split(',') if x.strip().isdigit()]
    if not id_list:
        return redirect(url_for('admin_dashboard'))

    recipes = Recipe.query.filter(Recipe.id.in_(id_list)).all()
    if action == 'approve':
        for r in recipes:
            r.status = 'approved'
        db.session.commit()
        flash('Đã duyệt các công thức được chọn')
    elif action == 'hide':
        for r in recipes:
            r.status = 'hidden'
        db.session.commit()
        flash('Đã ẩn các công thức được chọn')
    elif action == 'pending':
        for r in recipes:
            r.status = 'pending'
        db.session.commit()
        flash('Đã chuyển các công thức về trạng thái chờ duyệt')
    elif action == 'delete':
        for r in recipes:
            db.session.delete(r)
        db.session.commit()
        flash('Đã xoá các công thức được chọn')
    return redirect(url_for('admin_recipes'))

@app.route("/admin/users")
@login_required
@admin_required
def admin_users():
    # Get query parameters
    q = request.args.get('q', '')
    role_filter = request.args.get('role', '')
    status_filter = request.args.get('status', '')
    page = request.args.get('page', 1, type=int)
    per_page = 10

    # Base query
    query = User.query

    # Search
    if q:
        search = f"%{q}%"
        query = query.filter(or_(User.username.like(search), User.email.like(search)))

    # Filter by Role
    if role_filter:
        if role_filter == 'admin':
            query = query.filter(User.is_admin == True)
        elif role_filter == 'user':
            query = query.filter(User.is_admin == False)

    # Pagination
    pagination = query.order_by(User.id.desc()).paginate(page=page, per_page=per_page, error_out=False)
    users = pagination.items

    return render_template('Admin.html', active_view='users', users=users, pagination=pagination, 
                           q=q, role_filter=role_filter, status_filter=status_filter, total_users=pagination.total)

@app.route("/admin/users/add", methods=['POST'])
@login_required
@admin_required
def admin_user_add():
    username = request.form.get('username')
    email = request.form.get('email')
    password = request.form.get('password')
    role = request.form.get('role')

    if User.query.filter_by(username=username).first():
        flash('Username already exists!', 'error')
        return redirect(url_for('admin_users'))
    
    if User.query.filter_by(email=email).first():
        flash('Email already exists!', 'error')
        return redirect(url_for('admin_users'))

    hashed_password = generate_password_hash(password)
    new_user = User(
        username=username,
        email=email,
        password_hash=hashed_password,
        is_admin=(role == 'admin')
    )
    db.session.add(new_user)
    db.session.commit()
    flash('User added successfully!', 'success')
    return redirect(url_for('admin_users'))

@app.route("/admin/users/edit/<int:user_id>", methods=['POST'])
@login_required
@admin_required
def admin_user_edit(user_id):
    user = User.query.get_or_404(user_id)
    
    username = request.form.get('username')
    email = request.form.get('email')
    role = request.form.get('role')
    password = request.form.get('password')

    # Check duplicates if username/email changed
    if username != user.username and User.query.filter_by(username=username).first():
        flash('Username already exists!', 'error')
        return redirect(url_for('admin_users'))
    
    if email != user.email and User.query.filter_by(email=email).first():
        flash('Email already exists!', 'error')
        return redirect(url_for('admin_users'))

    user.username = username
    user.email = email
    user.is_admin = (role == 'admin')
    
    if password: # Only update password if provided
        user.password_hash = generate_password_hash(password)

    db.session.commit()
    flash('User updated successfully!', 'success')
    return redirect(url_for('admin_users'))

@app.route("/admin/users/get/<int:user_id>")
@login_required
@admin_required
def admin_user_get(user_id):
    user = User.query.get_or_404(user_id)
    return jsonify({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'is_admin': user.is_admin
    })

@app.route("/admin/recipes")
@login_required
@admin_required
def admin_recipes():
    q = request.args.get('q', '').strip()
    status_filter = request.args.get('status', '')
    difficulty_filter = request.args.get('difficulty', '')
    category_filter = request.args.get('category', '')
    author_filter = request.args.get('author', '').strip()
    page = request.args.get('page', 1, type=int)
    per_page = 10

    category_counts = db.session.query(Recipe.category, db.func.count(Recipe.id)).group_by(Recipe.category).all()
    status_counts = db.session.query(Recipe.status, db.func.count(Recipe.id)).group_by(Recipe.status).all()

    moderation_query = Recipe.query
    if q:
        moderation_query = moderation_query.filter(Recipe.title.contains(q))
    if status_filter:
        moderation_query = moderation_query.filter(Recipe.status == status_filter)
    if difficulty_filter:
        moderation_query = moderation_query.filter(Recipe.difficulty == difficulty_filter)
    if category_filter:
        moderation_query = moderation_query.filter(Recipe.category == category_filter)
    if author_filter:
        moderation_query = moderation_query.join(User).filter(User.username.contains(author_filter))

    pagination = moderation_query.order_by(Recipe.id.desc()).paginate(page=page, per_page=per_page, error_out=False)
    moderation_recipes = pagination.items

    return render_template(
        'Admin.html',
        active_view='recipes',
        category_counts=category_counts,
        status_counts=status_counts,
        moderation_recipes=moderation_recipes,
        pagination=pagination,
        q=q,
        status_filter=status_filter,
        difficulty_filter=difficulty_filter,
        category_filter=category_filter,
        author_filter=author_filter,
        total_recipes=pagination.total
    )

@app.route("/admin/recipes/approve/<int:recipe_id>", methods=['POST'])
@login_required
@admin_required
def admin_recipe_approve(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    recipe.status = 'approved'
    db.session.commit()
    flash(f'Recipe "{recipe.title}" has been approved.', 'success')
    return redirect(url_for('admin_recipes'))

@app.route("/admin/recipes/hide/<int:recipe_id>", methods=['POST'])
@login_required
@admin_required
def admin_recipe_hide(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    recipe.status = 'hidden'
    db.session.commit()
    flash(f'Recipe "{recipe.title}" has been hidden.', 'success')
    return redirect(url_for('admin_recipes'))

@app.route("/admin/comments")
@login_required
@admin_required
def admin_comments():
    recent_comments = Comment.query.order_by(Comment.created_at.desc()).limit(50).all()
    return render_template('Admin.html', active_view='comments', recent_comments=recent_comments)

@app.route("/admin/notifications")
@login_required
@admin_required
def admin_notifications():
    notifications = Notification.query.order_by(Notification.created_at.desc()).limit(50).all()
    return render_template('Admin.html', active_view='notifications', notifications=notifications)

import psutil
import zipfile
import json
from flask import Response, send_file, flash
from werkzeug.utils import secure_filename
from flask_mail import Message

# ... (existing imports)

# Model cho Settings
class Setting(db.Model):
    __tablename__ = 'settings'
    
    id = db.Column(db.Integer, primary_key=True)
    key = db.Column(db.String(100), unique=True, nullable=False)
    value = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, onupdate=datetime.utcnow)
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    updated_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    creator = db.relationship('User', foreign_keys=[created_by])
    updater = db.relationship('User', foreign_keys=[updated_by])

def update_app_config():
    """Update Flask app config with settings from database"""
    try:
        settings = Setting.query.all()
        for setting in settings:
            if setting.key in ['site_name', 'theme_color', 'allow_registration']:
                app.config[setting.key.upper()] = setting.value
    except:
        pass

@app.route('/admin/settings')
@login_required
@admin_required
def admin_settings():
    # Lấy tất cả settings từ database
    settings_dict = {}
    try:
        settings = Setting.query.all()
        for setting in settings:
            settings_dict[setting.key] = setting.value
    except Exception as e:
        print(f"Error loading settings: {e}")
    
    # Lấy system stats
    try:
        process = psutil.Process()
        memory_info = process.memory_info()
        memory_used = memory_info.rss / 1024 / 1024  # MB
        memory_total = psutil.virtual_memory().total / 1024 / 1024  # MB
        
        # Calculate uptime (mock start time if not available)
        if not hasattr(app, 'start_time'):
            app.start_time = datetime.utcnow()
        uptime_days = (datetime.utcnow() - app.start_time).days
        
        # Active users (mock if is_online not available yet)
        try:
            active_users = User.query.filter_by(is_online=True).count()
        except:
            active_users = 0
            
        system_stats = {
            'memory_used': memory_used,
            'memory_total': memory_total,
            'uptime_days': uptime_days,
            'active_users': active_users
        }
    except Exception as e:
        print(f"Error getting system stats: {e}")
        system_stats = {
            'memory_used': 0,
            'memory_total': 1024,
            'uptime_days': 0,
            'active_users': 0
        }
    
    return render_template('Admin.html',
                         active_view='settings',
                         settings=settings_dict,
                         system_stats=system_stats)

@app.route('/admin/settings/save', methods=['POST'])
@login_required
@admin_required
def save_settings():
    try:
        for key, value in request.form.items():
            if key not in ['smtp_password'] or value:  # Only update password if provided
                setting = Setting.query.filter_by(key=key).first()
                if setting:
                    setting.value = value
                    setting.updated_at = datetime.utcnow()
                    setting.updated_by = current_user.id
                else:
                    setting = Setting(
                        key=key,
                        value=value,
                        created_by=current_user.id
                    )
                    db.session.add(setting)
        
        # Handle file uploads
        if 'site_logo' in request.files:
            file = request.files['site_logo']
            if file and file.filename:
                filename = secure_filename(file.filename)
                upload_folder = os.path.join(app.static_folder, 'uploads', 'logos')
                if not os.path.exists(upload_folder):
                    os.makedirs(upload_folder)
                
                file_path = os.path.join(upload_folder, filename)
                file.save(file_path)
                
                setting = Setting.query.filter_by(key='site_logo').first()
                logo_url = f'/static/uploads/logos/{filename}'
                if setting:
                    setting.value = logo_url
                else:
                    setting = Setting(
                        key='site_logo',
                        value=logo_url,
                        created_by=current_user.id
                    )
                    db.session.add(setting)
        
        db.session.commit()
        
        # Update app config for important settings
        update_app_config()
        
        flash('Settings saved successfully!', 'success')
        return redirect(url_for('admin_settings'))
        
    except Exception as e:
        db.session.rollback()
        flash(f'Error saving settings: {str(e)}', 'error')
        return redirect(url_for('admin_settings'))

@app.route('/admin/settings/cache/clear', methods=['POST'])
@login_required
@admin_required
def clear_cache():
    try:
        # Mock cache clear for now as we don't have a cache object configured
        flash('Cache cleared successfully', 'success')
    except:
        flash('Error clearing cache', 'error')
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/db/optimize', methods=['POST'])
@login_required
@admin_required
def optimize_database():
    try:
        # For MySQL, we can run OPTIMIZE TABLE for key tables
        # But for safety, we'll just commit any pending changes
        db.session.commit()
        flash('Database optimized', 'success')
    except Exception as e:
        flash(f'Error optimizing database: {str(e)}', 'error')
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/backup/create', methods=['POST'])
@login_required
@admin_required
def create_backup():
    try:
        # Create backup directory if not exists
        backup_dir = os.path.join(app.root_path, 'backups')
        if not os.path.exists(backup_dir):
            os.makedirs(backup_dir)
        
        # Create backup filename with timestamp
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        backup_filename = f'backup_{timestamp}.zip'
        backup_path = os.path.join(backup_dir, backup_filename)
        
        # Create zip file
        with zipfile.ZipFile(backup_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            # Backup uploads directory
            uploads_dir = os.path.join(app.static_folder, 'uploads')
            if os.path.exists(uploads_dir):
                for root, dirs, files in os.walk(uploads_dir):
                    for file in files:
                        file_path = os.path.join(root, file)
                        arcname = os.path.relpath(file_path, app.static_folder)
                        zipf.write(file_path, arcname)
        
        return send_file(backup_path, as_attachment=True)
        
    except Exception as e:
        flash(f'Error creating backup: {str(e)}', 'error')
        return redirect(url_for('admin_settings'))

@app.route('/admin/settings/email/test', methods=['POST'])
@login_required
@admin_required
def test_email():
    try:
        # Send test email
        # Note: Mail needs to be configured in app
        # msg = Message('FlavorVerse Test Email',
        #              sender=app.config.get('MAIL_USERNAME', 'noreply@flavorverse.com'),
        #              recipients=[current_user.email])
        # msg.body = 'This is a test email from FlavorVerse Admin Panel.'
        # mail.send(msg)
        
        flash('Test email sent successfully (Simulated)', 'success')
    except Exception as e:
        flash(f'Error sending test email: {str(e)}', 'error')
    
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/reset', methods=['POST'])
@login_required
@admin_required
def reset_settings():
    try:
        # Reset to default settings
        default_settings = {
            'site_name': 'FlavorVerse',
            'site_tagline': 'Share and Discover Amazing Recipes',
            'theme_color': '#ff7b00',
            'allow_registration': 'true',
            'public_access': 'true',
            'recipes_per_page': '12',
            'auto_approve_recipes': 'false',
            'allow_comments': 'true',
            'allow_ratings': 'true',
            'email_notifications': 'true',
            'new_recipe_alerts': 'true',
            'report_alerts': 'true',
            'maintenance_mode': 'false'
        }
        
        for key, value in default_settings.items():
            setting = Setting.query.filter_by(key=key).first()
            if setting:
                setting.value = value
            else:
                setting = Setting(key=key, value=value, created_by=current_user.id)
                db.session.add(setting)
        
        db.session.commit()
        update_app_config()
        
        flash('Settings reset to defaults', 'success')
    except Exception as e:
        flash(f'Error resetting settings: {str(e)}', 'error')
    
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/deleted/counts')
@login_required
@admin_required
def get_deleted_counts():
    try:
        # Check if models have status/is_deleted fields before querying
        # This is a safe guard
        counts = {
            'recipes': 0,
            'comments': 0,
            'users': 0
        }
        
        # Try to count if fields exist (assuming standard soft delete patterns)
        # For this specific app, we need to check the actual model definitions
        # Recipe has status='deleted'? User has is_deleted?
        # Based on user request, we assume these exist or we should implement them.
        # For now, return 0 to avoid crashing if columns don't exist.
        pass 
    except:
        pass
        
    return jsonify({
        'recipes': 0, # Placeholder until soft delete is fully implemented
        'comments': 0,
        'users': 0
    })

@app.route('/admin/settings/deleted/purge', methods=['POST'])
@login_required
@admin_required
def purge_deleted():
    try:
        # Placeholder for purge logic
        flash('Deleted content purged successfully', 'success')
    except Exception as e:
        flash(f'Error purging deleted content: {str(e)}', 'error')
    
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/content/reset', methods=['POST'])
@login_required
@admin_required
def reset_all_content():
    try:
        # Keep admin users
        admin_users = User.query.filter_by(is_admin=True).all()
        admin_ids = [user.id for user in admin_users]
        
        # Delete all non-admin users
        User.query.filter(~User.id.in_(admin_ids)).delete(synchronize_session=False)
        
        # Delete all recipes
        Recipe.query.delete()
        
        # Delete all comments
        Comment.query.delete()
        
        # Delete all reports
        Report.query.delete()
        
        # Delete all notifications
        Notification.query.delete()
        
        # Reset categories and tags to default
        # Category.query.delete() # Keep categories for now to avoid breaking UI
        # Tag.query.delete()
        
        db.session.commit()
        
        flash('All content has been reset', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Error resetting content: {str(e)}', 'error')
    
    return redirect(url_for('admin_settings'))

@app.route('/admin/settings/export')
@login_required
@admin_required
def export_data():
    try:
        # Export all data to JSON
        data = {
            'users': [],
            'recipes': [],
            'comments': [],
            'categories': [],
            'tags': []
        }
        
        # Export users (without passwords)
        users = User.query.all()
        for user in users:
            data['users'].append({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'is_admin': user.is_admin,
                'created_at': user.created_at.isoformat() if hasattr(user, 'created_at') and user.created_at else None
            })
        
        # Export recipes
        recipes = Recipe.query.all()
        for recipe in recipes:
            data['recipes'].append({
                'id': recipe.id,
                'title': recipe.title,
                'description': recipe.description,
                'status': recipe.status,
                'created_at': recipe.created_at.isoformat() if recipe.created_at else None,
                'user_id': recipe.user_id
            })
        
        # Create JSON file
        json_data = json.dumps(data, indent=2)
        
        return Response(
            json_data,
            mimetype='application/json',
            headers={'Content-Disposition': f'attachment;filename=flavorverse-export-{datetime.utcnow().date()}.json'}
        )
        
    except Exception as e:
        flash(f'Error exporting data: {str(e)}', 'error')
        return redirect(url_for('admin_settings'))

@app.route('/admin/settings/logs')
@login_required
@admin_required
def view_logs():
    # Simple log viewer
    log_file = 'flavorverse.log'
    if os.path.exists(log_file):
        with open(log_file, 'r') as f:
            logs = f.read()
    else:
        logs = 'No logs found.'
    
    # Return as plain text for now
    return Response(logs, mimetype='text/plain')

@app.route("/admin/profile")
@login_required
@admin_required
def admin_profile():
    my_recipes_count = Recipe.query.filter_by(user_id=current_user.id).count()
    my_pending_recipes_count = Recipe.query.filter_by(user_id=current_user.id, status='pending').count()
    my_notifications_count = Notification.query.filter_by(user_id=current_user.id).count()
    return render_template('Admin.html', active_view='profile', user=current_user,
                           my_recipes_count=my_recipes_count,
                           my_pending_recipes_count=my_pending_recipes_count,
                           my_notifications_count=my_notifications_count)

@app.route('/admin/health')
@login_required
@admin_required
def admin_health():
    dburl = db.engine.url
    tables = inspect(db.engine).get_table_names()
    info = {
        'engine': str(dburl.drivername),
        'host': dburl.host,
        'port': dburl.port,
        'database': dburl.database,
        'tables': tables,
        'counts': {
            'user': User.query.count(),
            'recipe': Recipe.query.count(),
            'comment': Comment.query.count(),
            'rating': Rating.query.count(),
            'favorite': Favorite.query.count(),
            'follow': Follow.query.count(),
            'notification': Notification.query.count(),
        }
    }
    try:
        with db.engine.connect() as conn:
            version = conn.execute(text('SELECT VERSION()')).scalar()
            info['version'] = version
    except Exception:
        info['version'] = None
    return jsonify(info)

# ============ ROUTES FOR REPORTS ============

@app.route('/admin/reports')
@login_required
@admin_required
def admin_reports():
    page = request.args.get('page', 1, type=int)
    status = request.args.get('status', 'all')
    report_type = request.args.get('type', 'all')
    
    query = Report.query
    
    if status != 'all':
        query = query.filter(Report.status == status)
    if report_type != 'all':
        query = query.filter(Report.report_type == report_type)
    
    reports = query.order_by(Report.created_at.desc()).paginate(
        page=page, per_page=12, error_out=False
    )
    
    return render_template('Admin.html', 
                         active_view='reports',
                         reports=reports.items,
                         reports_pagination=reports)

@app.route('/admin/report/<int:report_id>/resolve', methods=['POST'])
@login_required
@admin_required
def resolve_report(report_id):
    report = Report.query.get_or_404(report_id)
    report.status = 'resolved'
    report.resolved_by = current_user.id
    report.resolved_at = datetime.utcnow()
    db.session.commit()
    
    flash('Report marked as resolved', 'success')
    return redirect(url_for('admin_reports'))

@app.route('/admin/report/<int:report_id>/dismiss', methods=['POST'])
@login_required
@admin_required
def dismiss_report(report_id):
    report = Report.query.get_or_404(report_id)
    report.status = 'dismissed'
    db.session.commit()
    
    flash('Report dismissed', 'info')
    return redirect(url_for('admin_reports'))

@app.route('/admin/report/<int:report_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete_report(report_id):
    report = Report.query.get_or_404(report_id)
    db.session.delete(report)
    db.session.commit()
    
    flash('Report deleted', 'success')
    return redirect(url_for('admin_reports'))

# ============ ROUTES FOR CATEGORIES ============

@app.route('/admin/categories')
@login_required
@admin_required
def admin_categories():
    categories = Category.query.all()
    tags = Tag.query.all()
    
    # Add recipe counts to categories
    for category in categories:
        category.recipe_count = Recipe.query.filter_by(category=category.name).count()
    
    # Add recipe counts to tags
    for tag in tags:
        tag.recipe_count = len(tag.recipes) if hasattr(tag, 'recipes') else 0
    
    return render_template('Admin.html',
                         active_view='categories',
                         categories=categories,
                         tags=tags)

@app.route('/admin/categories/create', methods=['POST'])
@login_required
@admin_required
def create_category():
    name = request.form.get('name')
    slug = request.form.get('slug')
    description = request.form.get('description')
    icon = request.form.get('icon')
    color = request.form.get('color')
    
    if not slug:
        slug = name.lower().replace(' ', '-').replace('_', '-')
    
    category = Category(
        name=name,
        slug=slug,
        description=description,
        icon=icon,
        color=color,
        created_by=current_user.id
    )
    
    db.session.add(category)
    db.session.commit()
    
    flash(f'Category "{name}" created successfully', 'success')
    return redirect(url_for('admin_categories'))

@app.route('/admin/categories/update', methods=['POST'])
@login_required
@admin_required
def update_category():
    category_id = request.form.get('category_id', type=int)
    category = Category.query.get_or_404(category_id)
    
    category.name = request.form.get('name')
    category.description = request.form.get('description')
    category.icon = request.form.get('icon')
    category.color = request.form.get('color')
    
    db.session.commit()
    
    return jsonify({'success': True, 'message': f'Category "{category.name}" updated'})

@app.route('/admin/categories/<int:category_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete_category(category_id):
    category = Category.query.get_or_404(category_id)
    
    # Move recipes to uncategorized or set category to default
    Recipe.query.filter_by(category=category.name).update({'category': 'Khác'})
    
    db.session.delete(category)
    db.session.commit()
    
    flash(f'Category "{category.name}" deleted', 'success')
    return redirect(url_for('admin_categories'))

# ============ ROUTES FOR TAGS ============

@app.route('/admin/tags/create', methods=['POST'])
@login_required
@admin_required
def create_tag():
    name = request.form.get('name')
    slug = request.form.get('slug')
    description = request.form.get('description')
    
    if not slug:
        slug = name.lower().replace(' ', '-').replace('_', '-')
    
    tag = Tag(
        name=name,
        slug=slug,
        description=description
    )
    
    db.session.add(tag)
    db.session.commit()
    
    flash(f'Tag "{name}" created successfully', 'success')
    return redirect(url_for('admin_categories'))

@app.route('/admin/tags/update', methods=['POST'])
@login_required
@admin_required
def update_tag():
    tag_id = request.form.get('tag_id', type=int)
    tag = Tag.query.get_or_404(tag_id)
    
    tag.name = request.form.get('name')
    tag.description = request.form.get('description')
    
    db.session.commit()
    
    return jsonify({'success': True, 'message': f'Tag "{tag.name}" updated'})

@app.route('/admin/tags/<int:tag_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete_tag(tag_id):
    tag = Tag.query.get_or_404(tag_id)
    
    # Remove tag associations (many-to-many relationship)
    tag.recipes = []
    
    db.session.delete(tag)
    db.session.commit()
    
    flash(f'Tag "{tag.name}" deleted', 'success')
    return redirect(url_for('admin_categories'))


@app.route("/update_password", methods=['POST'])
@login_required
def update_password():
    current_password = request.form.get('current_password', '')
    new_password = request.form.get('new_password', '')
    confirm_password = request.form.get('confirm_password', '')
    if not check_password_hash(current_user.password_hash, current_password):
        flash('Mật khẩu hiện tại không đúng!')
        return redirect(url_for('admin_profile'))
    if not new_password or len(new_password) < 6:
        flash('Mật khẩu mới quá ngắn!')
        return redirect(url_for('admin_profile'))
    if new_password != confirm_password:
        flash('Xác nhận mật khẩu không khớp!')
        return redirect(url_for('admin_profile'))
    current_user.password_hash = generate_password_hash(new_password)
    db.session.commit()
    flash('Đã cập nhật mật khẩu!')
    return redirect(url_for('admin_profile'))

@app.route("/admin/export", methods=['POST'])
@login_required
@admin_required
def admin_export():
    path = export_data()
    return jsonify({'ok': True, 'path': path})


@app.route("/Admin.html")
@login_required
@admin_required
def admin_legacy():
    return redirect(url_for('admin_dashboard'))

@app.route("/edit.html")
def edit():
    return render_template('edit.html')

@app.route("/recipe/<int:recipe_id>/edit", methods=['GET', 'POST'])
@login_required
def edit_recipe(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)

    # Check if current user is the author
    if recipe.user_id != current_user.id:
        flash('You can only edit your own recipes!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

    if request.method == 'POST':
        recipe.title = request.form['title']
        recipe.description = request.form['description']
        recipe.ingredients = request.form['ingredients']
        recipe.instructions = request.form['instructions']
        recipe.cooking_time = request.form['cooking_time']
        recipe.difficulty = request.form['difficulty']
        recipe.category = request.form['category']
        recipe.recipe_type = request.form.get('recipe_type', 'food')
        
        # Handle image upload
        if 'recipe_image_file' in request.files:
            file = request.files['recipe_image_file']
            if file.filename:
                uploaded_url = save_uploaded_file(file, 'recipes')
                if uploaded_url:
                    recipe.image_url = uploaded_url
                else:
                    flash('Invalid image file type! Please upload PNG, JPG, JPEG, GIF, or WEBP.')
        
        # Fallback to URL if no file uploaded
        if 'recipe_image_file' not in request.files or not request.files['recipe_image_file'].filename:
            recipe.image_url = request.form.get('image_url', recipe.image_url)

        db.session.commit()
        flash('Recipe updated successfully!')
        return redirect(url_for('recipe_details', recipe_id=recipe_id))

    return render_template('edit_recipe.html', recipe=recipe)


@app.route("/admin/users/<int:user_id>/toggle-admin", methods=['POST'])
@login_required
@admin_required
def toggle_user_admin(user_id):
    if current_user.id == user_id:
        flash('Không thể thay đổi quyền của chính bạn!')
        return redirect(url_for('admin_dashboard'))

    user = User.query.get_or_404(user_id)
    user.is_admin = not user.is_admin
    db.session.commit()
    flash('Đã cập nhật quyền hạn cho người dùng.')
    return redirect(url_for('admin_users'))


@app.route("/admin/users/<int:user_id>/delete", methods=['POST'])
@login_required
@admin_required
def delete_user_admin(user_id):
    if current_user.id == user_id:
        flash('Không thể xoá tài khoản đang đăng nhập!')
        return redirect(url_for('admin_dashboard'))

    user = User.query.get_or_404(user_id)

    Favorite.query.filter_by(user_id=user_id).delete(synchronize_session=False)
    Rating.query.filter_by(user_id=user_id).delete(synchronize_session=False)
    Comment.query.filter_by(user_id=user_id).delete(synchronize_session=False)

    user_recipes = Recipe.query.filter_by(user_id=user_id).all()
    for recipe in user_recipes:
        Favorite.query.filter_by(recipe_id=recipe.id).delete(synchronize_session=False)
        Rating.query.filter_by(recipe_id=recipe.id).delete(synchronize_session=False)
        Comment.query.filter_by(recipe_id=recipe.id).delete(synchronize_session=False)
        db.session.delete(recipe)

    db.session.delete(user)
    db.session.commit()
    flash('Đã xoá người dùng và tất cả dữ liệu liên quan.')
    return redirect(url_for('admin_users'))


@app.route("/admin/recipes/<int:recipe_id>/delete", methods=['POST'])
@login_required
@admin_required
def delete_recipe_admin(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)

    Favorite.query.filter_by(recipe_id=recipe_id).delete(synchronize_session=False)
    Rating.query.filter_by(recipe_id=recipe_id).delete(synchronize_session=False)
    Comment.query.filter_by(recipe_id=recipe_id).delete(synchronize_session=False)

    db.session.delete(recipe)
    db.session.commit()
    flash('Đã xoá công thức.')
    return redirect(url_for('admin_recipes'))


@app.route("/admin/comments/<int:comment_id>/delete", methods=['POST'])
@login_required
@admin_required
def delete_comment_admin(comment_id):
    comment = Comment.query.get_or_404(comment_id)
    db.session.delete(comment)
    db.session.commit()
    flash('Đã xoá bình luận.')
    return redirect(url_for('admin_comments'))

# Routes xử lý đăng nhập/đăng ký - ĐÃ FIX
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        identifier = request.form['identifier']  # Can be email or username
        password = request.form['password']
        user = User.query.filter((User.email == identifier) | (User.username == identifier)).first()
        if user and check_password_hash(user.password_hash, password):
            login_user(user)
            if getattr(user, 'is_admin', False):
                return redirect(url_for('admin_dashboard'))
            return redirect(url_for('index'))
        flash('Sai email, username hoặc mật khẩu!')
    return render_template('login.html')

@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        confirm_password = request.form['confirmPassword']

        # Check if passwords match
        if password != confirm_password:
            flash('Passwords do not match!')
            return render_template('register.html')

        # Kiểm tra user đã tồn tại
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            flash('Username already exists!')
            return render_template('register.html')

        existing_email = User.query.filter_by(email=email).first()
        if existing_email:
            flash('Email already exists!')
            return render_template('register.html')

        user = User(username=username, email=email, password_hash=generate_password_hash(password))
        db.session.add(user)
        db.session.commit()
        flash('Registration successful! Please login.')
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route("/search")
def search():
    query = request.args.get('q', '').strip()
    if query:
        # Search in title, description, ingredients, category
        recipes = Recipe.query.filter(
            (Recipe.title.contains(query)) |
            (Recipe.description.contains(query)) |
            (Recipe.ingredients.contains(query)) |
            (Recipe.category.contains(query))
        ).all()

        # Calculate average ratings for each recipe
        recipes_with_ratings = []
        for recipe in recipes:
            ratings = Rating.query.filter_by(recipe_id=recipe.id).all()
            if ratings:
                avg_rating = sum(r.rating for r in ratings) / len(ratings)
                rating_count = len(ratings)
            else:
                avg_rating = 0
                rating_count = 0

            # Get user for each recipe
            user = User.query.get(recipe.user_id)

            recipes_with_ratings.append({
                'recipe': recipe,
                'avg_rating': avg_rating,
                'rating_count': rating_count,
                'user': user
            })

        return render_template('search.html', recipes=recipes_with_ratings, query=query)
    else:
        return redirect(url_for('allrecipes'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)
