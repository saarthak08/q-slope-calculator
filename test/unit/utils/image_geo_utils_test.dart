import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/utils/geo_utils.dart';
import 'package:q_slope_calculator/src/utils/image_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GeoUtils & GeoPositionData Tests', () {
    test('GeoPositionData holds correct coordinate properties', () {
      const pos = GeoPositionData(
        latitude: -23.456,
        longitude: 119.876,
        altitude: 450.0,
        accuracy: 3.5,
      );

      expect(pos.latitude, -23.456);
      expect(pos.longitude, 119.876);
      expect(pos.altitude, 450.0);
      expect(pos.accuracy, 3.5);
    });

    test('GeoPositionData allows optional altitude and accuracy', () {
      const pos = GeoPositionData(latitude: 10.0, longitude: 20.0);

      expect(pos.latitude, 10.0);
      expect(pos.longitude, 20.0);
      expect(pos.altitude, isNull);
      expect(pos.accuracy, isNull);
    });

    test('GeoUtils.openInMap does not crash with coordinates', () async {
      // In headless unit test environment, url_launcher returns false gracefully
      final result = await GeoUtils.openInMap(-31.95, 115.86);
      expect(result, isFalse);
    });
  });

  group('ImageUtils Tests', () {
    test(
      'ImageUtils.captureOrPickImage gracefully handles headless test environment',
      () async {
        // In headless test environment without platform camera channel, it handles error and returns null
        final result = await ImageUtils.captureOrPickImage(fromCamera: false);
        expect(result, isNull);
      },
    );
  });
}
