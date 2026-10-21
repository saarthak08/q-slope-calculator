import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_character_page/jrc_profilometer_modal.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('JrcProfilometerModal Widget Tests', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
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
        home: Scaffold(
          body: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed: () => JrcProfilometerModal.show(context),
                  child: const Text('Open Modal'),
                ),
          ),
        ),
      );
    }

    testWidgets('opens modal and displays Barton 10 profiles', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Barton 10-Profile JRC Selector'), findsOneWidget);
      expect(find.text('JRC 0 - 2'), findsOneWidget);
      expect(find.text('Jr = 0.5'), findsOneWidget);
      expect(find.text('JRC 2 - 4'), findsOneWidget);
      expect(find.text('Jr = 1.0'), findsOneWidget);

      // Tap on JRC 2-4 profile to select it
      await tester.tap(find.text('JRC 2 - 4'));
      await tester.pumpAndSettle();

      // Modal is dismissed
      expect(find.text('Barton 10-Profile JRC Selector'), findsNothing);
    });

    testWidgets('opens modal on mobile viewport and closes via close button', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(320, 640));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Barton 10-Profile JRC Selector'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Close using close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Barton 10-Profile JRC Selector'), findsNothing);
    });
  });
}
