import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 0)
class FoodItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double caloriesPer100g;

  @HiveField(3)
  double proteinPer100g;

  @HiveField(4)
  double carbsPer100g;

  @HiveField(5)
  double fatsPer100g;

  @HiveField(6)
  String category;

  @HiveField(7)
  bool isCustom;

  FoodItem({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    this.proteinPer100g = 0,
    this.carbsPer100g = 0,
    this.fatsPer100g = 0,
    this.category = 'General',
    this.isCustom = false,
  });

  double getCalories(double grams) => (caloriesPer100g * grams) / 100;
  double getProtein(double grams) => (proteinPer100g * grams) / 100;
  double getCarbs(double grams) => (carbsPer100g * grams) / 100;
  double getFats(double grams) => (fatsPer100g * grams) / 100;

  FoodItem copyWith({
    String? id,
    String? name,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatsPer100g,
    String? category,
    bool? isCustom,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatsPer100g: fatsPer100g ?? this.fatsPer100g,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
