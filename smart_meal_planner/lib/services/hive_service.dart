import 'package:hive_flutter/hive_flutter.dart';
import '../features/food_database/data/food_item.dart';
import '../features/meal_planning/data/meal_entry.dart';
import '../features/goals/data/nutrition_goal.dart';
import '../features/food_database/data/food_database.dart';

class HiveService {
  static const String foodItemsBox = 'food_items';
  static const String mealEntriesBox = 'meal_entries';
  static const String nutritionGoalBox = 'nutrition_goal';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(MealEntryAdapter());
    Hive.registerAdapter(NutritionGoalAdapter());

    // Open boxes
    await Hive.openBox<FoodItem>(foodItemsBox);
    await Hive.openBox<MealEntry>(mealEntriesBox);
    await Hive.openBox<NutritionGoal>(nutritionGoalBox);

    // Seed default foods if empty
    await _seedDefaultFoods();

    // Seed default goal if empty
    await _seedDefaultGoal();
  }

  static Future<void> _seedDefaultFoods() async {
    final box = Hive.box<FoodItem>(foodItemsBox);
    if (box.isEmpty) {
      final defaults = FoodDatabase.defaultFoods;
      for (final food in defaults) {
        await box.put(food.id, food);
      }
    }
  }

  static Future<void> _seedDefaultGoal() async {
    final box = Hive.box<NutritionGoal>(nutritionGoalBox);
    if (box.isEmpty) {
      await box.put('default', NutritionGoal());
    }
  }

  // Food Items
  static Box<FoodItem> getFoodBox() => Hive.box<FoodItem>(foodItemsBox);
  static Box<MealEntry> getMealBox() => Hive.box<MealEntry>(mealEntriesBox);
  static Box<NutritionGoal> getGoalBox() => Hive.box<NutritionGoal>(nutritionGoalBox);
}
