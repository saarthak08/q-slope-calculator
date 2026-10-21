import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/sample_data.dart';
import 'package:q_slope_calculator/src/utils/csv_utils.dart';

void main() {
  group('CsvUtils Tests', () {
    test('parseCsvContent parses valid CSV accurately', () {
      const csv =
          '''ID,Location_ID,Lithology,RQD,Jn,Jr1,Ja1,Jr2,Ja2,OFactor1,OFactor2,Jwice,SRF,QSlope,SlopeAngleByUser,AllowableAngle,SafetyMargin,StabilityStatus,CreatedAt
test-1,LocA,Granite,85,4,2,1,,,1,,0.8,2,8.5,60,75,15,stable,2026-10-19T10:00:00.000Z
test-2,LocB,Basalt,50,9,1,2,,,0.5,,0.5,5,0.27,65,53.4,-11.6,unstable,2026-10-19T11:00:00.000Z
''';

      final results = CsvUtils.parseCsvContent(csv);
      expect(results.length, 2);

      expect(results[0].id, 'test-1');
      expect(results[0].locationId, 'LocA');
      expect(results[0].lithology, 'Granite');
      expect(results[0].blockSize?.rqd, 85);
      expect(results[0].blockSize?.sumOfCorePieces, 85);
      expect(results[0].blockSize?.totalDrillRun, 100);
      expect(results[0].blockSize?.jointSetNumber, 4);
      expect(results[0].jointCharacter?.jointRoughness?[0], 2.0);
      expect(results[0].jointCharacter?.jointAlteration?[0], 1.0);
      expect(results[0].slopeAngleByUser, 60.0);

      expect(results[1].id, 'test-2');
      expect(results[1].locationId, 'LocB');
      expect(results[1].lithology, 'Basalt');
      expect(results[1].blockSize?.rqd, 50);
      expect(results[1].blockSize?.sumOfCorePieces, 50);
      expect(results[1].blockSize?.totalDrillRun, 100);
      expect(results[1].blockSize?.jointSetNumber, 9);
      expect(results[1].slopeAngleByUser, 65.0);
    });

    test('parseCsvContent handles quoted fields with commas', () {
      const csv =
          '''ID,Location_ID,Lithology,RQD,Jn,Jr,Ja,OFactor,Jwice,SRF,QSlope,SlopeAngleByUser,CreatedAt
1,"Pit 4, Bench 2","Schist, weathered",70,4,1.5,1,1,0.7,1.5,5.5,50,2026-10-19T12:00:00.000Z
''';

      final results = CsvUtils.parseCsvContent(csv);
      expect(results.length, 1);
      expect(results[0].locationId, 'Pit 4, Bench 2');
      expect(results[0].lithology, 'Schist, weathered');
    });

    test('parseCsvContent returns empty list for empty content', () {
      expect(CsvUtils.parseCsvContent(''), isEmpty);
      expect(CsvUtils.parseCsvContent('Header only'), isEmpty);
    });

    test(
      'generateCsvString and parseCsvContent roundtrip for 2-joint wedge failure',
      () {
        final original = QSlope(
          id: 'wedge-test-1',
          locationId: 'North Pit Cut 3',
          lithology: 'Gneiss',
          blockSize: BlockSize(
            rqd: 80.0,
            jointSetNumber: 6.0,
            numberOfJoints: 2,
            numberOfRandomSets: 0,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [2.5, 1.5],
            jointAlteration: [1.0, 2.0],
            jrCalculationType: JrCalculationType.jr,
          ),
          oFactor: OFactor(
            oFactorForFirstJoint: 1.0,
            oFactorForSecondJoint: 0.85,
            indexOfFirstJoint: 0,
            indexOfSecondJoint: 1,
            oFactorCalculationType: OFactorCalculationType.value,
            oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.8,
          ),
          activeStress: ActiveStress(srf: 2.5, srfA: 2.5),
          qSlope: 5.44,
          slopeAngleByUser: 62.0,
          createdAt: DateTime(2026, 10, 18, 9, 30),
        );

        final csvString = CsvUtils.generateCsvString([original]);
        expect(csvString.contains('North Pit Cut 3'), isTrue);
        expect(csvString.contains('Gneiss'), isTrue);
        expect(csvString.contains('80.0,6.0,2.5,1.0,1.5,2.0,1.0,0.85'), isTrue);

        final parsedList = CsvUtils.parseCsvContent(csvString);
        expect(parsedList.length, 1);

        final restored = parsedList.first;
        expect(restored.id, original.id);
        expect(restored.locationId, original.locationId);
        expect(restored.lithology, original.lithology);
        expect(restored.blockSize?.rqd, 80.0);
        expect(restored.blockSize?.jointSetNumber, 6.0);
        expect(restored.jointCharacter?.jointRoughness?.length, 2);
        expect(restored.jointCharacter?.jointRoughness?[0], 2.5);
        expect(restored.jointCharacter?.jointRoughness?[1], 1.5);
        expect(restored.jointCharacter?.jointAlteration?[0], 1.0);
        expect(restored.jointCharacter?.jointAlteration?[1], 2.0);
        expect(restored.oFactor?.oFactorForFirstJoint, 1.0);
        expect(restored.oFactor?.oFactorForSecondJoint, 0.85);
        expect(
          restored.oFactor?.oFactorTypeOfFailure,
          OFactorTypeOfFailure.wedge,
        );
        expect(
          restored.externalFactors?.environmentalAndGeologicalConditionalNumber,
          0.8,
        );
        expect(restored.activeStress?.srf, 2.5);
      },
    );

    test(
      'generateCsvString and parseCsvContent roundtrip for Joint Volume (Jv) method slope',
      () {
        // Volumetric joint count Palmstrom method
        final original = QSlope(
          id: 'jv-slope-1',
          locationId: 'South Portal',
          lithology: 'Granite',
          blockSize: BlockSize(
            numberOfJoints: 3,
            numberOfRandomSets: 1,
            jointSpacingInMeters: [0.5, 0.8, 1.2],
            areaInSquareMeters: 10.0,
            jointVolume: 4.15,
            rqd: 99.6,
            jointSetNumber: 6.0,
            rqdCalculationType: RqdCalculationType.jv,
            rqdByJvCalculationType: RqdByJvCalculationType.formulaWith2Point5Jv,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [3.0, 2.0, 1.5],
            jointAlteration: [1.0, 1.5, 2.0],
          ),
          oFactor: OFactor(
            oFactorForFirstJoint: 1.0,
            indexOfFirstJoint: 0,
            oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.9,
          ),
          activeStress: ActiveStress(srf: 1.5, srfA: 1.5),
          qSlope: 29.88,
          slopeAngleByUser: 70.0,
        );

        final csv = CsvUtils.generateCsvString([original]);
        final parsedList = CsvUtils.parseCsvContent(csv);
        expect(parsedList.length, 1);

        final restored = parsedList.first;
        expect(restored.locationId, 'South Portal');
        expect(restored.blockSize?.rqd, 99.6);
        expect(restored.blockSize?.sumOfCorePieces, 99.6);
        expect(restored.blockSize?.totalDrillRun, 100.0);
        expect(restored.blockSize?.jointSetNumber, 6.0);
        expect(restored.jointCharacter?.jointRoughness?[0], 3.0);
        expect(restored.qSlope, 29.88);
      },
    );

    test('generateCsvString safely handles out-of-range joint indices', () {
      final slopeWithInvalidIndices = QSlope(
        id: 'invalid-idx-1',
        locationId: 'Sector 9',
        jointCharacter: JointCharacter(
          jointRoughness: [2.0],
          jointAlteration: [1.0],
        ),
        oFactor: OFactor(
          indexOfFirstJoint: 5,
          indexOfSecondJoint: 8,
          oFactorForFirstJoint: 1.0,
        ),
      );

      // Should not throw RangeError
      final csv = CsvUtils.generateCsvString([slopeWithInvalidIndices]);
      expect(csv.contains('Sector 9'), isTrue);
      expect(csv.contains('2.0,1.0'), isTrue);
    });

    test(
      'generateCsvString and parseCsvContent roundtrip for Toppling failure with Romana parameters',
      () {
        final topplingSlope = QSlope(
          id: 'toppling-romana-1',
          locationId: 'North Ridge 7',
          lithology: 'Slate',
          blockSize: BlockSize(
            rqd: 65.0,
            sumOfCorePieces: 65.0,
            totalDrillRun: 100.0,
            jointSetNumber: 6.0,
            numberOfJoints: 1,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [1.5],
            jointAlteration: [2.0],
          ),
          oFactor: OFactor(
            indexOfFirstJoint: 0,
            oFactorForFirstJoint: 0.88,
            oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
            oFactorTypeOfFailure: OFactorTypeOfFailure.toppling,
            alphaJ: 240.0,
            alphaS: 60.0,
            betaJ: 55.0,
            betaS: 70.0,
            f1: 0.0,
            f2: 1.0,
            f3: 125.0,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.7,
          ),
          activeStress: ActiveStress(srf: 3.0),
          qSlope: 1.83,
          slopeAngleByUser: 55.0,
        );

        final csv = CsvUtils.generateCsvString([topplingSlope]);
        final parsed = CsvUtils.parseCsvContent(csv);

        expect(parsed.length, 1);
        final restored = parsed.first;
        expect(restored.locationId, 'North Ridge 7');
        expect(
          restored.oFactor?.oFactorTypeOfFailure,
          OFactorTypeOfFailure.toppling,
        );
        expect(
          restored.oFactor?.oFactorCalculationType,
          OFactorCalculationType.romanaAdjacentFactor,
        );
        expect(restored.oFactor?.alphaJ, 240.0);
        expect(restored.oFactor?.alphaS, 60.0);
        expect(restored.oFactor?.betaJ, 55.0);
        expect(restored.oFactor?.betaS, 70.0);
        expect(restored.oFactor?.f1, 0.0);
        expect(restored.oFactor?.f2, 1.0);
        expect(restored.oFactor?.f3, 125.0);
      },
    );

    test(
      'generateCsvString and parseCsvContent roundtrip for Planar failure with Romana parameters',
      () {
        final planarSlope = QSlope(
          id: 'planar-romana-1',
          locationId: 'South Wall 2',
          lithology: 'Limestone',
          blockSize: BlockSize(
            rqd: 80.0,
            sumOfCorePieces: 80.0,
            totalDrillRun: 100.0,
            jointSetNumber: 3.0,
            numberOfJoints: 1,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [2.0],
            jointAlteration: [1.0],
          ),
          oFactor: OFactor(
            indexOfFirstJoint: 0,
            oFactorForFirstJoint: 1.05,
            oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
            oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
            alphaJ: 50.0,
            alphaS: 60.0,
            betaJ: 45.0,
            betaS: 65.0,
            f1: 10.0,
            f2: 45.0,
            f3: -20.0,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.9,
          ),
          activeStress: ActiveStress(srf: 2.0),
          qSlope: 25.2,
          slopeAngleByUser: 62.0,
        );

        final csv = CsvUtils.generateCsvString([planarSlope]);
        final parsed = CsvUtils.parseCsvContent(csv);

        expect(parsed.length, 1);
        final restored = parsed.first;
        expect(restored.locationId, 'South Wall 2');
        expect(
          restored.oFactor?.oFactorTypeOfFailure,
          OFactorTypeOfFailure.planar,
        );
        expect(
          restored.oFactor?.oFactorCalculationType,
          OFactorCalculationType.romanaAdjacentFactor,
        );
        expect(restored.oFactor?.alphaJ, 50.0);
        expect(restored.oFactor?.betaJ, 45.0);
      },
    );
  });

  group('Data Serialization Tests', () {
    test(
      'QSlope JSON roundtrip maintains all data integrity with all methods',
      () {
        final original = QSlope(
          id: 'json-all-methods',
          locationId: 'Mine Shaft 4B',
          lithology: 'Dolomite',
          blockSize: BlockSize(
            rqd: 82.5,
            sumOfCorePieces: 165.0,
            totalDrillRun: 200.0,
            jointSetNumber: 4.0,
            numberOfJoints: 3,
            numberOfRandomSets: 1,
            jointSpacingInMeters: [0.6, 0.9, 1.4],
            areaInSquareMeters: 12.0,
            jointVolume: 3.85,
            rqdCalculationType: RqdCalculationType.jv,
            rqdByJvCalculationType: RqdByJvCalculationType.formulaWith2Point5Jv,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [2.0, 1.5, 3.0],
            jointAlteration: [1.0, 2.0, 1.5],
            jointSmoothness: [1.0, 1.5, 2.0],
            jointWaviness: [2.0, 1.0, 1.5],
            jrCalculationType: JrCalculationType.palmstorm,
          ),
          oFactor: OFactor(
            oFactorForFirstJoint: 1.15,
            oFactorForSecondJoint: 0.90,
            indexOfFirstJoint: 0,
            indexOfSecondJoint: 1,
            alphaI: 55.0,
            alphaJ: 50.0,
            alphaS: 65.0,
            betaI: 40.0,
            betaJ: 45.0,
            betaS: 60.0,
            f1: 15.0,
            f2: 1.0,
            f3: 15.0,
            ratingForF1: 0.15,
            ratingForF2: 0.85,
            ratingForF3: 0.50,
            oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
            oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.75,
            externalFactorsCalculationType:
                ExternalFactorsCalculationType.factors,
            externalFactorsEnvironmentConditions:
                ExternalFactorsEnvironmentConditions.desertEnvironment,
            externalFactorsStrengthOfRock:
                ExternalFactorsStrengthOfRock.competent,
            externalFactorsStructureType: ExternalFactorsStructureType.stable,
          ),
          activeStress: ActiveStress(srf: 3.5, srfA: 2.0, srfB: 3.5, srfC: 1.0),
          qSlope: 12.45,
          slopeAngleByUser: 64.0,
          createdAt: DateTime(2026, 10, 19, 14, 30),
        );

        final jsonMap = original.toMap();
        final restored = QSlope.fromMap(jsonMap);

        expect(restored.id, original.id);
        expect(restored.locationId, original.locationId);
        expect(restored.lithology, original.lithology);
        expect(restored.blockSize?.rqd, 82.5);
        expect(restored.blockSize?.sumOfCorePieces, 165.0);
        expect(restored.blockSize?.totalDrillRun, 200.0);
        expect(restored.blockSize?.jointSpacingInMeters, [0.6, 0.9, 1.4]);
        expect(restored.blockSize?.rqdCalculationType, RqdCalculationType.jv);
        expect(
          restored.jointCharacter?.jrCalculationType,
          JrCalculationType.palmstorm,
        );
        expect(restored.jointCharacter?.jointWaviness, [2.0, 1.0, 1.5]);
        expect(
          restored.oFactor?.oFactorCalculationType,
          OFactorCalculationType.romanaAdjacentFactor,
        );
        expect(restored.oFactor?.alphaS, 65.0);
        expect(
          restored.externalFactors?.externalFactorsEnvironmentConditions,
          ExternalFactorsEnvironmentConditions.desertEnvironment,
        );
        expect(restored.activeStress?.srfB, 3.5);
        expect(restored.qSlope, 12.45);
        expect(restored.slopeAngleByUser, 64.0);
        expect(
          restored.createdAt?.millisecondsSinceEpoch,
          original.createdAt?.millisecondsSinceEpoch,
        );
      },
    );

    test(
      'parseCsvContent parses SRFb and SRFc with camelCase or un-underscored headers',
      () {
        const csv =
            '''ID,Location_ID,Lithology,RQD,Jn,Jr1,Ja1,OFactor1,Jwice,SRF,SRFa,SRFb,SRFc,CreatedAt
pit-1,Bench 1,Basalt,75,4,2,1,1,0.8,15.0,2.5,15.0,5.0,2026-10-21T09:00:00.000Z
pit-2,Bench 2,Granite,80,3,1.5,1,1,0.9,4.0,4.0,null,-,2026-10-21T09:00:00.000Z
''';

        final results = CsvUtils.parseCsvContent(csv);
        expect(results.length, 2);

        // pit-1: all 3 SRF parameters specified
        expect(results[0].activeStress?.srfA, 2.5);
        expect(results[0].activeStress?.srfB, 15.0);
        expect(results[0].activeStress?.srfC, 5.0);
        expect(results[0].activeStress?.srf, 15.0);

        // pit-2: SRFb is "null" string, SRFc is "-" string, should parse to null
        expect(results[1].activeStress?.srfA, 4.0);
        expect(results[1].activeStress?.srfB, isNull);
        expect(results[1].activeStress?.srfC, isNull);
        expect(results[1].activeStress?.srf, 4.0);
      },
    );

    test(
      'parseCsvContent parses SRF_A, SRF_B, SRF_C with underscored headers',
      () {
        const csv =
            '''ID,Location_ID,Lithology,RQD,Jn,Jr1,Ja1,OFactor1,Jwice,SRF,SRF_A,SRF_B,SRF_C
srf-test,Pit C,Diorite,90,2,3,1,1,1.0,20.0,2.0,20.0,8.0
''';

        final results = CsvUtils.parseCsvContent(csv);
        expect(results.length, 1);
        expect(results[0].activeStress?.srfA, 2.0);
        expect(results[0].activeStress?.srfB, 20.0);
        expect(results[0].activeStress?.srfC, 8.0);
        expect(results[0].activeStress?.srf, 20.0);
      },
    );

    test('sample files parse successfully', () {
      final csvFile = File('sample_data/sample_q_slope_data.csv');
      expect(csvFile.existsSync(), isTrue);
      final csvContent = csvFile.readAsStringSync();
      final csvItems = CsvUtils.parseCsvContent(csvContent);
      expect(csvItems.length, 5);
      expect(csvItems.first.locationId, 'Mine Bench 4B - Quartzite');
      expect(csvItems.first.lithology, 'Quartzite');
      expect(csvItems.first.qSlope, 18.13);
    });

    test('SampleData.getSampleQSlopes provides 5 benchmark calculations', () {
      final samples = SampleData.getSampleQSlopes();
      expect(samples.length, 5);
      expect(samples[0].locationId, 'Sample 1: Mine Bench 4B - Quartzite');
      expect(samples[0].lithology, 'Quartzite');
      expect(samples[0].qSlope, 18.13);
      expect(samples[1].locationId, 'Sample 2: Highway 102 Cut - Mica Schist');
      expect(samples[1].qSlope, 0.28);
      expect(samples[2].locationId, 'Sample 3: East Wall Sector 2 - Siltstone');
      expect(samples[2].qSlope, 0.017);
      expect(
        samples[3].locationId,
        'Sample 4: Rail Corridor Cut 9 - Sandstone',
      );
      expect(samples[3].qSlope, 11.78);
      expect(
        samples[4].locationId,
        'Sample 5: Spillway Left Abutment - Basalt',
      );
      expect(samples[4].qSlope, 0.36);
    });
  });
}
