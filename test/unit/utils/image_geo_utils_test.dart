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

    test('GeoResult handles success and failure states', () {
      const pos = GeoPositionData(latitude: 12.34, longitude: 56.78);
      const successResult = GeoResult.success(pos);
      expect(successResult.isSuccess, isTrue);
      expect(successResult.position, pos);
      expect(successResult.failureReason, isNull);

      const failResult = GeoResult.failure(
        GeoFailureReason.permissionDenied,
        'denied',
      );
      expect(failResult.isSuccess, isFalse);
      expect(failResult.position, isNull);
      expect(failResult.failureReason, GeoFailureReason.permissionDenied);
      expect(failResult.errorMessage, 'denied');
    });

    test(
      'GeoUtils handles headless test environment without throwing',
      () async {
        final res = await GeoUtils.getCurrentLocationResult();
        expect(res.isSuccess, isFalse);
        expect(res.failureReason, isNotNull);

        final loc = await GeoUtils.getCurrentLocation();
        expect(loc, isNull);

        final settingsResult = await GeoUtils.openAppSettings();
        expect(settingsResult, isFalse);

        final locSettingsResult = await GeoUtils.openLocationSettings();
        expect(locSettingsResult, isFalse);
      },
    );

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

    test(
      'ImageUtils.captureOrPickImages gracefully handles multi-image picking in headless test',
      () async {
        final resultsGallery = await ImageUtils.captureOrPickImages(
          fromCamera: false,
        );
        expect(resultsGallery, isEmpty);

        final resultsCamera = await ImageUtils.captureOrPickImages(
          fromCamera: true,
        );
        expect(resultsCamera, isEmpty);
      },
    );
  });
}
