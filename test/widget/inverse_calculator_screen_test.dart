import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/inverse_calculator_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('InverseCalculatorScreen Widget Tests', () {
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
        home: InverseCalculatorScreen(
          arguments: InverseCalculatorScreenArguments(qSlope: qSlope),
        ),
      );
    }

    testWidgets(
      'renders inverse slope design calculator and target angle slider',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1000, 1200));
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Inverse Slope Design'), findsOneWidget);
        expect(find.text('Target Slope Angle (β)'), findsOneWidget);
        expect(find.text('Required Q-Slope'), findsOneWidget);
        expect(
          find.text('Engineering Feasibility & Parameter Thresholds'),
          findsOneWidget,
        );
        expect(find.text('Baseline Rock Mass Constraints'), findsOneWidget);
        expect(
          find.text('Open Scenario in Live Sensitivity Simulator'),
          findsOneWidget,
        );
      },
    );
  });
}
