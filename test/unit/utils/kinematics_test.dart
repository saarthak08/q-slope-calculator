import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

void main() {
  group('Kinematic Discontinuity Stability Analysis Tests', () {
    test(
      'identifies critical planar sliding when joint daylights and strikes parallel',
      () {
        final result = analyzeKinematics(
          slopeDip: 70.0,
          slopeDipDirection: 120.0,
          joint1Dip: 45.0, // daylights: 45° < 70°, and > friction angle (30°)
          joint1DipDirection: 125.0, // within 5° difference
          frictionAngle: 30.0,
        );

        expect(result.planarRisk, KinematicRiskLevel.critical);
        expect(result.daylightsOnSlope, isTrue);
        expect(result.hasAnyKinematicRisk, isTrue);
      },
    );

    test(
      'identifies kinematically stable condition when joint dips into rock mass',
      () {
        final result = analyzeKinematics(
          slopeDip: 70.0,
          slopeDipDirection: 120.0,
          joint1Dip: 45.0,
          joint1DipDirection:
              300.0, // dips into rock (opposite slope face), dip sum 45+70=115 < 120 so not toppling
          frictionAngle: 30.0,
        );

        expect(result.planarRisk, KinematicRiskLevel.none);
        expect(result.daylightsOnSlope, isFalse);
      },
    );

    test(
      'identifies toppling failure when joints dip steeply into slope face',
      () {
        final result = analyzeKinematics(
          slopeDip: 75.0,
          slopeDipDirection: 90.0,
          joint1Dip: 60.0,
          joint1DipDirection:
              270.0, // exactly 180° opposite; 60 + 75 = 135 >= 90 + 30 = 120°
          frictionAngle: 30.0,
        );

        expect(result.topplingRisk, KinematicRiskLevel.critical);
        expect(result.hasAnyKinematicRisk, isTrue);
      },
    );

    test(
      'calculateIntersectionLinePlungeAndTrend solves line vector for wedge',
      () {
        final res = calculateIntersectionLinePlungeAndTrend(
          dip1: 60.0,
          dipDir1: 110.0,
          dip2: 55.0,
          dipDir2: 170.0,
        );

        expect(res, isNotNull);
        expect(res!['plunge'], inInclusiveRange(30.0, 60.0));
        expect(res['trend'], inInclusiveRange(120.0, 160.0));
      },
    );

    test(
      'identifies critical wedge sliding when intersection line daylights',
      () {
        final result = analyzeKinematics(
          slopeDip: 75.0,
          slopeDipDirection: 140.0,
          joint1Dip: 60.0,
          joint1DipDirection: 110.0,
          joint2Dip: 55.0,
          joint2DipDirection: 170.0,
          frictionAngle: 30.0,
        );

        expect(result.wedgeRisk, KinematicRiskLevel.critical);
        expect(result.intersectionPlunge, isNotNull);
        expect(result.intersectionTrend, isNotNull);
        expect(result.daylightsOnSlope, isTrue);
      },
    );
  });
}
