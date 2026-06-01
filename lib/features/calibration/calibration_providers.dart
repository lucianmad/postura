import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/stream_telemetry.dart';
import 'package:postura/core/providers/device_providers.dart';

final streamTelemetryProvider = StreamProvider<StreamTelemetry>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final deviceIdAsync = ref.watch(deviceIdProvider);

  return deviceIdAsync.when(
    data: (deviceId) {
      if (deviceId == null) return Stream.value(StreamTelemetry.empty());
      return FirebaseDatabase.instance
          .ref('users/${user.uid}/devices/$deviceId/telemetry')
          .onValue
          .map((event) {
            if (event.snapshot.value == null) return StreamTelemetry.empty();
            return StreamTelemetry.fromMap(
              Map<String, dynamic>.from(event.snapshot.value as Map),
            );
          });
    },
    loading: () => Stream.value(StreamTelemetry.empty()),
    error: (_, _) => Stream.value(StreamTelemetry.empty()),
  );
});
