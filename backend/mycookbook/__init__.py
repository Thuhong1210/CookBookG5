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
from sqlalchemy import inspect, text
from werkzeug.security import generate_password_hash, check_password_hash

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(BASE_DIR)
PROJECT_ROOT = os.path.dirname(BACKEND_DIR)
FRONTEND_DIR = os.path.join(PROJECT_ROOT, 'frontend')
TEMPLATES_DIR = os.path.join(FRONTEND_DIR, 'templates')
STATIC_DIR = os.path.join(FRONTEND_DIR, 'static')

app = Flask(__name__, template_folder=TEMPLATES_DIR, static_folder=STATIC_DIR)
app.config['SECRET_KEY'] = 'mycookbook_secret_key_2024'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cookbook.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = os.path.join(STATIC_DIR, 'uploads')
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}

# Create upload directories if they don't exist
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'profiles'), exist_ok=True)
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'recipes'), exist_ok=True)

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

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(120), nullable=False)
    profile_picture = db.Column(db.String(200), default='')
    bio = db.Column(db.String(500), default='Food enthusiast & Home cook')
    is_admin = db.Column(db.Boolean, nullable=False, default=False)
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
        if not check_password_hash(admin_user.password_hash, admin_password):
            if hashed_password is None:
                hashed_password = generate_password_hash(admin_password)
            admin_user.password_hash = hashed_password
            updated = True
        if not admin_user.email:
            admin_user.email = admin_email
            updated = True
        if updated:
            db.session.commit()


def ensure_notification_schema():
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

with app.app_context():
    db.create_all()
    ensure_admin_schema()
    ensure_admin_account()
    ensure_notification_schema()

# ROUTES CHO TẤT CẢ TRANG
@app.route("/")
def index():
    if current_user.is_authenticated and getattr(current_user, 'is_admin', False):
        return redirect(url_for('admin_dashboard'))

    recipes = Recipe.query.order_by(db.func.random()).limit(12).all()
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
            user_id=current_user.id  # Gán user đang login
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
    related_recipes = Recipe.query.filter(Recipe.id != recipe_id).order_by(db.func.random()).limit(3).all()
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
    
    # Check if current user is the author
    if recipe.user_id != current_user.id:
        flash('You can only delete your own recipes!')
        return redirect(url_for('userprofile'))
    
    # Delete all related data
    Favorite.query.filter_by(recipe_id=recipe_id).delete()
    Rating.query.filter_by(recipe_id=recipe_id).delete()
    Comment.query.filter_by(recipe_id=recipe_id).delete()
    
    # Delete the recipe
    db.session.delete(recipe)
    db.session.commit()
    
    flash('Recipe deleted successfully!')
    return redirect(url_for('userprofile'))

@app.route("/admin")
@login_required
@admin_required
def admin_dashboard():
    total_users = User.query.count()
    total_recipes = Recipe.query.count()
    total_comments = Comment.query.count()
    total_favorites = Favorite.query.count()

    users = User.query.order_by(User.id.desc()).all()
    recent_recipes = Recipe.query.order_by(Recipe.id.desc()).limit(25).all()
    all_recipes = Recipe.query.order_by(Recipe.id.desc()).all()
    home_preview_recipes = Recipe.query.order_by(db.func.random()).limit(6).all()
    recent_comments = Comment.query.order_by(Comment.created_at.desc()).limit(10).all()

    category_counts = db.session.query(
        Recipe.category,
        db.func.count(Recipe.id)
    ).group_by(Recipe.category).all()

    return render_template(
        'Admin.html',
        total_users=total_users,
        total_recipes=total_recipes,
        total_comments=total_comments,
        total_favorites=total_favorites,
        users=users,
        recent_recipes=recent_recipes,
        all_recipes=all_recipes,
        home_preview_recipes=home_preview_recipes,
        recent_comments=recent_comments,
        category_counts=category_counts
    )


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
    return redirect(url_for('admin_dashboard'))


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
    return redirect(url_for('admin_dashboard'))


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
    return redirect(url_for('admin_dashboard'))


@app.route("/admin/comments/<int:comment_id>/delete", methods=['POST'])
@login_required
@admin_required
def delete_comment_admin(comment_id):
    comment = Comment.query.get_or_404(comment_id)
    db.session.delete(comment)
    db.session.commit()
    flash('Đã xoá bình luận.')
    return redirect(url_for('admin_dashboard'))

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
