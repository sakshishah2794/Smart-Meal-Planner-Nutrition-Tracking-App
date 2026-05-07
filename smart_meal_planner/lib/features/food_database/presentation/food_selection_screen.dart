import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../data/food_item.dart';
import '../data/food_database.dart';
import '../providers/food_provider.dart';
import '../../meal_planning/providers/meal_provider.dart';
import '../../meal_planning/data/meal_entry.dart';
import 'package:uuid/uuid.dart';

class FoodSelectionScreen extends StatefulWidget {
  final String mealType;
  const FoodSelectionScreen({super.key, required this.mealType});

  @override
  State<FoodSelectionScreen> createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodProvider>(
      builder: (context, fp, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Add to ${widget.mealType}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                onPressed: () => _showCustomFoodDialog(context, fp),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (q) => fp.searchFoods(q),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search food items...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.close, color: AppColors.textMuted, size: 18),
                            onPressed: () { _searchCtrl.clear(); fp.searchFoods(''); })
                        : null,
                  ),
                ),
              ),
              // Category filter
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: FoodDatabase.categories.length,
                  itemBuilder: (_, i) {
                    final cat = FoodDatabase.categories[i];
                    final sel = fp.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => fp.filterByCategory(cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sel ? AppColors.primary : AppColors.border),
                          ),
                          child: Text(cat, style: TextStyle(
                            color: sel ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400, fontSize: 13)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Food list
              Expanded(
                child: fp.filteredFoods.isEmpty
                    ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text('No foods found', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _showCustomFoodDialog(context, fp),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add custom food'),
                        ),
                      ]))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: fp.filteredFoods.length,
                        itemBuilder: (_, i) => _foodTile(context, fp.filteredFoods[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _foodTile(BuildContext context, FoodItem food) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _showQuantityDialog(context, food),
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
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(food.name[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(food.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${food.caloriesPer100g.toStringAsFixed(0)} kcal/100g  •  ${food.category}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('P:${food.proteinPer100g.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.protein, fontSize: 11, fontWeight: FontWeight.w600)),
                Text('C:${food.carbsPer100g.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.carbs, fontSize: 11, fontWeight: FontWeight.w600)),
                Text('F:${food.fatsPer100g.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.fats, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(width: 8),
              const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, FoodItem food) {
    final qtyCtrl = TextEditingController(text: '100');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(food.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Quantity (grams)', suffixText: 'g'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            StatefulBuilder(builder: (ctx2, setState2) {
              final qty = double.tryParse(qtyCtrl.text) ?? 100;
              qtyCtrl.addListener(() => setState2(() {}));
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _macroPreview('Cal', food.getCalories(qty), AppColors.accent),
                  _macroPreview('P', food.getProtein(qty), AppColors.protein),
                  _macroPreview('C', food.getCarbs(qty), AppColors.carbs),
                  _macroPreview('F', food.getFats(qty), AppColors.fats),
                ]),
              );
            }),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid quantity > 0')));
                  return;
                }
                final mp = context.read<MealProvider>();
                mp.addMeal(MealEntry(
                  id: '', foodItemId: food.id, foodName: food.name,
                  quantity: qty, mealType: widget.mealType,
                  date: mp.selectedDate,
                  calories: food.getCalories(qty),
                  protein: food.getProtein(qty),
                  carbs: food.getCarbs(qty),
                  fats: food.getFats(qty),
                ));
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${food.name} added to ${widget.mealType}')));
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _macroPreview(String label, double value, Color color) {
    return Column(children: [
      Text(value.toStringAsFixed(1), style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
      Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
    ]);
  }

  void _showCustomFoodDialog(BuildContext context, FoodProvider fp) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final proCtrl = TextEditingController(text: '0');
    final carbCtrl = TextEditingController(text: '0');
    final fatCtrl = TextEditingController(text: '0');

    showDialog(context: context, builder: (ctx) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Custom Food', style: TextStyle(color: AppColors.textPrimary)),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Food Name')),
          const SizedBox(height: 10),
          TextField(controller: calCtrl, keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Calories per 100g')),
          const SizedBox(height: 10),
          TextField(controller: proCtrl, keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Protein per 100g (g)')),
          const SizedBox(height: 10),
          TextField(controller: carbCtrl, keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Carbs per 100g (g)')),
          const SizedBox(height: 10),
          TextField(controller: fatCtrl, keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Fats per 100g (g)')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(onPressed: () {
            if (nameCtrl.text.trim().isEmpty || calCtrl.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Name and calories are required')));
              return;
            }
            final cal = double.tryParse(calCtrl.text);
            if (cal == null || cal <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter valid calorie value')));
              return;
            }
            fp.addCustomFood(FoodItem(
              id: '', name: nameCtrl.text.trim(), caloriesPer100g: cal,
              proteinPer100g: double.tryParse(proCtrl.text) ?? 0,
              carbsPer100g: double.tryParse(carbCtrl.text) ?? 0,
              fatsPer100g: double.tryParse(fatCtrl.text) ?? 0,
            ));
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${nameCtrl.text.trim()} added to database')));
          }, child: const Text('Save')),
        ],
      );
    });
  }
}
