import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/stream_telemetry.dart';

final streamTelemetryProvider = StreamProvider<StreamTelemetry>((ref) {
  final user = ref.watch(authStateProvider).value;

  if (user == null) {
    return const Stream.empty();
  }

  final userId = user.uid;

  final streamTelemetry = FirebaseDatabase.instance
      .ref('users/$userId/devices/pi_desk_001/telemetry')
      .onValue
      .map((event) {
        if (event.snapshot.value == null) return StreamTelemetry.empty();

        final castedMap = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );

        return StreamTelemetry.fromMap(castedMap);
      });

  return streamTelemetry;
});
