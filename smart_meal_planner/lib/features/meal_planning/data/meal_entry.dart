import 'package:hive/hive.dart';

part 'meal_entry.g.dart';

@HiveType(typeId: 1)
class MealEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String foodItemId;

  @HiveField(2)
  String foodName;

  @HiveField(3)
  double quantity; // in grams

  @HiveField(4)
  String mealType; // Breakfast, Lunch, Dinner, Snacks

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  double calories;

  @HiveField(7)
  double protein;

  @HiveField(8)
  double carbs;

  @HiveField(9)
  double fats;

  @HiveField(10)
  bool isSynced;

  MealEntry({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.quantity,
    required this.mealType,
    required this.date,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
    this.isSynced = false,
  });

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  MealEntry copyWith({
    String? id,
    String? foodItemId,
    String? foodName,
    double? quantity,
    String? mealType,
    DateTime? date,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    bool? isSynced,
  }) {
    return MealEntry(
      id: id ?? this.id,
      foodItemId: foodItemId ?? this.foodItemId,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
