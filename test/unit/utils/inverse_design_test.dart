import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

void main() {
  group('Inverse Slope Design Formula Tests', () {
    test(
      'calculateRequiredQSlope returns mathematically exact Q-slope ratings',
      () {
        // From beta = 20 * log10(Q) + 65:
        // When beta = 65, Q = 10^0 = 1.0
        expect(calculateRequiredQSlope(65.0), closeTo(1.0, 1e-5));

        // When beta = 85, Q = 10^1 = 10.0
        expect(calculateRequiredQSlope(85.0), closeTo(10.0, 1e-4));

        // When beta = 45, Q = 10^-1 = 0.1
        expect(calculateRequiredQSlope(45.0), closeTo(0.1, 1e-5));

        // When beta = 25, Q = 10^-2 = 0.01
        expect(calculateRequiredQSlope(25.0), closeTo(0.01, 1e-5));
      },
    );

    test(
      'calculateRequiredQSlope throws ArgumentError for out-of-range angles',
      () {
        expect(() => calculateRequiredQSlope(0), throwsArgumentError);
        expect(() => calculateRequiredQSlope(-5), throwsArgumentError);
        expect(() => calculateRequiredQSlope(90), throwsArgumentError);
        expect(() => calculateRequiredQSlope(95), throwsArgumentError);
      },
    );

    test('calculateRequiredJwice computes necessary drainage level', () {
      // RQD=80, Jn=4, Jr=2, Ja=1, O=1 => rockMassFactor = 20 * 2 * 1 = 40
      // Target beta = 65 => Q_req = 1.0
      // With SRF = 4.0: Jwice_req = (1.0 * 4.0) / 40 = 0.1
      final jwice = calculateRequiredJwice(
        targetSlopeAngle: 65.0,
        rqd: 80.0,
        jn: 4.0,
        jr: 2.0,
        ja: 1.0,
        oFactor: 1.0,
        srf: 4.0,
      );
      expect(jwice, closeTo(0.1, 1e-4));
    });

    test(
      'calculateRequiredSRF computes permissible blasting stress factor',
      () {
        // RQD=80, Jn=4, Jr=2, Ja=1, O=1 => rockMassFactor = 40
        // Jwice = 0.5
        // Target beta = 65 => Q_req = 1.0
        // SRF_permissible = (40 * 0.5) / 1.0 = 20.0
        final srf = calculateRequiredSRF(
          targetSlopeAngle: 65.0,
          rqd: 80.0,
          jn: 4.0,
          jr: 2.0,
          ja: 1.0,
          oFactor: 1.0,
          jwice: 0.5,
        );
        expect(srf, closeTo(20.0, 1e-4));
      },
    );
  });
}
