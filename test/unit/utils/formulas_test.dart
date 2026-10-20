import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

void main() {
  group('Formulas Utility Tests', () {
    test('calculateRqdByDirectMethod calculates RQD correctly', () {
      final result = calculateRqdByDirectMethod(80, 100);
      expect(result, 80.0);
    });

    test('calculateJointVolume calculates JV correctly', () {
      final result = calculateJointVolume(2, [0.5, 0.5, 0.5], 100);
      // reverse = (1/0.5)*3 = 6
      // 2 / (5 * 10) = 0.04
      // total = 6.04
      expect(result, closeTo(6.04, 0.001));
    });

    test('calculateRqdByTwoPointFiveJv calculates correctly', () {
      final result = calculateRqdByTwoPointFiveJv(10);
      expect(result, 85.0);
    });

    test('calculateRqdByThreePointThreeJv calculates correctly', () {
      final result = calculateRqdByThreePointThreeJv(10);
      expect(result, 82.0);
    });

    test('calculateJointSetNumber returns correct values', () {
      expect(calculateJointSetNumber(0, 0), 0.5);
      expect(calculateJointSetNumber(1, 0), 2.0);
      expect(calculateJointSetNumber(1, 1), 3.0);
      expect(calculateJointSetNumber(2, 0), 4.0);
      expect(calculateJointSetNumber(3, 1), 12.0);
      expect(calculateJointSetNumber(4, 0), 15.0);
      expect(calculateJointSetNumber(5, 0), 20.0);
    });

    test('calculateJwice returns correct values for desert environment', () {
      expect(
        calculateJwice(
          ExternalFactorsEnvironmentConditions.desertEnvironment,
          ExternalFactorsStrengthOfRock.competent,
          ExternalFactorsStructureType.stable,
        ),
        1.0,
      );
    });

    test('calculateF1ForPlanarFailure calculates correctly', () {
      expect(calculateF1ForPlanarFailure(150, 20), 130);
      expect(
        calculateF1ForPlanarFailure(10, 200),
        170,
      ); // 190 > 180 => 360-190=170
    });

    test('calculateSlopeAngle calculates correctly', () {
      // 10 -> log10(10)*20 + 65 = 1*20 + 65 = 85
      final result = calculateSlopeAngle(10);
      expect(result, 85.0);
    });

    test('calculateSafetyMargin calculates difference correctly', () {
      // Q=1 -> allowable = 65. actual = 60 -> margin = +5 (stable)
      expect(calculateSafetyMargin(1, 60), 5.0);
      // Q=1 -> allowable = 65. actual = 70 -> margin = -5 (unstable)
      expect(calculateSafetyMargin(1, 70), -5.0);
      // edge cases
      expect(calculateSafetyMargin(null, 60), isNull);
      expect(calculateSafetyMargin(0, 60), isNull);
      expect(calculateSafetyMargin(1, null), isNull);
    });

    test('getSlopeStabilityStatus classifies slopes accurately', () {
      // Q=1 -> allowable = 65
      // margin >= 2.5 -> stable
      expect(getSlopeStabilityStatus(1, 60), SlopeStabilityStatus.stable);
      expect(getSlopeStabilityStatus(1, 62.5), SlopeStabilityStatus.stable);

      // within +- 2.5 -> uncertain
      expect(getSlopeStabilityStatus(1, 65), SlopeStabilityStatus.uncertain);
      expect(getSlopeStabilityStatus(1, 66), SlopeStabilityStatus.uncertain);
      expect(getSlopeStabilityStatus(1, 64), SlopeStabilityStatus.uncertain);

      // margin <= -2.5 -> unstable
      expect(getSlopeStabilityStatus(1, 68), SlopeStabilityStatus.unstable);
      expect(getSlopeStabilityStatus(1, 75), SlopeStabilityStatus.unstable);

      // unknown / missing parameters
      expect(getSlopeStabilityStatus(null, 60), SlopeStabilityStatus.unknown);
      expect(getSlopeStabilityStatus(1, null), SlopeStabilityStatus.unknown);
      expect(getSlopeStabilityStatus(0, 60), SlopeStabilityStatus.unknown);
    });

    group('OFactor Calculations across All Modes and Combinations', () {
      test('Planar failure Romana F1, F2, F3 and ratings', () {
        final f1 = calculateF1ForPlanarFailure(50, 65);
        expect(f1, 15.0);
        final f3 = calculateF3ForPlanarFailure(40, 60);
        expect(f3, -20.0);

        final rF1 = calculateRatingForF1(f1);
        final rF2 = calculateRatingForF2(40);
        final rF3 = calculateRatingForF3NonTopplingFailure(f3);

        expect(rF1, isNotNull);
        expect(rF2, isNotNull);
        expect(rF3, isNotNull);

        final oFactor = calculateOFactorByRomananAdjustmentFactor(rF1, rF2, rF3);
        expect(oFactor, isPositive);
      });

      test('Wedge failure Romana F1, F2, F3 and ratings', () {
        final f1 = calculateF1ForWedgeFailure(45, 65);
        expect(f1, 20.0);
        final f3 = calculateF3ForWedgeFailure(35, 60);
        expect(f3, -25.0);

        final rF1 = calculateRatingForF1(f1);
        final rF2 = calculateRatingForF2(35);
        final rF3 = calculateRatingForF3NonTopplingFailure(f3);

        final oFactor = calculateOFactorByRomananAdjustmentFactor(rF1, rF2, rF3);
        expect(oFactor, isPositive);
      });

      test('Toppling failure Romana F1, F2, F3 and ratings', () {
        final f1 = calculateF1ForTopplingFailure(245, 65);
        // |245 - 65 - 180| = 0
        expect(f1, 0.0);
        final f3 = calculateF3ForTopplingFailure(50, 60);
        // 50 + 60 = 110
        expect(f3, 110.0);

        final rF1 = calculateRatingForF1(f1);
        // For toppling failure, F2 is always 1
        final rF3 = calculateRatingForF3TopplingFailure(f3);

        final oFactor = calculateOFactorByRomananAdjustmentFactor(rF1, 1.0, rF3);
        expect(oFactor, isPositive);
      });

      test('calculateQSlope with Direct OFactor - Planar failure', () {
        final q = QSlope(
          id: 'q_planar',
          blockSize: BlockSize(rqd: 80, jointSetNumber: 4),
          jointCharacter: JointCharacter(
            jointRoughness: [2.0],
            jointAlteration: [1.0],
          ),
          oFactor: OFactor(
            indexOfFirstJoint: 0,
            oFactorForFirstJoint: 1.25,
            oFactorCalculationType: OFactorCalculationType.value,
            oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.8,
          ),
          activeStress: ActiveStress(srf: 2.0),
        );

        // Q = (80/4) * (2/1) * 1.25 * (0.8/2.0) = 20 * 2 * 1.25 * 0.4 = 20.0
        final result = calculateQSlope(q);
        expect(result, closeTo(20.0, 0.001));
      });

      test('calculateQSlope with Direct OFactor - Wedge failure with 2 joints', () {
        final q = QSlope(
          id: 'q_wedge',
          blockSize: BlockSize(rqd: 90, jointSetNumber: 3),
          jointCharacter: JointCharacter(
            jointRoughness: [3.0, 1.5],
            jointAlteration: [1.0, 2.0],
          ),
          oFactor: OFactor(
            indexOfFirstJoint: 0,
            indexOfSecondJoint: 1,
            oFactorForFirstJoint: 1.1,
            oFactorForSecondJoint: 0.9,
            oFactorCalculationType: OFactorCalculationType.value,
            oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.75,
          ),
          activeStress: ActiveStress(srf: 2.5),
        );

        // Q = (90/3) * (3/1) * 1.1 * (0.75/2.5) * (1.5/2) * 0.9
        //   = 30 * 3 * 1.1 * 0.3 * 0.75 * 0.9 = 20.0475
        final result = calculateQSlope(q);
        expect(result, closeTo(20.0475, 0.001));
      });

      test('calculateQSlope with Romana Adjustment Factor - Toppling failure', () {
        final q = QSlope(
          id: 'q_toppling',
          blockSize: BlockSize(rqd: 70, jointSetNumber: 6),
          jointCharacter: JointCharacter(
            jointRoughness: [1.5],
            jointAlteration: [2.0],
          ),
          oFactor: OFactor(
            indexOfFirstJoint: 0,
            oFactorForFirstJoint: 0.85,
            oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
            oFactorTypeOfFailure: OFactorTypeOfFailure.toppling,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.6,
          ),
          activeStress: ActiveStress(srf: 3.0),
        );

        // Q = (70/6) * (1.5/2) * 0.85 * (0.6/3) = 11.6667 * 0.75 * 0.85 * 0.2 = 1.4875
        final result = calculateQSlope(q);
        expect(result, closeTo(1.4875, 0.001));
      });
    });
  });
}
