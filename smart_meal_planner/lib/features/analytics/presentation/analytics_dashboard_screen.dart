import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../meal_planning/providers/meal_provider.dart';
import '../../goals/providers/goal_provider.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<MealProvider, GoalProvider>(
      builder: (context, mp, gp, _) {
        final weekData = mp.getWeeklyData();
        final goal = gp.goal;
        final todayCal = mp.totalCaloriesToday;
        final achievement = gp.goalAchievementPercent(todayCal);

        // Weekly averages
        final weekCals = weekData.map((d) => d['calories'] as double).toList();
        final avgCal = weekCals.isEmpty ? 0.0 : weekCals.reduce((a, b) => a + b) / weekCals.length;
        final daysOnTarget = weekCals.where((c) => (c - goal.targetCalories).abs() <= goal.targetCalories * 0.1).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: const Text('Analytics', style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w700)),
                  ),
                ),

                // Summary cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(children: [
                      Expanded(child: _summaryCard('Today', '${todayCal.toStringAsFixed(0)}', 'kcal', AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: _summaryCard('Avg/Day', '${avgCal.toStringAsFixed(0)}', 'kcal', AppColors.accentBlue)),
                      const SizedBox(width: 12),
                      Expanded(child: _summaryCard('On Target', '$daysOnTarget/7', 'days', AppColors.accentOrange)),
                    ]),
                  ),
                ),

                // Goal achievement
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Goal Achievement', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: achievement >= 80 ? AppColors.success.withOpacity(0.15) : achievement >= 50 ? AppColors.warning.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8)),
                            child: Text('${achievement.toStringAsFixed(0)}%', style: TextStyle(
                              color: achievement >= 80 ? AppColors.success : achievement >= 50 ? AppColors.warning : AppColors.error,
                              fontWeight: FontWeight.w700, fontSize: 14)),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        Stack(children: [
                          Container(height: 12, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(6))),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic,
                            height: 12,
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (achievement / 100).clamp(0.0, 1.0),
                              child: Container(decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 8)],
                              )),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        Text('${todayCal.toStringAsFixed(0)} / ${goal.targetCalories.toStringAsFixed(0)} kcal today',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ]),
                    ),
                  ),
                ),

                // Weekly chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Weekly Calorie Trend', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (weekCals.isEmpty ? 2500.0 : weekCals.reduce((a, b) => a > b ? a : b) * 1.3).clamp(500.0, 5000.0).toDouble(),
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, gIdx, rod, rIdx) {
                                    return BarTooltipItem('${rod.toY.toStringAsFixed(0)} kcal',
                                      const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12));
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28,
                                  getTitlesWidget: (val, meta) {
                                    if (val.toInt() < weekData.length) {
                                      return Text(DateFormat('E').format(weekData[val.toInt()]['date'] as DateTime).substring(0, 2),
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12));
                                    }
                                    return const Text('');
                                  })),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40,
                                  getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(color: AppColors.textMuted, fontSize: 10)))),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: true, drawVerticalLine: false,
                                getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 0.5)),
                              extraLinesData: ExtraLinesData(horizontalLines: [
                                HorizontalLine(y: goal.targetCalories, color: AppColors.accent.withOpacity(0.6), strokeWidth: 1, dashArray: [6, 4],
                                  label: HorizontalLineLabel(show: true, labelResolver: (_) => 'Goal',
                                    style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w600))),
                              ]),
                              barGroups: weekData.asMap().entries.map((e) {
                                final cal = e.value['calories'] as double;
                                final isOnTarget = (cal - goal.targetCalories).abs() <= goal.targetCalories * 0.1;
                                return BarChartGroupData(x: e.key, barRods: [
                                  BarChartRodData(
                                    toY: cal, width: 20,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                    gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                                      colors: isOnTarget
                                        ? [AppColors.primary.withOpacity(0.7), AppColors.primary]
                                        : cal > goal.targetCalories
                                          ? [AppColors.error.withOpacity(0.7), AppColors.error]
                                          : [AppColors.accentBlue.withOpacity(0.7), AppColors.accentBlue]),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          _legendDot(AppColors.primary, 'On Target'),
                          const SizedBox(width: 16),
                          _legendDot(AppColors.accentBlue, 'Under'),
                          const SizedBox(width: 16),
                          _legendDot(AppColors.error, 'Over'),
                        ]),
                      ]),
                    ),
                  ),
                ),

                // Macros pie chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("Today's Macro Split", style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: Row(children: [
                            Expanded(child: PieChart(PieChartData(
                              centerSpaceRadius: 40,
                              sectionsSpace: 3,
                              sections: _macroSections(mp),
                            ))),
                            const SizedBox(width: 20),
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              _macroLegend('Protein', mp.totalProteinToday, AppColors.protein),
                              const SizedBox(height: 10),
                              _macroLegend('Carbs', mp.totalCarbsToday, AppColors.carbs),
                              const SizedBox(height: 10),
                              _macroLegend('Fats', mp.totalFatsToday, AppColors.fats),
                            ]),
                          ]),
                        ),
                      ]),
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

  List<PieChartSectionData> _macroSections(MealProvider mp) {
    final p = mp.totalProteinToday;
    final c = mp.totalCarbsToday;
    final f = mp.totalFatsToday;
    final total = p + c + f;
    if (total == 0) {
      return [PieChartSectionData(value: 1, color: AppColors.surfaceLight, title: '', radius: 24)];
    }
    return [
      PieChartSectionData(value: p, color: AppColors.protein, title: '${(p / total * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), radius: 28),
      PieChartSectionData(value: c, color: AppColors.carbs, title: '${(c / total * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), radius: 28),
      PieChartSectionData(value: f, color: AppColors.fats, title: '${(f / total * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), radius: 28),
    ];
  }

  Widget _summaryCard(String title, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700)),
        Text(unit, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ]),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
    ]);
  }

  Widget _macroLegend(String label, double value, Color color) {
    return Row(children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text('${value.toStringAsFixed(1)}g', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14)),
      ]),
    ]);
  }
}
