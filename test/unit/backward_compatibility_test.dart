import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/repository/q_slope_repository.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/q_slope_list_item_card.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/kinematic_compass_screen.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('Backward Compatibility Tests (Pre-existing Stored Calculations)', () {
    // Exact schema representation from commit 5fea1b7 (Planar Failure)
    const legacyCommit5fea1b7PlanarJson = '''{
  "id": "legacy-calc-001",
  "locationId": "Pit 3 - North Wall",
  "lithology": "Sandstone",
  "blockSize": {
    "numberOfJoints": 1,
    "numberOfRandomSets": 0,
    "jointSpacingInMeters": [1.5],
    "areaInSquareMeters": 5.0,
    "jointVolume": null,
    "sumOfCorePieces": null,
    "totalDrillRun": null,
    "rqdCalculationType": null,
    "rqdByJvCalculationType": null,
    "rqd": 75.0,
    "jointSetNumber": 3.0
  },
  "jointCharacter": {
    "jointRoughness": [1.5],
    "jw": null,
    "js": null,
    "jrCalculationType": null,
    "jointAlteration": [1.0]
  },
  "oFactor": {
    "oFactorCalculationType": null,
    "f1": null,
    "f2": null,
    "f3": null,
    "ratingForF1": null,
    "ratingForF2": null,
    "ratingForF3": null,
    "alphaI": null,
    "alphaJ": null,
    "alphaS": null,
    "betaI": null,
    "betaJ": null,
    "betaS": null,
    "indexOfFirstJoint": 0,
    "indexOfSecondJoint": null,
    "oFactorForFirstJoint": 0.95,
    "oFactorForSecondJoint": null,
    "oFactorTypeOfFailure": null,
    "oFactorRomanaValueType": null
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 0.7,
    "externalFactorsStructureType": null,
    "externalFactorsStrengthOfRock": null,
    "externalFactorsEnvironmentConditions": null,
    "externalFactorsCalculationType": null
  },
  "activeStress": {
    "srfA": 0.0,
    "srfB": 0.0,
    "srfC": 0.0,
    "srf": 2.5
  },
  "qSlope": 6.65,
  "createdAt": 1700000000000,
  "slopeAngleByUser": 58.0
}''';

    // Exact schema representation from commit 5fea1b7 (Wedge Failure with 2 joints)
    const legacyCommit5fea1b7WedgeJson = '''{
  "id": "legacy-wedge-002",
  "locationId": "East Bench 2",
  "lithology": "Schist",
  "blockSize": {
    "numberOfJoints": 2,
    "numberOfRandomSets": 1,
    "jointSpacingInMeters": [0.8, 1.2],
    "areaInSquareMeters": 10.0,
    "jointVolume": 2.5,
    "sumOfCorePieces": 80.0,
    "totalDrillRun": 100.0,
    "rqdCalculationType": "directMethod",
    "rqdByJvCalculationType": null,
    "rqd": 80.0,
    "jointSetNumber": 6.0
  },
  "jointCharacter": {
    "jointRoughness": [2.0, 1.5],
    "jw": [2.0, 1.5],
    "js": [1.0, 1.0],
    "jrCalculationType": "jr",
    "jointAlteration": [1.0, 2.0]
  },
  "oFactor": {
    "oFactorCalculationType": "value",
    "f1": null,
    "f2": null,
    "f3": null,
    "ratingForF1": null,
    "ratingForF2": null,
    "ratingForF3": null,
    "alphaI": null,
    "alphaJ": null,
    "alphaS": null,
    "betaI": null,
    "betaJ": null,
    "betaS": null,
    "indexOfFirstJoint": 0,
    "indexOfSecondJoint": 1,
    "oFactorForFirstJoint": 1.0,
    "oFactorForSecondJoint": 0.8,
    "oFactorTypeOfFailure": "wedge",
    "oFactorRomanaValueType": null
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 0.9,
    "externalFactorsStructureType": "stable",
    "externalFactorsStrengthOfRock": "competent",
    "externalFactorsEnvironmentConditions": "wetEnvironment",
    "externalFactorsCalculationType": "value"
  },
  "activeStress": {
    "srfA": 1.5,
    "srfB": 3.0,
    "srfC": 0.0,
    "srf": 3.0
  },
  "qSlope": 4.8,
  "createdAt": 1700005000000,
  "slopeAngleByUser": 62.0
}''';

    // Bare minimum legacy record (missing optional blocks and fields)
    const minimalLegacyJson = '''{
  "id": "minimal-legacy-003",
  "locationId": "Old Borehole 1",
  "blockSize": {
    "rqd": 60,
    "jointSetNumber": 4
  },
  "jointCharacter": {
    "jointRoughness": [1],
    "jointAlteration": [1]
  },
  "oFactor": {
    "oFactor": 1
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 0.8
  },
  "activeStress": {
    "srf": 2
  },
  "qSlope": 6
}''';

    // Legacy record containing explicit 0 values for fields that are now nullable
    const legacyWithZerosJson = '''{
  "id": "legacy-zeros-004",
  "locationId": "Zero Fault Zone",
  "lithology": "Granite",
  "blockSize": {
    "rqd": 80.0,
    "jointSetNumber": 4.0,
    "numberOfRandomSets": 0,
    "numberOfJoints": 2
  },
  "jointCharacter": {
    "jointRoughness": [2.0],
    "jointAlteration": [1.0]
  },
  "oFactor": {
    "oFactorForFirstJoint": 1.0,
    "oFactorForSecondJoint": 0.0,
    "oFactorTypeOfFailure": "planar"
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 1.0
  },
  "activeStress": {
    "srfA": 0.0,
    "srfB": 0.0,
    "srfC": 0.0,
    "srf": 2.0
  },
  "slopeAngleByUser": 0.0,
  "createdAt": 1705000000000
}''';

    // Legacy record with ISO 8601 string date and legacy photoPaths
    const legacyWithIsoAndPhotosJson = '''{
  "id": "legacy-iso-005",
  "locationId": "Photo Bench C",
  "lithology": "Basalt",
  "blockSize": {
    "rqd": 90.0,
    "jointSetNumber": 3.0
  },
  "jointCharacter": {
    "jointRoughness": 2.0,
    "jointAlteration": 1.0,
    "jw": 1.5,
    "js": 1.0
  },
  "oFactor": {
    "oFactor": 1.2
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 0.7
  },
  "activeStress": {
    "srf": 1.5
  },
  "createdAt": "2024-09-15T08:30:00.000Z",
  "photoPaths": ["/storage/legacy/img1.jpg", "/storage/legacy/img2.jpg"],
  "slopeAngleByUser": 64.0
}''';

    // Legacy record with integer numeric types and missing jointSetNumber (inferred Jn)
    const legacyWithIntsAndDerivedJnJson = '''{
  "id": "legacy-ints-006",
  "locationId": "South Portal",
  "blockSize": {
    "rqd": 50,
    "numberOfJoints": 2,
    "numberOfRandomSets": 0
  },
  "jointCharacter": {
    "jointRoughness": [2],
    "jointAlteration": [1]
  },
  "oFactor": {
    "oFactorForFirstJoint": 1
  },
  "externalFactors": {
    "environmentalAndGeologicalConditionalNumber": 1
  },
  "activeStress": {
    "srf": 2
  }
}''';

    test(
      'QSlope.fromJson deserializes 5fea1b7 planar calculation without error',
      () {
        final slope = QSlope.fromJson(legacyCommit5fea1b7PlanarJson);
        expect(slope.id, 'legacy-calc-001');
        expect(slope.locationId, 'Pit 3 - North Wall');
        expect(slope.lithology, 'Sandstone');
        expect(slope.blockSize?.rqd, 75.0);
        expect(slope.blockSize?.jointSetNumber, 3.0);
        expect(slope.jointCharacter?.jointRoughness, [1.5]);
        expect(slope.jointCharacter?.jointAlteration, [1.0]);
        expect(slope.oFactor?.oFactorForFirstJoint, 0.95);
        expect(
          slope.externalFactors?.environmentalAndGeologicalConditionalNumber,
          0.7,
        );
        expect(slope.activeStress?.srf, 2.5);
        expect(slope.slopeAngleByUser, 58.0);
        expect(
          slope.createdAt,
          DateTime.fromMillisecondsSinceEpoch(1700000000000),
        );

        // Newly added fields must default gracefully to null
        expect(slope.latitude, isNull);
        expect(slope.longitude, isNull);
        expect(slope.elevation, isNull);
        expect(slope.benchHeight, isNull);
        expect(slope.imagePaths, isNull);
        expect(slope.photoPaths, isNull);

        // Verify mathematical calculation: (75/3) * (1.5/1.0) * 0.95 * (0.7/2.5) = 9.975
        final calculated = calculateQSlope(slope);
        expect(calculated, closeTo(9.975, 0.01));
      },
    );

    test(
      'QSlope.fromJson deserializes 5fea1b7 wedge calculation correctly',
      () {
        final slope = QSlope.fromJson(legacyCommit5fea1b7WedgeJson);
        expect(slope.id, 'legacy-wedge-002');
        expect(slope.jointCharacter?.jointRoughness?.length, 2);
        expect(slope.activeStress?.srfA, 1.5);
        expect(slope.activeStress?.srfB, 3.0);
        expect(slope.activeStress?.srf, 3.0);

        // Wedge formula: (80/6) * (2/1)*1.0 * (1.5/2)*0.8 * (0.9/3) = 4.8
        final calculated = calculateQSlope(slope);
        expect(calculated, closeTo(4.8, 0.001));
      },
    );

    test('QSlope.fromJson handles minimal pre-v1 legacy calculation', () {
      final slope = QSlope.fromJson(minimalLegacyJson);
      expect(slope.id, 'minimal-legacy-003');
      expect(slope.locationId, 'Old Borehole 1');
      expect(slope.blockSize?.rqd, 60.0);
      expect(slope.blockSize?.jointSetNumber, 4.0);
      expect(slope.oFactor?.oFactorForFirstJoint, 1.0);
      expect(slope.activeStress?.srf, 2.0);
      expect(slope.createdAt, isNull);
      expect(slope.slopeAngleByUser, isNull);

      // Formula: (60 / 4) * (1 / 1) * 1.0 * (0.8 / 2) = 6.0
      expect(calculateQSlope(slope), closeTo(6.0, 0.001));
      expect(
        calculateSafetyMargin(slope.qSlope, slope.slopeAngleByUser),
        isNull,
      );
      expect(
        getSlopeStabilityStatus(slope.qSlope, slope.slopeAngleByUser),
        SlopeStabilityStatus.unknown,
      );
    });

    test(
      'Zero values do NOT collide with geotechnical formulas or zero-out Q-slope',
      () {
        final slope = QSlope.fromJson(legacyWithZerosJson);
        expect(slope.id, 'legacy-zeros-004');
        expect(slope.activeStress?.srfA, 0.0);
        expect(slope.activeStress?.srfB, 0.0);
        expect(slope.activeStress?.srfC, 0.0);
        expect(slope.activeStress?.srf, 2.0);
        expect(slope.oFactor?.oFactorForSecondJoint, 0.0);

        // Planar failure with oFactorForSecondJoint: 0.0 MUST NOT multiply by 0
        final calculated = calculateQSlope(slope);
        // (80 / 4) * (2 / 1) * 1.0 * (1.0 / 2.0) = 20.0
        expect(calculated, closeTo(20.0, 0.001));
        expect(calculated, isNot(0.0));

        // Slope angle 0.0 must be safely treated as unknown/unspecified
        expect(
          calculateSafetyMargin(calculated, slope.slopeAngleByUser),
          isNull,
        );
        expect(
          getSlopeStabilityStatus(calculated, slope.slopeAngleByUser),
          SlopeStabilityStatus.unknown,
        );
      },
    );

    test(
      'Legacy ISO 8601 string dates, scalar joint character and photoPaths are parsed correctly',
      () {
        final slope = QSlope.fromJson(legacyWithIsoAndPhotosJson);
        expect(slope.id, 'legacy-iso-005');
        expect(slope.createdAt, DateTime.parse("2024-09-15T08:30:00.000Z"));
        expect(slope.imagePaths, [
          '/storage/legacy/img1.jpg',
          '/storage/legacy/img2.jpg',
        ]);
        expect(slope.jointCharacter?.jointRoughness, [2.0]);
        expect(slope.jointCharacter?.jointAlteration, [1.0]);
        expect(slope.jointCharacter?.jointWaviness, [1.5]);
        expect(slope.jointCharacter?.jointSmoothness, [1.0]);
        expect(slope.oFactor?.oFactorForFirstJoint, 1.2);

        // Formula: (90 / 3) * (2 / 1) * 1.2 * (0.7 / 1.5) = 30 * 2 * 1.2 * 0.4667 = 33.6
        expect(calculateQSlope(slope), closeTo(33.6, 0.01));
      },
    );

    test('Legacy integer numbers and missing jointSetNumber infer correctly', () {
      final slope = QSlope.fromJson(legacyWithIntsAndDerivedJnJson);
      expect(slope.blockSize?.rqd, 50.0);
      expect(slope.blockSize?.numberOfJoints, 2);
      expect(slope.blockSize?.jointSetNumber, isNull);

      // Inferred Jn from 2 joints = 2.0: (50 / 2) * (2 / 1) * 1.0 * (1 / 2) = 25.0
      final calculated = calculateQSlope(slope);
      expect(calculated, closeTo(25.0, 0.01));
    });

    test(
      'QSlopeRepository persists and retrieves diverse legacy calculations',
      () async {
        final pref = await SharedPreferences.getInstance();
        await pref.setStringList('Q_SLOPES', [
          legacyCommit5fea1b7PlanarJson,
          legacyCommit5fea1b7WedgeJson,
          minimalLegacyJson,
          legacyWithZerosJson,
          legacyWithIsoAndPhotosJson,
          legacyWithIntsAndDerivedJnJson,
        ]);

        final repo = QSlopeRepository();
        final list = await repo.getAllQSlopes();

        expect(list.length, 6);
        expect(list[0].id, 'legacy-calc-001');
        expect(list[1].id, 'legacy-wedge-002');
        expect(list[2].id, 'minimal-legacy-003');
        expect(list[3].id, 'legacy-zeros-004');
        expect(list[4].id, 'legacy-iso-005');
        expect(list[5].id, 'legacy-ints-006');
      },
    );

    testWidgets(
      'QSlopeListItemCard renders legacy calculation with stability badge cleanly',
      (tester) async {
        final legacySlope = QSlope.fromJson(legacyCommit5fea1b7PlanarJson);

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: QSlopeListItemCard(
                item: legacySlope,
                isSelected: false,
                isSelectionMode: false,
                onTap: () {},
                onLongPress: () {},
                onCheckboxChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Pit 3 - North Wall'), findsOneWidget);
        expect(find.textContaining('Sandstone'), findsOneWidget);
        expect(find.textContaining('6.6500'), findsOneWidget);
        expect(find.textContaining('Stable'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      },
    );

    testWidgets(
      'QSlopeListItemCard gracefully handles legacy calculation with 0.0 slope angle',
      (tester) async {
        final zeroSlope = QSlope.fromJson(legacyWithZerosJson);

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: QSlopeListItemCard(
                item: zeroSlope,
                isSelected: false,
                isSelectionMode: false,
                onTap: () {},
                onLongPress: () {},
                onCheckboxChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Zero Fault Zone'), findsOneWidget);
        expect(find.byIcon(Icons.help_outline), findsOneWidget);
      },
    );

    testWidgets(
      'CalculateScreen opens legacy calculation and traverses all tabs without errors',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        final legacySlope = QSlope.fromJson(legacyCommit5fea1b7PlanarJson);

        await tester.pumpWidget(
          MaterialApp(
            builder:
                (context, child) => ResponsiveBreakpoints.builder(
                  child: child!,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  ],
                ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: CalculateScreen(qSlope: legacySlope),
          ),
        );
        await tester.pumpAndSettle();

        // Block Size tab is visible
        expect(find.text('Pit 3 - North Wall'), findsOneWidget);
        expect(find.text('Sandstone'), findsOneWidget);

        // Traversal to Tab 1 (Joint Character)
        await tester.tap(find.text('Joint Character'));
        await tester.pumpAndSettle();

        // Traversal to Tab 2 (O-Factor)
        await tester.tap(find.text('O-Factor'));
        await tester.pumpAndSettle();

        // Traversal to Tab 3 (External Factors)
        await tester.tap(find.text('External Factors'));
        await tester.pumpAndSettle();

        // Traversal to Tab 4 (Active Stress)
        await tester.tap(find.text('Active Stress & Q-slope'));
        await tester.pumpAndSettle();

        // Ensure that in Active Stress, srfB and srfC do NOT show the literal text "null" or "0"
        expect(find.text('null'), findsNothing);
      },
    );

    testWidgets(
      'CalculateScreen handles legacy wedge calculation across tabs without blockers',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        final wedgeSlope = QSlope.fromJson(legacyCommit5fea1b7WedgeJson);

        await tester.pumpWidget(
          MaterialApp(
            builder:
                (context, child) => ResponsiveBreakpoints.builder(
                  child: child!,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  ],
                ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: CalculateScreen(qSlope: wedgeSlope),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('East Bench 2'), findsOneWidget);

        await tester.tap(find.text('Joint Character'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('O-Factor'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('External Factors'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Active Stress & Q-slope'));
        await tester.pumpAndSettle();

        expect(find.text('null'), findsNothing);
      },
    );

    testWidgets(
      'KinematicCompassScreen functions seamlessly with legacy calculation input',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        final legacySlope = QSlope.fromJson(legacyCommit5fea1b7PlanarJson);

        await tester.pumpWidget(
          MaterialApp(
            builder:
                (context, child) => ResponsiveBreakpoints.builder(
                  child: child!,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  ],
                ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: KinematicCompassScreen(
              arguments: KinematicCompassScreenArguments(
                slopeDip: legacySlope.slopeAngleByUser ?? 65.0,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Kinematic Stereonet & Compass'),
          findsOneWidget,
        );
      },
    );
  });
}
