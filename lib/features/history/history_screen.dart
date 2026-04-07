import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

    ref.listen(monthSessionsProvider(_focusedMonth), (previous, next) {
      next.whenData((data) {
        setState(() {
          _cachedMonthData = data;
        });
      });
    });

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime(2027, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            headerStyle: HeaderStyle(formatButtonVisible: false),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
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
              return _cachedMonthData[DateTime(day.year, day.month, day.day)] ??
                  [];
            },
          ),
          Expanded(
            child: sessionAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const Center(child: Text('No data for this day'));
                }

                final totalDuration = sessions.fold(
                  0,
                  (sum, s) => sum + s.duration,
                );
                final goodDuration = sessions
                    .where((s) => s.status == 'Posture OK')
                    .fold(0, (sum, s) => sum + s.duration);
                final goodPercentage = totalDuration > 0
                    ? (goodDuration / totalDuration * 100).round()
                    : 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Good posture: $goodPercentage%'),
                    Text('Total tracked: ${totalDuration ~/ 60} minutes'),
                  ],
                );
              },
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (err, stack) => Text(err.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
