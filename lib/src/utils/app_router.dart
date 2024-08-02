import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case CalculateScreen.route:
        return MaterialPageRoute(builder: (context) => const CalculateScreen());
      case PhotoViewScreen.route:
        final args = settings.arguments as ImageProvider;
        return MaterialPageRoute(
            builder: (context) => PhotoViewScreen(imageProvider: args));
      default:
        return MaterialPageRoute(
          builder: (context) => const Text("No Route Found"),
        );
    }
  }
}
