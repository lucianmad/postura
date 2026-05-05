import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postura/core/models/posture_status_enum.dart';

class SessionLog {
  final String status;
  final int duration;
  final DateTime timestamp;
  final String date;

  const SessionLog({
    required this.status,
    required this.duration,
    required this.timestamp,
    required this.date,
  });

  factory SessionLog.fromMap(Map<String, dynamic> map) {
    return SessionLog(
      status: map['status'] as String,
      duration: map['duration'] as int,
      date: map['date'] as String,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  PostureStatus get postureStatus => PostureStatus.fromString(status);
}
