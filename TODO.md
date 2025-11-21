# TODO: Implement Rating and Commenting Functionality

## Database Models
- [x] Add Rating model to __init__.py (user_id, recipe_id, rating, created_at)
- [x] Add Comment model to __init__.py (user_id, recipe_id, comment, created_at)

## Routes
- [x] Add route to submit rating (/recipe/<id>/rate, POST)
- [x] Add route to submit comment (/recipe/<id>/comment, POST)
- [x] Update recipe details route to fetch and display real ratings/comments
- [x] Add route to get average rating for recipes

## Templates
- [x] Update Details.html to display dynamic reviews from database
- [x] Add form in Details.html for submitting ratings/comments (authenticated users only)
- [x] Update allrecipes.html to show calculated average ratings instead of hardcoded values

## Authentication & Validation
- [x] Ensure only logged-in users can submit ratings/comments
- [x] Add form validation for rating (1-5) and comment length
- [x] Prevent duplicate ratings from same user per recipe

## Testing
- [x] Test submitting ratings and comments
- [x] Verify average ratings display correctly
- [x] Test authentication requirements
