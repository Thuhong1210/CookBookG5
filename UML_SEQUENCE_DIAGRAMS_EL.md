# UML Sequence Diagrams - FlavorVerse CookBook Platform

> **Project**: FlavorVerse - Recipe Sharing Platform  
> **Created**: 2025-12-06  
> **Description**: This document contains detailed UML Sequence Diagrams for all major business flows in the CookBookG5 system.

---

## 📑 Table of Contents

1. [User Registration Flow](#1-user-registration-flow)
2. [User Login Flow](#2-user-login-flow)
3. [Create Recipe Flow](#3-create-recipe-flow)
4. [View Recipe Details Flow](#4-view-recipe-details-flow)
5. [Rate Recipe Flow](#5-rate-recipe-flow)
6. [Comment on Recipe Flow](#6-comment-on-recipe-flow)
7. [Favorite Recipe Flow](#7-favorite-recipe-flow)
8. [Follow User Flow](#8-follow-user-flow)
9. [View Notifications Flow](#9-view-notifications-flow)
10. [Admin Approve Recipe Flow](#10-admin-approve-recipe-flow)
11. [Update User Profile Flow](#11-update-user-profile-flow)
12. [Search and Filter Recipes Flow](#12-search-and-filter-recipes-flow)

---

## 1. User Registration Flow

**Description**: New user registers an account on the system.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant Auth as Authentication Service
    participant DB as MySQL Database
    
    User->>Browser: Access registration page
    Browser->>Flask: GET /register.html
    Flask->>Browser: Return registration form
    Browser->>User: Display registration form
    
    User->>Browser: Enter information (username, email, password)
    Browser->>Flask: POST /register (username, email, password)
    
    Flask->>Flask: Validate input data
    
    alt Invalid data
        Flask->>Browser: Return validation error
        Browser->>User: Display error message
    else Valid data
        Flask->>DB: Check if username/email exists
        
        alt Username/Email exists
            DB->>Flask: Return result: Exists
            Flask->>Browser: Return error: "Username/Email already taken"
            Browser->>User: Display error message
        else Username/Email does not exist
            DB->>Flask: Return result: Does not exist
            Flask->>Auth: Hash password (Werkzeug)
            Auth->>Flask: Return password_hash
            
            Flask->>DB: INSERT INTO user (username, email, password_hash, is_admin=False)
            DB->>Flask: Return user_id
            
            Flask->>Auth: Create session for user
            Auth->>Flask: Session created
            
            Flask->>Browser: Redirect to /home.html
            Browser->>User: Display home page (logged in)
        end
    end
```

**Related Components**:
- **Route**: `POST /register`
- **Models**: `User`
- **Database Tables**: `user`
- **Authentication**: Flask-Login, Werkzeug password hashing

---

## 2. User Login Flow

**Description**: Existing user logs into the system.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant Auth as Authentication Service
    participant DB as MySQL Database
    
    User->>Browser: Access login page
    Browser->>Flask: GET /login.html
    Flask->>Browser: Return login form
    Browser->>User: Display login form
    
    User->>Browser: Enter username and password
    Browser->>Flask: POST /login (username, password)
    
    Flask->>DB: SELECT * FROM user WHERE username = ?
    
    alt User does not exist
        DB->>Flask: Return NULL
        Flask->>Browser: Return error: "Account does not exist"
        Browser->>User: Display error message
    else User exists
        DB->>Flask: Return user data (id, username, password_hash, is_admin)
        
        Flask->>Auth: Verify password (check_password_hash)
        Auth->>Flask: Return authentication result
        
        alt Incorrect password
            Flask->>Browser: Return error: "Incorrect password"
            Browser->>User: Display error message
        else Correct password
            Flask->>Auth: Create session (login_user)
            Auth->>Flask: Session created
            
            Flask->>DB: UPDATE user SET is_online = TRUE WHERE id = ?
            DB->>Flask: Update successful
            
            Flask->>Browser: Redirect to /home.html
            Browser->>Flask: GET /home.html
            Flask->>DB: Get recipe list (personalized feed)
            DB->>Flask: Return recipe list
            Flask->>Browser: Render home page with recipes
            Browser->>User: Display home page (logged in)
        end
    end
```

**Related Components**:
- **Route**: `POST /login`, `GET /home.html`
- **Models**: `User`
- **Database Tables**: `user`
- **Authentication**: Flask-Login (login_user, UserMixin)

---

## 3. Create Recipe Flow

**Description**: Logged-in user creates a new recipe.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant FileSystem as File System
    participant DB as MySQL Database
    participant NotifService as Notification Service
    
    User->>Browser: Click "Create Recipe"
    Browser->>Flask: GET /create-recipe.html
    
    Flask->>Flask: Check @login_required
    alt Not logged in
        Flask->>Browser: Redirect to /login.html
    else Logged in
        Flask->>Browser: Return recipe creation form
        Browser->>User: Display form
        
        User->>Browser: Enter recipe information
        Note over User,Browser: Title, Description, Ingredients,<br/>Instructions, Category, Difficulty,<br/>Cooking Time, Recipe Type, Image
        
        User->>Browser: Upload image and Submit form
        Browser->>Flask: POST /create-recipe (multipart/form-data)
        
        Flask->>Flask: Validate data
        
        alt Invalid data
            Flask->>Browser: Return validation error
            Browser->>User: Display error message
        else Valid data
            alt Image file uploaded
                Flask->>Flask: Check allowed_file(filename)
                Flask->>Flask: Generate unique filename (UUID)
                Flask->>FileSystem: Save file to /static/uploads/recipes/
                FileSystem->>Flask: Return file path
            end
            
            Flask->>DB: INSERT INTO recipe (title, description, ingredients, instructions, category, difficulty, cooking_time, recipe_type, image_url, user_id, status='pending')
            DB->>Flask: Return recipe_id
            
            Flask->>DB: SELECT followers FROM follow WHERE followed_id = current_user.id
            DB->>Flask: Return follower list
            
            loop For each follower
                Flask->>NotifService: Create notification (type='new_recipe')
                NotifService->>DB: INSERT INTO notification
                DB->>NotifService: Notification created
            end
            
            Flask->>Browser: Redirect to /recipe/{recipe_id}
            Browser->>User: Display recipe details page
            User->>User: See message "Recipe pending approval"
        end
    end
```

**Related Components**:
- **Route**: `GET /create-recipe.html`, `POST /create-recipe`
- **Models**: `Recipe`, `User`, `Notification`
- **Database Tables**: `recipe`, `notification`, `follow`
- **File Upload**: Werkzeug secure_filename, UUID

---

## 4. View Recipe Details Flow

**Description**: User views detailed information of a recipe.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    
    User->>Browser: Click on recipe
    Browser->>Flask: GET /recipe/{recipe_id}
    
    Flask->>DB: SELECT * FROM recipe WHERE id = ? AND status = 'approved'
    
    alt Recipe does not exist or not approved
        DB->>Flask: Return NULL
        Flask->>Browser: Return 404 error
        Browser->>User: Display "Recipe not found"
    else Recipe exists
        DB->>Flask: Return recipe data
        
        Flask->>DB: SELECT * FROM user WHERE id = recipe.user_id
        DB->>Flask: Return author information
        
        Flask->>DB: SELECT AVG(rating) as avg_rating, COUNT(*) as rating_count FROM rating WHERE recipe_id = ?
        DB->>Flask: Return rating statistics
        
        Flask->>DB: SELECT * FROM comment JOIN user ON comment.user_id = user.id WHERE recipe_id = ? ORDER BY created_at DESC
        DB->>Flask: Return comment list
        
        alt User is logged in
            Flask->>DB: SELECT * FROM favorite WHERE user_id = ? AND recipe_id = ?
            DB->>Flask: Return favorite status
            
            Flask->>DB: SELECT rating FROM rating WHERE user_id = ? AND recipe_id = ?
            DB->>Flask: Return user's rating (if exists)
            
            Flask->>DB: SELECT * FROM follow WHERE follower_id = ? AND followed_id = recipe.user_id
            DB->>Flask: Return follow status
        end
        
        Flask->>Browser: Render Details.html with all data
        Browser->>User: Display recipe details
        Note over User: View: Title, Description, Ingredients,<br/>Instructions, Author, Ratings,<br/>Comments, Favorite status
    end
```

**Related Components**:
- **Route**: `GET /recipe/{recipe_id}`
- **Models**: `Recipe`, `User`, `Rating`, `Comment`, `Favorite`, `Follow`
- **Database Tables**: `recipe`, `user`, `rating`, `comment`, `favorite`, `follow`

---

## 5. Rate Recipe Flow

**Description**: User rates a recipe (1-5 stars).

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    participant NotifService as Notification Service
    
    User->>Browser: Select star rating (1-5) on details page
    Browser->>Flask: POST /recipe/{recipe_id}/rate (rating: 1-5)
    
    Flask->>Flask: Check @login_required
    
    alt Not logged in
        Flask->>Browser: Return 401 Unauthorized error
        Browser->>User: Redirect to /login.html
    else Logged in
        Flask->>DB: SELECT * FROM recipe WHERE id = ?
        
        alt Recipe does not exist
            DB->>Flask: Return NULL
            Flask->>Browser: Return 404 error
        else Recipe exists
            DB->>Flask: Return recipe data
            
            Flask->>Flask: Check user is not rating own recipe
            
            alt User rating own recipe
                Flask->>Browser: Return error "Cannot rate your own recipe"
                Browser->>User: Display error message
            else User rating another's recipe
                Flask->>DB: SELECT * FROM rating WHERE user_id = ? AND recipe_id = ?
                
                alt Already rated before
                    DB->>Flask: Return old rating
                    Flask->>DB: UPDATE rating SET rating = ?, created_at = NOW() WHERE id = ?
                    DB->>Flask: Update successful
                else Not rated before
                    DB->>Flask: Return NULL
                    Flask->>DB: INSERT INTO rating (user_id, recipe_id, rating)
                    DB->>Flask: Return rating_id
                    
                    Flask->>NotifService: Create notification for author
                    NotifService->>DB: INSERT INTO notification (user_id=recipe.user_id, actor_id=current_user.id, type='rating', recipe_id, message)
                    DB->>NotifService: Notification created
                end
                
                Flask->>DB: SELECT AVG(rating) as avg_rating, COUNT(*) as count FROM rating WHERE recipe_id = ?
                DB->>Flask: Return new statistics
                
                Flask->>Browser: Return JSON {success: true, avg_rating, rating_count}
                Browser->>Browser: Update UI (display new stars)
                Browser->>User: Display updated rating
            end
        end
    end
```

**Related Components**:
- **Route**: `POST /recipe/{recipe_id}/rate`
- **Models**: `Rating`, `Recipe`, `Notification`
- **Database Tables**: `rating`, `recipe`, `notification`

---

## 6. Comment on Recipe Flow

**Description**: User writes a comment on a recipe.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    participant NotifService as Notification Service
    
    User->>Browser: Enter comment text
    User->>Browser: Click "Submit comment"
    Browser->>Flask: POST /recipe/{recipe_id}/comment (comment_text)
    
    Flask->>Flask: Check @login_required
    
    alt Not logged in
        Flask->>Browser: Return 401 error
        Browser->>User: Redirect to /login.html
    else Logged in
        Flask->>Flask: Validate comment (not empty, <= 1000 characters)
        
        alt Invalid comment
            Flask->>Browser: Return validation error
            Browser->>User: Display error message
        else Valid comment
            Flask->>DB: SELECT * FROM recipe WHERE id = ?
            
            alt Recipe does not exist
                DB->>Flask: Return NULL
                Flask->>Browser: Return 404 error
            else Recipe exists
                DB->>Flask: Return recipe data
                
                Flask->>DB: INSERT INTO comment (user_id, recipe_id, comment, created_at)
                DB->>Flask: Return comment_id
                
                alt User commenting on another's recipe
                    Flask->>NotifService: Create notification for author
                    NotifService->>DB: INSERT INTO notification (user_id=recipe.user_id, actor_id=current_user.id, type='comment', recipe_id, message)
                    DB->>NotifService: Notification created
                end
                
                Flask->>DB: SELECT comment.*, user.username, user.profile_picture FROM comment JOIN user ON comment.user_id = user.id WHERE comment.id = ?
                DB->>Flask: Return comment data with user info
                
                Flask->>Browser: Return JSON {success: true, comment_data}
                Browser->>Browser: Add new comment to list (AJAX)
                Browser->>User: Display newly created comment
            end
        end
    end
```

**Related Components**:
- **Route**: `POST /recipe/{recipe_id}/comment`
- **Models**: `Comment`, `Recipe`, `User`, `Notification`
- **Database Tables**: `comment`, `recipe`, `user`, `notification`

---

## 7. Favorite Recipe Flow

**Description**: User adds/removes recipe from favorites list.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    
    User->>Browser: Click "Favorite" button (❤️)
    Browser->>Flask: POST /recipe/{recipe_id}/favorite
    
    Flask->>Flask: Check @login_required
    
    alt Not logged in
        Flask->>Browser: Return 401 error
        Browser->>User: Redirect to /login.html
    else Logged in
        Flask->>DB: SELECT * FROM recipe WHERE id = ?
        
        alt Recipe does not exist
            DB->>Flask: Return NULL
            Flask->>Browser: Return 404 error
        else Recipe exists
            DB->>Flask: Return recipe data
            
            Flask->>DB: SELECT * FROM favorite WHERE user_id = ? AND recipe_id = ?
            
            alt Already favorited (unfavorite)
                DB->>Flask: Return favorite record
                Flask->>DB: DELETE FROM favorite WHERE id = ?
                DB->>Flask: Delete successful
                Flask->>Browser: Return JSON {success: true, favorited: false}
                Browser->>Browser: Update UI (empty icon)
                Browser->>User: Display "Removed from favorites"
            else Not favorited (favorite)
                DB->>Flask: Return NULL
                Flask->>DB: INSERT INTO favorite (user_id, recipe_id)
                DB->>Flask: Return favorite_id
                Flask->>Browser: Return JSON {success: true, favorited: true}
                Browser->>Browser: Update UI (filled icon)
                Browser->>User: Display "Added to favorites"
            end
        end
    end
```

**Related Components**:
- **Route**: `POST /recipe/{recipe_id}/favorite`
- **Models**: `Favorite`, `Recipe`
- **Database Tables**: `favorite`, `recipe`

---

## 8. Follow User Flow

**Description**: User follows/unfollows another user.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    participant NotifService as Notification Service
    
    User->>Browser: Click "Follow" button on profile
    Browser->>Flask: POST /user/{user_id}/follow
    
    Flask->>Flask: Check @login_required
    
    alt Not logged in
        Flask->>Browser: Return 401 error
        Browser->>User: Redirect to /login.html
    else Logged in
        Flask->>Flask: Check user_id != current_user.id
        
        alt Following self
            Flask->>Browser: Return error "Cannot follow yourself"
            Browser->>User: Display error message
        else Following another user
            Flask->>DB: SELECT * FROM user WHERE id = ?
            
            alt User does not exist
                DB->>Flask: Return NULL
                Flask->>Browser: Return 404 error
            else User exists
                DB->>Flask: Return user data
                
                Flask->>DB: SELECT * FROM follow WHERE follower_id = ? AND followed_id = ?
                
                alt Already following (unfollow)
                    DB->>Flask: Return follow record
                    Flask->>DB: DELETE FROM follow WHERE id = ?
                    DB->>Flask: Delete successful
                    Flask->>Browser: Return JSON {success: true, following: false}
                    Browser->>Browser: Update UI ("Follow")
                    Browser->>User: Display "Unfollowed"
                else Not following (follow)
                    DB->>Flask: Return NULL
                    Flask->>DB: INSERT INTO follow (follower_id, followed_id)
                    DB->>Flask: Return follow_id
                    
                    Flask->>NotifService: Create notification for followed user
                    NotifService->>DB: INSERT INTO notification (user_id=followed_id, actor_id=current_user.id, type='follow', message)
                    DB->>NotifService: Notification created
                    
                    Flask->>Browser: Return JSON {success: true, following: true}
                    Browser->>Browser: Update UI ("Following")
                    Browser->>User: Display "Followed"
                end
            end
        end
    end
```

**Related Components**:
- **Route**: `POST /user/{user_id}/follow`
- **Models**: `Follow`, `User`, `Notification`
- **Database Tables**: `follow`, `user`, `notification`

---

## 9. View Notifications Flow

**Description**: User views their notification list.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    
    User->>Browser: Click notification icon (🔔)
    Browser->>Flask: GET /api/notifications
    
    Flask->>Flask: Check @login_required
    
    alt Not logged in
        Flask->>Browser: Return 401 error
    else Logged in
        Flask->>DB: SELECT COUNT(*) FROM notification WHERE user_id = ? AND is_read = FALSE
        DB->>Flask: Return unread_count
        
        Flask->>DB: SELECT notification.*, actor.username, actor.profile_picture, recipe.title FROM notification LEFT JOIN user AS actor ON notification.actor_id = actor.id LEFT JOIN recipe ON notification.recipe_id = recipe.id WHERE notification.user_id = ? ORDER BY created_at DESC LIMIT 20
        DB->>Flask: Return notification list
        
        Flask->>Browser: Return JSON {notifications: [...], unread_count: X}
        Browser->>Browser: Render notification list
        Browser->>User: Display notification dropdown
        
        User->>Browser: Click on a notification
        Browser->>Flask: POST /api/notifications/{notification_id}/read
        
        Flask->>DB: UPDATE notification SET is_read = TRUE WHERE id = ?
        DB->>Flask: Update successful
        
        Flask->>Browser: Return JSON {success: true}
        Browser->>Browser: Mark notification as read
        
        alt Notification has recipe_id
            Browser->>Flask: Redirect to /recipe/{recipe_id}
        else Notification has actor_id (follow)
            Browser->>Flask: Redirect to /user/{actor_id}
        end
    end
```

**Related Components**:
- **Route**: `GET /api/notifications`, `POST /api/notifications/{notification_id}/read`
- **Models**: `Notification`, `User`, `Recipe`
- **Database Tables**: `notification`, `user`, `recipe`

---

## 10. Admin Approve Recipe Flow

**Description**: Admin views and approves/rejects pending recipes.

```mermaid
sequenceDiagram
    actor Admin as Administrator
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    participant NotifService as Notification Service
    
    Admin->>Browser: Access Admin page
    Browser->>Flask: GET /admin/dashboard
    
    Flask->>Flask: Check @login_required and @admin_required
    
    alt Not admin
        Flask->>Browser: Return 403 Forbidden error
        Browser->>Admin: Display "Access denied"
    else Is admin
        Flask->>DB: SELECT COUNT(*) FROM recipe WHERE status = 'pending'
        DB->>Flask: Return pending_count
        
        Flask->>DB: SELECT COUNT(*) FROM user
        DB->>Flask: Return total_users
        
        Flask->>DB: SELECT COUNT(*) FROM recipe WHERE status = 'approved'
        DB->>Flask: Return total_recipes
        
        Flask->>DB: SELECT COUNT(*) FROM comment
        DB->>Flask: Return total_comments
        
        Flask->>Browser: Render admin_dashboard.html with statistics
        Browser->>Admin: Display dashboard
        
        Admin->>Browser: Click "Manage Recipes"
        Browser->>Flask: GET /admin/recipes?status=pending
        
        Flask->>DB: SELECT recipe.*, user.username FROM recipe JOIN user ON recipe.user_id = user.id WHERE recipe.status = 'pending' ORDER BY created_at DESC
        DB->>Flask: Return pending recipe list
        
        Flask->>Browser: Render admin recipes page
        Browser->>Admin: Display pending recipe list
        
        Admin->>Browser: View details and click "Approve"
        Browser->>Flask: POST /admin/recipes/approve/{recipe_id}
        
        Flask->>DB: UPDATE recipe SET status = 'approved' WHERE id = ?
        DB->>Flask: Update successful
        
        Flask->>DB: SELECT user_id FROM recipe WHERE id = ?
        DB->>Flask: Return user_id (author)
        
        Flask->>NotifService: Create notification for author
        NotifService->>DB: INSERT INTO notification (user_id, type='recipe_approved', recipe_id, message)
        DB->>NotifService: Notification created
        
        Flask->>Browser: Return JSON {success: true, message: "Approved"}
        Browser->>Browser: Remove recipe from pending list
        Browser->>Admin: Display "Recipe approved"
        
        alt Admin rejects recipe
            Admin->>Browser: Click "Reject"
            Browser->>Flask: POST /admin/recipes/reject/{recipe_id}
            Flask->>DB: UPDATE recipe SET status = 'rejected' WHERE id = ?
            DB->>Flask: Update successful
            Flask->>NotifService: Create notification (type='recipe_rejected')
            NotifService->>DB: INSERT INTO notification
            Flask->>Browser: Return success
            Browser->>Admin: Display "Recipe rejected"
        end
    end
```

**Related Components**:
- **Route**: `GET /admin/dashboard`, `GET /admin/recipes`, `POST /admin/recipes/approve/{recipe_id}`
- **Models**: `Recipe`, `User`, `Notification`
- **Database Tables**: `recipe`, `user`, `notification`
- **Decorators**: `@admin_required`

---

## 11. Update User Profile Flow

**Description**: User updates personal information and profile picture.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant FileSystem as File System
    participant DB as MySQL Database
    
    User->>Browser: Access account settings page
    Browser->>Flask: GET /account_settings.html
    
    Flask->>Flask: Check @login_required
    Flask->>DB: SELECT * FROM user WHERE id = current_user.id
    DB->>Flask: Return user data
    Flask->>Browser: Render form with current data
    Browser->>User: Display settings form
    
    User->>Browser: Change information (username, bio, email)
    User->>Browser: Upload new profile picture
    User->>Browser: Click "Update"
    
    Browser->>Flask: POST /update_profile (multipart/form-data)
    
    Flask->>Flask: Validate data
    
    alt Invalid data
        Flask->>Browser: Return validation error
        Browser->>User: Display error message
    else Valid data
        alt New username different from old
            Flask->>DB: SELECT * FROM user WHERE username = ? AND id != ?
            alt Username exists
                DB->>Flask: Return user record
                Flask->>Browser: Return error "Username already taken"
                Browser->>User: Display error
            end
        end
        
        alt New email different from old
            Flask->>DB: SELECT * FROM user WHERE email = ? AND id != ?
            alt Email exists
                DB->>Flask: Return user record
                Flask->>Browser: Return error "Email already taken"
                Browser->>User: Display error
            end
        end
        
        alt Profile picture uploaded
            Flask->>Flask: Check allowed_file()
            Flask->>Flask: Generate unique filename
            Flask->>FileSystem: Save file to /static/uploads/profiles/
            FileSystem->>Flask: Return file path
            
            alt Old picture exists
                Flask->>FileSystem: Delete old picture
            end
        end
        
        Flask->>DB: UPDATE user SET username=?, email=?, bio=?, profile_picture=? WHERE id=?
        DB->>Flask: Update successful
        
        Flask->>Browser: Redirect to /userprofile.html
        Browser->>Flask: GET /userprofile.html
        Flask->>DB: Get new user information
        DB->>Flask: Return user data
        Flask->>Browser: Render profile with new data
        Browser->>User: Display "Update successful"
    end
```

**Related Components**:
- **Route**: `GET /account_settings.html`, `POST /update_profile`
- **Models**: `User`
- **Database Tables**: `user`
- **File Upload**: Profile picture upload

---

## 12. Search and Filter Recipes Flow

**Description**: User searches and filters recipes by multiple criteria.

```mermaid
sequenceDiagram
    actor User as User
    participant Browser as Browser
    participant Flask as Flask Server
    participant DB as MySQL Database
    
    User->>Browser: Access "All Recipes" page
    Browser->>Flask: GET /allrecipes.html
    
    Flask->>DB: SELECT recipe.*, user.username, AVG(rating.rating) as avg_rating FROM recipe LEFT JOIN user ON recipe.user_id = user.id LEFT JOIN rating ON recipe.id = rating.recipe_id WHERE recipe.status = 'approved' GROUP BY recipe.id ORDER BY recipe.created_at DESC
    DB->>Flask: Return recipe list
    
    Flask->>Browser: Render allrecipes.html with all recipes
    Browser->>User: Display recipe list
    
    User->>Browser: Enter search keyword
    User->>Browser: Select filters (category, difficulty, recipe_type, cooking_time)
    User->>Browser: Click "Search" or Apply filter
    
    Browser->>Flask: GET /allrecipes.html?search=keyword&category=Vietnamese&difficulty=Easy&recipe_type=Food&cooking_time=30
    
    Flask->>Flask: Build dynamic query
    Note over Flask: query = Recipe.query.filter(Recipe.status == 'approved')
    
    alt Has search keyword
        Flask->>Flask: query = query.filter(Recipe.title.contains(search) OR Recipe.description.contains(search))
    end
    
    alt Has category filter
        Flask->>Flask: query = query.filter(Recipe.category == category)
    end
    
    alt Has difficulty filter
        Flask->>Flask: query = query.filter(Recipe.difficulty == difficulty)
    end
    
    alt Has recipe_type filter
        Flask->>Flask: query = query.filter(Recipe.recipe_type == recipe_type)
    end
    
    alt Has cooking_time filter
        Flask->>Flask: query = query.filter(Recipe.cooking_time <= cooking_time)
    end
    
    Flask->>DB: Execute query with JOIN user and rating
    DB->>Flask: Return filtered recipe list
    
    Flask->>Browser: Render allrecipes.html with results
    Browser->>User: Display filtered recipe list
    
    alt No results
        Browser->>User: Display "No recipes found"
    end
```

**Related Components**:
- **Route**: `GET /allrecipes.html`
- **Models**: `Recipe`, `User`, `Rating`
- **Database Tables**: `recipe`, `user`, `rating`
- **Query Parameters**: `search`, `category`, `difficulty`, `recipe_type`, `cooking_time`

---

## 📊 Database Schema Overview

### Main tables and relationships:

```mermaid
erDiagram
    USER ||--o{ RECIPE : creates
    USER ||--o{ COMMENT : writes
    USER ||--o{ RATING : gives
    USER ||--o{ FAVORITE : has
    USER ||--o{ FOLLOW : follows
    USER ||--o{ NOTIFICATION : receives
    
    RECIPE ||--o{ COMMENT : has
    RECIPE ||--o{ RATING : has
    RECIPE ||--o{ FAVORITE : has
    RECIPE ||--o{ NOTIFICATION : triggers
    
    USER {
        int id PK
        string username UK
        string email UK
        string password_hash
        string profile_picture
        string bio
        boolean is_admin
        boolean is_online
    }
    
    RECIPE {
        int id PK
        string title
        text description
        text ingredients
        text instructions
        string category
        string difficulty
        int cooking_time
        string recipe_type
        string image_url
        int user_id FK
        string status
        datetime created_at
    }
    
    COMMENT {
        int id PK
        int user_id FK
        int recipe_id FK
        text comment
        datetime created_at
    }
    
    RATING {
        int id PK
        int user_id FK
        int recipe_id FK
        int rating
        datetime created_at
    }
    
    FAVORITE {
        int id PK
        int user_id FK
        int recipe_id FK
    }
    
    FOLLOW {
        int id PK
        int follower_id FK
        int followed_id FK
        datetime created_at
    }
    
    NOTIFICATION {
        int id PK
        int user_id FK
        int actor_id FK
        int recipe_id FK
        string type
        text message
        boolean is_read
        datetime created_at
    }
```

---

## 🔐 Authentication Flow

### Authentication and authorization mechanism:

```mermaid
sequenceDiagram
    participant Client as Client
    participant Flask as Flask Server
    participant LoginManager as Flask-Login
    participant DB as Database
    
    Note over Client,DB: Initial Request
    Client->>Flask: Request with session cookie
    Flask->>LoginManager: load_user(user_id from session)
    LoginManager->>DB: SELECT * FROM user WHERE id = ?
    DB->>LoginManager: User data
    LoginManager->>Flask: current_user object
    
    Note over Client,DB: Protected Route
    Flask->>Flask: @login_required decorator
    alt User not logged in
        Flask->>Client: Redirect to /login.html
    else User logged in
        Flask->>Flask: Continue processing request
    end
    
    Note over Client,DB: Admin Route
    Flask->>Flask: @admin_required decorator
    alt User not admin
        Flask->>Client: Return 403 Forbidden
    else User is admin
        Flask->>Flask: Continue processing request
    end
```

---

## 📝 Technical Notes

### 1. **Session Management**
- Uses Flask-Login for session management
- Session stored in cookie with SECRET_KEY
- `current_user` automatically loaded for every request

### 2. **File Upload**
- Uses Werkzeug `secure_filename()` for security
- Generates unique UUID for each file
- Stored in `/static/uploads/profiles/` and `/static/uploads/recipes/`
- Limits: 16MB, extensions: png, jpg, jpeg, gif, webp

### 3. **Password Security**
- Hash password with Werkzeug `generate_password_hash()`
- Verify with `check_password_hash()`
- Never store plain text passwords

### 4. **Notification System**
- Creates notifications for events:
  - `follow`: When followed
  - `comment`: When new comment received
  - `rating`: When new rating received
  - `recipe_approved`: When recipe approved
  - `recipe_rejected`: When recipe rejected
- Real-time update with AJAX polling

### 5. **Database Queries**
- Uses SQLAlchemy ORM
- JOIN tables to reduce number of queries
- Eager loading with `db.relationship()`
- Pagination for large lists

### 6. **Recipe Status Flow**
```
pending → approved (by admin)
pending → rejected (by admin)
```

### 7. **API Endpoints**
- RESTful design
- JSON response for AJAX requests
- HTTP status codes: 200 (OK), 401 (Unauthorized), 403 (Forbidden), 404 (Not Found)

---

## 🎯 Conclusion

This document provides **12 detailed UML Sequence Diagrams** for all major business flows in the FlavorVerse CookBook Platform system:

✅ **Authentication**: Registration, Login  
✅ **Recipe Management**: Create, View, Edit, Delete recipes  
✅ **Social Features**: Follow, Favorite, Comment, Rating  
✅ **Notification System**: Real-time notifications  
✅ **Admin Functions**: Approve recipes, Manage users  
✅ **User Profile**: Update information, Upload avatar  
✅ **Search & Filter**: Search and filter recipes  

Each diagram includes:
- Actors and participants
- Detailed interaction flows
- Error handling
- Database operations
- Notification triggers
- Authentication checks

---

**Author**: Team CookBookG5  
**Last Updated**: 2025-12-06  
**Version**: 1.0
