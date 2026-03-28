import 'package:cloud_firestore/cloud_firestore.dart';

class SessionLog {
  final String status;
  final int duration;
  final DateTime timestamp;

  SessionLog({
    required this.status,
    required this.duration,
    required this.timestamp,
  });

  factory SessionLog.fromMap(Map<String, dynamic> map) {
    return SessionLog(
      status: map['status'],
      duration: map['duration'],
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
