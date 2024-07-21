import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/app_config.dart';
import 'package:q_slope_calculator/src/utils/app_router.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class App extends StatelessWidget {
  App({super.key});
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppConfig.of(context).appTitle,
        onGenerateRoute: _appRouter.generateRoute,
        theme: getThemeData(context));
  }
}
