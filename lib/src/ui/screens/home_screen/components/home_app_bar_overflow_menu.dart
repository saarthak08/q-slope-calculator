import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/settings/settings_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

enum HomeOverflowMenuAction {
  toggleTheme,
  bulkSelect,
  importJson,
  importCsv,
  about,
}

class HomeAppBarOverflowMenu extends StatelessWidget {
  final List<QSlope> allQSlopes;
  final Future<void> Function(BuildContext context, bool isJson) onImport;
  final VoidCallback? onBulkSelect;

  const HomeAppBarOverflowMenu({
    super.key,
    required this.allQSlopes,
    required this.onImport,
    this.onBulkSelect,
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

          case HomeOverflowMenuAction.importJson:
            onImport(context, true);
            break;

          case HomeOverflowMenuAction.importCsv:
            onImport(context, false);
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
                    Icon(
                      Icons.checklist_rtl,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).bulkSelect),
                  ],
                ),
              ),
            ],

            const PopupMenuDivider(),

            // Import section
            PopupMenuItem(
              value: HomeOverflowMenuAction.importJson,
              child: Row(
                children: [
                  Icon(Icons.code, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context).importJson),
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeOverflowMenuAction.importCsv,
              child: Row(
                children: [
                  Icon(Icons.grid_on_outlined, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context).importCsv),
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
                  Text(AppLocalizations.of(context).aboutQSlope),
                ],
              ),
            ),
          ],
    );
  }
}
