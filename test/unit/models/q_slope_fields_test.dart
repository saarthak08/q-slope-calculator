import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/csv_utils.dart';

void main() {
  group('QSlope GPS, BenchHeight & Photos Field Serialization Tests', () {
    test(
      'toMap and fromMap preserves GPS coordinates, bench height and photo paths',
      () {
        final qSlope = QSlope(
          id: 'test-geo-1',
          locationId: 'Pit Wall Bench 3',
          lithology: 'Granodiorite',
          latitude: -23.45678,
          longitude: 119.87654,
          elevation: 450.5,
          benchHeight: 20.0,
          imagePaths: ['/data/photos/photo1.jpg', '/data/photos/photo2.jpg'],
        );

        final map = qSlope.toMap();
        expect(map['latitude'], -23.45678);
        expect(map['longitude'], 119.87654);
        expect(map['elevation'], 450.5);
        expect(map['benchHeight'], 20.0);
        expect(map['imagePaths'], [
          '/data/photos/photo1.jpg',
          '/data/photos/photo2.jpg',
        ]);
        // Verify backward compatible getter
        expect(qSlope.photoPaths, [
          '/data/photos/photo1.jpg',
          '/data/photos/photo2.jpg',
        ]);

        final restored = QSlope.fromMap(map);
        expect(restored.latitude, -23.45678);
        expect(restored.longitude, 119.87654);
        expect(restored.elevation, 450.5);
        expect(restored.benchHeight, 20.0);
        expect(restored.imagePaths, [
          '/data/photos/photo1.jpg',
          '/data/photos/photo2.jpg',
        ]);
        expect(restored.photoPaths, [
          '/data/photos/photo1.jpg',
          '/data/photos/photo2.jpg',
        ]);
        expect(restored, equals(qSlope));
      },
    );

    test('copyWith updates GPS and bench height correctly', () {
      final qSlope = QSlope(id: 'test-1');
      final updated = qSlope.copyWith(
        latitude: 12.345,
        longitude: 67.890,
        elevation: 300.0,
        benchHeight: 18.0,
        imagePaths: ['/path/to/img.png'],
      );

      expect(updated.latitude, 12.345);
      expect(updated.longitude, 67.890);
      expect(updated.elevation, 300.0);
      expect(updated.benchHeight, 18.0);
      expect(updated.imagePaths, ['/path/to/img.png']);
      expect(updated.photoPaths, ['/path/to/img.png']);
    });

    test(
      'CSV export and import roundtrips GPS coordinates and photo paths',
      () {
        final qSlope = QSlope(
          id: 'csv-geo-test',
          locationId: 'North Ridge',
          lithology: 'Basalt',
          latitude: 34.5678,
          longitude: -112.3456,
          elevation: 1250.0,
          benchHeight: 25.0,
          imagePaths: ['photo_a.jpg', 'photo_b.jpg'],
        );

        final csvString = CsvUtils.generateCsvString([qSlope]);
        expect(csvString, contains('Latitude'));
        expect(csvString, contains('34.5678'));
        expect(csvString, contains('-112.3456'));
        expect(csvString, contains('1250.0'));
        expect(csvString, contains('photo_a.jpg;photo_b.jpg'));

        final parsedList = CsvUtils.parseCsvContent(csvString);
        expect(parsedList.length, 1);
        final parsed = parsedList.first;
        expect(parsed.latitude, closeTo(34.5678, 1e-4));
        expect(parsed.longitude, closeTo(-112.3456, 1e-4));
        expect(parsed.elevation, 1250.0);
        expect(parsed.benchHeight, 25.0);
        expect(parsed.imagePaths, containsAll(['photo_a.jpg', 'photo_b.jpg']));
      },
    );
  });
}
