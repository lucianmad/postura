class PostureState {
  final String status;
  final int timestamp;

  PostureState({required this.status, required this.timestamp});

  factory PostureState.fromMap(Map<String, dynamic> map) {
    return PostureState(status: map['status'], timestamp: map['timestamp']);
  }

  factory PostureState.empty() {
    return PostureState(status: 'SEARCHING', timestamp: 0);
  }
}
