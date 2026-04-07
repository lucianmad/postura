import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/session_log.dart';

final sessionLogProvider = FutureProvider.family<List<SessionLog>, String>((
  ref,
  date,
) async {
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

  return snapshot.docs.map((doc) => SessionLog.fromMap(doc.data())).toList();
});

final monthSessionsProvider =
    FutureProvider.family<Map<DateTime, List<bool>>, DateTime>((
      ref,
      month,
    ) async {
      final user = ref.watch(authStateProvider).value;

      if (user == null) {
        return {};
      }

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
