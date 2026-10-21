import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/full_screen_loader_dialog.dart';
import 'package:q_slope_calculator/src/ui/dialogs/generic_dialog.dart';
import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/q_slope_stability_chart_screen.dart';
import 'package:q_slope_calculator/src/utils/csv_utils.dart';
import 'package:q_slope_calculator/src/utils/excel_utils.dart';
import 'package:q_slope_calculator/src/utils/pdf_report_utils.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

enum SelectionMenuAction {
  toggleSelect,
  exportPdf,
  exportExcel,
  exportCalculations,
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
    final bool isSingleSelection = selectedIds.length == 1;

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
            if (isSingleSelection) ...[
              const PopupMenuDivider(),
              PopupMenuItem(
                value: SelectionMenuAction.exportPdf,
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).exportPdf,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const PopupMenuDivider(),
            PopupMenuItem(
              value: SelectionMenuAction.exportCalculations,
              child: Row(
                children: [
                  Icon(Icons.grid_on_outlined, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).exportCalculations,
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
                      AppLocalizations.of(context).exportExcel,
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
            const PopupMenuDivider(),
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

          case SelectionMenuAction.exportPdf:
            _exportPdf(context);
            break;

          case SelectionMenuAction.exportExcel:
            _exportExcel(context);
            break;

          case SelectionMenuAction.exportCalculations:
            _exportCalculations(context);
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

  void _exportPdf(BuildContext context) async {
    final qSlope = _selectedQSlopes.first;
    showFullScreenLoader(context);
    try {
      final fileName = await PdfReportUtils.exportPdfReport(
        qSlope,
        dialogTitle: AppLocalizations.of(context).selectDirectoryToSaveFile,
      );
      if (context.mounted) {
        Navigator.pop(context); // loader
        if (fileName != null && fileName.isNotEmpty) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 2),
            alignment: Alignment.bottomCenter,
            type: ToastificationType.success,
            title: Text(
              AppLocalizations.of(context).exportPdfSuccessful(fileName),
            ),
          );
          setSelectedIds({});
          onExitSelectionMode?.call();
        }
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context); // loader
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          title: Text(AppLocalizations.of(context).exportPdfFailed),
        );
      }
    }
  }

  void _exportExcel(BuildContext context) {
    showGenericDialog(
      context: context,
      titleText: AppLocalizations.of(context).exportExcel,
      label: AppLocalizations.of(context).exportFileContent,
      onOk: () async {
        Navigator.pop(context); // Dismiss the confirm dialog
        final qSlopes = _selectedQSlopes;
        showFullScreenLoader(context);
        try {
          final fileName = await ExcelUtils.exportExcelFile(
            qSlopes,
            dialogTitle: AppLocalizations.of(context).selectDirectoryToSaveFile,
          );
          if (context.mounted) {
            Navigator.pop(context); // loader
            if (fileName != null && fileName.isNotEmpty) {
              toastification.show(
                autoCloseDuration: const Duration(seconds: 2),
                alignment: Alignment.bottomCenter,
                type: ToastificationType.success,
                title: Text(
                  AppLocalizations.of(context).exportSuccessful(fileName),
                ),
              );
              setSelectedIds({});
              onExitSelectionMode?.call();
            }
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

  void _exportCalculations(BuildContext context) async {
    final qSlopes = _selectedQSlopes;
    showFullScreenLoader(context);
    try {
      final fileName = await CsvUtils.exportCsv(
        qSlopes,
        dialogTitle: AppLocalizations.of(context).selectDirectoryToSaveFile,
      );
      if (context.mounted) {
        Navigator.pop(context); // loader
        if (fileName != null && fileName.isNotEmpty) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 2),
            alignment: Alignment.bottomCenter,
            type: ToastificationType.success,
            title: Text(
              AppLocalizations.of(context).exportSuccessful(fileName),
            ),
          );
          setSelectedIds({});
          onExitSelectionMode?.call();
        }
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
        Navigator.pop(context); // Close the confirm dialog
        final cubit = context.read<QSlopeListCubit>();
        final idsToDelete = selectedIds.toList();
        await cubit.deleteMultipleQSlopesFromList(idsToDelete);
        setSelectedIds({});
        onExitSelectionMode?.call();
      },
    );
  }
}
