import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/kinematic_compass_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/q_slope_stability_chart_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/csv_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/excel_utils.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/pdf_report_utils.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

class ActiveStressPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const ActiveStressPage({
    super.key,
    required this.qSlope,
    required this.errorTabs,
  });

  @override
  State<ActiveStressPage> createState() => _ActiveStressPageState();
}

class _ActiveStressPageState extends State<ActiveStressPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController srfA = TextEditingController();
  final TextEditingController srfB = TextEditingController();
  final TextEditingController srfC = TextEditingController();
  final TextEditingController srf = TextEditingController();
  final ValueNotifier<double?> _qSlope = ValueNotifier(null);
  final tabIndex = 4;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    final active = qSlope.activeStress;
    if (active != null) {
      srfA.text =
          (active.srfA != null && active.srfA! > 0)
              ? active.srfA!.toString()
              : "";
      srfB.text =
          (active.srfB != null && active.srfB! > 0)
              ? active.srfB!.toString()
              : "";
      srfC.text =
          (active.srfC != null && active.srfC! > 0)
              ? active.srfC!.toString()
              : "";
      srf.text =
          (active.srf != null && active.srf! > 0) ? active.srf!.toString() : "";
    }
    if (srf.text.isNotEmpty &&
        srfA.text.isEmpty &&
        srfB.text.isEmpty &&
        srfC.text.isEmpty) {
      srfA.text = srf.text;
    }
    _qSlope.value = qSlope.qSlope;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculateQSlope();
      }
    });
    super.initState();
  }

  void _calculateQSlope() {
    final parsedA = double.tryParse(srfA.text);
    final parsedB = double.tryParse(srfB.text);
    final parsedC = double.tryParse(srfC.text);

    final bool isAValid =
        parsedA != null && parsedA <= maxSRFa && parsedA >= minSRFa;
    final bool isBValid =
        parsedB != null && parsedB <= maxSRFb && parsedB >= minSRFb;
    final bool isCValid =
        parsedC != null && parsedC <= maxSRFc && parsedC >= minSRFc;

    if (isAValid || isBValid || isCValid) {
      QSlope qSlope = widget.qSlope.value;
      qSlope.activeStress ??= ActiveStress();
      qSlope.activeStress?.srfA = isAValid ? parsedA : null;
      qSlope.activeStress?.srfB = isBValid ? parsedB : null;
      qSlope.activeStress?.srfC = isCValid ? parsedC : null;
      final List<double> validSrfs = [
        if (isAValid) parsedA,
        if (isBValid) parsedB,
        if (isCValid) parsedC,
      ];
      final double calculatedMaxSrf =
          validSrfs.isNotEmpty ? validSrfs.reduce(max) : 1.0;
      srf.text = calculatedMaxSrf.toStringAsFixed(4);
      widget.errorTabs.value[tabIndex] = false;
      widget.errorTabs.value = List.from(widget.errorTabs.value);
      qSlope.activeStress?.srf = calculatedMaxSrf;
      if (qSlope.activeStress != null &&
          qSlope.jointCharacter != null &&
          qSlope.externalFactors != null &&
          qSlope.blockSize != null &&
          qSlope.oFactor != null &&
          widget.errorTabs.value.firstWhereOrNull((value) => value) == null) {
        qSlope.qSlope = calculateQSlope(qSlope);
        _qSlope.value = qSlope.qSlope;
        widget.qSlope.value = qSlope.copyWith();
      } else {
        widget.errorTabs.value[tabIndex] = true;
        widget.errorTabs.value = List.from(widget.errorTabs.value);
      }
    } else {
      widget.errorTabs.value[tabIndex] = true;
      widget.errorTabs.value = List.from(widget.errorTabs.value);
    }
  }

  Future<void> _handleExport(BuildContext context, String format) async {
    QSlope qSlope = widget.qSlope.value;
    if (qSlope.activeStress != null &&
        qSlope.jointCharacter != null &&
        qSlope.externalFactors != null &&
        qSlope.blockSize != null &&
        qSlope.oFactor != null &&
        widget.errorTabs.value.firstWhereOrNull((value) => value) == null) {
      qSlope.createdAt = DateTime.now();
      widget.qSlope.value = qSlope.copyWith();
      try {
        String? fileName;
        final dialogTitle =
            AppLocalizations.of(context).selectDirectoryToSaveFile;
        if (format == 'excel') {
          fileName = await ExcelUtils.exportExcelFile(
            List.from([qSlope]),
            dialogTitle: dialogTitle,
          );
        } else if (format == 'pdf') {
          fileName = await PdfReportUtils.exportPdfReport(
            qSlope,
            dialogTitle: dialogTitle,
          );
        } else {
          fileName = await CsvUtils.exportCsv(
            List.from([qSlope]),
            dialogTitle: dialogTitle,
          );
        }

        if (fileName == null || fileName.isEmpty) {
          // User cancelled file save dialog
          return;
        }

        if (context.mounted) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 2),
            alignment: Alignment.bottomCenter,
            type: ToastificationType.success,
            title: Text(
              AppLocalizations.of(context).exportSuccessful(fileName),
            ),
          );
        }
      } catch (err) {
        if (context.mounted) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 2),
            alignment: Alignment.bottomCenter,
            type: ToastificationType.error,
            title: Text(AppLocalizations.of(context).exportFailed),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getViewPortWidth(context) * 0.04,
            vertical: getViewPortHeight(context) * 0.02,
          ),
          child: Form(
            key: formKey,
            onChanged: () {
              formKey.currentState?.validate();
              if (_qSlope.value == null) {
                widget.errorTabs.value[tabIndex] = true;
              }
              widget.errorTabs.value = List.from(widget.errorTabs.value);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getViewPortHeight(context) * 0.02,
                      bottom: getViewPortHeight(context) * 0.03,
                    ),
                    child: Text(
                      AppLocalizations.of(context).activeStress,
                      style: GoogleFonts.poppins(
                        fontSize: getSubtitleLargeFontSize(context),
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                CustomTextFormField(
                  type: const TextInputType.numberWithOptions(signed: false),
                  textInputAction: TextInputAction.done,
                  textEditingController: srfA,
                  titleText: AppLocalizations.of(context).srfAInputTitle,
                  validate: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        ((double.tryParse(value) ?? 0) < minSRFa ||
                            (double.tryParse(value) ?? 0) > maxSRFa)) {
                      return AppLocalizations.of(context).srfAInputConstraints;
                    }
                    return null;
                  },
                  onChanged: (_) {
                    _calculateQSlope();
                  },
                ),
                SizedBox(height: getViewPortHeight(context) * 0.02),
                CustomTextFormField(
                  type: const TextInputType.numberWithOptions(signed: false),
                  textInputAction: TextInputAction.done,
                  textEditingController: srfB,
                  titleText: AppLocalizations.of(context).srfBInputTitle,
                  validate: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        ((double.tryParse(value) ?? 0) < minSRFb ||
                            (double.tryParse(value) ?? 0) > maxSRFb)) {
                      return AppLocalizations.of(context).srfBInputConstraints;
                    }
                    return null;
                  },
                  onChanged: (_) {
                    _calculateQSlope();
                  },
                ),
                SizedBox(height: getViewPortHeight(context) * 0.02),
                CustomTextFormField(
                  type: const TextInputType.numberWithOptions(signed: false),
                  textInputAction: TextInputAction.done,
                  textEditingController: srfC,
                  titleText: AppLocalizations.of(context).srfCInputTitle,
                  validate: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        ((double.tryParse(value) ?? 0) < minSRFc ||
                            (double.tryParse(value) ?? 0) > maxSRFc)) {
                      return AppLocalizations.of(context).srfCInputConstraints;
                    }
                    return null;
                  },
                  onChanged: (_) {
                    _calculateQSlope();
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _qSlope,
                  builder:
                      (context, qSlope, child) =>
                          qSlope != null
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.04,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context).stressReductionFactorSymbol} = ${AppLocalizations.of(context).maxOf} (${AppLocalizations.of(context).srfA}, ${AppLocalizations.of(context).srfB}, ${AppLocalizations.of(context).srfC})",
                                    style: GoogleFonts.montserrat(
                                      fontFeatures: [],
                                      fontWeight: FontWeight.w600,
                                      fontSize: getSubTitleFontSize(context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.02,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context).stressReductionFactor} = ${srf.text}",
                                    style: GoogleFonts.montserrat(
                                      fontFeatures: [],
                                      fontWeight: FontWeight.w600,
                                      fontSize: getSubTitleFontSize(context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.03,
                                  ),
                                  const Divider(),
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.03,
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            getViewPortHeight(context) * 0.03,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).qSlopeCalculation,
                                        style: GoogleFonts.poppins(
                                          fontSize: getSubtitleLargeFontSize(
                                            context,
                                          ),
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context).qSlopeSymbol} = (${AppLocalizations.of(context).rockQualityDesignationSymbol} / ${AppLocalizations.of(context).jointSetNumberSymbol}) x (${AppLocalizations.of(context).jointRoughnessSymbol} / ${AppLocalizations.of(context).jointAlterationSymbol}) x (${AppLocalizations.of(context).oFactor}) x (${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} / ${AppLocalizations.of(context).stressReductionFactorSymbol})",
                                    style: GoogleFonts.montserrat(
                                      fontFeatures: [],
                                      fontWeight: FontWeight.w600,
                                      fontSize: getSubTitleFontSize(context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.02,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context).qSlopeSymbol} = ${qSlope.toStringAsFixed(4)}",
                                    style: GoogleFonts.montserrat(
                                      fontFeatures: [],
                                      fontWeight: FontWeight.w600,
                                      fontSize: getSubTitleFontSize(context),
                                    ),
                                  ),
                                ],
                              )
                              : Container(),
                ),
                SizedBox(height: getViewPortHeight(context) * 0.04),
                ValueListenableBuilder(
                  valueListenable: _qSlope,
                  builder:
                      (context, value, child) => Column(
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  value != null
                                      ? () {
                                        QSlope qSlope = widget.qSlope.value;
                                        if (qSlope.activeStress != null &&
                                            qSlope.jointCharacter != null &&
                                            qSlope.externalFactors != null &&
                                            qSlope.blockSize != null &&
                                            qSlope.oFactor != null &&
                                            widget.errorTabs.value
                                                    .firstWhereOrNull(
                                                      (value) => value,
                                                    ) ==
                                                null) {
                                          qSlope.createdAt = DateTime.now();
                                          widget.qSlope.value =
                                              qSlope.copyWith();
                                          context
                                              .read<QSlopeListCubit>()
                                              .saveQSlopeToList(qSlope)
                                              .then((result) {
                                                if (result.isSuccess &&
                                                    context.mounted) {
                                                  toastification.show(
                                                    autoCloseDuration:
                                                        const Duration(
                                                          seconds: 2,
                                                        ),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    type:
                                                        ToastificationType
                                                            .success,
                                                    title: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      ).saveCalculationSuccessful,
                                                    ),
                                                  );
                                                } else {
                                                  if (result.error
                                                          is QSlopeError &&
                                                      context.mounted) {
                                                    toastification.show(
                                                      autoCloseDuration:
                                                          const Duration(
                                                            seconds: 2,
                                                          ),
                                                      alignment:
                                                          Alignment
                                                              .bottomCenter,
                                                      type:
                                                          ToastificationType
                                                              .error,
                                                      title: Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        ).errorInSavingCalculation,
                                                      ),
                                                    );
                                                  }
                                                }
                                              });
                                        }
                                      }
                                      : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? WidgetStatePropertyAll(
                                          Colors.grey.shade800,
                                        )
                                        : null,
                                foregroundColor:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? WidgetStatePropertyAll(primaryColor)
                                        : null,
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                fixedSize: WidgetStatePropertyAll(
                                  Size(
                                    getViewPortWidth(context) * 0.8,
                                    getViewPortHeight(context) * 0.05,
                                  ),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(AppLocalizations.of(context).save),
                              ),
                            ),
                          ),
                          SizedBox(height: getViewPortHeight(context) * 0.01),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: PopupMenuButton<String>(
                                    enabled: value != null,
                                    tooltip:
                                        AppLocalizations.of(context).export,
                                    onSelected:
                                        (format) =>
                                            _handleExport(context, format),
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value: 'pdf',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).exportPdf,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'excel',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.table_chart_outlined,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).exportExcel,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'csv',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.grid_on_outlined,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    ).exportCalculations,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                    child: Container(
                                      height: getViewPortHeight(context) * 0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            value != null
                                                ? (Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey.shade800
                                                    : primaryColor)
                                                : Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_download_outlined,
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? primaryColor
                                                      : Colors.white,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              ).export,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? primaryColor
                                                        : Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? primaryColor
                                                      : Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        value != null
                                            ? () {
                                              Navigator.pushNamed(
                                                context,
                                                QSlopeStabilityChartScreen
                                                    .route,
                                                arguments:
                                                    QSlopeStabilityChartScreenArguments(
                                                      qSlopeValues:
                                                          List<double>.from([
                                                            value,
                                                          ]),
                                                      slopeAnglesByUser: List<
                                                        double?
                                                      >.from([
                                                        widget
                                                            .qSlope
                                                            .value
                                                            .slopeAngleByUser,
                                                      ]),
                                                    ),
                                              );
                                            }
                                            : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? WidgetStatePropertyAll(
                                                Colors.grey.shade800,
                                              )
                                              : null,
                                      foregroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? WidgetStatePropertyAll(
                                                primaryColor,
                                              )
                                              : null,
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      fixedSize: WidgetStatePropertyAll(
                                        Size.fromHeight(
                                          getViewPortHeight(context) * 0.05,
                                        ),
                                      ),
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "${AppLocalizations.of(context).qSlopeSymbol}\n ${AppLocalizations.of(context).stabilityChart}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (value != null) ...[
                            SizedBox(height: getViewPortHeight(context) * 0.02),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ActionChip(
                                  avatar: Icon(
                                    Icons.explore_outlined,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  label: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).kinematicCompass,
                                    style: const TextStyle(fontSize: 12.5),
                                  ),
                                  onPressed: () {
                                    final o = widget.qSlope.value.oFactor;
                                    Navigator.pushNamed(
                                      context,
                                      KinematicCompassScreen.route,
                                      arguments:
                                          KinematicCompassScreenArguments(
                                            slopeDip: o?.betaS ?? 65.0,
                                            slopeDipDirection:
                                                o?.alphaS ?? 120.0,
                                            joint1Dip: o?.betaJ ?? 45.0,
                                            joint1DipDirection:
                                                o?.alphaJ ?? 110.0,
                                            joint2Dip: o?.betaI,
                                            joint2DipDirection: o?.alphaI,
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: getViewPortHeight(context) * 0.08),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    srf.dispose();
    srfA.dispose();
    srfB.dispose();
    srfC.dispose();
    _qSlope.dispose();
    super.dispose();
  }
}
