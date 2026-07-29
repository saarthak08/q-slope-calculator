import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/home_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/utils/app_router.dart';

void main() {
  group('AppRouter Tests', () {
    late AppRouter appRouter;

    setUp(() {
      appRouter = AppRouter();
    });

    test('generates home route correctly', () {
      final route = appRouter.generateRoute(const RouteSettings(name: '/'));
      expect(route, isA<MaterialPageRoute>());

      final builder = (route as MaterialPageRoute).builder;
      final context = _MockBuildContext();
      expect(builder(context), isA<HomeScreen>());
    });

    test('generates about route correctly', () {
      final route = appRouter.generateRoute(
        const RouteSettings(name: AboutScreen.route),
      );
      expect(route, isA<MaterialPageRoute>());

      final builder = (route as MaterialPageRoute).builder;
      final context = _MockBuildContext();
      expect(builder(context), isA<AboutScreen>());
    });

    test('returns Text for unknown routes', () {
      final route = appRouter.generateRoute(
        const RouteSettings(name: '/unknown'),
      );
      expect(route, isA<MaterialPageRoute>());

      final builder = (route as MaterialPageRoute).builder;
      final context = _MockBuildContext();
      expect(builder(context), isA<Text>());
    });
  });
}

class _MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
