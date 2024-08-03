import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class OFactorRomanaAdjustmentFactorWidget extends StatefulWidget {
  final ValueNotifier<OFactorTypeOfFailure?> oFactorTypeOfFailure;
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
      required this.oFactor});

  @override
  State<OFactorRomanaAdjustmentFactorWidget> createState() =>
      _OFactorRomanaAdjustmentFactorWidgetState();
}

class _OFactorRomanaAdjustmentFactorWidgetState
    extends State<OFactorRomanaAdjustmentFactorWidget> {
  bool isF2Beta1 = true;

  void _calculateOFactor() {
    if (widget.oFactorTypeOfFailure.value != null) {
      double alphaI = double.tryParse(widget.alphaI.text) ?? 0;
      double alphaJ = double.tryParse(widget.alphaJ.text) ?? 0;
      double alphaS = double.tryParse(widget.alphaS.text) ?? 0;
      double betaI = double.tryParse(widget.betaI.text) ?? 0;
      double betaJ = double.tryParse(widget.betaJ.text) ?? 0;
      double betaS = double.tryParse(widget.betaS.text) ?? 0;
      if (widget.oFactorTypeOfFailure.value == OFactorTypeOfFailure.planar) {
        if (widget.alphaJ.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            ((isF2Beta1 && widget.betaI.text.isNotEmpty) ||
                (!isF2Beta1 && widget.betaJ.text.isNotEmpty)) &&
            widget.betaJ.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          widget.f1.text =
              calculateF1ForPlanarFailure(alphaJ, alphaS).toStringAsFixed(4);
          widget.f2.text =
              isF2Beta1 ? betaI.toStringAsFixed(4) : betaJ.toStringAsFixed(4);
          widget.f3.text =
              calculateF3ForPlanarFailure(betaJ, betaS).toStringAsFixed(4);
        }
      }
      if (widget.oFactorTypeOfFailure.value == OFactorTypeOfFailure.wedge) {
        if (widget.alphaI.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            ((isF2Beta1 && widget.betaI.text.isNotEmpty) ||
                (!isF2Beta1 && widget.betaJ.text.isNotEmpty)) &&
            widget.betaI.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          widget.f1.text =
              calculateF1ForWedgeFailure(alphaI, alphaS).toStringAsFixed(4);
          widget.f2.text =
              isF2Beta1 ? betaI.toStringAsFixed(4) : betaJ.toStringAsFixed(4);
          widget.f3.text =
              calculateF3ForWedgeFailure(betaI, betaS).toStringAsFixed(4);
        }
      }
      if (widget.oFactorTypeOfFailure.value == OFactorTypeOfFailure.toppling) {
        if (widget.alphaJ.text.isNotEmpty &&
            widget.alphaS.text.isNotEmpty &&
            widget.betaJ.text.isNotEmpty &&
            widget.betaS.text.isNotEmpty) {
          widget.f1.text =
              calculateF1ForTopplingFailure(alphaJ, alphaS).toStringAsFixed(4);
          widget.f2.text = "1";
          widget.f3.text =
              calculateF3ForTopplingFailure(betaJ, betaS).toStringAsFixed(4);
        }
      }

      if (widget.f1.text.isNotEmpty &&
          widget.f2.text.isNotEmpty &&
          widget.f3.text.isNotEmpty) {
        widget.oFactor.text = calculateOFactorByRomananAdjustmentFactor(
                double.tryParse(widget.f1.text) ?? 0,
                double.tryParse(widget.f2.text) ?? 0,
                double.tryParse(widget.f3.text) ?? 0)
            .toStringAsFixed(4);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.oFactorTypeOfFailure,
        builder: (context, oFactorTypeOfFailure, child) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getViewPortWidth(context) * 0.01),
                  child: Text(
                    AppLocalizations.of(context).typeOfFailure,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: getViewPortHeight(context) * 0.02),
                  )),
              SizedBox(
                height: getViewPortHeight(context) * 0.01,
              ),
              Row(children: [
                Radio<OFactorTypeOfFailure>(
                    value: OFactorTypeOfFailure.planar,
                    groupValue: oFactorTypeOfFailure,
                    onChanged: (value) {
                      widget.oFactorTypeOfFailure.value = value;
                      _calculateOFactor();
                    }),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).planarFailure,
                  style:
                      TextStyle(fontSize: getViewPortHeight(context) * 0.018),
                )),
              ]),
              Row(children: [
                Radio<OFactorTypeOfFailure>(
                    value: OFactorTypeOfFailure.wedge,
                    groupValue: oFactorTypeOfFailure,
                    onChanged: (value) {
                      widget.oFactorTypeOfFailure.value = value;
                      _calculateOFactor();
                    }),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).wedgeFailure,
                  style:
                      TextStyle(fontSize: getViewPortHeight(context) * 0.018),
                )),
              ]),
              Row(children: [
                Radio<OFactorTypeOfFailure>(
                    value: OFactorTypeOfFailure.toppling,
                    groupValue: oFactorTypeOfFailure,
                    onChanged: (value) {
                      widget.oFactorTypeOfFailure.value = value;
                      _calculateOFactor();
                    }),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).toppling,
                  style:
                      TextStyle(fontSize: getViewPortHeight(context) * 0.018),
                )),
              ]),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: oFactorTypeOfFailure == null
                      ? Container()
                      : Column(
                          children: [
                            oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: getViewPortHeight(context) * 0.02),
                                    child: CustomTextFormField(
                                      type:
                                          const TextInputType.numberWithOptions(
                                              signed: false),
                                      textInputAction: TextInputAction.done,
                                      textEditingController: widget.alphaI,
                                      onChanged: (_) {
                                        _calculateOFactor();
                                      },
                                      validate: (value) {
                                        if (oFactorTypeOfFailure ==
                                                OFactorTypeOfFailure.wedge &&
                                            (value == null || value.isEmpty)) {
                                          return "${AppLocalizations.of(context).alphaISymbol} ${AppLocalizations.of(context).isRequired}";
                                        }
                                        return null;
                                      },
                                      titleText:
                                          "${AppLocalizations.of(context).trendOfTheIntersectionLineInCaseOfTheWedge} (${AppLocalizations.of(context).alphaISymbol})",
                                    ))
                                : Container(),
                            oFactorTypeOfFailure != OFactorTypeOfFailure.wedge
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: getViewPortHeight(context) * 0.02),
                                    child: CustomTextFormField(
                                      type:
                                          const TextInputType.numberWithOptions(
                                              signed: false),
                                      textInputAction: TextInputAction.done,
                                      textEditingController: widget.alphaJ,
                                      onChanged: (_) {
                                        _calculateOFactor();
                                      },
                                      validate: (value) {
                                        if (oFactorTypeOfFailure !=
                                                OFactorTypeOfFailure.wedge &&
                                            (value == null || value.isEmpty)) {
                                          return "${AppLocalizations.of(context).alphaJSymbol} ${AppLocalizations.of(context).isRequired}";
                                        }
                                        return null;
                                      },
                                      titleText:
                                          "${AppLocalizations.of(context).discontinuityDipDirection} (${AppLocalizations.of(context).alphaJSymbol})",
                                    ))
                                : Container(),
                            oFactorTypeOfFailure != OFactorTypeOfFailure.wedge
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: getViewPortHeight(context) * 0.02),
                                    child: CustomTextFormField(
                                      type:
                                          const TextInputType.numberWithOptions(
                                              signed: false),
                                      textInputAction: TextInputAction.done,
                                      textEditingController: widget.alphaS,
                                      onChanged: (_) {
                                        _calculateOFactor();
                                      },
                                      validate: (value) {
                                        if (oFactorTypeOfFailure !=
                                                OFactorTypeOfFailure.wedge &&
                                            (value == null || value.isEmpty)) {
                                          return "${AppLocalizations.of(context).alphaSSymbol} ${AppLocalizations.of(context).isRequired}";
                                        }
                                        return null;
                                      },
                                      titleText:
                                          "${AppLocalizations.of(context).slopeDipDirection} (${AppLocalizations.of(context).alphaSSymbol})",
                                    ))
                                : Container(),
                            oFactorTypeOfFailure !=
                                    OFactorTypeOfFailure.toppling
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: getViewPortHeight(context) * 0.02),
                                    child: CustomTextFormField(
                                      type:
                                          const TextInputType.numberWithOptions(
                                              signed: false),
                                      textInputAction: TextInputAction.done,
                                      textEditingController: widget.betaI,
                                      onChanged: (_) {
                                        _calculateOFactor();
                                      },
                                      titleText:
                                          "${AppLocalizations.of(context).plungeOfTheIntersectionLine} (${AppLocalizations.of(context).betaISymbol})",
                                    ))
                                : Container(),
                            Container(
                                margin: EdgeInsets.only(
                                    top: getViewPortHeight(context) * 0.02),
                                child: CustomTextFormField(
                                  type: const TextInputType.numberWithOptions(
                                      signed: false),
                                  textInputAction: TextInputAction.done,
                                  textEditingController: widget.betaJ,
                                  onChanged: (_) {
                                    _calculateOFactor();
                                  },
                                  titleText:
                                      "${AppLocalizations.of(context).dipOfTheDiscontinuity} (${AppLocalizations.of(context).betaJSymbol})",
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    top: getViewPortHeight(context) * 0.02),
                                child: CustomTextFormField(
                                  type: const TextInputType.numberWithOptions(
                                      signed: false),
                                  textInputAction: TextInputAction.done,
                                  textEditingController: widget.betaS,
                                  onChanged: (_) {
                                    _calculateOFactor();
                                  },
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context).betaSSymbol} ${AppLocalizations.of(context).isRequired}";
                                    }
                                    return null;
                                  },
                                  titleText:
                                      "${AppLocalizations.of(context).dipOfTheSlope} (${AppLocalizations.of(context).betaSSymbol})",
                                )),
                            SizedBox(
                              height: getViewPortHeight(context) * 0.05,
                            ),
                            ValueListenableBuilder(
                                valueListenable: widget.oFactor,
                                builder: (context, oFactor, child) => oFactor
                                        .text.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                              oFactorTypeOfFailure ==
                                                      OFactorTypeOfFailure
                                                          .planar
                                                  ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaJSymbol} - ${AppLocalizations.of(context).alphaSSymbol}"
                                                  : oFactorTypeOfFailure ==
                                                          OFactorTypeOfFailure
                                                              .wedge
                                                      ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaISymbol} - ${AppLocalizations.of(context).alphaSSymbol}"
                                                      : "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${AppLocalizations.of(context).alphaJSymbol} - ${AppLocalizations.of(context).alphaSSymbol} -180",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.02,
                                            ),
                                            oFactorTypeOfFailure ==
                                                    OFactorTypeOfFailure
                                                        .toppling
                                                ? Text(
                                                    "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = 1",
                                                    style: GoogleFonts.montserrat(
                                                        fontFeatures: [],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            getViewPortHeight(
                                                                    context) *
                                                                0.019),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                          "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = ",
                                                          style: GoogleFonts.montserrat(
                                                              fontFeatures: [],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getViewPortHeight(
                                                                          context) *
                                                                      0.019),
                                                        ),
                                                        Radio<bool>(
                                                            value: true,
                                                            groupValue:
                                                                isF2Beta1,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isF2Beta1 =
                                                                    true;
                                                              });
                                                              _calculateOFactor();
                                                            }),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .betaISymbol,
                                                          style: GoogleFonts.montserrat(
                                                              fontFeatures: [],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getViewPortHeight(
                                                                          context) *
                                                                      0.019),
                                                        ),
                                                        Radio<bool>(
                                                            value: false,
                                                            groupValue:
                                                                isF2Beta1,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isF2Beta1 =
                                                                    false;
                                                              });
                                                              _calculateOFactor();
                                                            }),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .betaJSymbol,
                                                          style: GoogleFonts.montserrat(
                                                              fontFeatures: [],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  getViewPortHeight(
                                                                          context) *
                                                                      0.019),
                                                        ),
                                                      ]),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.02,
                                            ),
                                            Text(
                                              oFactorTypeOfFailure ==
                                                      OFactorTypeOfFailure
                                                          .planar
                                                  ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaJSymbol} - ${AppLocalizations.of(context).betaSSymbol}"
                                                  : oFactorTypeOfFailure ==
                                                          OFactorTypeOfFailure
                                                              .wedge
                                                      ? "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaISymbol} - ${AppLocalizations.of(context).betaSSymbol}"
                                                      : "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${AppLocalizations.of(context).betaJSymbol} + ${AppLocalizations.of(context).betaSSymbol}",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.05,
                                            ),
                                            Text(
                                              "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 = ${widget.f1.text}",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.02,
                                            ),
                                            Text(
                                              "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 = ${widget.f2.text}",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.02,
                                            ),
                                            Text(
                                              "${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3 = ${widget.f3.text}",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.03,
                                            ),
                                            Text(
                                              "${AppLocalizations.of(context).oFactor} = 1.9759 x (e ^ (0.0339 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}1 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}2 x ${AppLocalizations.of(context).romanaAdjustmentFactorSymbol}3))",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                            SizedBox(
                                              height:
                                                  getViewPortHeight(context) *
                                                      0.02,
                                            ),
                                            Text(
                                              "${AppLocalizations.of(context).oFactor} = ${oFactor.text}",
                                              style: GoogleFonts.montserrat(
                                                  fontFeatures: [],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getViewPortHeight(
                                                          context) *
                                                      0.019),
                                            ),
                                          ])
                                    : Container()),
                          ],
                        ))
            ]));
  }
}
