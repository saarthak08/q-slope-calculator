import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Text("No Route Found"),
        );
    }
  }
}
