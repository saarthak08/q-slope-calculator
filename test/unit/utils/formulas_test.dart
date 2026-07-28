import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
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
              ExternalFactorsStructureType.stable),
          1.0);
    });

    test('calculateF1ForPlanarFailure calculates correctly', () {
      expect(calculateF1ForPlanarFailure(150, 20), 130);
      expect(calculateF1ForPlanarFailure(10, 200), 170); // 190 > 180 => 360-190=170
    });

    test('calculateSlopeAngle calculates correctly', () {
      // 10 -> log10(10)*20 + 65 = 1*20 + 65 = 85
      final result = calculateSlopeAngle(10);
      expect(result, 85.0);
    });
  });
}
