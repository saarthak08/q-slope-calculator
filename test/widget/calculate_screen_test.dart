import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
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
  });
}
