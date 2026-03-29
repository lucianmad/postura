class Landmark {
  final double x;
  final double y;

  Landmark({required this.x, required this.y});

  factory Landmark.fromList(List<dynamic> list) {
    return Landmark(x: (list[0] as double), y: (list[1] as double));
  }
}
