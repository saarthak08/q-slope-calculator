import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/kinematic_compass_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('KinematicCompassScreen Widget Tests', () {
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
        home: const KinematicCompassScreen(),
      );
    }

    testWidgets(
      'renders kinematic analysis screen on small mobile without overflow',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Full AppBar title should be present without exception
        expect(find.text('Kinematic Stereonet & Compass'), findsOneWidget);
        // Risk chips should all render cleanly wrapped
        expect(find.textContaining('Planar:'), findsOneWidget);
        expect(find.textContaining('Wedge:'), findsOneWidget);
        expect(find.textContaining('Toppling:'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders kinematic analysis screen with stereonet and controls',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(1000, 1200));
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Kinematic Stereonet & Compass'), findsOneWidget);
        expect(find.text('Failure Mechanism Assessment'), findsOneWidget);
        expect(find.text('Interactive Orientation Controls'), findsOneWidget);
        expect(find.text('Slope Dip Direction (αs)'), findsOneWidget);
        expect(find.text('Slope Dip Angle (βs)'), findsOneWidget);
        expect(find.text('Joint 1 Dip Direction (αj1)'), findsOneWidget);
        expect(find.text('Joint 1 Dip Angle (βj1)'), findsOneWidget);
        expect(find.text('Include Joint 2 (Wedge Analysis)'), findsOneWidget);
      },
    );
  });
}
