import 'package:flutter/material.dart';
import 'package:postura/core/models/point.dart';
import 'package:postura/core/models/stream_telemetry.dart';

class SkeletonPainter extends CustomPainter {
  final StreamTelemetry telemetry;

  SkeletonPainter({required this.telemetry});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Offset toOffset(Landmark lm) {
      return Offset(lm.x * size.width, lm.y * size.height);
    }

    final nose = toOffset(telemetry.nose);
    final leftEar = toOffset(telemetry.leftEar);
    final rightEar = toOffset(telemetry.rightEar);
    final leftShoulder = toOffset(telemetry.leftShoulder);
    final rightShoulder = toOffset(telemetry.rightShoulder);

    final midShoulder = Offset(
      (leftShoulder.dx + rightShoulder.dx) / 2,
      (leftShoulder.dy + rightShoulder.dy) / 2,
    );

    canvas.drawLine(leftEar, rightEar, linePaint);
    canvas.drawLine(leftShoulder, rightShoulder, linePaint);
    canvas.drawLine(nose, midShoulder, linePaint);

    final points = [nose, leftEar, rightEar, leftShoulder, rightShoulder];

    for (final point in points) {
      canvas.drawCircle(point, 6.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as SkeletonPainter).telemetry != telemetry;
  }
}
