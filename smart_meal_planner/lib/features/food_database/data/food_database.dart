import 'package:uuid/uuid.dart';
import 'food_item.dart';

class FoodDatabase {
  FoodDatabase._();
  static const _uuid = Uuid();

  static List<FoodItem> get defaultFoods => [
        // Grains & Cereals
        FoodItem(id: _uuid.v4(), name: 'White Rice (cooked)', caloriesPer100g: 130, proteinPer100g: 2.7, carbsPer100g: 28.2, fatsPer100g: 0.3, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'Brown Rice (cooked)', caloriesPer100g: 112, proteinPer100g: 2.6, carbsPer100g: 23.5, fatsPer100g: 0.9, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'Chapati / Roti', caloriesPer100g: 297, proteinPer100g: 9.0, carbsPer100g: 55.0, fatsPer100g: 5.0, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'White Bread', caloriesPer100g: 265, proteinPer100g: 9.0, carbsPer100g: 49.0, fatsPer100g: 3.2, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'Oats (cooked)', caloriesPer100g: 71, proteinPer100g: 2.5, carbsPer100g: 12.0, fatsPer100g: 1.5, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'Pasta (cooked)', caloriesPer100g: 131, proteinPer100g: 5.0, carbsPer100g: 25.0, fatsPer100g: 1.1, category: 'Grains'),
        FoodItem(id: _uuid.v4(), name: 'Poha', caloriesPer100g: 110, proteinPer100g: 2.5, carbsPer100g: 22.0, fatsPer100g: 2.0, category: 'Grains'),

        // Proteins
        FoodItem(id: _uuid.v4(), name: 'Chicken Breast (grilled)', caloriesPer100g: 165, proteinPer100g: 31.0, carbsPer100g: 0.0, fatsPer100g: 3.6, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Egg (whole boiled)', caloriesPer100g: 155, proteinPer100g: 13.0, carbsPer100g: 1.1, fatsPer100g: 11.0, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Egg White', caloriesPer100g: 52, proteinPer100g: 11.0, carbsPer100g: 0.7, fatsPer100g: 0.2, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Dal (cooked)', caloriesPer100g: 116, proteinPer100g: 9.0, carbsPer100g: 20.0, fatsPer100g: 0.4, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Paneer', caloriesPer100g: 265, proteinPer100g: 18.0, carbsPer100g: 1.2, fatsPer100g: 20.0, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Tofu', caloriesPer100g: 76, proteinPer100g: 8.0, carbsPer100g: 1.9, fatsPer100g: 4.8, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Tuna (canned)', caloriesPer100g: 116, proteinPer100g: 25.5, carbsPer100g: 0.0, fatsPer100g: 1.0, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Salmon (grilled)', caloriesPer100g: 208, proteinPer100g: 20.0, carbsPer100g: 0.0, fatsPer100g: 13.0, category: 'Protein'),
        FoodItem(id: _uuid.v4(), name: 'Chickpeas (cooked)', caloriesPer100g: 164, proteinPer100g: 8.9, carbsPer100g: 27.4, fatsPer100g: 2.6, category: 'Protein'),

        // Dairy
        FoodItem(id: _uuid.v4(), name: 'Whole Milk', caloriesPer100g: 61, proteinPer100g: 3.2, carbsPer100g: 4.8, fatsPer100g: 3.3, category: 'Dairy'),
        FoodItem(id: _uuid.v4(), name: 'Curd / Yogurt', caloriesPer100g: 61, proteinPer100g: 3.5, carbsPer100g: 4.7, fatsPer100g: 3.3, category: 'Dairy'),
        FoodItem(id: _uuid.v4(), name: 'Greek Yogurt', caloriesPer100g: 59, proteinPer100g: 10.0, carbsPer100g: 3.6, fatsPer100g: 0.4, category: 'Dairy'),
        FoodItem(id: _uuid.v4(), name: 'Butter', caloriesPer100g: 717, proteinPer100g: 0.9, carbsPer100g: 0.1, fatsPer100g: 81.0, category: 'Dairy'),
        FoodItem(id: _uuid.v4(), name: 'Cheese (cheddar)', caloriesPer100g: 402, proteinPer100g: 25.0, carbsPer100g: 1.3, fatsPer100g: 33.0, category: 'Dairy'),

        // Vegetables
        FoodItem(id: _uuid.v4(), name: 'Spinach (raw)', caloriesPer100g: 23, proteinPer100g: 2.9, carbsPer100g: 3.6, fatsPer100g: 0.4, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Broccoli', caloriesPer100g: 34, proteinPer100g: 2.8, carbsPer100g: 7.0, fatsPer100g: 0.4, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Tomato', caloriesPer100g: 18, proteinPer100g: 0.9, carbsPer100g: 3.9, fatsPer100g: 0.2, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Potato (boiled)', caloriesPer100g: 77, proteinPer100g: 2.0, carbsPer100g: 17.0, fatsPer100g: 0.1, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Carrot (raw)', caloriesPer100g: 41, proteinPer100g: 0.9, carbsPer100g: 10.0, fatsPer100g: 0.2, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Onion', caloriesPer100g: 40, proteinPer100g: 1.1, carbsPer100g: 9.3, fatsPer100g: 0.1, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Cucumber', caloriesPer100g: 16, proteinPer100g: 0.7, carbsPer100g: 3.6, fatsPer100g: 0.1, category: 'Vegetables'),
        FoodItem(id: _uuid.v4(), name: 'Sweet Potato', caloriesPer100g: 86, proteinPer100g: 1.6, carbsPer100g: 20.0, fatsPer100g: 0.1, category: 'Vegetables'),

        // Fruits
        FoodItem(id: _uuid.v4(), name: 'Banana', caloriesPer100g: 89, proteinPer100g: 1.1, carbsPer100g: 23.0, fatsPer100g: 0.3, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Apple', caloriesPer100g: 52, proteinPer100g: 0.3, carbsPer100g: 14.0, fatsPer100g: 0.2, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Mango', caloriesPer100g: 60, proteinPer100g: 0.8, carbsPer100g: 15.0, fatsPer100g: 0.4, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Orange', caloriesPer100g: 47, proteinPer100g: 0.9, carbsPer100g: 12.0, fatsPer100g: 0.1, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Grapes', caloriesPer100g: 69, proteinPer100g: 0.7, carbsPer100g: 18.0, fatsPer100g: 0.2, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Strawberry', caloriesPer100g: 32, proteinPer100g: 0.7, carbsPer100g: 7.7, fatsPer100g: 0.3, category: 'Fruits'),
        FoodItem(id: _uuid.v4(), name: 'Watermelon', caloriesPer100g: 30, proteinPer100g: 0.6, carbsPer100g: 7.6, fatsPer100g: 0.2, category: 'Fruits'),

        // Snacks & Fast food
        FoodItem(id: _uuid.v4(), name: 'Almonds', caloriesPer100g: 579, proteinPer100g: 21.0, carbsPer100g: 22.0, fatsPer100g: 50.0, category: 'Snacks'),
        FoodItem(id: _uuid.v4(), name: 'Peanuts (roasted)', caloriesPer100g: 567, proteinPer100g: 26.0, carbsPer100g: 16.0, fatsPer100g: 49.0, category: 'Snacks'),
        FoodItem(id: _uuid.v4(), name: 'Peanut Butter', caloriesPer100g: 588, proteinPer100g: 25.0, carbsPer100g: 20.0, fatsPer100g: 50.0, category: 'Snacks'),
        FoodItem(id: _uuid.v4(), name: 'Dark Chocolate', caloriesPer100g: 546, proteinPer100g: 5.0, carbsPer100g: 60.0, fatsPer100g: 31.0, category: 'Snacks'),
        FoodItem(id: _uuid.v4(), name: 'Biscuits / Cookies', caloriesPer100g: 480, proteinPer100g: 6.5, carbsPer100g: 65.0, fatsPer100g: 22.0, category: 'Snacks'),
        FoodItem(id: _uuid.v4(), name: 'Chips (potato)', caloriesPer100g: 536, proteinPer100g: 7.0, carbsPer100g: 53.0, fatsPer100g: 34.0, category: 'Snacks'),

        // Beverages
        FoodItem(id: _uuid.v4(), name: 'Tea with Milk (no sugar)', caloriesPer100g: 18, proteinPer100g: 0.9, carbsPer100g: 2.4, fatsPer100g: 0.6, category: 'Beverages'),
        FoodItem(id: _uuid.v4(), name: 'Coffee (black)', caloriesPer100g: 2, proteinPer100g: 0.3, carbsPer100g: 0.0, fatsPer100g: 0.0, category: 'Beverages'),
        FoodItem(id: _uuid.v4(), name: 'Orange Juice', caloriesPer100g: 45, proteinPer100g: 0.7, carbsPer100g: 10.0, fatsPer100g: 0.2, category: 'Beverages'),
        FoodItem(id: _uuid.v4(), name: 'Protein Shake (whey)', caloriesPer100g: 100, proteinPer100g: 20.0, carbsPer100g: 5.0, fatsPer100g: 1.5, category: 'Beverages'),

        // Indian dishes
        FoodItem(id: _uuid.v4(), name: 'Idli (steamed)', caloriesPer100g: 130, proteinPer100g: 4.0, carbsPer100g: 26.0, fatsPer100g: 0.5, category: 'Indian'),
        FoodItem(id: _uuid.v4(), name: 'Dosa (plain)', caloriesPer100g: 168, proteinPer100g: 4.0, carbsPer100g: 30.0, fatsPer100g: 4.0, category: 'Indian'),
        FoodItem(id: _uuid.v4(), name: 'Sambar', caloriesPer100g: 50, proteinPer100g: 3.0, carbsPer100g: 7.0, fatsPer100g: 1.0, category: 'Indian'),
        FoodItem(id: _uuid.v4(), name: 'Rajma (cooked)', caloriesPer100g: 127, proteinPer100g: 9.0, carbsPer100g: 22.0, fatsPer100g: 0.5, category: 'Indian'),
        FoodItem(id: _uuid.v4(), name: 'Biryani (veg)', caloriesPer100g: 150, proteinPer100g: 4.0, carbsPer100g: 27.0, fatsPer100g: 3.5, category: 'Indian'),
        FoodItem(id: _uuid.v4(), name: 'Biryani (chicken)', caloriesPer100g: 180, proteinPer100g: 10.0, carbsPer100g: 25.0, fatsPer100g: 5.0, category: 'Indian'),
      ];

  static const List<String> categories = [
    'All',
    'Grains',
    'Protein',
    'Dairy',
    'Vegetables',
    'Fruits',
    'Snacks',
    'Beverages',
    'Indian',
    'Custom',
  ];

  static const List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];
}
