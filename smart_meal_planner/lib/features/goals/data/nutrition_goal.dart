import 'package:hive/hive.dart';

part 'nutrition_goal.g.dart';

@HiveType(typeId: 2)
class NutritionGoal extends HiveObject {
  @HiveField(0)
  double targetCalories;

  @HiveField(1)
  double targetProtein;

  @HiveField(2)
  double targetCarbs;

  @HiveField(3)
  double targetFats;

  NutritionGoal({
    this.targetCalories = 2000,
    this.targetProtein = 50,
    this.targetCarbs = 250,
    this.targetFats = 65,
  });

  NutritionGoal copyWith({
    double? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFats,
  }) {
    return NutritionGoal(
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFats: targetFats ?? this.targetFats,
    );
  }
}
