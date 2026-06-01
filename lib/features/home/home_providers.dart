import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/posture_state.dart';
import 'package:postura/core/providers/device_providers.dart';

final postureStateProvider = StreamProvider<PostureState>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final deviceIdAsync = ref.watch(deviceIdProvider);

  return deviceIdAsync.when(
    data: (deviceId) {
      if (deviceId == null) return Stream.value(PostureState.empty());
      return FirebaseDatabase.instance
          .ref('users/${user.uid}/devices/$deviceId/current_state')
          .onValue
          .map((event) {
            if (event.snapshot.value == null) return PostureState.empty();
            return PostureState.fromMap(
              Map<String, dynamic>.from(event.snapshot.value as Map),
            );
          });
    },
    loading: () => Stream.value(PostureState.empty()),
    error: (_, _) => Stream.value(PostureState.empty()),
  );
});
