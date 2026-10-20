import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/full_screen_loader_dialog.dart';
import 'package:q_slope_calculator/src/ui/dialogs/generic_dialog.dart';
import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/q_slope_stability_chart_screen.dart';
import 'package:q_slope_calculator/src/utils/csv_service.dart';
import 'package:q_slope_calculator/src/utils/export_excel_file.dart';
import 'package:q_slope_calculator/src/utils/json_backup_service.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

enum SelectionMenuAction {
  toggleSelect,
  exportExcel,
  exportJson,
  exportCsv,
  chart,
  delete,
}

class AppBarListSelectionMenuWidget extends StatelessWidget {
  final Set<String> selectedIds;
  final List<QSlope> currentList;
  final void Function(Set<String> selectedIds) setSelectedIds;
  final VoidCallback? onExitSelectionMode;

  const AppBarListSelectionMenuWidget({
    super.key,
    required this.selectedIds,
    required this.currentList,
    required this.setSelectedIds,
    this.onExitSelectionMode,
  });

  List<QSlope> get _selectedQSlopes {
    return currentList.where((item) => selectedIds.contains(item.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool deselectAll =
        currentList.isNotEmpty &&
        currentList.every((item) => selectedIds.contains(item.id));

    return PopupMenuButton<SelectionMenuAction>(
      iconColor: primaryColor,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: SelectionMenuAction.toggleSelect,
              child: Row(
                children: [
                  Icon(
                    deselectAll ? Icons.deselect : Icons.select_all,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      deselectAll
                          ? AppLocalizations.of(context).deselectAll
                          : AppLocalizations.of(context).selectAll,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SelectionMenuAction.exportExcel,
              child: Row(
                children: [
                  Icon(Icons.table_chart_outlined, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).exportFileTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SelectionMenuAction.exportJson,
              child: Row(
                children: [
                  Icon(Icons.code, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).exportJson,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SelectionMenuAction.exportCsv,
              child: Row(
                children: [
                  Icon(Icons.grid_on_outlined, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).exportCsv,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SelectionMenuAction.chart,
              child: Row(
                children: [
                  Icon(Icons.area_chart, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).qSlopeStabilityChart,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SelectionMenuAction.delete,
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).delete,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
      onSelected: (value) async {
        switch (value) {
          case SelectionMenuAction.toggleSelect:
            if (deselectAll) {
              setSelectedIds({});
            } else {
              setSelectedIds(currentList.map((e) => e.id).toSet());
            }
            break;

          case SelectionMenuAction.exportExcel:
            _exportExcel(context);
            break;

          case SelectionMenuAction.exportJson:
            _exportJson(context);
            break;

          case SelectionMenuAction.exportCsv:
            _exportCsv(context);
            break;

          case SelectionMenuAction.chart:
            final selected = _selectedQSlopes;
            final qSlopes =
                selected
                    .where((q) => q.qSlope != null)
                    .map((q) => q.qSlope!)
                    .toList();
            final slopeAngles =
                selected.map((q) => q.slopeAngleByUser).toList();

            Navigator.pushNamed(
              context,
              QSlopeStabilityChartScreen.route,
              arguments: QSlopeStabilityChartScreenArguments(
                qSlopeValues: qSlopes,
                slopeAnglesByUser: slopeAngles,
              ),
            );
            break;

          case SelectionMenuAction.delete:
            _confirmDelete(context);
            break;
        }
      },
    );
  }

  void _exportExcel(BuildContext context) {
    showGenericDialog(
      context: context,
      titleText: AppLocalizations.of(context).exportFileTitle,
      label: AppLocalizations.of(context).exportFileContent,
      onOk: () async {
        Navigator.pop(context); // Dismiss the confirm dialog
        final qSlopes = _selectedQSlopes;
        showFullScreenLoader(context);
        try {
          final fileName = await exportExcelFile(qSlopes, context);
          if (context.mounted) {
            Navigator.pop(context); // loader
            toastification.show(
              autoCloseDuration: const Duration(seconds: 2),
              alignment: Alignment.bottomCenter,
              type: ToastificationType.success,
              title: Text(AppLocalizations.of(context).exportSuccessful(fileName)),
            );
            setSelectedIds({});
            onExitSelectionMode?.call();
          }
        } catch (err) {
          if (context.mounted) {
            Navigator.pop(context); // loader
            toastification.show(
              autoCloseDuration: const Duration(seconds: 2),
              alignment: Alignment.bottomCenter,
              type: ToastificationType.error,
              title: Text(AppLocalizations.of(context).exportFailed),
            );
          }
        }
      },
    );
  }

  void _exportJson(BuildContext context) async {
    final qSlopes = _selectedQSlopes;
    showFullScreenLoader(context);
    try {
      final fileName = await JsonBackupService.exportJson(qSlopes, context);
      if (context.mounted) {
        Navigator.pop(context); // loader
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.success,
          title: Text(AppLocalizations.of(context).exportSuccessful(fileName)),
        );
        setSelectedIds({});
        onExitSelectionMode?.call();
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context); // loader
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          title: Text(AppLocalizations.of(context).exportFailed),
        );
      }
    }
  }

  void _exportCsv(BuildContext context) async {
    final qSlopes = _selectedQSlopes;
    showFullScreenLoader(context);
    try {
      final fileName = await CsvService.exportCsv(qSlopes, context);
      if (context.mounted) {
        Navigator.pop(context); // loader
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.success,
          title: Text(AppLocalizations.of(context).exportSuccessful(fileName)),
        );
        setSelectedIds({});
        onExitSelectionMode?.call();
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context); // loader
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          title: Text(AppLocalizations.of(context).exportFailed),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showGenericDialog(
      context: context,
      titleText: AppLocalizations.of(context).deleteCalculationsModalTitle,
      label: AppLocalizations.of(context).deleteCalculationsModalContent,
      onOk: () async {
        Navigator.pop(context); // Dismiss the confirm dialog
        final ids = selectedIds.toList();
        showFullScreenLoader(context);
        try {
          await context.read<QSlopeListCubit>().deleteMultipleQSlopesFromList(ids);
          if (context.mounted) {
            Navigator.pop(context); // loader
            toastification.show(
              autoCloseDuration: const Duration(seconds: 2),
              alignment: Alignment.bottomCenter,
              type: ToastificationType.success,
              title: Text(AppLocalizations.of(context).deleteCalculationSuccessful),
            );
            setSelectedIds({});
            onExitSelectionMode?.call();
          }
        } catch (err) {
          if (context.mounted) {
            Navigator.pop(context); // loader
            toastification.show(
              autoCloseDuration: const Duration(seconds: 2),
              alignment: Alignment.bottomCenter,
              type: ToastificationType.error,
              title: Text(AppLocalizations.of(context).errorInDeletingCalculation),
            );
          }
        }
      },
    );
  }
}
