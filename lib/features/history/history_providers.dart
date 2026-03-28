import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      .collection('daily_logs')
      .doc('pi_desk_001')
      .collection(date)
      .get();

  return snapshot.docs.map((doc) => SessionLog.fromMap(doc.data())).toList();
});
