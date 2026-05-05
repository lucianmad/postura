import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/theme/app_theme.dart';
import 'package:postura/core/widgets/stat_bar.dart';
import 'package:postura/features/history/history_providers.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  Map<DateTime, List<bool>> _cachedMonthData = {};

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final sessionAsync = ref.watch(sessionLogProvider(dateStr));
    final weeklyGoodPosturePercentageAsync = ref.watch(
      weeklyGoodPosturePercentageProvider(_selectedDay),
    );

    ref.listen(monthSessionsProvider(_focusedMonth), (previous, next) {
      next.whenData((data) {
        setState(() {
          _cachedMonthData = data;
        });
      });
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'History',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Your posture over time',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar(
                    availableGestures: AvailableGestures.horizontalSwipe,
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2027, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: AppColors.accent,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: AppColors.accent,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: const TextStyle(color: Colors.white),
                      weekendTextStyle: const TextStyle(color: Colors.white),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: AppColors.good,
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      weekendStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _focusedMonth = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _focusedMonth = focusedDay;
                        _cachedMonthData = {};
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final existingData = ref.read(
                          monthSessionsProvider(focusedDay),
                        );
                        existingData.whenData((data) {
                          setState(() => _cachedMonthData = data);
                        });
                      });
                    },
                    eventLoader: (day) {
                      return _cachedMonthData[DateTime(
                            day.year,
                            day.month,
                            day.day,
                          )] ??
                          [];
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              weeklyGoodPosturePercentageAsync.when(
                data: (percentages) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weekly Trend',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Good posture % over last 7 days',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 160,
                            child: BarChart(
                              BarChartData(
                                maxY: 100,
                                minY: 0,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 25,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.white.withValues(alpha: 0.06),
                                    strokeWidth: 1,
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      interval: 25,
                                      getTitlesWidget: (value, meta) => Text(
                                        '${value.toInt()}%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final day = _selectedDay.subtract(
                                          Duration(days: 6 - value.toInt()),
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            DateFormat('E').format(day),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: percentages.asMap().entries.map((
                                  entry,
                                ) {
                                  final isSelected = entry.key == 6;
                                  final isEmpty = entry.value == 0;
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: isEmpty ? 2 : entry.value,
                                        color: isSelected
                                            ? AppColors.accent
                                            : AppColors.good.withValues(
                                                alpha: 0.7,
                                              ),
                                        width: 20,
                                        borderRadius: BorderRadius.circular(6),
                                        backDrawRodData:
                                            BackgroundBarChartRodData(
                                              show: true,
                                              toY: 100,
                                              color: Colors.white.withValues(
                                                alpha: 0.04,
                                              ),
                                            ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              sessionAsync.when(
                data: (sessions) {
                  final totalDuration = sessions.fold(
                    0,
                    (sum, s) => sum + s.duration,
                  );
                  final neutralDuration = sessions
                      .where(
                        (s) =>
                            s.postureStatus.category == PostureCategory.neutral,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final activeDuration = totalDuration - neutralDuration;
                  final goodDuration = sessions
                      .where(
                        (s) => s.postureStatus.category == PostureCategory.good,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final badDuration = sessions
                      .where(
                        (s) => s.postureStatus.category == PostureCategory.bad,
                      )
                      .fold(0, (sum, s) => sum + s.duration);
                  final informationalDuration = sessions
                      .where(
                        (s) =>
                            s.postureStatus.category ==
                            PostureCategory.informational,
                      )
                      .fold(0, (sum, s) => sum + s.duration);

                  final Map<PostureStatus, int> byStatus = {};
                  for (final session in sessions) {
                    if (session.postureStatus.category == PostureCategory.bad ||
                        session.postureStatus.category ==
                            PostureCategory.informational) {
                      byStatus[session.postureStatus] =
                          (byStatus[session.postureStatus] ?? 0) +
                          session.duration;
                    }
                  }

                  final sortedIssues = byStatus.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM d').format(_selectedDay),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Posture Summary',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${totalDuration ~/ 60} min total',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              StatBar(
                                label: 'Good',
                                duration: goodDuration,
                                total: activeDuration,
                                color: AppColors.good,
                              ),
                              const SizedBox(height: 8),
                              StatBar(
                                label: 'Bad',
                                duration: badDuration,
                                total: activeDuration,
                                color: AppColors.bad,
                              ),
                              const SizedBox(height: 8),
                              StatBar(
                                label: 'Informational',
                                duration: informationalDuration,
                                total: activeDuration,
                                color: AppColors.info,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (sortedIssues.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Top Issues',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...sortedIssues.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: entry.key.color,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            entry.key.displayName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${entry.value ~/ 60} min',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => Text(err.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
