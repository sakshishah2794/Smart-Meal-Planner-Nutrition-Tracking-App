import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/goal_provider.dart';
import '../data/nutrition_goal.dart';

class GoalSettingScreen extends StatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late TextEditingController _calCtrl;
  late TextEditingController _proCtrl;
  late TextEditingController _carbCtrl;
  late TextEditingController _fatCtrl;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final goal = context.read<GoalProvider>().goal;
      _calCtrl = TextEditingController(text: goal.targetCalories.toStringAsFixed(0));
      _proCtrl = TextEditingController(text: goal.targetProtein.toStringAsFixed(0));
      _carbCtrl = TextEditingController(text: goal.targetCarbs.toStringAsFixed(0));
      _fatCtrl = TextEditingController(text: goal.targetFats.toStringAsFixed(0));
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _calCtrl.dispose();
    _proCtrl.dispose();
    _carbCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Nutrition Goals'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes_rounded, color: AppColors.primary, size: 48),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('Set Your Daily Goals', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text('These targets help track your progress', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ),
            const SizedBox(height: 32),

            // Calorie goal
            _goalField(
              label: 'Daily Calorie Target',
              controller: _calCtrl,
              icon: Icons.local_fire_department_rounded,
              color: AppColors.accent,
              unit: 'kcal',
              hint: 'e.g. 2000',
            ),
            const SizedBox(height: 16),

            const Text('Macronutrient Targets (Optional)', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),

            _goalField(label: 'Protein', controller: _proCtrl, icon: Icons.fitness_center_rounded, color: AppColors.protein, unit: 'g', hint: 'e.g. 50'),
            const SizedBox(height: 12),
            _goalField(label: 'Carbohydrates', controller: _carbCtrl, icon: Icons.grain_rounded, color: AppColors.carbs, unit: 'g', hint: 'e.g. 250'),
            const SizedBox(height: 12),
            _goalField(label: 'Fats', controller: _fatCtrl, icon: Icons.water_drop_rounded, color: AppColors.fats, unit: 'g', hint: 'e.g. 65'),

            const SizedBox(height: 32),

            // Preset buttons
            const Text('Quick Presets', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _presetButton('Weight Loss', 1500, 60, 150, 50)),
                const SizedBox(width: 10),
                Expanded(child: _presetButton('Maintenance', 2000, 50, 250, 65)),
                const SizedBox(width: 10),
                Expanded(child: _presetButton('Muscle Gain', 2800, 120, 300, 80)),
              ],
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGoal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Save Goals'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _goalField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    required String unit,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          Text(unit, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _presetButton(String label, double cal, double pro, double carbs, double fats) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _calCtrl.text = cal.toStringAsFixed(0);
          _proCtrl.text = pro.toStringAsFixed(0);
          _carbCtrl.text = carbs.toStringAsFixed(0);
          _fatCtrl.text = fats.toStringAsFixed(0);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
        ),
      ),
    );
  }

  void _saveGoal() {
    final cal = double.tryParse(_calCtrl.text);
    if (cal == null || cal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid calorie target')));
      return;
    }

    final goal = NutritionGoal(
      targetCalories: cal,
      targetProtein: double.tryParse(_proCtrl.text) ?? 50,
      targetCarbs: double.tryParse(_carbCtrl.text) ?? 250,
      targetFats: double.tryParse(_fatCtrl.text) ?? 65,
    );

    context.read<GoalProvider>().updateGoal(goal);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goals saved successfully!')));
  }
}
