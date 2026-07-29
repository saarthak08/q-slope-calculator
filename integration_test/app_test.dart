import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:q_slope_calculator/main.dart' as app;
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E Test: Navigates calculation flow and checks history/result', (
    WidgetTester tester,
  ) async {
    // 1. Setup mock data in SharedPreferences
    final mockQSlope = QSlope(
      id: 'mock-123',
      locationId: 'Loc-Test-1',
      lithology: 'Granite',
      qSlope: 25.0,
      createdAt: DateTime.now(),
      slopeAngleByUser: 45.0,
      blockSize: BlockSize(rqd: 50, jointSetNumber: 2),
      jointCharacter: JointCharacter(
        jointRoughness: [1.0],
        jointAlteration: [1.0],
      ),
      oFactor: OFactor(oFactorForFirstJoint: 1.0),
      externalFactors: ExternalFactors(
        environmentalAndGeologicalConditionalNumber: 1.0,
      ),
      activeStress: ActiveStress(srfA: 1.0, srf: 1.0),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('Q_SLOPES', [mockQSlope.toJson()]);

    // 2. Launch the app
    app.main();
    await tester.pumpAndSettle();

    // 3. Verify history has the item
    // The home screen should show the location ID
    expect(find.textContaining('Loc-Test-1'), findsWidgets);

    // 4. Tap the item to open CalculateScreen
    await tester.tap(find.textContaining('Loc-Test-1').first);
    await tester.pumpAndSettle();

    // 5. We are now in CalculateScreen. Let's input some sample data.
    // The first tab is Block Size, we should find TextFormFields.
    // Let's modify the Location ID.
    final textFields = find.byType(TextFormField);
    expect(textFields, findsWidgets);

    // We enter a new Location ID in the first field
    await tester.enterText(textFields.first, 'Loc-Test-Modified');
    await tester.pumpAndSettle();

    // 6. Navigate to Active Stress Tab (5th tab) to see stability chart
    // We can tap the 5th Tab
    final tabs = find.byType(Tab);
    expect(tabs.evaluate().length, 5);
    await tester.tap(tabs.last);
    await tester.pumpAndSettle();

    // 7. Verify we are on Active Stress page, and qSlope is visible or Stability Chart button is visible.
    // The save button or stability chart button should be present
    expect(find.byType(ElevatedButton), findsWidgets);

    // 8. Go back to Home Screen
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Clear prefs at the end
    await prefs.clear();
  });
}
