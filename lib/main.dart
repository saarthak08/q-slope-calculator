import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:q_slope_calculator/src/app.dart';
import 'package:q_slope_calculator/src/constants/app_environment.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/utils/app_config.dart';

/// Determine the current build flavor (environment) from compile-time variables.
/// Defaults to null for Web, otherwise gets 'FLAVOR' from dart-defines.
const String? _flavor = kIsWeb ? null : String.fromEnvironment('FLAVOR');

/// The main entry point for the Q-slope Calculator Flutter application.
/// The main entry point of the Q-Slope Calculator application.
/// It ensures bindings are initialized, loads environment variables,
/// configures the app environment (Dev/Prod based on flavor), and launches
/// the root [App] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final configuredApp = AppConfig(
    environment:
        _flavor == null
            ? AppEnvironment.production
            : _flavor == AppEnvironment.production.value
            ? AppEnvironment.production
            : AppEnvironment.development,
    appTitle:
        _flavor == null
            ? appName
            : _flavor == AppEnvironment.production.value
            ? appName
            : "[DEV] $appName",
    child: App(),
  );
  runApp(configuredApp);
}
