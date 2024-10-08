import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/utils/app_config.dart';
import 'package:q_slope_calculator/src/utils/app_router.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  App({super.key});
  final AppRouter _appRouter = AppRouter();
  final QSlopeListCubit _qSlopeListCubit = QSlopeListCubit();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => _qSlopeListCubit)],
        child: ToastificationWrapper(
            child: MaterialApp(
                title: AppConfig.of(context).appTitle,
                builder: (context, child) => ResponsiveBreakpoints.builder(
                      child: child!,
                      breakpoints: [
                        const Breakpoint(start: 0, end: 450, name: MOBILE),
                        const Breakpoint(start: 451, end: 800, name: TABLET),
                        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                        const Breakpoint(
                            start: 1921, end: double.infinity, name: '4K'),
                      ],
                    ),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                onGenerateRoute: _appRouter.generateRoute,
                theme: getThemeData(context))));
  }
}
