# FlavorVerse - Recipe Sharing Platform

<img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d" alt="FlavorVerse Banner" width="100%">

**FlavorVerse** is a full-stack recipe sharing and social cooking platform built with Flask and MySQL. Users can discover recipes, create their own culinary masterpieces, follow other food enthusiasts, and engage with a vibrant cooking community.

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [User Roles](#-user-roles)
- [API Endpoints](#-api-endpoints)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 🔐 User Authentication & Profiles
- User registration and login with secure password hashing (Werkzeug)
- Profile management with custom avatars and bio
- Admin and regular user roles
- Account settings (change username, password, profile picture)

### 🍳 Recipe Management
- **Create** recipes with detailed information:
  - Title, description, ingredients, instructions
  - Cooking time, difficulty level (Easy/Medium/Hard)
  - Category (Vietnamese, Italian, Japanese, Healthy, Dessert, Drinks)
  - Recipe type (Food/Drink)
  - Image upload or URL
- **Edit** and **Delete** your own recipes
- Recipe approval system (pending/approved status)
- Browse all recipes with advanced filtering:
  - By difficulty
  - By category
  - By recipe type
  - By cooking time

### 💬 Social Features
- **Follow/Unfollow** other users
- **Favorite** recipes (bookmark)
- **Rate** recipes (1-5 stars)
- **Comment** on recipes
- View user profiles with their recipes
- Personalized feed showing recipes from followed users first

### 🔔 Notifications
- Real-time notifications for:
  - New followers
  - Comments on your recipes
  - Ratings on your recipes
- Mark notifications as read/unread
- Notification count badge

### 👨‍💼 Admin Dashboard
- View platform statistics:
  - Total users, recipes, comments
  - Recent activity
- Manage recipes (approve/reject pending recipes)
- View recent comments
- User management capabilities

### 🎨 User Interface
- Responsive design (mobile, tablet, desktop)
- Modern, clean interface
- Recipe cards with images and ratings
- Filter sidebar for easy recipe discovery
- User-friendly forms with validation

---

## 🛠 Tech Stack

### Backend
- **Python 3.8+**
- **Flask 2.3.3** - Web framework
- **Flask-SQLAlchemy 3.0.5** - ORM for database operations
- **Flask-Login 0.6.3** - User session management
- **Flask-WTF 1.1.1** - Form handling and validation
- **Werkzeug 2.3.7** - Password hashing and security
- **SQLAlchemy 2.0.19** - Database toolkit
- **PyMySQL** - MySQL database connector (optional)

### Frontend
- **HTML5** - Structure
- **CSS3** - Styling
- **JavaScript** - Interactivity
- **Jinja2 3.1.2** - Template engine

### Database
- **SQLite** (default, development)
- **MySQL/MariaDB** (production, optional)

### Deployment
- **Heroku** ready with Procfile
- Environment variable configuration

---

## 📁 Project Structure

```
CookBookG5/
├── backend/                      # Backend application
│   ├── mycookbook/              # Main Flask package
│   │   ├── __init__.py          # App initialization, routes, models
│   │   └── ...
│   ├── data/                    # Data directory
│   │   └── dump.json           # Database backup/seed data
│   ├── instance/                # Instance folder (SQLite DB)
│   ├── run_app.py              # Application entry point
│   ├── requirements.txt        # Python dependencies
│   ├── seed_fake_data.py       # Database seeding script
│   ├── add_sample_recipes.py   # Add sample recipes
│   ├── check_db.py             # Database verification
│   └── fix_database.py         # Database migration helper
│
├── frontend/                    # Frontend assets
│   ├── templates/              # HTML templates (46 files)
│   │   ├── home.html
│   │   ├── allrecipes.html
│   │   ├── Details.html
│   │   ├── create-recipe.html
│   │   ├── userprofile.html
│   │   ├── login.html
│   │   ├── register.html
│   │   ├── account_settings.html
│   │   ├── admin_dashboard.html
│   │   └── ...
│   └── static/                 # Static files
│       ├── css/                # Stylesheets
│       ├── js/                 # JavaScript files
│       ├── img/                # Images
│       └── uploads/            # User uploaded files
│           ├── profiles/       # Profile pictures
│           └── recipes/        # Recipe images
│
├── Mycookbook_db (1).sql       # MySQL database dump
├── requirements.txt            # Root requirements file
├── run_app.py                  # Root entry point
├── run_mycookbook.sh          # Shell script to run app
├── Procfile                    # Heroku deployment config
├── .env                        # Environment variables
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## 🚀 Installation

### Prerequisites
- Python 3.8 or higher
- pip (Python package manager)
- MySQL/MariaDB (optional, for production)

### Step 1: Clone the Repository
```bash
git clone https://github.com/Thuhong1210/CookBookG5.git
cd CookBookG5
```

### Step 2: Create Virtual Environment
```bash
# Using Python 3
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### Step 3: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 4: Set Up Database

#### Option A: SQLite (Default - Development)
No additional setup required. Database will be created automatically at `backend/instance/cookbook.db`

#### Option B: MySQL (Production)
1. Install MySQL/MariaDB
2. Create database:
```sql
CREATE DATABASE Mycookbook_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
3. Import the provided SQL dump:
```bash
mysql -u root -p Mycookbook_db < "Mycookbook_db (1).sql"
```

---

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# Server Configuration
IP=127.0.0.1
PORT=8000

# Database Configuration (Optional - for MySQL)
USE_MYSQL=1
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=your_password
MYSQL_DB=Mycookbook_db

# Security
SECRET_KEY=your_secret_key_here

# Admin Account (Default)
DEFAULT_ADMIN_USERNAME=admin
DEFAULT_ADMIN_EMAIL=admin@example.com
DEFAULT_ADMIN_PASSWORD=123

# Data Import
AUTO_IMPORT_DUMP=1
```

### Configuration Options

- **USE_MYSQL**: Set to `1` to use MySQL, `0` for SQLite
- **SECRET_KEY**: Flask secret key for session management
- **AUTO_IMPORT_DUMP**: Automatically import data from `backend/data/dump.json` if database is empty

---

## 🏃 Running the Application

### Method 1: Using Python directly
```bash
# From project root
python run_app.py

# Or from backend directory
cd backend
python run_app.py
```

### Method 2: Using the shell script (macOS/Linux)
```bash
chmod +x run_mycookbook.sh
./run_mycookbook.sh
```

### Method 3: Using Flask CLI
```bash
cd backend
flask run
```

The application will be available at: **http://localhost:8000**

### Default Admin Credentials
- **Username**: `admin`
- **Password**: `123`
- **Email**: `admin@example.com`
### AWS EC2 Deployment

Xem hướng dẫn chi tiết tại: [DEPLOY_AWS_EC2.md](DEPLOY_AWS_EC2.md)

**Tóm tắt các bước**:
1. Launch EC2 instance (Ubuntu 22.04)
2. Cài đặt Docker & Docker Compose
3. Clone repository
4. Cấu hình environment variables
5. Run với Docker Compose
6. Cấu hình domain & SSL (Let's Encrypt)
---

## 👥 User Roles

### Regular Users
- Create, edit, delete their own recipes
- Browse and search all approved recipes
- Rate and comment on recipes
- Follow other users
- Favorite recipes
- Receive notifications
- Manage their profile

### Admin Users
- All regular user capabilities
- Access admin dashboard
- View platform statistics
- Approve/reject pending recipes
- Manage all recipes
- View all user activity

---

## 🔌 API Endpoints

### Authentication
- `GET /login.html` - Login page
- `POST /login` - Login user
- `GET /register.html` - Registration page
- `POST /register` - Register new user
- `GET /logout` - Logout user

### Recipes
- `GET /` - Home page with featured recipes
- `GET /allrecipes.html` - Browse all recipes (with filters)
- `GET /recipe/<id>` - View recipe details
- `GET /create-recipe.html` - Create recipe form
- `POST /create-recipe` - Submit new recipe
- `GET /recipe/<id>/edit` - Edit recipe form
- `POST /recipe/<id>/edit` - Update recipe
- `POST /recipe/<id>/delete` - Delete recipe
- `POST /recipe/<id>/rate` - Rate recipe
- `POST /recipe/<id>/comment` - Comment on recipe
- `POST /recipe/<id>/favorite` - Toggle favorite

### User Profile
- `GET /userprofile.html` - Current user profile
- `GET /user/<id>` - View user profile
- `POST /user/<id>/follow` - Toggle follow user
- `GET /account_settings.html` - Account settings
- `POST /update_profile` - Update profile

### Notifications
- `GET /api/notifications` - Get user notifications (JSON)
- `POST /api/notifications/<id>/read` - Mark notification as read

### Admin
- `GET /admin` - Admin dashboard
- `GET /admin/recipes/pending` - View pending recipes
- `POST /admin/recipe/<id>/approve` - Approve recipe
- `POST /admin/recipe/<id>/reject` - Reject recipe

---

## 📸 Screenshots

### Home Page
Modern landing page with featured recipes and personalized feed.

### Recipe Details
Comprehensive recipe view with ingredients, instructions, ratings, and comments.

### Create Recipe
User-friendly form for creating new recipes with image upload.

### User Profile
View user's recipes, favorites, and follower information.

### Admin Dashboard
Statistics and management tools for administrators.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 Development Notes

### Database Seeding
To populate the database with sample data:
```bash
cd backend
python seed_fake_data.py
```

This creates:
- 16 sample users (including admin)
- 42 recipes across various categories
- Ratings, comments, favorites, and follows
- Realistic notification data

### Database Backup/Restore
Export current database to JSON:
```python
from mycookbook import app, export_data
with app.app_context():
    export_data()
```

Import from JSON (automatic on first run if `AUTO_IMPORT_DUMP=1`):
- Data is imported from `backend/data/dump.json`
- Only imports if database is empty

### File Upload Configuration
- **Upload folder**: `frontend/static/uploads/`
- **Max file size**: 16 MB
- **Allowed extensions**: png, jpg, jpeg, gif, webp
- **Subfolders**: 
  - `profiles/` - User profile pictures
  - `recipes/` - Recipe images

---

## 🐛 Known Issues & Troubleshooting

### Issue: Database connection errors
**Solution**: Check MySQL credentials in `.env` file or switch to SQLite by setting `USE_MYSQL=0`

### Issue: Import errors
**Solution**: Ensure virtual environment is activated and all dependencies are installed

### Issue: Static files not loading
**Solution**: Check that `frontend/static/` directory exists and contains css, js, img folders

### Issue: Recipe images not displaying
**Solution**: Ensure `frontend/static/uploads/` directory exists and has write permissions

---

## 📄 License

This project is created for educational purposes as part of a university project.

---

## 👨‍💻 Authors

**Team CookBookG5**
- GitHub: [@Thuhong1210](https://github.com/Thuhong1210)

---

## 🙏 Acknowledgments

- Flask documentation and community
- Unsplash for recipe images
- All contributors and testers

---

## 📞 Support

For issues and questions:
- Open an issue on GitHub
- Contact: [admin@example.com](mailto:admin@example.com)

---

**Built with ❤️ and Python**
