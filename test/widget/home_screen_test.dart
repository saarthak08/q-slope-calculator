import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/common/result.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/logic/cubit/settings/settings_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/app_bar_list_selection_menu_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

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
      child: ToastificationWrapper(
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

    testWidgets('filters list by search query correctly', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));

      final qSlopes = [
        QSlope(
          id: 'test_id_1',
          locationId: 'Pit Alpha',
          lithology: 'Granite',
          qSlope: 2.5,
          createdAt: DateTime.now(),
        ),
        QSlope(
          id: 'test_id_2',
          locationId: 'Road Cut Beta',
          lithology: 'Basalt',
          qSlope: 0.8,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockQSlopeListCubit.state,
      ).thenReturn(QSlopeListLoaded(qSlopes));

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      expect(find.textContaining('Pit Alpha'), findsOneWidget);
      expect(find.textContaining('Road Cut Beta'), findsOneWidget);

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Alpha');
      await tester.pumpAndSettle();

      expect(find.textContaining('Pit Alpha'), findsOneWidget);
      expect(find.textContaining('Road Cut Beta'), findsNothing);
    });

    testWidgets('renders overflow menu with dark mode, import, and about options', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));
      when(() => mockQSlopeListCubit.state).thenReturn(QSlopeListEmpty());

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      // Find the overflow menu icon
      final overflowMenuFinder = find.byIcon(Icons.more_vert);
      expect(overflowMenuFinder, findsOneWidget);

      // Tap the overflow menu button
      await tester.tap(overflowMenuFinder);
      await tester.pumpAndSettle();

      // Verify menu items appear
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Import JSON'), findsOneWidget);
      expect(find.text('Import CSV'), findsOneWidget);
      expect(find.text('About Q-slope'), findsOneWidget);

      // Verify export options are NOT in the home overflow menu
      expect(find.text('Export Excel File'), findsNothing);
      expect(find.text('Export JSON'), findsNothing);
      expect(find.text('Export CSV'), findsNothing);
    });

    testWidgets('renders leading app icon as prefix without redirection', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));
      when(() => mockQSlopeListCubit.state).thenReturn(QSlopeListEmpty());

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      // App icon image is visible in AppBar leading
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);

      // Tapping the leading image does not redirect or change screens
      await tester.tap(find.byType(Image));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('search bar loses focus on outside tap and back press', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));

      final qSlopes = [
        QSlope(
          id: 'test_1',
          locationId: 'Pit Alpha',
          lithology: 'Granite',
          qSlope: 2.5,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockQSlopeListCubit.state,
      ).thenReturn(QSlopeListLoaded(qSlopes));

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      // Tap on search bar to give it focus
      await tester.tap(textFieldFinder);
      await tester.pumpAndSettle();

      TextField textField = tester.widget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, isTrue);

      // Tap outside on the background or list area
      await tester.tapAt(const Offset(50, 400));
      await tester.pumpAndSettle();

      textField = tester.widget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, isFalse);

      // Tap again to focus
      await tester.tap(textFieldFinder);
      await tester.pumpAndSettle();
      textField = tester.widget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, isTrue);

      // Simulate system back press
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      textField = tester.widget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, isFalse);
    });

    testWidgets('deleting calculations dismisses modal and clears selection mode', (
      WidgetTester tester,
    ) async {
      when(
        () => mockSettingsCubit.state,
      ).thenReturn(SettingsState(themeMode: ThemeMode.light));

      final qSlopes = [
        QSlope(
          id: 'test_1',
          locationId: 'Pit Alpha',
          lithology: 'Granite',
          qSlope: 2.5,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockQSlopeListCubit.state,
      ).thenReturn(QSlopeListLoaded(qSlopes));
      when(
        () => mockQSlopeListCubit.deleteMultipleQSlopesFromList(any()),
      ).thenAnswer((_) async => const Success(true));

      await tester.pumpWidget(buildHomeScreen());
      await tester.pumpAndSettle();

      // Long press card to enter selection mode
      await tester.longPress(find.textContaining('Pit Alpha'));
      await tester.pumpAndSettle();

      // Verify in selection mode (shows 1 selected)
      expect(find.text('1 selected'), findsOneWidget);

      // Open selection menu
      final popupMenuFinder = find.byType(PopupMenuButton<SelectionMenuAction>);
      expect(popupMenuFinder, findsOneWidget);
      await tester.tap(popupMenuFinder);
      await tester.pumpAndSettle();

      // Tap Delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Calculations'), findsOneWidget);

      // Tap OK in confirm dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify the dialog is dismissed!
      expect(find.byType(AlertDialog), findsNothing);

      // Verify selection mode is exited and app title is restored
      expect(find.text('1 selected'), findsNothing);
      expect(find.text('Q-slope Calculator'), findsOneWidget);

      // Settle toast timer
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
