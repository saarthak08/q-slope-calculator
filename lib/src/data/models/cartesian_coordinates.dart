/// Represents a 2D coordinate point (x, y) on the Q-Slope stability chart.
class CartesianCoordinates {
  /// The horizontal coordinate (typically log-scale Q-Slope value).
  final double x;

  /// The vertical coordinate (typically slope angle in degrees).
  final double y;

  const CartesianCoordinates({required this.x, required this.y});
}
