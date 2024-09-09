import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/o_factor_rating_widget.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class OFactorRomanaAdjustmentFactorWidget extends StatefulWidget {
  final OFactorTypeOfFailure? oFactorTypeOfFailure;
  final TextEditingController alphaI;
  final TextEditingController alphaJ;
  final TextEditingController alphaS;
  final TextEditingController betaI;
  final TextEditingController betaJ;
  final TextEditingController betaS;
  final TextEditingController f1;
  final TextEditingController f2;
  final TextEditingController f3;
  final TextEditingController oFactor;
  final TextEditingController ratingForF1;
  final TextEditingController ratingForF2;
  final TextEditingController ratingForF3;
  final ValueNotifier<OFactorRomanaValueType?> oFactorRomanaValueType;
  final void Function() setQSlope;

  const OFactorRomanaAdjustmentFactorWidget(
      {super.key,
      required this.oFactorTypeOfFailure,
      required this.alphaI,
      required this.alphaJ,
      required this.alphaS,
      required this.betaI,
      required this.betaJ,
      required this.betaS,
      required this.f1,
      required this.f2,
      required this.f3,
      required this.oFactor,
      required this.setQSlope,
      required this.ratingForF1,
      required this.ratingForF2,
      required this.ratingForF3,
      required this.oFactorRomanaValueType});

  @override
  State<OFactorRomanaAdjustmentFactorWidget> createState() =>
      _OFactorRomanaAdjustmentFactorWidgetState();
}

class _OFactorRomanaAdjustmentFactorWidgetState
    extends State<OFactorRomanaAdjustmentFactorWidget> {
  void _calculateOFactor() {
    if (widget.oFactorTypeOfFailure != null) {
      double alphaI = double.tryParse(widget.alphaI.text) ?? 0;
      double alphaJ = double.tryParse(widget.alphaJ.text) ?? 0;
      double alphaS = double.tryParse(widget.alphaS.text) ?? 0;
      if (alphaI >= 360) {
        alphaI = 360 - alphaI;
        widget.alphaI.text = alphaI.toString();
      }
      if (alphaJ >= 360) {
        alphaJ = 360 - alphaJ;
        widget.alphaJ.text = alphaJ.toString();
      }
      if (alphaS >= 360) {
        alphaS = 360 - alphaS;
        widget.alphaS.text = alphaS.toString();
      }
      double betaI = double.tryParse(widget.betaI.text) ?? 0;
      double betaJ = double.tryParse(widget.betaJ.text) ?? 0;
      double betaS = double.tryParse(widget.betaS.text) ?? 0;
      if (widget.oFactorTypeOfFailure == OFactorTypeOfFailure.planar) {
        if (widget.alphaJ.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            widget.betaJ.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          double f1 = calculateF1ForPlanarFailure(alphaJ, alphaS);
          if (f1 >= 360) {
            f1 = 360 - f1;
          }
          double f2 = betaJ;
          double f3 = calculateF3ForPlanarFailure(betaJ, betaS);
          widget.f1.text = f1.toStringAsFixed(4);
          widget.f2.text = f2.toStringAsFixed(4);
          widget.f3.text = f3.toStringAsFixed(4);
          widget.ratingForF1.text = calculateRatingForF1(f1).toStringAsFixed(4);
          widget.ratingForF2.text = calculateRatingForF2(f2).toStringAsFixed(4);
          widget.ratingForF3.text =
              calculateRatingForF3NonTopplingFailure(f3).toStringAsFixed(4);
        }
      }
      if (widget.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge) {
        if (widget.alphaI.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            widget.betaI.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          double f1 = calculateF1ForWedgeFailure(alphaI, alphaS);
          double f2 = betaI;
          double f3 = calculateF3ForWedgeFailure(betaI, betaS);
          widget.f1.text = f1.toStringAsFixed(4);
          widget.f2.text = f2.toStringAsFixed(4);
          widget.f3.text = f3.toStringAsFixed(4);
          widget.ratingForF1.text = calculateRatingForF1(f1).toStringAsFixed(4);
          widget.ratingForF2.text = calculateRatingForF2(f2).toStringAsFixed(4);
          widget.ratingForF3.text =
              calculateRatingForF3NonTopplingFailure(f3).toStringAsFixed(4);
        }
      }
      if (widget.oFactorTypeOfFailure == OFactorTypeOfFailure.toppling) {
        if (widget.alphaJ.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            widget.betaJ.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          double f1 = calculateF1ForTopplingFailure(alphaJ, alphaS);
          double f2 = 1;
          double f3 = calculateF3ForTopplingFailure(betaJ, betaS);
          widget.f1.text = f1.toStringAsFixed(4);
          widget.f2.text = f2.toStringAsFixed(4);
          widget.f3.text = f3.toStringAsFixed(4);
          widget.ratingForF1.text = calculateRatingForF1(f1).toStringAsFixed(4);
          widget.ratingForF2.text = "1";
          widget.ratingForF3.text =
              calculateRatingForF3TopplingFailure(f3).toStringAsFixed(4);
        }
      }
      if (widget.ratingForF1.text.isNotEmpty &&
          widget.ratingForF2.text.isNotEmpty &&
          widget.ratingForF3.text.isNotEmpty) {
        widget.oFactor.text = calculateOFactorByRomananAdjustmentFactor(
                double.tryParse(widget.ratingForF1.text) ?? 0,
                double.tryParse(widget.ratingForF2.text) ?? 0,
                double.tryParse(widget.ratingForF3.text) ?? 0)
            .toStringAsFixed(4);
        widget.setQSlope();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: ValueListenableBuilder(
            valueListenable: widget.oFactorRomanaValueType,
            builder:
                (context, oFactorRomanaValueType, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getViewPortHeight(context) * 0.02,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getViewPortWidth(context) * 0.01),
                              child: Text(
                                AppLocalizations.of(context)
                                    .calculateRomanaAdjustmentFactor,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: getSubTitleFontSize(context)),
                              )),
                          Row(children: [
                            Radio<OFactorRomanaValueType>(
                                value: OFactorRomanaValueType.value,
                                groupValue: oFactorRomanaValueType,
                                onChanged: (value) {
                                  setState(() {
                                    widget.oFactorRomanaValueType.value = value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context)
                                  .romanaAdjustmentFactorByValue,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<OFactorRomanaValueType>(
                                value: OFactorRomanaValueType.calculation,
                                groupValue: oFactorRomanaValueType,
                                onChanged: (value) {
                                  setState(() {
                                    widget.oFactorRomanaValueType.value = value;
                                  });
                                  widget.oFactor.text = "";
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context)
                                  .romanaAdjustmentFactorByF1F2F3,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          oFactorRomanaValueType == OFactorRomanaValueType.value
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: getViewPortHeight(context) * 0.02),
                                  child: CustomTextFormField(
                                    type: const TextInputType.numberWithOptions(
                                        signed: false),
                                    textInputAction: TextInputAction.done,
                                    textEditingController: widget.oFactor,
                                    onChanged: (value) {
                                      widget.oFactor.text = value;
                                      widget.setQSlope();
                                    },
                                    validate: (value) {
                                      if (oFactorRomanaValueType ==
                                              OFactorRomanaValueType.value &&
                                          (value == null || value.isEmpty)) {
                                        return "${AppLocalizations.of(context).oFactor} ${AppLocalizations.of(context).isRequired}";
                                      }
                                      return null;
                                    },
                                    titleText:
                                        "${AppLocalizations.of(context).oFactorValueFor} ${AppLocalizations.of(context).oFactorConstraints}",
                                  ))
                              : oFactorRomanaValueType ==
                                      OFactorRomanaValueType.calculation
                                  ? AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
                                      },
                                      child: widget.oFactorTypeOfFailure == null
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                widget.oFactorTypeOfFailure ==
                                                        OFactorTypeOfFailure
                                                            .wedge
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: getViewPortHeight(
                                                                    context) *
                                                                0.02),
                                                        child:
                                                            CustomTextFormField(
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              signed: false),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textEditingController:
                                                              widget.alphaI,
                                                          onChanged: (_) {
                                                            _calculateOFactor();
                                                          },
                                                          validate: (value) {
                                                            if (widget.oFactorTypeOfFailure ==
                                                                    OFactorTypeOfFailure
                                                                        .wedge &&
                                                                (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty)) {
                                                              return "${AppLocalizations.of(context).alphaISymbol} ${AppLocalizations.of(context).isRequired}";
                                                            }
                                                            return null;
                                                          },
                                                          titleText:
                                                              "${AppLocalizations.of(context).trendOfTheIntersectionLineInCaseOfTheWedge} (${AppLocalizations.of(context).alphaISymbol})",
                                                        ))
                                                    : Container(),
                                                widget.oFactorTypeOfFailure !=
                                                        OFactorTypeOfFailure
                                                            .wedge
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: getViewPortHeight(
                                                                    context) *
                                                                0.02),
                                                        child:
                                                            CustomTextFormField(
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              signed: false),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textEditingController:
                                                              widget.alphaJ,
                                                          onChanged: (_) {
                                                            _calculateOFactor();
                                                          },
                                                          validate: (value) {
                                                            if (widget.oFactorTypeOfFailure !=
                                                                    OFactorTypeOfFailure
                                                                        .wedge &&
                                                                (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty)) {
                                                              return "${AppLocalizations.of(context).alphaJSymbol} ${AppLocalizations.of(context).isRequired}";
                                                            }
                                                            return null;
                                                          },
                                                          titleText:
                                                              "${AppLocalizations.of(context).discontinuityDipDirection} (${AppLocalizations.of(context).alphaJSymbol})",
                                                        ))
                                                    : Container(),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: getViewPortHeight(
                                                                context) *
                                                            0.02),
                                                    child: CustomTextFormField(
                                                      type: const TextInputType
                                                          .numberWithOptions(
                                                          signed: false),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      textEditingController:
                                                          widget.alphaS,
                                                      onChanged: (_) {
                                                        _calculateOFactor();
                                                      },
                                                      validate: (value) {
                                                        if ((value == null ||
                                                            value.isEmpty)) {
                                                          return "${AppLocalizations.of(context).alphaSSymbol} ${AppLocalizations.of(context).isRequired}";
                                                        }
                                                        return null;
                                                      },
                                                      titleText:
                                                          "${AppLocalizations.of(context).slopeDipDirection} (${AppLocalizations.of(context).alphaSSymbol})",
                                                    )),
                                                widget.oFactorTypeOfFailure ==
                                                        OFactorTypeOfFailure
                                                            .wedge
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: getViewPortHeight(
                                                                    context) *
                                                                0.02),
                                                        child:
                                                            CustomTextFormField(
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              signed: false),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textEditingController:
                                                              widget.betaI,
                                                          onChanged: (_) {
                                                            _calculateOFactor();
                                                          },
                                                          validate: (value) {
                                                            if (widget.oFactorTypeOfFailure ==
                                                                    OFactorTypeOfFailure
                                                                        .wedge &&
                                                                (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty)) {
                                                              return "${AppLocalizations.of(context).betaISymbol} ${AppLocalizations.of(context).isRequired}";
                                                            }
                                                            return null;
                                                          },
                                                          titleText:
                                                              "${AppLocalizations.of(context).plungeOfTheIntersectionLine} (${AppLocalizations.of(context).betaISymbol})",
                                                        ))
                                                    : Container(),
                                                widget.oFactorTypeOfFailure !=
                                                        OFactorTypeOfFailure
                                                            .wedge
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: getViewPortHeight(
                                                                    context) *
                                                                0.02),
                                                        child:
                                                            CustomTextFormField(
                                                          type: const TextInputType
                                                              .numberWithOptions(
                                                              signed: false),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textEditingController:
                                                              widget.betaJ,
                                                          onChanged: (_) {
                                                            _calculateOFactor();
                                                          },
                                                          validate: (value) {
                                                            if (widget.oFactorTypeOfFailure !=
                                                                    OFactorTypeOfFailure
                                                                        .wedge &&
                                                                (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty)) {
                                                              return "${AppLocalizations.of(context).betaJSymbol} ${AppLocalizations.of(context).isRequired}";
                                                            }
                                                            return null;
                                                          },
                                                          titleText:
                                                              "${AppLocalizations.of(context).dipOfTheDiscontinuity} (${AppLocalizations.of(context).betaJSymbol})",
                                                        ))
                                                    : Container(),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: getViewPortHeight(
                                                                context) *
                                                            0.02),
                                                    child: CustomTextFormField(
                                                      type: const TextInputType
                                                          .numberWithOptions(
                                                          signed: false),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      textEditingController:
                                                          widget.betaS,
                                                      onChanged: (_) {
                                                        _calculateOFactor();
                                                      },
                                                      validate: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "${AppLocalizations.of(context).betaSSymbol} ${AppLocalizations.of(context).isRequired}";
                                                        }
                                                        return null;
                                                      },
                                                      titleText:
                                                          "${AppLocalizations.of(context).dipOfTheSlope} (${AppLocalizations.of(context).betaSSymbol})",
                                                    )),
                                                SizedBox(
                                                  height: getViewPortHeight(
                                                          context) *
                                                      0.05,
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable:
                                                        widget.oFactor,
                                                    builder: (context, oFactor,
                                                            child) =>
                                                        oFactor.text.isNotEmpty
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                    Text(
                                                                      widget.oFactorTypeOfFailure ==
                                                                              OFactorTypeOfFailure.planar
                                                                          ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaJSymbol} - ${AppLocalizations.of(context).alphaSSymbol}${(double.parse(widget.alphaJ.text) - double.parse(widget.alphaS.text)) < 0 ? ' + 360' : ''}"
                                                                          : widget.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
                                                                              ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaISymbol} - ${AppLocalizations.of(context).alphaSSymbol}${(double.parse(widget.alphaI.text) - double.parse(widget.alphaS.text)) < 0 ? ' + 360' : ''}"
                                                                              : "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaJSymbol} - ${AppLocalizations.of(context).alphaSSymbol} - 180${(double.parse(widget.alphaJ.text) - double.parse(widget.alphaS.text) - 180) < 0 ? ' + 360' : ''}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Text(
                                                                      widget.oFactorTypeOfFailure ==
                                                                              OFactorTypeOfFailure.planar
                                                                          ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = ${AppLocalizations.of(context).betaJSymbol}"
                                                                          : widget.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
                                                                              ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = ${AppLocalizations.of(context).betaISymbol}"
                                                                              : "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = 1",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Text(
                                                                      widget.oFactorTypeOfFailure ==
                                                                              OFactorTypeOfFailure.planar
                                                                          ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaJSymbol} - ${AppLocalizations.of(context).betaSSymbol}"
                                                                          : widget.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
                                                                              ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaISymbol} - ${AppLocalizations.of(context).betaSSymbol}"
                                                                              : "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaJSymbol} + ${AppLocalizations.of(context).betaSSymbol}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.03,
                                                                    ),
                                                                    Text(
                                                                      "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${widget.f1.text}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Text(
                                                                      "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = ${widget.f2.text}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Text(
                                                                      "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${widget.f3.text}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.05,
                                                                    ),
                                                                    OFactorRatingWidget(
                                                                        oFactorTypeOfFailure:
                                                                            widget
                                                                                .oFactorTypeOfFailure,
                                                                        f1: widget
                                                                            .f1,
                                                                        f2: widget
                                                                            .f2,
                                                                        f3: widget
                                                                            .f3,
                                                                        ratingForF1:
                                                                            widget
                                                                                .ratingForF1,
                                                                        ratingForF2:
                                                                            widget
                                                                                .ratingForF2,
                                                                        ratingForF3:
                                                                            widget.ratingForF3),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.03,
                                                                    ),
                                                                    Text(
                                                                      "${AppLocalizations.of(context).oFactor} = 1.9759 x (e ^ (0.0339 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3))",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getViewPortHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Text(
                                                                      "${AppLocalizations.of(context).oFactor} = ${oFactor.text}",
                                                                      style: GoogleFonts.montserrat(
                                                                          fontFeatures: [],
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              getSubTitleFontSize(context)),
                                                                    ),
                                                                  ])
                                                            : Container()),
                                              ],
                                            ))
                                  : Container()
                        ])));
  }
}
