import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

void main() {
  group('Dimensions utils', () {
    testWidgets('getDeviceWidth returns correct width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final width = getDeviceWidth(context);
              expect(width, 800.0);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('getDeviceHeight returns correct height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final height = getDeviceHeight(context);
              expect(height, 600.0);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ThemeData utils', () {
    testWidgets('getThemeData returns light theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final theme = getThemeData(context);
              expect(theme.brightness, Brightness.light);
              expect(theme.useMaterial3, true);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('getDarkThemeData returns dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final theme = getDarkThemeData(context);
              expect(theme.brightness, Brightness.dark);
              expect(theme.useMaterial3, true);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
