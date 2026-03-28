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
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final sessionAsync = ref.watch(sessionLogProvider(dateStr));

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime(2027, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
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
