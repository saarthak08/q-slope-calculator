import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/ui/widgets/stability_badge.dart';

void main() {
  Widget buildTestBadge({
    required double? qSlope,
    required double? actualSlopeAngle,
    bool showSafetyMargin = true,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: StabilityBadge(
          qSlope: qSlope,
          actualSlopeAngle: actualSlopeAngle,
          showSafetyMargin: showSafetyMargin,
        ),
      ),
    );
  }

  group('StabilityBadge Widget Tests', () {
    testWidgets('renders Stable badge with positive safety margin', (
      WidgetTester tester,
    ) async {
      // Q=1 -> allowable=65. actual=55 -> margin=+10 -> Stable
      await tester.pumpWidget(
        buildTestBadge(qSlope: 1.0, actualSlopeAngle: 55.0),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Stable'), findsOneWidget);
      expect(find.textContaining('+10.0°'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('renders Uncertain badge within tolerance band', (
      WidgetTester tester,
    ) async {
      // Q=1 -> allowable=65. actual=65 -> margin=0 -> Uncertain
      await tester.pumpWidget(
        buildTestBadge(qSlope: 1.0, actualSlopeAngle: 65.0),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Uncertain'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('renders Unstable badge with negative safety margin', (
      WidgetTester tester,
    ) async {
      // Q=1 -> allowable=65. actual=75 -> margin=-10 -> Unstable
      await tester.pumpWidget(
        buildTestBadge(qSlope: 1.0, actualSlopeAngle: 75.0),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Unstable'), findsOneWidget);
      expect(find.textContaining('-10.0°'), findsOneWidget);
      expect(find.byIcon(Icons.dangerous_outlined), findsOneWidget);
    });

    testWidgets('renders Allowable angle when actual slope angle is null', (
      WidgetTester tester,
    ) async {
      // Q=1 -> allowable=65. actual=null
      await tester.pumpWidget(
        buildTestBadge(qSlope: 1.0, actualSlopeAngle: null),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('65.0°'), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('renders compact badge without safety margin and without overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestBadge(
          qSlope: 1.0,
          actualSlopeAngle: 55.0,
          showSafetyMargin: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Stable'), findsOneWidget);
      expect(find.textContaining('Δβ'), findsNothing);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
