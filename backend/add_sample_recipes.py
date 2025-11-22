import os
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from mycookbook import app, db, User, Recipe

with app.app_context():
    # Create tables if they don't exist
    db.create_all()

    # Check if we already have recipes
    if Recipe.query.count() > 0:
        print("Recipes already exist, skipping...")
        sys.exit(0)

    # Create a sample user if none exists
    user = User.query.filter_by(email='sample@example.com').first()
    if not user:
        user = User(
            username='ChefSample',
            email='sample@example.com',
            password_hash='scrypt:32768:8:1$Nm2BTbRL4Qxpi29D$0fb0be23380c59182c677be638e6a517bdbb0f17a34deac250990a9e6b4cd8383051e8f4cc8e861b300e04d2afeec23cc85cda7de73731ffb0fe30f22c7ba23b'  # password: sample123
        )
        db.session.add(user)
        db.session.commit()

    # Sample recipes
    recipes_data = [
        {
            'title': 'Bún Bò Huế',
            'description': 'A spicy Vietnamese beef noodle soup originating from the city of Huế. Known for its rich, flavorful broth and tender beef slices.',
            'ingredients': '500g beef bones\n300g beef brisket\n200g pork hock\n100g lemongrass\n50g chili paste\n30g shrimp paste\n200g rice noodles\nFresh herbs (basil, cilantro, lime)\n100g beef meatballs\n2 liters water',
            'instructions': '1. Clean and prepare the beef bones and meats\n2. Boil the bones for 30 minutes to remove impurities\n3. Add lemongrass, chili paste, and shrimp paste to create the broth base\n4. Simmer for 2-3 hours until the broth is rich and flavorful\n5. Cook the rice noodles separately\n6. Slice the cooked beef thinly\n7. Assemble the bowl with noodles, beef, meatballs, and hot broth\n8. Garnish with fresh herbs and serve with lime wedges',
            'cooking_time': 180,
            'difficulty': 'Medium',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/d8/53/70/d85370dd59d8780ccea3872ef8d79ddd.jpg'
        },
        {
            'title': 'Phở Bò',
            'description': 'Vietnam\'s most famous noodle soup, featuring tender slices of beef in a fragrant, clear broth served over rice noodles.',
            'ingredients': '1kg beef bones\n500g beef brisket\n200g rice noodles\n100g onions\n50g ginger\n30g star anise\n20g cinnamon\nFresh herbs (basil, cilantro, green onions)\n100g bean sprouts\nLime wedges\nHoisin sauce\nSriracha',
            'instructions': '1. Roast onions and ginger until charred\n2. Clean and boil beef bones to make clear broth\n3. Add roasted aromatics and spices to the broth\n4. Simmer for 4-6 hours to develop rich flavor\n5. Cook rice noodles separately\n6. Thinly slice the cooked beef\n7. Assemble bowls with noodles, raw and cooked beef\n8. Pour hot broth over the top\n9. Garnish with herbs and serve with accompaniments',
            'cooking_time': 360,
            'difficulty': 'Hard',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/f7/c4/72/f7c472ad678887044fc886a2b332f737.jpg'
        },
        {
            'title': 'Gỏi Cuốn',
            'description': 'Fresh spring rolls filled with shrimp, pork, vermicelli noodles, and fresh herbs, served with a tangy peanut sauce.',
            'ingredients': '200g shrimp\n200g pork belly\n100g rice vermicelli\nRice paper wrappers\nFresh herbs (mint, basil, cilantro)\nLettuce leaves\n50g roasted peanuts\nPeanut sauce ingredients (hoisin, peanut butter, water)\nBean sprouts',
            'instructions': '1. Cook shrimp and pork, then slice thinly\n2. Cook vermicelli noodles and cool\n3. Prepare all filling ingredients\n4. Soak rice paper in warm water until pliable\n5. Fill with shrimp, pork, noodles, and herbs\n6. Roll tightly like a burrito\n7. Prepare peanut sauce by mixing ingredients\n8. Serve rolls with sauce for dipping',
            'cooking_time': 45,
            'difficulty': 'Easy',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/16/4c/93/164c9332f3f7523d381026d7835ed00c.jpg'
        },
        {
            'title': 'Cơm Tấm Sườn Bì',
            'description': 'Broken rice served with grilled pork chop, shredded pork skin, and a fried egg, accompanied by pickled vegetables and fish sauce.',
            'ingredients': '300g pork chop\n200g pork skin\n2 cups broken rice\n2 eggs\nPickled mustard greens\nCucumber\nTomato\nFish sauce\nSugar\nGarlic\nOil for frying',
            'instructions': '1. Marinate pork chop with garlic, sugar, and fish sauce\n2. Grill or pan-fry the pork chop until caramelized\n3. Boil and shred the pork skin\n4. Cook broken rice\n5. Fry eggs sunny-side up\n6. Prepare nuoc cham sauce\n7. Slice pickled vegetables\n8. Assemble plate with rice, pork, egg, and vegetables\n9. Serve with sauce',
            'cooking_time': 60,
            'difficulty': 'Medium',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/d3/8b/f7/d38bf71b127dd69a49cd0e6b9c32b7b3.jpg'
        },
        {
            'title': 'Cà Phê Sữa Đá',
            'description': 'Vietnamese iced coffee made with dark roast coffee and sweetened condensed milk, served over ice.',
            'ingredients': '4 tbsp ground Vietnamese coffee\n4 tbsp sweetened condensed milk\n2 cups hot water\nIce cubes\nPhin filter (Vietnamese coffee maker)',
            'instructions': '1. Place coffee grounds in phin filter\n2. Slowly pour hot water over grounds\n3. Let coffee drip through (about 4-5 minutes)\n4. Fill glass with ice\n5. Add 2 tbsp sweetened condensed milk to glass\n6. Pour brewed coffee over ice and milk\n7. Stir well and serve immediately',
            'cooking_time': 10,
            'difficulty': 'Easy',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/ca/a1/2a/caa12ac72049ad2e8225bc5782be2dc0.jpg'
        },
        {
            'title': 'Bánh Mì Thịt Nướng',
            'description': 'Vietnamese sandwich with grilled pork, pickled vegetables, fresh herbs, and mayo in a crispy baguette.',
            'ingredients': '300g pork shoulder\n2 baguettes\nPickled carrots and daikon\nCucumber\nCilantro\nMint\nMayonnaise\nSoy sauce\nFish sauce\nGarlic\nSugar\nOil',
            'instructions': '1. Marinate pork with garlic, soy sauce, fish sauce, and sugar\n2. Grill or pan-fry pork until cooked and slightly charred\n3. Slice pork thinly\n4. Prepare pickled vegetables\n5. Slice baguette and spread mayo\n6. Layer pork, pickled veggies, cucumber, and herbs\n7. Close sandwich and serve',
            'cooking_time': 45,
            'difficulty': 'Easy',
            'category': 'Vietnamese',
            'image_url': 'https://i.pinimg.com/736x/f3/c4/ab/f3c4abded1846802415d038551270f8c.jpg'
        }
    ]

    for recipe_data in recipes_data:
        recipe = Recipe(
            title=recipe_data['title'],
            description=recipe_data['description'],
            ingredients=recipe_data['ingredients'],
            instructions=recipe_data['instructions'],
            cooking_time=recipe_data['cooking_time'],
            difficulty=recipe_data['difficulty'],
            category=recipe_data['category'],
            image_url=recipe_data['image_url'],
            user_id=user.id
        )
        db.session.add(recipe)

    db.session.commit()
    print(f"✅ Added {len(recipes_data)} sample recipes successfully!")
