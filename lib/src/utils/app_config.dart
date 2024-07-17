import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/constants/app_environment.dart';

class AppConfig extends InheritedWidget {
  final AppEnvironment environment;
  final String appTitle;

  const AppConfig({
    super.key,
    required super.child,
    required this.environment,
    required this.appTitle,
  });

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
