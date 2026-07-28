import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('UI Widgets Tests', () {
    testWidgets('CustomTextFormField renders correctly', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(
            body: CustomTextFormField(
              textEditingController: controller,
              titleText: 'Test Title',
              hintText: 'Test Hint',
              placeholderText: 'Test Placeholder',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Placeholder'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('DividerWidget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DividerWidget(color: Colors.red),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('IllustrationWidget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            ],
          ),
          home: Scaffold(
            body: IllustrationWidget(
              assetPath: 'assets/illustrations/test.svg',
              text: 'Test Illustration',
              onRefresh: () async {},
            ),
          ),
        ),
      );

      expect(find.text('Test Illustration'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
