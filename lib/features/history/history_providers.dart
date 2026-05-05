import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/models/session_log.dart';

final sessionLogProvider = FutureProvider.autoDispose
    .family<List<SessionLog>, String>((ref, date) async {
      final user = ref.watch(authStateProvider).value;

      if (user == null) {
        return [];
      }

      final userId = user.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('date', isEqualTo: date)
          .get();

      return snapshot.docs
          .map((doc) => SessionLog.fromMap(doc.data()))
          .toList();
    });

final monthSessionsProvider = FutureProvider.autoDispose
    .family<Map<DateTime, List<bool>>, DateTime>((ref, month) async {
      final user = ref.watch(authStateProvider).value;
      if (user == null) return {};

      final userId = user.uid;

      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final firstDayStr = DateFormat('yyyy-MM-dd').format(firstDay);
      final lastDayStr = DateFormat('yyyy-MM-dd').format(lastDay);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('date', isGreaterThanOrEqualTo: firstDayStr)
          .where('date', isLessThanOrEqualTo: lastDayStr)
          .get();

      final Map<DateTime, List<bool>> results = {};

      for (final doc in snapshot.docs) {
        final dateStr = doc.data()['date'] as String;
        final date = DateTime.parse(dateStr);

        results[date] = [true];
      }

      return results;
    });

final weeklyGoodPosturePercentageProvider = FutureProvider.autoDispose
    .family<List<double>, DateTime>((ref, endDate) async {
      final user = ref.watch(authStateProvider).value;
      if (user == null) return List.filled(7, 0);

      final startDate = endDate.subtract(const Duration(days: 6));
      final startStr = DateFormat('yyyy-MM-dd').format(startDate);
      final endStr = DateFormat('yyyy-MM-dd').format(endDate);

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('sessions')
          .where('date', isGreaterThanOrEqualTo: startStr)
          .where('date', isLessThanOrEqualTo: endStr)
          .get();

      final sessions = snapshot.docs
          .map((doc) => SessionLog.fromMap(doc.data()))
          .toList();

      final List<double> percentages = [];

      for (int i = 6; i >= 0; i--) {
        final day = endDate.subtract(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(day);

        final daySessions = sessions.where((s) => s.date == dateStr).toList();
        if (daySessions.isEmpty) {
          percentages.add(0);
          continue;
        }

        final total = daySessions.fold(0, (sum, s) => sum + s.duration);
        final neutral = daySessions
            .where((s) => s.postureStatus.category == PostureCategory.neutral)
            .fold(0, (sum, s) => sum + s.duration);
        final active = total - neutral;
        final good = daySessions
            .where((s) => s.postureStatus.category == PostureCategory.good)
            .fold(0, (sum, s) => sum + s.duration);

        percentages.add(active > 0 ? (good / active * 100) : 0);
      }

      return percentages;
    });
