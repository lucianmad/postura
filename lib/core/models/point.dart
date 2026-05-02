class Landmark {
  final double x;
  final double y;

  const Landmark({required this.x, required this.y});

  factory Landmark.fromList(List<dynamic> list) {
    return Landmark(
      x: (list[0] as num).toDouble(),
      y: (list[1] as num).toDouble(),
    );
  }
}
