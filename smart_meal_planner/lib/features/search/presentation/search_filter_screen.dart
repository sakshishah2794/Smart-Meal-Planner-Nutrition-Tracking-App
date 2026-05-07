import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../meal_planning/providers/meal_provider.dart';
import '../../meal_planning/data/meal_entry.dart';
import '../../food_database/data/food_database.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedMealType;
  DateTime? _selectedDate;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mp, _) {
        final filtered = _filterMeals(mp.allMeals);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: const Text('Search & Filter', style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
                  ),
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (q) => setState(() => _searchQuery = q),
                      decoration: InputDecoration(
                        hintText: 'Search logged meals...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(icon: const Icon(Icons.close, color: AppColors.textMuted, size: 18),
                                onPressed: () { _searchCtrl.clear(); setState(() => _searchQuery = ''); })
                            : null,
                      ),
                    ),
                  ),
                ),

                // Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(children: [
                      // Date filter
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context, initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2024), lastDate: DateTime.now(),
                              builder: (ctx, child) => Theme(
                                data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface, onSurface: AppColors.textPrimary)),
                                child: child!),
                            );
                            setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedDate != null ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _selectedDate != null ? AppColors.primary : AppColors.border),
                            ),
                            child: Row(children: [
                              Icon(Icons.calendar_today_rounded, size: 16, color: _selectedDate != null ? AppColors.primary : AppColors.textMuted),
                              const SizedBox(width: 8),
                              Expanded(child: Text(
                                _selectedDate != null ? DateFormat('MMM d, yyyy').format(_selectedDate!) : 'Any Date',
                                style: TextStyle(color: _selectedDate != null ? AppColors.primary : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              )),
                              if (_selectedDate != null)
                                GestureDetector(
                                  onTap: () => setState(() => _selectedDate = null),
                                  child: const Icon(Icons.close, size: 16, color: AppColors.primary),
                                ),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Meal type filter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: _selectedMealType != null ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _selectedMealType != null ? AppColors.primary : AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMealType,
                              isExpanded: true,
                              hint: const Text('Any Meal', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              dropdownColor: AppColors.surface,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Meals', style: TextStyle(color: AppColors.textPrimary, fontSize: 13))),
                                ...FoodDatabase.mealTypes.map((t) => DropdownMenuItem(value: t,
                                  child: Text(t, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)))),
                              ],
                              onChanged: (v) => setState(() => _selectedMealType = v),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

                // Results count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text('${filtered.length} results', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ),
                ),

                // Results
                if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text('No meals found', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
                      ])),
                    ),
                  ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final meal = filtered[i];
                      return _mealResult(meal, mp);
                    },
                    childCount: filtered.length,
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

  List<MealEntry> _filterMeals(List<MealEntry> all) {
    return all.where((m) {
      final matchesSearch = _searchQuery.isEmpty || m.foodName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedMealType == null || m.mealType == _selectedMealType;
      final matchesDate = _selectedDate == null || m.dateKey == '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      return matchesSearch && matchesType && matchesDate;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Widget _mealResult(MealEntry meal, MealProvider mp) {
    Color mealColor;
    switch (meal.mealType) {
      case 'Breakfast': mealColor = AppColors.breakfast; break;
      case 'Lunch': mealColor = AppColors.lunch; break;
      case 'Dinner': mealColor = AppColors.dinner; break;
      default: mealColor = AppColors.snacks;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Dismissible(
        key: Key(meal.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.delete_rounded, color: AppColors.error),
        ),
        onDismissed: (_) => mp.deleteMeal(meal.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Container(width: 4, height: 44, decoration: BoxDecoration(color: mealColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(meal.foodName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text('${meal.quantity.toStringAsFixed(0)}g • ${meal.mealType} • ${DateFormat('MMM d').format(meal.date)}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ])),
            Text('${meal.calories.toStringAsFixed(0)} kcal', style: TextStyle(color: mealColor, fontWeight: FontWeight.w700, fontSize: 14)),
          ]),
        ),
      ),
    );
  }
}
