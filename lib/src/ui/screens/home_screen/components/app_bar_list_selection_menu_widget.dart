import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/full_screen_loader_dialog.dart';
import 'package:q_slope_calculator/src/ui/dialogs/generic_dialog.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/export_excel_file.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarListSelectionMenuWidget extends StatelessWidget {
  final List<bool>? selectedTiles;
  final void Function(List<bool> selectedTiles) setSelectedTiles;
  const AppBarListSelectionMenuWidget(
      {super.key, required this.selectedTiles, required this.setSelectedTiles});

  @override
  Widget build(BuildContext context) {
    bool deselectAll = true;
    for (var value in selectedTiles ?? []) {
      if (!value) {
        deselectAll = false;
        break;
      }
    }

    final qSlopeListState = context.watch<QSlopeListCubit>().state;

    return PopupMenuButton(
        color: primaryColor,
        itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    var qSlopeState = qSlopeListState;
                    if (qSlopeState is QSlopeListLoaded) {
                      if (deselectAll) {
                        setSelectedTiles(
                            List.filled(qSlopeState.qSlopeList.length, false));
                      } else {
                        setSelectedTiles(
                            List.filled(qSlopeState.qSlopeList.length, true));
                      }
                    }
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(deselectAll
                        ? AppLocalizations.of(context).deselectAll
                        : AppLocalizations.of(context).selectAll),
                    SizedBox(
                      width: getViewPortWidth(context) * 0.005,
                    ),
                    Icon(
                      deselectAll ? Icons.deselect : Icons.select_all,
                      color: primaryColor,
                    ),
                  ])),
              PopupMenuItem(
                  onTap: () {
                    showGenericDialog(
                        context: context,
                        titleText: AppLocalizations.of(context).exportFileTitle,
                        label: AppLocalizations.of(context).exportFileContent,
                        onOk: () async {
                          var qSlopeState = qSlopeListState;
                          if (qSlopeState is QSlopeListLoaded) {
                            int index = 0;
                            var qSlopes = List<QSlope>.empty(growable: true);
                            var tiles = selectedTiles;
                            if (tiles != null) {
                              for (var selectedQSlopes in tiles) {
                                if (selectedQSlopes) {
                                  qSlopes.add(qSlopeState.qSlopeList[index]);
                                }
                                index++;
                              }
                              showFullScreenLoader(context);
                              try {
                                String fileName =
                                    await exportExcelFile(qSlopes, context);
                                if (context.mounted) {
                                  toastification.show(
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.success,
                                      title: Text(AppLocalizations.of(context)
                                          .exportSuccessful(fileName)));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              } catch (err) {
                                if (context.mounted) {
                                  toastification.show(
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.error,
                                      title: Text(AppLocalizations.of(context)
                                          .exportFailed));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  rethrow;
                                }
                              }
                            }
                            setSelectedTiles(List.filled(
                                qSlopeState.qSlopeList.length, false));
                          }
                        });
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(AppLocalizations.of(context).export),
                    SizedBox(
                      width: getViewPortWidth(context) * 0.005,
                    ),
                    Icon(
                      Icons.file_upload_outlined,
                      color: primaryColor,
                    ),
                  ])),
              PopupMenuItem(
                  onTap: () async {
                    showGenericDialog(
                        context: context,
                        titleText: AppLocalizations.of(context)
                            .deleteCalculationsModalTitle,
                        label: AppLocalizations.of(context)
                            .deleteCalculationsModalContent,
                        onOk: () async {
                          var qSlopeState = qSlopeListState;
                          if (qSlopeState is QSlopeListLoaded) {
                            int index = 0;
                            var qSlopes = List<String>.empty(growable: true);
                            var tiles = selectedTiles;
                            if (tiles != null) {
                              for (var selectedQSlopes in tiles) {
                                if (selectedQSlopes) {
                                  qSlopes.add(qSlopeState.qSlopeList[index].id);
                                }
                                index++;
                              }
                              showFullScreenLoader(context);
                              try {
                                await context
                                    .read<QSlopeListCubit>()
                                    .deleteMultipleQSlopesFromList(qSlopes);
                                if (context.mounted) {
                                  toastification.show(
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.success,
                                      title: Text(AppLocalizations.of(context)
                                          .deleteCalculationSuccessful));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              } catch (err) {
                                if (context.mounted) {
                                  toastification.show(
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.error,
                                      title: Text(AppLocalizations.of(context)
                                          .errorInDeletingCalculation));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  rethrow;
                                }
                              }
                            }
                          }
                        });
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(AppLocalizations.of(context).delete),
                    SizedBox(
                      width: getViewPortWidth(context) * 0.005,
                    ),
                    const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ])),
            ]);
  }
}
