import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case CalculateScreen.route:
        final args = settings.arguments as CalculateScreenArguments;
        return MaterialPageRoute(
            builder: (context) => CalculateScreen(qSlope: args.qSlope));
      case PhotoViewScreen.route:
        final args = settings.arguments as ImageProvider;
        return MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageProvider: args));
      case AboutScreen.route:
        return MaterialPageRoute(builder: (context) => const AboutScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Text("No Route Found"),
        );
    }
  }
}
