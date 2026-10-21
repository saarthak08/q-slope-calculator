import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/support_guide_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('SupportGuideScreen Widget Tests', () {
    Widget createWidgetUnderTest({QSlope? qSlope}) {
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
        home: SupportGuideScreen(
          arguments: SupportGuideScreenArguments(qSlope: qSlope),
        ),
      );
    }

    testWidgets('renders empirical slope support guide and category cards', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 1400));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Empirical Slope Support Guide'), findsOneWidget);
      expect(find.text('Active Geotechnical Assessment'), findsOneWidget);
      expect(find.text('Bench Geometry & Rock Mass Inputs'), findsOneWidget);
      expect(
        find.text('Barton & Bar (2017) Empirical Support Categories'),
        findsOneWidget,
      );
      expect(find.text('Bench / Slope Height (H) in meters'), findsOneWidget);
      expect(find.text('Q-Slope Rating'), findsOneWidget);
    });
  });
}
