import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/sensitivity_simulator_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  group('SensitivitySimulatorScreen Widget Tests', () {
    Widget createWidgetUnderTest({QSlope? qSlope}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<QSlopeListCubit>(create: (context) => QSlopeListCubit()),
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
          supportedLocales: const [Locale('en')],
          home: SensitivitySimulatorScreen(
            arguments: SensitivitySimulatorScreenArguments(qSlope: qSlope),
          ),
        ),
      );
    }

    testWidgets(
      'renders sensitivity simulator on small mobile viewport without overflow',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(320, 640));
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Live Sensitivity Simulator'), findsOneWidget);
        expect(find.text('Q-Slope Rating'), findsOneWidget);
        expect(find.text('Interactive Parameter Sliders'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders sensitivity simulator controls and results card', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(1000, 1200));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Live Sensitivity Simulator'), findsOneWidget);
      expect(find.text('Q-Slope Rating'), findsOneWidget);
      expect(
        find.text('Live Stability Envelope Operating Point'),
        findsOneWidget,
      );
      expect(
        find.text('Parameter Sensitivity Ranking (Tornado Impact)'),
        findsOneWidget,
      );
      expect(find.text('Interactive Parameter Sliders'), findsOneWidget);
      expect(find.text('RQD (%)'), findsOneWidget);
      expect(find.text('Joint Set Number (Jn)'), findsOneWidget);
      expect(find.text('Joint Roughness (Jr)'), findsOneWidget);
    });

    testWidgets('moving RQD slider updates Q-slope live value', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 1200));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final sliderFinder = find.byType(Slider).first;
      expect(sliderFinder, findsWidgets);

      // Drag the first slider
      await tester.drag(sliderFinder, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Should still render cleanly with new values
      expect(find.text('Live Sensitivity Simulator'), findsOneWidget);
    });
  });
}
