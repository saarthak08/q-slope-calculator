import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/constants/app_environment.dart';
import 'package:q_slope_calculator/src/utils/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    testWidgets('provides configuration correctly', (
      WidgetTester tester,
    ) async {
      const String testTitle = 'Test App Title';
      const AppEnvironment testEnv = AppEnvironment.development;

      late AppConfig extractedConfig;

      await tester.pumpWidget(
        AppConfig(
          appTitle: testTitle,
          environment: testEnv,
          child: Builder(
            builder: (BuildContext context) {
              extractedConfig = AppConfig.of(context);
              return Container();
            },
          ),
        ),
      );

      expect(extractedConfig, isNotNull);
      expect(extractedConfig.appTitle, testTitle);
      expect(extractedConfig.environment, testEnv);
    });

    testWidgets('updateShouldNotify always returns false', (
      WidgetTester tester,
    ) async {
      final config1 = AppConfig(
        appTitle: 'Title 1',
        environment: AppEnvironment.production,
        child: Container(),
      );

      final config2 = AppConfig(
        appTitle: 'Title 2',
        environment: AppEnvironment.development,
        child: Container(),
      );

      expect(config2.updateShouldNotify(config1), false);
    });
  });
}
