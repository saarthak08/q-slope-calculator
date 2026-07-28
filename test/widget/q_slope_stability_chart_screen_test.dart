import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/q_slope_stability_chart_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  Widget buildChartScreen() {
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
      home: QSlopeStabilityChartScreen(
        qSlopeStabilityChartScreenArguments:
            QSlopeStabilityChartScreenArguments(
              qSlopeValues: [1.5],
              slopeAnglesByUser: [60.0],
            ),
      ),
    );
  }

  group('QSlopeStabilityChartScreen Widget Tests', () {
    testWidgets('renders properly', (WidgetTester tester) async {
      await tester.pumpWidget(buildChartScreen());
      await tester.pumpAndSettle();
      expect(find.byType(QSlopeStabilityChartScreen), findsOneWidget);
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });
  });
}
