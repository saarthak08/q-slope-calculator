/// Represents the stability classification of a rock slope based on
/// empirical Q-Slope values and actual/designed slope angles.
enum SlopeStabilityStatus {
  /// Actual angle is within the empirically stable zone (safety margin >= 2.5°).
  stable,

  /// Actual angle is in the boundary / uncertain zone (within ±2.5° of allowable).
  uncertain,

  /// Actual angle exceeds the allowable slope angle by > 2.5°.
  unstable,

  /// Slope angle or Q-Slope value is missing, zero, or uncalculated.
  unknown,
}
