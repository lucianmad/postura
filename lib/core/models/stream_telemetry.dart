import 'package:postura/core/models/point.dart';

class StreamTelemetry {
  final Landmark nose;
  final Landmark leftEar;
  final Landmark rightEar;
  final Landmark leftShoulder;
  final Landmark rightShoulder;

  StreamTelemetry({
    required this.nose,
    required this.leftEar,
    required this.rightEar,
    required this.leftShoulder,
    required this.rightShoulder,
  });

  factory StreamTelemetry.fromMap(Map<String, dynamic> map) {
    return StreamTelemetry(
      nose: Landmark.fromList(map['n']),
      leftEar: Landmark.fromList(map['le']),
      rightEar: Landmark.fromList(map['re']),
      leftShoulder: Landmark.fromList(map['ls']),
      rightShoulder: Landmark.fromList(map['rs']),
    );
  }

  factory StreamTelemetry.empty() {
    return StreamTelemetry(
      nose: Landmark(x: 0, y: 0),
      leftEar: Landmark(x: 0, y: 0),
      rightEar: Landmark(x: 0, y: 0),
      leftShoulder: Landmark(x: 0, y: 0),
      rightShoulder: Landmark(x: 0, y: 0),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is StreamTelemetry &&
      other.nose.x == nose.x &&
      other.nose.y == nose.y;
}
