import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/meal_type_chip.dart';
import '../../meal_planning/providers/meal_provider.dart';
import '../../meal_planning/data/meal_entry.dart';
import '../../food_database/data/food_database.dart';
import '../../food_database/presentation/food_selection_screen.dart';

class MealPlanningScreen extends StatelessWidget {
  const MealPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mp, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(context, mp)),
                SliverToBoxAdapter(child: _filterChips(mp)),
                ...FoodDatabase.mealTypes.where((t) =>
                  mp.filterMealType == null || mp.filterMealType == t
                ).map((t) => SliverToBoxAdapter(
                  child: _mealSection(context, t, mp),
                )),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddSheet(context),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, MealProvider mp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Meal Plan', style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(DateFormat('EEEE, MMM d').format(mp.selectedDate),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          ]),
          Row(children: [
            _navBtn(Icons.chevron_left_rounded, () => mp.setSelectedDate(mp.selectedDate.subtract(const Duration(days: 1)))),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => mp.setSelectedDate(DateTime.now()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: const Text('Today', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 8),
            _navBtn(Icons.chevron_right_rounded, () {
              final next = mp.selectedDate.add(const Duration(days: 1));
              if (!next.isAfter(DateTime.now())) mp.setSelectedDate(next);
            }),
          ]),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _filterChips(MealProvider mp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          MealTypeChip(mealType: 'All', isSelected: mp.filterMealType == null, onTap: () => mp.setFilterMealType(null)),
          const SizedBox(width: 8),
          ...FoodDatabase.mealTypes.map((t) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MealTypeChip(mealType: t, isSelected: mp.filterMealType == t,
              onTap: () => mp.setFilterMealType(mp.filterMealType == t ? null : t)),
          )),
        ]),
      ),
    );
  }

  Color _mealColor(String t) {
    switch (t) { case 'Breakfast': return AppColors.breakfast; case 'Lunch': return AppColors.lunch; case 'Dinner': return AppColors.dinner; default: return AppColors.snacks; }
  }

  IconData _mealIcon(String t) {
    switch (t) { case 'Breakfast': return Icons.wb_sunny_rounded; case 'Lunch': return Icons.restaurant_rounded; case 'Dinner': return Icons.nights_stay_rounded; default: return Icons.cookie_rounded; }
  }

  Widget _mealSection(BuildContext context, String type, MealProvider mp) {
    final meals = mp.getMealsForDateAndType(mp.selectedDate, type);
    final color = _mealColor(type);
    final totalCal = meals.fold(0.0, (s, m) => s + m.calories);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(_mealIcon(type), color: color, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(type, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
                Text('${meals.length} items • ${totalCal.toStringAsFixed(0)} kcal', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodSelectionScreen(mealType: type))),
                child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.add_rounded, color: color, size: 20)),
              ),
            ]),
          ),
          if (meals.isNotEmpty) const Divider(height: 1, color: AppColors.border),
          ...meals.map((meal) => Dismissible(
            key: Key(meal.id), direction: DismissDirection.endToStart,
            background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1)),
              child: const Icon(Icons.delete_rounded, color: AppColors.error, size: 20)),
            onDismissed: (_) => mp.deleteMeal(meal.id),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(meal.foodName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                  Text('${meal.quantity.toStringAsFixed(0)}g', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ])),
                Text('${meal.calories.toStringAsFixed(0)} kcal', style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
              ])),
          )),
          if (meals.isEmpty) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text('No items added', style: TextStyle(color: AppColors.textMuted, fontSize: 13))),
        ]),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Select Meal Type', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          ...FoodDatabase.mealTypes.map((type) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => FoodSelectionScreen(mealType: type))); },
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _mealColor(type).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(_mealIcon(type), color: _mealColor(type))),
              title: Text(type, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: AppColors.cardBg,
            ),
          )),
        ]),
      ),
    );
  }
}
