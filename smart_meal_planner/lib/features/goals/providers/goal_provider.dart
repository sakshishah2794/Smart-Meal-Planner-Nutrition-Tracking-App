import 'package:flutter/foundation.dart';
import '../data/nutrition_goal.dart';
import '../../../services/hive_service.dart';

class GoalProvider extends ChangeNotifier {
  NutritionGoal _goal = NutritionGoal();

  NutritionGoal get goal => _goal;

  GoalProvider() {
    loadGoal();
  }

  void loadGoal() {
    final box = HiveService.getGoalBox();
    if (box.isNotEmpty) {
      _goal = box.get('default') ?? NutritionGoal();
    }
    notifyListeners();
  }

  Future<void> updateGoal(NutritionGoal newGoal) async {
    final box = HiveService.getGoalBox();
    await box.put('default', newGoal);
    _goal = newGoal;
    notifyListeners();
  }

  double calorieProgress(double consumed) {
    if (_goal.targetCalories <= 0) return 0;
    return (consumed / _goal.targetCalories).clamp(0.0, 1.5);
  }

  double proteinProgress(double consumed) {
    if (_goal.targetProtein <= 0) return 0;
    return (consumed / _goal.targetProtein).clamp(0.0, 1.5);
  }

  double carbsProgress(double consumed) {
    if (_goal.targetCarbs <= 0) return 0;
    return (consumed / _goal.targetCarbs).clamp(0.0, 1.5);
  }

  double fatsProgress(double consumed) {
    if (_goal.targetFats <= 0) return 0;
    return (consumed / _goal.targetFats).clamp(0.0, 1.5);
  }

  double goalAchievementPercent(double consumedCalories) {
    if (_goal.targetCalories <= 0) return 0;
    final diff = (consumedCalories - _goal.targetCalories).abs();
    final tolerance = _goal.targetCalories * 0.1; // 10% tolerance
    if (diff <= tolerance) return 100;
    if (consumedCalories < _goal.targetCalories) {
      return (consumedCalories / _goal.targetCalories * 100).clamp(0, 100);
    }
    // Over-eating: reduce score
    return ((1 - (diff / _goal.targetCalories)) * 100).clamp(0, 100);
  }
}
