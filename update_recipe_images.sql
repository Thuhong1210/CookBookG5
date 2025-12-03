-- Update images for all existing recipes to ensure they are beautiful and accurate

-- Breakfast
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=400' WHERE title LIKE '%Pancakes%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400' WHERE title LIKE '%Avocado Toast%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1638176311291-36123011387d?w=400' WHERE title LIKE '%Smoothie Bowl%';

-- Seafood
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400' WHERE title LIKE '%Salmon%';

-- Asian
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400' WHERE title LIKE '%Ramen%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400' WHERE title LIKE '%Stir Fry%';

-- Italian
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400' WHERE title LIKE '%Pizza%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1612874742237-98280d20748b?w=400' WHERE title LIKE '%Carbonara%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400' WHERE title LIKE '%Pasta%';

-- Mexican
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400' WHERE title LIKE '%Tacos%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1534352956036-c01ac18bd985?w=400' WHERE title LIKE '%Enchiladas%';

-- Desserts
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=400' WHERE title LIKE '%Lava Cake%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400' WHERE title LIKE '%Tiramisu%';

-- Healthy
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400' WHERE title LIKE '%Buddha Bowl%';

-- Test/Other Recipes (Generic Food Images)
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400' WHERE title LIKE '%Test Recipe 1%';
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400' WHERE title LIKE '%Test Recipe 2%';

-- Fallback for any remaining recipes without images (Generic Cooking Image)
UPDATE recipe SET image_url = 'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=400' WHERE image_url IS NULL OR image_url = '';
