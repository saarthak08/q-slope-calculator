/// Kinematic failure potential for rock slope stability
enum KinematicRiskLevel { none, low, moderate, critical }

/// Comprehensive kinematic discontinuity analysis result
class KinematicAnalysisResult {
  final KinematicRiskLevel planarRisk;
  final KinematicRiskLevel wedgeRisk;
  final KinematicRiskLevel topplingRisk;
  final bool daylightsOnSlope;
  final double? intersectionTrend;
  final double? intersectionPlunge;
  final String primaryMechanismDescription;
  final String engineeringRecommendation;

  const KinematicAnalysisResult({
    required this.planarRisk,
    required this.wedgeRisk,
    required this.topplingRisk,
    required this.daylightsOnSlope,
    this.intersectionTrend,
    this.intersectionPlunge,
    required this.primaryMechanismDescription,
    required this.engineeringRecommendation,
  });

  bool get hasAnyKinematicRisk =>
      planarRisk != KinematicRiskLevel.none ||
      wedgeRisk != KinematicRiskLevel.none ||
      topplingRisk != KinematicRiskLevel.none;
}
