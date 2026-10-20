import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MockQSlopeListCubit extends MockCubit<QSlopeListState>
    implements QSlopeListCubit {}

void main() {
  late MockQSlopeListCubit mockQSlopeListCubit;

  setUp(() {
    mockQSlopeListCubit = MockQSlopeListCubit();
  });

  Widget buildCalculateScreen({QSlope? qSlope}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QSlopeListCubit>.value(value: mockQSlopeListCubit),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: ResponsiveBreakpoints(
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
          child: CalculateScreen(qSlope: qSlope),
        ),
      ),
    );
  }

  group('CalculateScreen Widget Tests', () {
    testWidgets('renders CalculateScreen and tabs correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalculateScreen());
      await tester.pumpAndSettle();

      expect(find.byType(CalculateScreen), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('shows delete icon if qSlope is provided', (
      WidgetTester tester,
    ) async {
      final qSlope = QSlope(
        id: 'test_id',
        locationId: 'Test Loc',
        lithology: 'Test Lithology',
      );
      await tester.pumpWidget(buildCalculateScreen(qSlope: qSlope));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('does not show delete icon if qSlope is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildCalculateScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('allows imported calculation without random sets to switch tabs seamlessly', (
      WidgetTester tester,
    ) async {
      final importedQSlope = QSlope(
        id: 'imported_1',
        locationId: 'Pit Alpha',
        lithology: 'Granite',
        blockSize: BlockSize(
          rqd: 85.0,
          jointSetNumber: 3.0,
          numberOfJoints: 1,
        ),
        jointCharacter: JointCharacter(
          jointRoughness: [2.0],
          jointAlteration: [1.0],
          jrCalculationType: JrCalculationType.jr,
        ),
        oFactor: OFactor(
          oFactorForFirstJoint: 1.0,
          indexOfFirstJoint: 0,
          oFactorCalculationType: OFactorCalculationType.value,
          oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
        ),
        externalFactors: ExternalFactors(
          environmentalAndGeologicalConditionalNumber: 0.8,
        ),
        activeStress: ActiveStress(
          srf: 2.5,
          srfA: 2.5,
        ),
        qSlope: 18.13,
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: importedQSlope));
      await tester.pumpAndSettle();

      // Tap on Joint Character tab (index 1)
      await tester.tap(find.text('Joint Character'));
      await tester.pumpAndSettle();

      // Verify no blocking dialog appears
      expect(
        find.text('Please complete the Basic Info and Block Size section before proceeding to this step.'),
        findsNothing,
      );
      expect(find.text('Enter joint roughness value for all the joints: (0.5 - 4)'), findsOneWidget);

      // Tap on O-Factor tab (index 2)
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please complete the Basic Info and Block Size section before proceeding to this step.'),
        findsNothing,
      );
    });

    testWidgets('Direct method automatically populates Sum of Core Pieces and Total Drill Run when RQD is present', (
      WidgetTester tester,
    ) async {
      final importedQSlope = QSlope(
        id: 'calc_with_rqd',
        locationId: 'Pit Alpha',
        lithology: 'Granite',
        blockSize: BlockSize(
          rqd: 75.0,
          jointSetNumber: 4.0,
          numberOfJoints: 1,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: importedQSlope));
      await tester.pumpAndSettle();

      // On tab 0 (Basic Info & Block Size), Direct Method fields should be populated
      expect(find.text('75'), findsWidgets);
      expect(find.text('100'), findsWidgets);
      expect(find.text('Sum of Core Pieces is required'), findsNothing);
      expect(find.text('Total Drill Run is required'), findsNothing);
    });

    testWidgets('Active Stress tab allows exporting to Excel, JSON, and CSV', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final qSlope = QSlope(
        id: 'exported_calc',
        locationId: 'Pit Gamma',
        lithology: 'Basalt',
        blockSize: BlockSize(rqd: 80.0, jointSetNumber: 3.0, numberOfJoints: 1),
        jointCharacter: JointCharacter(
          jointRoughness: [2.0],
          jointAlteration: [1.0],
          jrCalculationType: JrCalculationType.jr,
        ),
        oFactor: OFactor(
          oFactorForFirstJoint: 1.0,
          indexOfFirstJoint: 0,
          oFactorCalculationType: OFactorCalculationType.value,
          oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
        ),
        externalFactors: ExternalFactors(
          environmentalAndGeologicalConditionalNumber: 1.0,
        ),
        activeStress: ActiveStress(srf: 2.0, srfA: 2.0),
        qSlope: 26.67,
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: qSlope));
      await tester.pumpAndSettle();

      // Tap on Active Stress tab (index 4)
      await tester.tap(find.text('Active Stress & Q-slope'));
      await tester.pumpAndSettle();

      // Find the export dropdown button
      final exportButtonFinder = find.byType(PopupMenuButton<String>);
      expect(exportButtonFinder, findsOneWidget);

      await tester.tap(exportButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Export Excel File'), findsOneWidget);
      expect(find.text('Export JSON'), findsOneWidget);
      expect(find.text('Export CSV'), findsOneWidget);
    });

    testWidgets('Block Size tab renders dynamic joint spacing controllers for Palmstrom Jv method', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final jvQSlope = QSlope(
        id: 'jv_test',
        locationId: 'Bench South 1',
        lithology: 'Sandstone',
        slopeAngleByUser: 60.0,
        blockSize: BlockSize(
          numberOfJoints: 3,
          numberOfRandomSets: 1,
          jointSpacingInMeters: [0.5, 0.8, 1.2],
          areaInSquareMeters: 5.0,
          jointSetNumber: 6.0,
          jointVolume: 4.0,
          rqd: 88.0,
          rqdCalculationType: RqdCalculationType.jv,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: jvQSlope));
      await tester.pumpAndSettle();

      // Verify Jv method components are displayed
      expect(find.text('Joint Spacing (S) in meters'), findsOneWidget);
      expect(find.text('0.5'), findsOneWidget);
      expect(find.text('0.8'), findsOneWidget);
      expect(find.text('1.2'), findsOneWidget);
      expect(find.text('S1'), findsOneWidget);
      expect(find.text('S2'), findsOneWidget);
      expect(find.text('S3'), findsOneWidget);
    });

    testWidgets('Joint Character tab renders Palmstrom roughness with waviness and smoothness inputs for multiple joints', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final palmstromQSlope = QSlope(
        id: 'palmstrom_test',
        locationId: 'Bench South 2',
        lithology: 'Granite',
        blockSize: BlockSize(
          numberOfJoints: 2,
          rqd: 80.0,
          sumOfCorePieces: 80.0,
          totalDrillRun: 100.0,
          jointSetNumber: 4.0,
          rqdCalculationType: RqdCalculationType.directMethod,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.palmstorm,
          jointRoughness: [3.0, 1.5],
          jointWaviness: [2.0, 1.5],
          jointSmoothness: [1.5, 1.0],
          jointAlteration: [1.0, 2.0],
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: palmstromQSlope));
      await tester.pumpAndSettle();

      // Navigate to Joint Character tab
      await tester.tap(find.text('Joint Character'));
      await tester.pumpAndSettle();

      // Palmstrom Roughness UI elements
      expect(find.text('Joint Wavyness (Jw)'), findsOneWidget);
      expect(find.text('Joint Smoothness (Js)'), findsOneWidget);
      expect(find.text('2.0'), findsWidgets);
      expect(find.text('1.5'), findsWidgets);
      expect(find.text('1.0'), findsWidgets);
    });

    testWidgets('O-Factor tab populates Romana Adjustment Factor and Wedge failure inputs accurately', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final romanaQSlope = QSlope(
        id: 'romana_test',
        locationId: 'East Wall 5',
        lithology: 'Schist',
        blockSize: BlockSize(
          numberOfJoints: 2,
          rqd: 75.0,
          jointSetNumber: 4.0,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.jr,
          jointRoughness: [2.0, 1.5],
          jointAlteration: [1.0, 2.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
          oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          indexOfFirstJoint: 0,
          indexOfSecondJoint: 1,
          alphaI: 55.0,
          betaI: 40.0,
          alphaS: 65.0,
          betaS: 60.0,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: romanaQSlope));
      await tester.pumpAndSettle();

      // Navigate to O-Factor tab
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      // Verify no blocking dialog
      expect(
        find.text('Please complete the Basic Info and Block Size section before proceeding to this step.'),
        findsNothing,
      );

      // Verify Romana failure mode and angle values are populated
      expect(find.text('Wedge Failure'), findsWidgets);
      expect(find.text('55.0'), findsOneWidget);
      expect(find.text('65.0'), findsOneWidget);
    });

    testWidgets('O-Factor tab populates direct value inputs for both joints in Wedge failure', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final wedgeValueQSlope = QSlope(
        id: 'wedge_value_test',
        locationId: 'West Wall 3',
        lithology: 'Basalt',
        blockSize: BlockSize(
          numberOfJoints: 2,
          rqd: 80.0,
          jointSetNumber: 4.0,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.jr,
          jointRoughness: [2.0, 1.5],
          jointAlteration: [1.0, 2.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.value,
          oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          indexOfFirstJoint: 0,
          indexOfSecondJoint: 1,
          oFactorForFirstJoint: 1.15,
          oFactorForSecondJoint: 0.90,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: wedgeValueQSlope));
      await tester.pumpAndSettle();

      // Navigate to O-Factor tab
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      // Verify direct O-Factor values for both joints are populated
      expect(find.text('Wedge Failure'), findsWidgets);
      expect(find.text('1.15'), findsOneWidget);
      expect(find.text('0.9'), findsOneWidget);
    });

    testWidgets('O-Factor tab populates Toppling failure with Romana parameters', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final topplingQSlope = QSlope(
        id: 'toppling_test',
        locationId: 'North Ridge 8',
        lithology: 'Slate',
        blockSize: BlockSize(
          numberOfJoints: 1,
          rqd: 70.0,
          jointSetNumber: 3.0,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.jr,
          jointRoughness: [2.0],
          jointAlteration: [1.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
          oFactorTypeOfFailure: OFactorTypeOfFailure.toppling,
          indexOfFirstJoint: 0,
          alphaJ: 240.0,
          betaJ: 55.0,
          alphaS: 60.0,
          betaS: 70.0,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: topplingQSlope));
      await tester.pumpAndSettle();

      // Navigate to O-Factor tab
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      // Verify Toppling mode and angle fields are populated
      expect(find.text('Toppling'), findsWidgets);
      expect(find.text('240.0'), findsOneWidget);
      expect(find.text('55.0'), findsOneWidget);
      expect(find.text('60.0'), findsOneWidget);
      expect(find.text('70.0'), findsOneWidget);
    });

    testWidgets('O-Factor tab populates Planar failure with direct value mode', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final planarQSlope = QSlope(
        id: 'planar_test',
        locationId: 'South Wall 1',
        lithology: 'Sandstone',
        blockSize: BlockSize(
          numberOfJoints: 1,
          rqd: 75.0,
          jointSetNumber: 3.0,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.jr,
          jointRoughness: [2.0],
          jointAlteration: [1.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.value,
          oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
          indexOfFirstJoint: 0,
          oFactorForFirstJoint: 1.25,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: planarQSlope));
      await tester.pumpAndSettle();

      // Navigate to O-Factor tab
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      // Verify Planar mode and single O-Factor value populated
      expect(find.text('Planar Failure'), findsWidgets);
      expect(find.text('1.25'), findsOneWidget);
    });

    testWidgets('O-Factor tab populates Romana Adjustment Factor by value mode', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final romanaValueQSlope = QSlope(
        id: 'romana_value_test',
        locationId: 'Abutment 3',
        lithology: 'Gneiss',
        blockSize: BlockSize(
          numberOfJoints: 1,
          rqd: 80.0,
          jointSetNumber: 4.0,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.jr,
          jointRoughness: [2.0],
          jointAlteration: [1.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
          oFactorRomanaValueType: OFactorRomanaValueType.value,
          oFactorTypeOfFailure: OFactorTypeOfFailure.planar,
          indexOfFirstJoint: 0,
          oFactorForFirstJoint: 1.05,
        ),
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: romanaValueQSlope));
      await tester.pumpAndSettle();

      // Navigate to O-Factor tab
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();

      // Verify Romana by value mode is displayed with 1.05
      expect(find.text('1.05'), findsOneWidget);
    });

    testWidgets('Seamless traversal through all tabs for complex calculation without blockers', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final complexQSlope = QSlope(
        id: 'complex_roundtrip',
        locationId: 'Sector Omega',
        lithology: 'Dolomite',
        slopeAngleByUser: 68.0,
        blockSize: BlockSize(
          numberOfJoints: 2,
          numberOfRandomSets: 0,
          jointSpacingInMeters: [0.6, 0.9],
          areaInSquareMeters: 4.0,
          jointSetNumber: 4.0,
          jointVolume: 3.0,
          rqd: 85.0,
          rqdCalculationType: RqdCalculationType.jv,
        ),
        jointCharacter: JointCharacter(
          jrCalculationType: JrCalculationType.palmstorm,
          jointRoughness: [2.0, 1.5],
          jointWaviness: [2.0, 1.5],
          jointSmoothness: [1.0, 1.0],
          jointAlteration: [1.0, 2.0],
        ),
        oFactor: OFactor(
          oFactorCalculationType: OFactorCalculationType.romanaAdjacentFactor,
          oFactorTypeOfFailure: OFactorTypeOfFailure.wedge,
          indexOfFirstJoint: 0,
          indexOfSecondJoint: 1,
          oFactorForFirstJoint: 1.0,
          oFactorForSecondJoint: 0.85,
          alphaI: 50.0,
          betaI: 35.0,
          alphaS: 60.0,
          betaS: 65.0,
          f1: 10.0,
          f2: 1.0,
          f3: 12.0,
        ),
        externalFactors: ExternalFactors(
          environmentalAndGeologicalConditionalNumber: 0.75,
          externalFactorsCalculationType: ExternalFactorsCalculationType.factors,
          externalFactorsEnvironmentConditions: ExternalFactorsEnvironmentConditions.desertEnvironment,
          externalFactorsStrengthOfRock: ExternalFactorsStrengthOfRock.competent,
          externalFactorsStructureType: ExternalFactorsStructureType.stable,
        ),
        activeStress: ActiveStress(
          srf: 3.5,
          srfB: 3.5,
        ),
        qSlope: 9.82,
      );

      await tester.pumpWidget(buildCalculateScreen(qSlope: complexQSlope));
      await tester.pumpAndSettle();

      // Tab 0 -> Tab 1
      await tester.tap(find.text('Joint Character'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      // Tab 1 -> Tab 2
      await tester.tap(find.text('O-Factor'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      // Tab 2 -> Tab 3
      await tester.tap(find.text('External Factors'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);

      // Tab 3 -> Tab 4
      await tester.tap(find.text('Active Stress & Q-slope'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
