import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';

class CalorieRingWidget extends StatelessWidget {
  final double consumed;
  final double target;
  final double size;

  const CalorieRingWidget({
    super.key,
    required this.consumed,
    required this.target,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
    final remaining = (target - consumed).clamp(0, double.infinity);
    final isOver = consumed > target;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: 1.0,
              color: AppColors.surfaceLight,
              strokeWidth: 12,
            ),
          ),
          // Progress ring
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: value,
                  color: isOver ? AppColors.error : AppColors.primary,
                  strokeWidth: 12,
                  hasGlow: true,
                ),
              );
            },
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                consumed.toStringAsFixed(0),
                style: TextStyle(
                  color: isOver ? AppColors.error : AppColors.textPrimary,
                  fontSize: size * 0.17,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              Text(
                'kcal eaten',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: size * 0.07,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isOver
                      ? AppColors.error.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isOver
                      ? '+${(consumed - target).toStringAsFixed(0)} over'
                      : '${remaining.toStringAsFixed(0)} left',
                  style: TextStyle(
                    color: isOver ? AppColors.error : AppColors.primary,
                    fontSize: size * 0.065,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool hasGlow;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.hasGlow = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (hasGlow) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        glowPaint,
      );
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
