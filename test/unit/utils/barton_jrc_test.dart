import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/barton_jrc_profile.dart';

void main() {
  group('Barton 10-Profile JRC Definition Tests', () {
    test('contains all 10 canonical Barton & Choubey profiles', () {
      expect(BartonJrcProfile.allProfiles.length, 10);

      for (int i = 0; i < 10; i++) {
        final profile = BartonJrcProfile.allProfiles[i];
        expect(profile.id, i + 1);
        expect(profile.typicalJr, inInclusiveRange(0.5, 4.0));
        expect(profile.normalizedCurve.isNotEmpty, isTrue);
        expect(profile.minJrc, lessThan(profile.maxJrc));
      }
    });

    test('profile 1 corresponds to slickensided / smooth (Jr = 0.5)', () {
      final p1 = BartonJrcProfile.allProfiles.first;
      expect(p1.jrcRangeLabel, '0 - 2');
      expect(p1.typicalJr, 0.5);
    });

    test('profile 10 corresponds to stepped extremely rough (Jr = 4.0)', () {
      final p10 = BartonJrcProfile.allProfiles.last;
      expect(p10.jrcRangeLabel, '18 - 20');
      expect(p10.typicalJr, 4.0);
    });
  });
}
