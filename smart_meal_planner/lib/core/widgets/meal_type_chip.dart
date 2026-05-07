import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MealTypeChip extends StatelessWidget {
  final String mealType;
  final bool isSelected;
  final VoidCallback onTap;

  const MealTypeChip({
    super.key,
    required this.mealType,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color {
    switch (mealType) {
      case 'Breakfast':
        return AppColors.breakfast;
      case 'Lunch':
        return AppColors.lunch;
      case 'Dinner':
        return AppColors.dinner;
      case 'Snacks':
        return AppColors.snacks;
      default:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (mealType) {
      case 'Breakfast':
        return Icons.wb_sunny_rounded;
      case 'Lunch':
        return Icons.restaurant_rounded;
      case 'Dinner':
        return Icons.nights_stay_rounded;
      case 'Snacks':
        return Icons.cookie_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _color.withOpacity(0.2) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _color : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: isSelected ? _color : AppColors.textMuted, size: 18),
            const SizedBox(width: 6),
            Text(
              mealType,
              style: TextStyle(
                color: isSelected ? _color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
