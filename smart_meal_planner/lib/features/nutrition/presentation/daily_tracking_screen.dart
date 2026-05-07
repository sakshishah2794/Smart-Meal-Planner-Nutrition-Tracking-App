import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/calorie_ring_widget.dart';
import '../../../core/widgets/nutrient_progress_bar.dart';
import '../../meal_planning/providers/meal_provider.dart';
import '../../goals/providers/goal_provider.dart';
import '../../meal_planning/data/meal_entry.dart';

class DailyTrackingScreen extends StatelessWidget {
  const DailyTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<MealProvider, GoalProvider>(
      builder: (context, mealProvider, goalProvider, _) {
        final goal = goalProvider.goal;
        final totalCal = mealProvider.totalCaloriesToday;
        final totalProtein = mealProvider.totalProteinToday;
        final totalCarbs = mealProvider.totalCarbsToday;
        final totalFats = mealProvider.totalFatsToday;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Tracking',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, MMM d').format(mealProvider.selectedDate),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            _buildDatePicker(context, mealProvider),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Calorie Ring
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CalorieRingWidget(
                        consumed: totalCal,
                        target: goal.targetCalories,
                        size: 200,
                      ),
                    ),
                  ),
                ),

                // Macros summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Macros',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          NutrientProgressBar(
                            label: 'Protein',
                            current: totalProtein,
                            target: goal.targetProtein,
                            color: AppColors.protein,
                          ),
                          NutrientProgressBar(
                            label: 'Carbs',
                            current: totalCarbs,
                            target: goal.targetCarbs,
                            color: AppColors.carbs,
                          ),
                          NutrientProgressBar(
                            label: 'Fats',
                            current: totalFats,
                            target: goal.targetFats,
                            color: AppColors.fats,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Meal breakdown
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: const Text(
                      'Meal Breakdown',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildMealTypeCard('Breakfast', Icons.wb_sunny_rounded, AppColors.breakfast, mealProvider),
                        _buildMealTypeCard('Lunch', Icons.restaurant_rounded, AppColors.lunch, mealProvider),
                        _buildMealTypeCard('Dinner', Icons.nights_stay_rounded, AppColors.dinner, mealProvider),
                        _buildMealTypeCard('Snacks', Icons.cookie_rounded, AppColors.snacks, mealProvider),
                      ],
                    ),
                  ),
                ),

                // Meals list
                if (mealProvider.mealsForSelectedDate.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: const Text(
                        'Food Log',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final meal = mealProvider.mealsForSelectedDate[index];
                        return _buildMealTile(context, meal, mealProvider);
                      },
                      childCount: mealProvider.mealsForSelectedDate.length,
                    ),
                  ),
                ],

                if (mealProvider.mealsForSelectedDate.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.restaurant_menu_rounded, size: 60, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'No meals logged yet',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to add your first meal',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context, MealProvider provider) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: provider.selectedDate,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  surface: AppColors.surface,
                  onSurface: AppColors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          provider.setSelectedDate(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
      ),
    );
  }

  Widget _buildMealTypeCard(String type, IconData icon, Color color, MealProvider provider) {
    final cal = provider.caloriesForMealType(type);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(
                    '${provider.getMealsForDateAndType(provider.selectedDate, type).length} items',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${cal.toStringAsFixed(0)} kcal',
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(BuildContext context, MealEntry meal, MealProvider provider) {
    Color mealColor;
    switch (meal.mealType) {
      case 'Breakfast':
        mealColor = AppColors.breakfast;
        break;
      case 'Lunch':
        mealColor = AppColors.lunch;
        break;
      case 'Dinner':
        mealColor = AppColors.dinner;
        break;
      default:
        mealColor = AppColors.snacks;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Dismissible(
        key: Key(meal.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_rounded, color: AppColors.error),
        ),
        onDismissed: (_) {
          provider.deleteMeal(meal.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${meal.foodName} removed')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: mealColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.foodName,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${meal.quantity.toStringAsFixed(0)}g • ${meal.mealType}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${meal.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Text(
                    'P:${meal.protein.toStringAsFixed(0)} C:${meal.carbs.toStringAsFixed(0)} F:${meal.fats.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
