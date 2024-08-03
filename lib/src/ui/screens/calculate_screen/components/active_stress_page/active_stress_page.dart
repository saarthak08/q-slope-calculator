import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/next_previous_buttons.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class ActiveStressPage extends StatefulWidget {
  final ValueNotifier<QSlope?> qSlope;
  final PageController pageController;
  final int maxPageValue;
  final ValueNotifier<int> currentPage;

  const ActiveStressPage(
      {super.key,
      required this.qSlope,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue});

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

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    if (qSlope != null) {
      srfA.text = qSlope.activeStress?.srfA.toString() ?? "";
      srfB.text = qSlope.activeStress?.srfB.toString() ?? "";
      srfC.text = qSlope.activeStress?.srfC.toString() ?? "";
      srf.text = qSlope.activeStress?.srf.toString() ?? "";
    }
    super.initState();
  }

  void _calculateQSlope() {
    if (srfA.text.isNotEmpty || srfB.text.isNotEmpty || srfC.text.isNotEmpty) {
      QSlope? qSlope = widget.qSlope.value;
      if (qSlope != null) {
        qSlope.activeStress = ActiveStress();
        qSlope.activeStress?.srfA = double.tryParse(srfA.text) ?? 0;
        qSlope.activeStress?.srfB = double.tryParse(srfB.text) ?? 0;
        qSlope.activeStress?.srfC = double.tryParse(srfC.text) ?? 0;
        double preMax = max<double>(
            qSlope.activeStress?.srfA ?? 0, qSlope.activeStress?.srfB ?? 0);
        srf.text = max<double>(preMax, qSlope.activeStress?.srfC ?? 0)
            .toStringAsFixed(2);
        qSlope.activeStress?.srf = double.tryParse(srf.text) ?? 1;
        qSlope.qSlope = calculateQSlope(qSlope);
        _qSlope.value = qSlope.qSlope;
        qSlope.createdAt = DateTime.now();
        widget.qSlope.value = qSlope.copyWith();
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
                    vertical: getViewPortHeight(context) * 0.02),
                child: Form(
                  key: formKey,
                  onChanged: () {
                    formKey.currentState?.validate();
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
                                    fontSize: getViewPortHeight(context) * 0.02,
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
                                                getViewPortHeight(context) *
                                                    0.019),
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
                                                getViewPortHeight(context) *
                                                    0.019),
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
                                                    fontSize: getViewPortHeight(
                                                            context) *
                                                        0.02,
                                                    color: Colors.teal),
                                              ))),
                                      Text(
                                        "${AppLocalizations.of(context).qSlopeSymbol} = (${AppLocalizations.of(context).rockQualityDesignationSymbol} / ${AppLocalizations.of(context).numberOfJointsSymbol}) x (${AppLocalizations.of(context).jointRoughnessSymbol} / ${AppLocalizations.of(context).jointAlterationSymbol}) x (${AppLocalizations.of(context).oFactor}) x (${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} / ${AppLocalizations.of(context).stressReductionFactorSymbol})",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getViewPortHeight(context) *
                                                    0.019),
                                      ),
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.02,
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context).qSlopeSymbol} = ${qSlope.toStringAsFixed(2)}",
                                        style: GoogleFonts.montserrat(
                                            fontFeatures: [],
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                getViewPortHeight(context) *
                                                    0.019),
                                      )
                                    ])
                              : Container()),
                      SizedBox(
                        height: getViewPortHeight(context) * 0.02,
                      ),
                      ValueListenableBuilder(
                          valueListenable: srf,
                          builder: (context, srf, child) => NextPreviousButtons(
                                pageController: widget.pageController,
                                currentPage: widget.currentPage,
                                maxPageValue: widget.maxPageValue,
                                isNextButtonEnabled: false,
                                onNext: null,
                              ))
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
}
