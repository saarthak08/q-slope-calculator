import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/logic/cubit/settings/settings_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MockQSlopeListCubit extends MockCubit<QSlopeListState>
    implements QSlopeListCubit {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late MockQSlopeListCubit mockQSlopeListCubit;
  late MockSettingsCubit mockSettingsCubit;

  setUp(() {
    mockQSlopeListCubit = MockQSlopeListCubit();
    mockSettingsCubit = MockSettingsCubit();

    when(() => mockQSlopeListCubit.loadQSlopeList()).thenAnswer((_) async {});
  });

  Widget buildHomeScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QSlopeListCubit>.value(value: mockQSlopeListCubit),
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
      ],
      child: MaterialApp(
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
        supportedLocales: [Locale('en')],
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders empty state correctly', (WidgetTester tester) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));
      when(() => mockQSlopeListCubit.state).thenReturn(QSlopeListEmpty());

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      // Wait for app localization to load
      final noDataFinder = find.text('No previous calculations found');
      expect(noDataFinder, findsOneWidget);
    });

    testWidgets('renders loaded state with list correctly', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));

      final qSlopes = [
        QSlope(
          id: 'test_id_1',
          locationId: 'Loc 1',
          lithology: 'Granite',
          qSlope: 1.5,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockQSlopeListCubit.state,
      ).thenReturn(QSlopeListLoaded(qSlopes));

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.textContaining('Loc 1'), findsOneWidget);
      expect(find.textContaining('Granite'), findsOneWidget);
    });
  });
}
