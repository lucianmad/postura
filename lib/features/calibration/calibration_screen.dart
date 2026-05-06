import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/auth/auth_providers.dart';
import 'package:postura/core/models/posture_status_enum.dart';
import 'package:postura/core/models/skeleton_painter.dart';
import 'package:postura/core/theme/app_theme.dart';
import 'package:postura/features/calibration/calibration_providers.dart';
import 'package:postura/features/home/home_providers.dart';

class CalibrationScreen extends ConsumerStatefulWidget {
  const CalibrationScreen({super.key});

  @override
  ConsumerState<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends ConsumerState<CalibrationScreen> {
  String? _cachedUid;
  bool _isCalibrating = false;
  bool _calibrationSuccess = false;

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

  Future<void> _calibrate() async {
    final uid = _cachedUid;
    if (uid == null) return;

    setState(() {
      _isCalibrating = true;
    });

    try {
      await FirebaseDatabase.instance
          .ref('users/$uid/devices/pi_desk_001/commands/calibrate')
          .set(true);

      final ref = FirebaseDatabase.instance.ref(
        'users/$uid/devices/pi_desk_001/commands/calibrate',
      );

      bool confirmed = false;
      await for (final event in ref.onValue.timeout(
        const Duration(seconds: 5),
        onTimeout: (sink) => sink.close(),
      )) {
        if (event.snapshot.value == false) {
          confirmed = true;
          break;
        }
      }

      if (mounted) {
        setState(() => _calibrationSuccess = confirmed);
        if (confirmed) {
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) setState(() => _calibrationSuccess = false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Pi not responding, ensure it is running',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.bad,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calibration failed: ${e.toString()}'),
            backgroundColor: AppColors.bad,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCalibrating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final telemetryStream = ref.watch(streamTelemetryProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calibration',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Set your perfect posture baseline',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Sit straight in your perfect posture position and press Calibrate.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(16),
                    child: telemetryStream.when(
                      data: (telemetry) {
                        final postureState = ref
                            .watch(postureStateProvider)
                            .value;
                        final isIdle =
                            postureState == null ||
                            postureState.postureStatus == PostureStatus.idle;

                        if (telemetry.isEmpty || isIdle) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_off_outlined,
                                  size: 48,
                                  color: AppColors.neutral,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No user detected',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sit in front of the camera',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            SizedBox.expand(
                              child: CustomPaint(
                                painter: SkeletonPainter(telemetry: telemetry),
                              ),
                            ),
                            if (_calibrationSuccess)
                              Container(
                                color: AppColors.good.withValues(alpha: 0.15),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.good,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Calibrated!',
                                        style: TextStyle(
                                          color: AppColors.good,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Waiting for Pi connection...',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (err, stack) => Center(
                        child: Text(
                          'Connection error',
                          style: TextStyle(color: AppColors.bad),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCalibrating ? null : _calibrate,

                  child: _isCalibrating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Calibrate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
