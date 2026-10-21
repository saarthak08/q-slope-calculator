import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/settings/settings_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/inverse_calculator_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/kinematic_compass_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/sensitivity_simulator_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/support_guide_screen.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

enum HomeOverflowMenuAction {
  toggleTheme,
  bulkSelect,
  openSensitivitySimulator,
  openInverseCalculator,
  openSupportGuide,
  openKinematicCompass,
  importCalculations,
  loadSampleData,
  about,
}

class HomeAppBarOverflowMenu extends StatelessWidget {
  final List<QSlope> allQSlopes;
  final Future<void> Function(BuildContext context) onImport;
  final VoidCallback? onBulkSelect;
  final VoidCallback? onLoadSampleData;

  const HomeAppBarOverflowMenu({
    super.key,
    required this.allQSlopes,
    required this.onImport,
    this.onBulkSelect,
    this.onLoadSampleData,
  });

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<SettingsCubit>().state.themeMode;
    final isCurrentlyDark =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return PopupMenuButton<HomeOverflowMenuAction>(
      icon: Icon(Icons.more_vert, color: primaryColor),
      tooltip: AppLocalizations.of(context).options,
      onSelected: (action) {
        switch (action) {
          case HomeOverflowMenuAction.toggleTheme:
            context.read<SettingsCubit>().setThemeMode(
              isCurrentlyDark ? ThemeMode.light : ThemeMode.dark,
            );
            break;

          case HomeOverflowMenuAction.bulkSelect:
            onBulkSelect?.call();
            break;

          case HomeOverflowMenuAction.openSensitivitySimulator:
            Navigator.pushNamed(context, SensitivitySimulatorScreen.route);
            break;

          case HomeOverflowMenuAction.openInverseCalculator:
            Navigator.pushNamed(context, InverseCalculatorScreen.route);
            break;

          case HomeOverflowMenuAction.openSupportGuide:
            Navigator.pushNamed(context, SupportGuideScreen.route);
            break;

          case HomeOverflowMenuAction.openKinematicCompass:
            Navigator.pushNamed(context, KinematicCompassScreen.route);
            break;

          case HomeOverflowMenuAction.importCalculations:
            onImport(context);
            break;

          case HomeOverflowMenuAction.loadSampleData:
            onLoadSampleData?.call();
            break;

          case HomeOverflowMenuAction.about:
            Navigator.pushNamed(context, AboutScreen.route);
            break;
        }
      },
      itemBuilder:
          (context) => [
            // Theme toggle
            PopupMenuItem(
              value: HomeOverflowMenuAction.toggleTheme,
              child: Row(
                children: [
                  Icon(
                    isCurrentlyDark ? Icons.light_mode : Icons.dark_mode,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isCurrentlyDark
                        ? AppLocalizations.of(context).lightMode
                        : AppLocalizations.of(context).darkMode,
                  ),
                ],
              ),
            ),

            if (allQSlopes.isNotEmpty) ...[
              PopupMenuItem(
                value: HomeOverflowMenuAction.bulkSelect,
                child: Row(
                  children: [
                    Icon(Icons.checklist_rtl, color: primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).bulkSelect),
                  ],
                ),
              ),
            ],

            const PopupMenuDivider(),

            // Engineering Analysis Tools Section
            PopupMenuItem(
              value: HomeOverflowMenuAction.openSensitivitySimulator,
              child: Row(
                children: [
                  Icon(Icons.tune, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).sensitivitySimulator,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeOverflowMenuAction.openInverseCalculator,
              child: Row(
                children: [
                  Icon(Icons.architecture, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).inverseDesignCalculator,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeOverflowMenuAction.openSupportGuide,
              child: Row(
                children: [
                  Icon(Icons.construction, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).slopeSupportGuide,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeOverflowMenuAction.openKinematicCompass,
              child: Row(
                children: [
                  Icon(Icons.explore_outlined, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).kinematicCompass,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const PopupMenuDivider(),

            // Import calculations (geologist friendly)
            PopupMenuItem(
              value: HomeOverflowMenuAction.importCalculations,
              child: Row(
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).importCalculations,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeOverflowMenuAction.loadSampleData,
              child: Row(
                children: [
                  Icon(Icons.science_outlined, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).loadSampleCalculations,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const PopupMenuDivider(),

            // About section
            PopupMenuItem(
              value: HomeOverflowMenuAction.about,
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).aboutQSlope,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
