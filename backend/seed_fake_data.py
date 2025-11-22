import os
import random
import sys

from werkzeug.security import generate_password_hash

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from mycookbook import app, db, User, Recipe  # noqa: E402


TARGET_USERS = 10
TARGET_RECIPES = 30

USER_PROFILES = [
    ("ChefLuna", "luna@example.com"),
    ("HerbMaster", "herbmaster@example.com"),
    ("SpiceGuru", "spiceguru@example.com"),
    ("SweetTooth", "sweettooth@example.com"),
    ("BentoBoss", "bentoboss@example.com"),
    ("VeganVibes", "veganvibes@example.com"),
    ("GrillKing", "grillking@example.com"),
    ("SoupSorcerer", "soupsorcerer@example.com"),
    ("MidnightBaker", "midnightbaker@example.com"),
    ("BrunchBuddy", "brunchbuddy@example.com"),
    ("NoodleNinja", "noodleninja@example.com"),
    ("CurryCrafter", "currycrafter@example.com"),
    ("GardenChef", "gardenchef@example.com"),
    ("CozyCook", "cozycook@example.com")
]

RECIPE_TEMPLATES = [
    {
        "title": "Spicy Lemongrass Chicken",
        "category": "Vietnamese",
        "difficulty": "Medium",
        "cooking_time": 45,
        "description": "Juicy chicken thighs marinated with lemongrass, chili, and fish sauce, then pan-seared until caramelized.",
        "ingredients": "600g chicken thighs\n4 stalks lemongrass\n3 tbsp fish sauce\n1 tbsp sugar\n2 cloves garlic\nFresh chili\nSpring onions",
        "instructions": "1. Mince lemongrass, garlic, and chili\n2. Marinate chicken with spices for 30 minutes\n3. Heat pan with a bit of oil\n4. Sear chicken skin-side down until golden\n5. Flip and cook through\n6. Garnish with spring onions and serve with rice",
        "image_url": "https://images.unsplash.com/photo-1504674900247-0877df9cc836"
    },
    {
        "title": "Citrus Herb Salmon",
        "category": "Seafood",
        "difficulty": "Easy",
        "cooking_time": 25,
        "description": "Zesty baked salmon with fresh herbs, perfect for a light dinner.",
        "ingredients": "4 salmon fillets\n2 oranges\n1 lemon\nFresh dill\nOlive oil\nSalt & pepper",
        "instructions": "1. Preheat oven to 200°C\n2. Place salmon on parchment\n3. Top with citrus slices and herbs\n4. Drizzle olive oil\n5. Bake for 15 minutes\n6. Serve with mixed greens",
        "image_url": "https://images.unsplash.com/photo-1485921325833-c519f76c4927"
    },
    {
        "title": "Roasted Vegetable Buddha Bowl",
        "category": "Healthy",
        "difficulty": "Easy",
        "cooking_time": 35,
        "description": "Colorful bowl with roasted veggies, quinoa, and tahini dressing.",
        "ingredients": "2 cups quinoa\n1 sweet potato\n1 zucchini\nBroccoli florets\nCherry tomatoes\nChickpeas\nTahini dressing",
        "instructions": "1. Cook quinoa per package\n2. Toss veggies with olive oil and roast\n3. Roast chickpeas until crispy\n4. Assemble bowl with quinoa base\n5. Add veggies and drizzle dressing",
        "image_url": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd"
    },
    {
        "title": "Classic Beef Lasagna",
        "category": "Italian",
        "difficulty": "Medium",
        "cooking_time": 70,
        "description": "Layers of rich meat sauce, creamy béchamel, and mozzarella.",
        "ingredients": "12 lasagna sheets\n500g ground beef\nTomato sauce\nOnion\nGarlic\nMozzarella\nParmesan\nMilk\nButter\nFlour",
        "instructions": "1. Cook beef with onion and garlic\n2. Simmer with tomato sauce\n3. Prepare béchamel sauce\n4. Layer pasta, sauces, and cheese\n5. Bake at 190°C for 40 minutes\n6. Let rest before slicing",
        "image_url": "https://images.unsplash.com/photo-1608039829574-6cff58c46a5c"
    },
    {
        "title": "Matcha Tiramisu",
        "category": "Dessert",
        "difficulty": "Hard",
        "cooking_time": 90,
        "description": "Japanese twist on the classic tiramisu with earthy matcha flavor.",
        "ingredients": "Ladyfingers\n250g mascarpone\n3 eggs\n80g sugar\nMatcha powder\nMilk\nWhite chocolate",
        "instructions": "1. Separate eggs and whip yolks with sugar\n2. Fold in mascarpone\n3. Beat egg whites to stiff peaks and fold in\n4. Dip ladyfingers in matcha milk\n5. Layer with cream\n6. Chill 4 hours and dust with matcha",
        "image_url": "https://images.unsplash.com/photo-1505253758473-96b7015fcd40"
    },
    {
        "title": "Caramelized Pork Belly Bites",
        "category": "Vietnamese",
        "difficulty": "Medium",
        "cooking_time": 60,
        "description": "Thịt kho kiểu mới với lớp caramel bóng mượt, ăn cùng cơm nóng.",
        "ingredients": "600g pork belly\nCoconut water\nFish sauce\nBrown sugar\nGarlic\nShallots\nBlack pepper",
        "instructions": "1. Cut pork into cubes\n2. Caramelize sugar until amber\n3. Add pork and aromatics\n4. Pour coconut water, simmer 40 minutes\n5. Reduce sauce until glossy\n6. Serve with pickled veggies",
        "image_url": "https://images.unsplash.com/photo-1504674900247-0877df9cc836"
    },
    {
        "title": "Miso Ramen with Soft Eggs",
        "category": "Japanese",
        "difficulty": "Medium",
        "cooking_time": 50,
        "description": "Comforting miso broth with chewy noodles, charred corn, and jammy eggs.",
        "ingredients": "Ramen noodles\n4 cups chicken broth\nMiso paste\nSoy sauce\nSesame oil\nCorn\nSoft-boiled eggs\nGreen onions",
        "instructions": "1. Simmer broth with miso and soy\n2. Cook noodles separately\n3. Char corn in a hot pan\n4. Assemble bowl with noodles and broth\n5. Top with eggs, corn, and onions",
        "image_url": "https://images.unsplash.com/photo-1504674900247-0877df9cc836?fit=crop&w=900&q=80"
    },
    {
        "title": "Thai Mango Sticky Rice",
        "category": "Dessert",
        "difficulty": "Easy",
        "cooking_time": 30,
        "description": "Sweet sticky rice infused with coconut milk, served with ripe mango.",
        "ingredients": "1 cup glutinous rice\n1 can coconut milk\n4 tbsp sugar\nPinch of salt\n2 ripe mangoes\nToasted sesame seeds",
        "instructions": "1. Steam sticky rice until tender\n2. Warm coconut milk with sugar and salt\n3. Mix half of coconut sauce with rice\n4. Serve rice with sliced mango\n5. Drizzle extra sauce and sprinkle sesame seeds",
        "image_url": "https://images.unsplash.com/photo-1499636136210-6f4ee915583e"
    },
    {
        "title": "Korean BBQ Beef Tacos",
        "category": "Fusion",
        "difficulty": "Easy",
        "cooking_time": 35,
        "description": "Tacos filled with bulgogi beef, kimchi slaw, and gochujang crema.",
        "ingredients": "8 tortillas\n400g beef sirloin\nSoy sauce\nPear puree\nGarlic\nKimchi\nCabbage\nGochujang\nSour cream",
        "instructions": "1. Marinate beef with soy, pear, garlic\n2. Grill beef and slice thinly\n3. Toss kimchi with shredded cabbage\n4. Mix gochujang with sour cream\n5. Assemble tacos and serve immediately",
        "image_url": "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe"
    },
    {
        "title": "Mediterranean Mezze Platter",
        "category": "Appetizer",
        "difficulty": "Easy",
        "cooking_time": 20,
        "description": "Assorted dips, roasted veggies, olives, and warm pita.",
        "ingredients": "Hummus\nBaba ghanoush\nRoasted peppers\nOlives\nCucumber\nCherry tomatoes\nFeta\nPita bread",
        "instructions": "1. Warm pita in oven\n2. Arrange dips in bowls\n3. Slice veggies and drizzle olive oil\n4. Plate everything on large board\n5. Garnish with herbs and serve",
        "image_url": "https://images.unsplash.com/photo-1466978913421-dad2ebd01d17"
    }
]


def ensure_users():
    existing_users = User.query.count()
    created = 0

    for username, email in USER_PROFILES:
        if User.query.filter((User.username == username) | (User.email == email)).first():
            continue
        if existing_users + created >= TARGET_USERS:
            break

        user = User(
            username=username,
            email=email,
            password_hash=generate_password_hash("password123"),
            bio="Food lover who enjoys sharing kitchen experiments."
        )
        db.session.add(user)
        created += 1

    if created:
        db.session.commit()
    return created


def ensure_recipes():
    recipes_created = 0
    current_count = Recipe.query.count()
    users = User.query.all()

    if not users:
        raise RuntimeError("No users available to assign recipes.")

    recipe_pool = RECIPE_TEMPLATES * 4  # ensure enough entries
    random.shuffle(recipe_pool)

    while current_count + recipes_created < TARGET_RECIPES and recipe_pool:
        template = recipe_pool.pop()
        author = random.choice(users)

        recipe = Recipe(
            title=f"{template['title']} #{current_count + recipes_created + 1}",
            description=template['description'],
            ingredients=template['ingredients'],
            instructions=template['instructions'],
            cooking_time=template['cooking_time'],
            difficulty=template['difficulty'],
            category=template['category'],
            image_url=template['image_url'],
            user_id=author.id
        )
        db.session.add(recipe)
        recipes_created += 1

    if recipes_created:
        db.session.commit()
    return recipes_created


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
        new_users = ensure_users()
        new_recipes = ensure_recipes()
        print(f"✅ Added {new_users} users and {new_recipes} recipes (totals now {User.query.count()} users / {Recipe.query.count()} recipes).")

