import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

void main() {
  group('Empirical Rock Slope Support Guide (Bar & Barton 2017) Tests', () {
    test('returns Category 1 (Unsupported) for stable high quality slopes', () {
      final rec = getSlopeSupportRecommendation(
        2.5,
        benchHeight: 15.0,
        actualSlopeAngle: 55.0, // allowable ~ 73°, margin +18°
      );
      expect(rec.category, SlopeSupportCategory.unsupportedNatural);
      expect(rec.categoryNumber, 1);
      expect(rec.recommendedBoltLengthMeters, 0.0);
    });

    test(
      'returns Category 2 (Spot Bolting) for critical margin or moderate Q-slope',
      () {
        final rec = getSlopeSupportRecommendation(
          1.0,
          benchHeight: 15.0,
          actualSlopeAngle: 65.0, // allowable 65°, margin 0° (within ±2.5°)
        );
        expect(rec.category, SlopeSupportCategory.spotBolting);
        expect(rec.categoryNumber, 2);
        // L = max(2.5, 2.0 + 0.15*15) = max(2.5, 4.25) = 4.25
        expect(rec.recommendedBoltLengthMeters, 4.25);
      },
    );

    test(
      'returns Category 3 (Pattern Bolting + Mesh) for oversteepened margin',
      () {
        final rec = getSlopeSupportRecommendation(
          1.0,
          benchHeight: 20.0,
          actualSlopeAngle: 70.0, // allowable 65°, margin -5°
        );
        expect(rec.category, SlopeSupportCategory.patternBoltingMesh);
        expect(rec.categoryNumber, 3);
        expect(rec.recommendedBoltSpacingMeters, 2.2);
        // L = max(3.0, 2.0 + 0.15*20) = 5.0
        expect(rec.recommendedBoltLengthMeters, 5.0);
      },
    );

    test(
      'returns Category 4 (Systematic Bolting + Shotcrete) for severely oversteepened slope',
      () {
        final rec = getSlopeSupportRecommendation(
          1.0,
          benchHeight: 15.0,
          actualSlopeAngle: 75.0, // margin -10°
        );
        expect(rec.category, SlopeSupportCategory.systematicBoltingShotcrete);
        expect(rec.categoryNumber, 4);
        expect(rec.recommendedShotcreteThicknessMm, 75.0);
      },
    );

    test(
      'returns Category 5 (Heavy Cable Bolting) for deep oversteepening',
      () {
        final rec = getSlopeSupportRecommendation(
          1.0,
          benchHeight: 30.0,
          actualSlopeAngle: 83.0, // margin -18°
        );
        expect(rec.category, SlopeSupportCategory.heavyCableBolting);
        expect(rec.categoryNumber, 5);
        expect(rec.requiresCableAnchors, isTrue);
        // L = max(10.0, 0.40 * 30) = 12.0
        expect(rec.recommendedBoltLengthMeters, 12.0);
      },
    );

    test(
      'returns Category 6 (Reprofiling Required) when outside practical reinforcement',
      () {
        final rec = getSlopeSupportRecommendation(
          1.0,
          benchHeight: 25.0,
          actualSlopeAngle: 89.0, // margin -24°
        );
        expect(rec.category, SlopeSupportCategory.slopeReprofiling);
        expect(rec.categoryNumber, 6);
        expect(rec.requiresSlopeFlattening, isTrue);
      },
    );
  });
}
