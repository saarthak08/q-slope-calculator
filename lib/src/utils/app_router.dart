import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/inverse_calculator_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/kinematic_compass_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/q_slope_stability_chart_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/sensitivity_simulator_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/support_guide_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomeScreen(),
        );
      case CalculateScreen.route:
        final args =
            settings.arguments is CalculateScreenArguments
                ? settings.arguments as CalculateScreenArguments
                : null;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => CalculateScreen(qSlope: args?.qSlope),
        );
      case PhotoViewScreen.route:
        final args =
            settings.arguments is ImageProvider
                ? settings.arguments as ImageProvider
                : null;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => PhotoViewScreen(
                imageProvider:
                    args ?? const AssetImage('assets/images/app_logo.png'),
              ),
        );
      case AboutScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const AboutScreen(),
        );
      case QSlopeStabilityChartScreen.route:
        final args =
            settings.arguments is QSlopeStabilityChartScreenArguments
                ? settings.arguments as QSlopeStabilityChartScreenArguments
                : QSlopeStabilityChartScreenArguments(
                  qSlopeValues: const [],
                  slopeAnglesByUser: const [],
                );
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => QSlopeStabilityChartScreen(
                qSlopeStabilityChartScreenArguments: args,
              ),
        );
      case SensitivitySimulatorScreen.route:
        final args =
            settings.arguments is SensitivitySimulatorScreenArguments
                ? settings.arguments as SensitivitySimulatorScreenArguments
                : const SensitivitySimulatorScreenArguments();
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SensitivitySimulatorScreen(arguments: args),
        );
      case InverseCalculatorScreen.route:
        final args =
            settings.arguments is InverseCalculatorScreenArguments
                ? settings.arguments as InverseCalculatorScreenArguments
                : const InverseCalculatorScreenArguments();
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => InverseCalculatorScreen(arguments: args),
        );
      case SupportGuideScreen.route:
        final args =
            settings.arguments is SupportGuideScreenArguments
                ? settings.arguments as SupportGuideScreenArguments
                : const SupportGuideScreenArguments();
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SupportGuideScreen(arguments: args),
        );
      case KinematicCompassScreen.route:
        final args =
            settings.arguments is KinematicCompassScreenArguments
                ? settings.arguments as KinematicCompassScreenArguments
                : const KinematicCompassScreenArguments();
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => KinematicCompassScreen(arguments: args),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Text("No Route Found"),
        );
    }
  }
}
