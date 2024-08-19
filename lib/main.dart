import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:q_slope_calculator/src/app.dart';
import 'package:q_slope_calculator/src/constants/app_environment.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/utils/app_config.dart';

const String? _flavor = kIsWeb ? null : String.fromEnvironment('FLAVOR');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final configuredApp = AppConfig(
      environment: _flavor == null
          ? AppEnvironment.production
          : _flavor == AppEnvironment.production.value
              ? AppEnvironment.production
              : AppEnvironment.development,
      appTitle: _flavor == null
          ? appName
          : _flavor == AppEnvironment.production.value
              ? appName
              : "[DEV] $appName",
      child: App());
  runApp(configuredApp);
}
