import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:toastification/toastification.dart';

class ActiveStressPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const ActiveStressPage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<ActiveStressPage> createState() => _ActiveStressPageState();
}

class _ActiveStressPageState extends State<ActiveStressPage>
    with AutomaticKeepAliveClientMixin {
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
    srfA.text = qSlope.activeStress?.srfA.toString() ?? "";
    srfB.text = qSlope.activeStress?.srfB.toString() ?? "";
    srfC.text = qSlope.activeStress?.srfC.toString() ?? "";
    srf.text = qSlope.activeStress?.srf.toString() ?? "";
    _qSlope.value = qSlope.qSlope;
    super.initState();
  }

  void _calculateQSlope() {
    if ((srfA.text.isNotEmpty &&
            (double.tryParse(srfA.text) ?? 0) <= maxSRFa &&
            (double.tryParse(srfA.text) ?? 0) >= minSRFa) ||
        (srfB.text.isNotEmpty &&
            (double.tryParse(srfB.text) ?? 0) <= maxSRFb &&
            (double.tryParse(srfB.text) ?? 0) >= minSRFb) ||
        (srfC.text.isNotEmpty &&
            (double.tryParse(srfC.text) ?? 0) <= maxSRFc &&
            (double.tryParse(srfC.text) ?? 0) >= minSRFc)) {
      QSlope qSlope = widget.qSlope.value;
      qSlope.activeStress = ActiveStress();
      qSlope.activeStress?.srfA = double.tryParse(srfA.text) ?? 0;
      qSlope.activeStress?.srfB = double.tryParse(srfB.text) ?? 0;
      qSlope.activeStress?.srfC = double.tryParse(srfC.text) ?? 0;
      double preMax = max<double>(
          qSlope.activeStress?.srfA ?? 0, qSlope.activeStress?.srfB ?? 0);
      srf.text = max<double>(preMax, qSlope.activeStress?.srfC ?? 0)
          .toStringAsFixed(4);
      widget.errorTabs.value[tabIndex] = false;
      widget.errorTabs.value = List.from(widget.errorTabs.value);
      qSlope.activeStress?.srf = double.tryParse(srf.text) ?? 1;
      if (qSlope.activeStress != null &&
          qSlope.jointCharacter != null &&
          qSlope.externalFactors != null &&
          qSlope.blockSize != null &&
          qSlope.oFactor != null &&
          widget.errorTabs.value.firstWhereOrNull((value) => value) == null) {
        qSlope.qSlope = calculateQSlope(qSlope);
        _qSlope.value = qSlope.qSlope;
        widget.qSlope.value = qSlope.copyWith();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getViewPortWidth(context) * 0.04,
                    vertical: getViewPortHeight(context) * 0.02),
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
                                  bottom: getViewPortHeight(context) * 0.03),
                              child: Text(
                                AppLocalizations.of(context).activeStress,
                                style: GoogleFonts.poppins(
                                    fontSize: getSubtitleLargeFontSize(context),
                                    color: Colors.teal),
                              ))),
                      CustomTextFormField(
                        type: const TextInputType.numberWithOptions(
                            signed: false),
                        textInputAction: TextInputAction.done,
                        textEditingController: srfA,
                        titleText: AppLocalizations.of(context).srfA,
                        validate: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              ((double.tryParse(value) ?? 0) < minSRFa ||
                                  (double.tryParse(value) ?? 0) > maxSRFa)) {
                            return AppLocalizations.of(context)
                                .srfAInputConstraints;
                          }
                          return null;
                        },
                        onChanged: (_) {
                          _calculateQSlope();
                        },
                      ),
                      SizedBox(
                        height: getViewPortHeight(context) * 0.02,
                      ),
                      CustomTextFormField(
                        type: const TextInputType.numberWithOptions(
                            signed: false),
                        textInputAction: TextInputAction.done,
                        textEditingController: srfB,
                        titleText: AppLocalizations.of(context).srfB,
                        validate: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              ((double.tryParse(value) ?? 0) < minSRFb ||
                                  (double.tryParse(value) ?? 0) > maxSRFb)) {
                            return AppLocalizations.of(context)
                                .srfBInputConstraints;
                          }
                          return null;
                        },
                        onChanged: (_) {
                          _calculateQSlope();
                        },
                      ),
                      SizedBox(
                        height: getViewPortHeight(context) * 0.02,
                      ),
                      CustomTextFormField(
                        type: const TextInputType.numberWithOptions(
                            signed: false),
                        textInputAction: TextInputAction.done,
                        textEditingController: srfC,
                        titleText: AppLocalizations.of(context).srfC,
                        validate: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              ((double.tryParse(value) ?? 0) < minSRFc ||
                                  (double.tryParse(value) ?? 0) > maxSRFc)) {
                            return AppLocalizations.of(context)
                                .srfCInputConstraints;
                          }
                          return null;
                        },
                        onChanged: (_) {
                          _calculateQSlope();
                        },
                      ),
                      ValueListenableBuilder(
                          valueListenable: _qSlope,
                          builder: (context, qSlope, child) => qSlope != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.04,
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context).stressReductionFactorSymbol} = ${AppLocalizations.of(context).maxOf} (${AppLocalizations.of(context).srfA}, ${AppLocalizations.of(context).srfB}, ${AppLocalizations.of(context).srfC})",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getSubTitleFontSize(context)),
                                      ),
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.02,
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context).stressReductionFactor} = ${srf.text}",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getSubTitleFontSize(context)),
                                      ),
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.03,
                                      ),
                                      const Divider(),
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.03,
                                      ),
                                      Center(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: getViewPortHeight(
                                                          context) *
                                                      0.03),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .qSlopeCalculation,
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        getSubtitleLargeFontSize(
                                                            context),
                                                    color: Colors.teal),
                                              ))),
                                      Text(
                                        "${AppLocalizations.of(context).qSlopeSymbol} = (${AppLocalizations.of(context).rockQualityDesignationSymbol} / ${AppLocalizations.of(context).numberOfJointsSymbol}) x (${AppLocalizations.of(context).jointRoughnessSymbol} / ${AppLocalizations.of(context).jointAlterationSymbol}) x (${AppLocalizations.of(context).oFactor}) x (${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} / ${AppLocalizations.of(context).stressReductionFactorSymbol})",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getSubTitleFontSize(context)),
                                      ),
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.02,
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context).qSlopeSymbol} = ${qSlope.toStringAsFixed(4)}",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getSubTitleFontSize(context)),
                                      )
                                    ])
                              : Container()),
                      SizedBox(
                        height: getViewPortHeight(context) * 0.1,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _qSlope,
                          builder: (context, value, child) => Center(
                                  child: ElevatedButton(
                                onPressed: value != null
                                    ? () {
                                        QSlope qSlope = widget.qSlope.value;
                                        if (qSlope.activeStress != null &&
                                            qSlope.jointCharacter != null &&
                                            qSlope.externalFactors != null &&
                                            qSlope.blockSize != null &&
                                            qSlope.oFactor != null &&
                                            widget.errorTabs.value
                                                    .firstWhereOrNull(
                                                        (value) => value) ==
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
                                                          seconds: 2),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  type: ToastificationType
                                                      .success,
                                                  title: Text(AppLocalizations
                                                          .of(context)
                                                      .saveCalculationSuccessful));
                                            } else {
                                              if (result.error is QSlopeError &&
                                                  context.mounted) {
                                                toastification.show(
                                                    autoCloseDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    type: ToastificationType
                                                        .error,
                                                    title: Text(AppLocalizations
                                                            .of(context)
                                                        .errorInSavingCalculation));
                                              }
                                            }
                                          });
                                        }
                                      }
                                    : null,
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    fixedSize: WidgetStatePropertyAll(Size(
                                        getViewPortWidth(context) * 0.35,
                                        getViewPortHeight(context) * 0.05))),
                                child: Text(
                                  AppLocalizations.of(context).save,
                                ),
                              ))),
                    ],
                  ),
                ))));
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

  @override
  bool get wantKeepAlive => true;
}
