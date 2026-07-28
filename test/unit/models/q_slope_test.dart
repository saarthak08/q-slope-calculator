import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';

void main() {
  group('QSlope Model', () {
    test('copyWith updates fields correctly', () {
      final slope = QSlope(
        id: '1',
        locationId: 'Loc1',
        lithology: 'Granite',
        blockSize: BlockSize(rqd: 80, jointSetNumber: 2),
      );

      final updatedSlope = slope.copyWith(
        locationId: 'Loc2',
        qSlope: 15.5,
      );

      expect(updatedSlope.id, '1');
      expect(updatedSlope.locationId, 'Loc2');
      expect(updatedSlope.lithology, 'Granite');
      expect(updatedSlope.qSlope, 15.5);
      expect(updatedSlope.blockSize?.rqd, 80);
    });

    test('toMap and fromMap works correctly', () {
      final slope = QSlope(
        id: '1',
        locationId: 'Loc1',
        lithology: 'Granite',
        qSlope: 12.3,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000000),
      );

      final map = slope.toMap();
      final fromMapSlope = QSlope.fromMap(map);

      expect(fromMapSlope.id, '1');
      expect(fromMapSlope.locationId, 'Loc1');
      expect(fromMapSlope.lithology, 'Granite');
      expect(fromMapSlope.qSlope, 12.3);
      expect(fromMapSlope.createdAt?.millisecondsSinceEpoch, 1000000);
      expect(fromMapSlope, slope); // Testing equality operator
    });

    test('toJson and fromJson works correctly', () {
      final slope = QSlope(
        id: '2',
        locationId: 'Loc2',
        lithology: 'Sandstone',
        qSlope: 5.5,
      );

      final jsonString = slope.toJson();
      final fromJsonSlope = QSlope.fromJson(jsonString);

      expect(fromJsonSlope, slope);
    });
  });
}
