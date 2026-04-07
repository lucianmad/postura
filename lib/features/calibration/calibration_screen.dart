import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/skeleton_painter.dart';
import 'package:postura/features/calibration/calibration_providers.dart';

class CalibrationScreen extends ConsumerStatefulWidget {
  const CalibrationScreen({super.key});

  @override
  ConsumerState<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends ConsumerState<CalibrationScreen> {
  String? _cachedUid;

  void _setStreaming(bool value) {
    final uid = _cachedUid;
    if (uid == null) return;
    FirebaseDatabase.instance
        .ref('users/$uid/devices/pi_desk_001/commands/stream_telemetry')
        .set(value);
  }

  @override
  void initState() {
    super.initState();
    _cachedUid = ref.read(authStateProvider).value?.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStreaming(true);
    });
  }

  @override
  void dispose() {
    _setStreaming(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final telemetryStream = ref.watch(streamTelemetryProvider);
    final uid = ref.watch(authStateProvider).value?.uid;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Sit straight in your perfect position and press \'Calibrate\'',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              telemetryStream.when(
                data: (telemetry) => Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: CustomPaint(
                    size: Size(640, 480),
                    painter: SkeletonPainter(telemetry: telemetry),
                  ),
                ),
                loading: () => CircularProgressIndicator(),
                error: (err, stack) => Text(err.toString()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseDatabase.instance
                        .ref(
                          'users/$uid/devices/pi_desk_001/commands/calibrate',
                        )
                        .set(true);
                  } catch (ex) {
                    print(ex.toString());
                  }
                },
                child: Text('Calibrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
