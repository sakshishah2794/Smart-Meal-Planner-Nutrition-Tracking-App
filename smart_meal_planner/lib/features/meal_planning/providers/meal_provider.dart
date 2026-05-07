import 'package:flutter/foundation.dart';
import '../../../features/meal_planning/data/meal_entry.dart';
import '../../../services/hive_service.dart';
import 'package:uuid/uuid.dart';

class MealProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  List<MealEntry> _allMeals = [];
  DateTime _selectedDate = DateTime.now();
  String? _filterMealType;

  List<MealEntry> get allMeals => _allMeals;
  DateTime get selectedDate => _selectedDate;
  String? get filterMealType => _filterMealType;

  MealProvider() {
    loadMeals();
  }

  String get _selectedDateKey =>
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

  void loadMeals() {
    final box = HiveService.getMealBox();
    _allMeals = box.values.toList();
    notifyListeners();
  }

  List<MealEntry> get mealsForSelectedDate {
    var meals = _allMeals.where((m) => m.dateKey == _selectedDateKey).toList();
    if (_filterMealType != null) {
      meals = meals.where((m) => m.mealType == _filterMealType).toList();
    }
    meals.sort((a, b) {
      const order = {'Breakfast': 0, 'Lunch': 1, 'Dinner': 2, 'Snacks': 3};
      return (order[a.mealType] ?? 4).compareTo(order[b.mealType] ?? 4);
    });
    return meals;
  }

  List<MealEntry> getMealsForDate(DateTime date) {
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _allMeals.where((m) => m.dateKey == key).toList();
  }

  List<MealEntry> getMealsForDateAndType(DateTime date, String mealType) {
    return getMealsForDate(date).where((m) => m.mealType == mealType).toList();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void setFilterMealType(String? type) {
    _filterMealType = type;
    notifyListeners();
  }

  // Daily totals for selected date
  double get totalCaloriesToday =>
      mealsForSelectedDate.fold(0, (sum, m) => sum + m.calories);
  double get totalProteinToday =>
      mealsForSelectedDate.fold(0, (sum, m) => sum + m.protein);
  double get totalCarbsToday =>
      mealsForSelectedDate.fold(0, (sum, m) => sum + m.carbs);
  double get totalFatsToday =>
      mealsForSelectedDate.fold(0, (sum, m) => sum + m.fats);

  // Totals for any date
  double totalCaloriesForDate(DateTime date) =>
      getMealsForDate(date).fold(0, (sum, m) => sum + m.calories);
  double totalProteinForDate(DateTime date) =>
      getMealsForDate(date).fold(0, (sum, m) => sum + m.protein);
  double totalCarbsForDate(DateTime date) =>
      getMealsForDate(date).fold(0, (sum, m) => sum + m.carbs);
  double totalFatsForDate(DateTime date) =>
      getMealsForDate(date).fold(0, (sum, m) => sum + m.fats);

  // Meal type totals for selected date
  double caloriesForMealType(String mealType) =>
      mealsForSelectedDate
          .where((m) => m.mealType == mealType)
          .fold(0, (sum, m) => sum + m.calories);

  Future<void> addMeal(MealEntry meal) async {
    final entry = meal.copyWith(id: _uuid.v4());
    final box = HiveService.getMealBox();
    await box.put(entry.id, entry);
    loadMeals();
  }

  Future<void> updateMeal(MealEntry meal) async {
    final box = HiveService.getMealBox();
    await box.put(meal.id, meal);
    loadMeals();
  }

  Future<void> deleteMeal(String id) async {
    final box = HiveService.getMealBox();
    await box.delete(id);
    loadMeals();
  }

  // Weekly data for analytics
  List<Map<String, dynamic>> getWeeklyData() {
    final List<Map<String, dynamic>> weekData = [];
    final today = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(today.year, today.month, today.day - i);
      weekData.add({
        'date': date,
        'calories': totalCaloriesForDate(date),
        'protein': totalProteinForDate(date),
        'carbs': totalCarbsForDate(date),
        'fats': totalFatsForDate(date),
      });
    }
    return weekData;
  }
}
