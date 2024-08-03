import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class BlockSizePageJoinVolumeWidget extends StatefulWidget {
  final TextEditingController numberOfJointsController;
  final ValueNotifier<List<TextEditingController>> jointSpacingControllers;
  final TextEditingController numberOfRandomSetsController;
  final TextEditingController areaController;
  final RqdCalculationType? rqdCalculationType;
  final ValueNotifier<double?> rqd;
  final ValueNotifier<List<double>> jointSpacings;
  final ValueNotifier<double?> jointVolume;
  final ValueNotifier<RqdByJvCalculationType?> rqdByJvCalculationType;

  const BlockSizePageJoinVolumeWidget(
      {super.key,
      required this.numberOfJointsController,
      required this.jointSpacingControllers,
      required this.numberOfRandomSetsController,
      required this.areaController,
      this.rqdCalculationType,
      required this.rqd,
      required this.jointSpacings,
      required this.jointVolume,
      required this.rqdByJvCalculationType});

  @override
  State<BlockSizePageJoinVolumeWidget> createState() =>
      _BlockSizePageJoinVolumeWidgetState();
}

class _BlockSizePageJoinVolumeWidgetState
    extends State<BlockSizePageJoinVolumeWidget> {
  void _calculateRqd() {
    if (widget.numberOfJointsController.text.isNotEmpty &&
        widget.numberOfRandomSetsController.text.isNotEmpty &&
        widget.areaController.text.isNotEmpty &&
        double.tryParse(widget.areaController.text) != 0 &&
        widget.jointSpacingControllers.value.isNotEmpty) {
      int index = 0;
      bool emptySpacing = false;
      int numberOfJoints =
          int.tryParse(widget.numberOfJointsController.text) ?? 0;
      for (var controller in widget.jointSpacingControllers.value) {
        if (index == numberOfJoints) {
          break;
        }
        if ((double.tryParse(controller.text) ?? 0) == 0.0) {
          emptySpacing = true;
          break;
        }
        index++;
      }
      if (!emptySpacing) {
        List<double> spacings = List.empty(growable: true);
        int index = 0;
        for (var controller in widget.jointSpacingControllers.value) {
          if (index == numberOfJoints) {
            break;
          }
          spacings.add(double.tryParse(controller.text) ?? 1);
          index++;
        }
        widget.jointSpacings.value = spacings;
        widget.jointVolume.value = double.tryParse(calculateJointVolume(
                int.tryParse(widget.numberOfRandomSetsController.text) ?? 0,
                spacings,
                double.tryParse(widget.areaController.text) ?? 1.0)
            .toStringAsFixed(4));
        if (widget.rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith2Point5Jv) {
          widget.rqd.value = double.tryParse(
              calculateRqdByTwoPointFiveJv(widget.jointVolume.value ?? 0)
                  .toStringAsFixed(4));
        }
        if (widget.rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith3Point3Jv) {
          widget.rqd.value = double.tryParse(
              calculateRqdByTwoPointFiveJv(widget.jointVolume.value ?? 0)
                  .toStringAsFixed(4));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          type: const TextInputType.numberWithOptions(
              signed: false, decimal: false),
          textInputAction: TextInputAction.next,
          textEditingController: widget.numberOfJointsController,
          titleText: AppLocalizations.of(context).numberOfJointsTextInputTitle,
          validate: (value) {
            if (widget.rqdCalculationType == RqdCalculationType.jv &&
                (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)
                  .numberOfJointsTextInputRequired;
            }
            if (value != null &&
                value.isNotEmpty &&
                (int.tryParse(value) ?? 0) > 100) {
              return AppLocalizations.of(context)
                  .numberOfJointsNotMoreThanHundred;
            }
            return null;
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              int intValue = int.tryParse(value) ?? 0;
              if (widget.jointSpacingControllers.value.length < intValue &&
                  intValue <= 100) {
                List<TextEditingController> controller = List.from(
                    widget.jointSpacingControllers.value,
                    growable: true);
                for (int i = 0;
                    i < intValue - widget.jointSpacingControllers.value.length;
                    i++) {
                  controller.add(TextEditingController());
                }
                widget.jointSpacingControllers.value = controller;
              }
            }
            _calculateRqd();
          },
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
        ValueListenableBuilder(
            valueListenable: widget.numberOfJointsController,
            builder: (context, numOfJoints, child) => ValueListenableBuilder(
                valueListenable: widget.jointSpacingControllers,
                builder: (context, controllers, child) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: numOfJoints.text.isEmpty ||
                            (int.tryParse(numOfJoints.text) ?? 0) >
                                controllers.length
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getViewPortWidth(context) * 0.01),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .jointSpacingInMeters,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize:
                                              getFontSizeAccordingToOrientation(
                                                      context) *
                                                  0.018),
                                    )),
                                SizedBox(
                                  height: getViewPortHeight(context) * 0.01,
                                ),
                                SizedBox(
                                    height: getViewPortHeight(context) * 0.14,
                                    child: ListView.builder(
                                        primary: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                                parent:
                                                    ClampingScrollPhysics()),
                                        itemCount:
                                            int.tryParse(numOfJoints.text) ?? 0,
                                        itemBuilder: (context, index) =>
                                            Container(
                                                width:
                                                    getViewPortWidth(context) *
                                                        0.22,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        getViewPortWidth(
                                                                context) *
                                                            0.02),
                                                child: CustomTextFormField(
                                                  onChanged: (value) {
                                                    _calculateRqd();
                                                  },
                                                  titleText:
                                                      "${AppLocalizations.of(context).jointSpacingSymbol}${index + 1}",
                                                  textEditingController:
                                                      controllers[index],
                                                  placeholderText:
                                                      "${AppLocalizations.of(context).jointSymbol}${index + 1}",
                                                  validate: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        int.tryParse(value) ==
                                                            0) {
                                                      return "";
                                                    }
                                                    return null;
                                                  },
                                                  type: const TextInputType
                                                      .numberWithOptions(
                                                      signed: false),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                ))))
                              ])))),
        CustomTextFormField(
          onChanged: (value) {
            _calculateRqd();
          },
          type: const TextInputType.numberWithOptions(
              signed: false, decimal: false),
          textInputAction: TextInputAction.next,
          textEditingController: widget.numberOfRandomSetsController,
          titleText:
              AppLocalizations.of(context).numberOfRandomSetsTextInputTitle,
          validate: (value) {
            if (widget.rqdCalculationType == RqdCalculationType.jv &&
                (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)
                  .numberOfRandomSetsTextInputRequired;
            }
            return null;
          },
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
        CustomTextFormField(
          onChanged: (value) {
            _calculateRqd();
          },
          type: const TextInputType.numberWithOptions(signed: false),
          textInputAction: TextInputAction.next,
          textEditingController: widget.areaController,
          titleText: AppLocalizations.of(context).areaTextInputTitle,
          validate: (value) {
            if (widget.rqdCalculationType == RqdCalculationType.jv &&
                (value == null || value.isEmpty)) {
              return AppLocalizations.of(context).areaTextInputRequired;
            }
            if (value != null && value.isNotEmpty && int.tryParse(value) == 0) {
              return AppLocalizations.of(context).areaCannotBeZero;
            }
            return null;
          },
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.05,
        ),
        Text(
          "${AppLocalizations.of(context).jointVolume} = (1 / ${AppLocalizations.of(context).jointSpacingSymbol}1) + (1 / ${AppLocalizations.of(context).jointSpacingSymbol}2) + ... + (${AppLocalizations.of(context).numberOfRandomSetsSymbol} / (5 x √ ${AppLocalizations.of(context).areaSymbol}))",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getFontSizeAccordingToOrientation(context) * 0.019),
        ),
        ValueListenableBuilder(
            valueListenable: widget.jointVolume,
            builder: (context, jvVal, child) => jvVal != null
                ? Container(
                    margin:
                        EdgeInsets.only(top: getViewPortHeight(context) * 0.03),
                    child: Text(
                      "${AppLocalizations.of(context).jointVolume} = $jvVal",
                      style: GoogleFonts.montserrat(
                          fontFeatures: [],
                          fontWeight: FontWeight.w600,
                          fontSize: getFontSizeAccordingToOrientation(context) *
                              0.019),
                    ))
                : Container()),
        ValueListenableBuilder(
            valueListenable: widget.rqdByJvCalculationType,
            builder: (context, rqdByJvCalculationValue, child) =>
                ValueListenableBuilder(
                    valueListenable: widget.jointVolume,
                    builder: (context, jVValue, child) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          child: jVValue != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      SizedBox(
                                        height:
                                            getViewPortHeight(context) * 0.03,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .rockQualityDesignationCalculation,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            fontSize:
                                                getFontSizeAccordingToOrientation(
                                                        context) *
                                                    0.018),
                                      ),
                                      Row(children: [
                                        Radio<RqdByJvCalculationType>(
                                            value: RqdByJvCalculationType
                                                .formulaWith3Point3Jv,
                                            groupValue: rqdByJvCalculationValue,
                                            onChanged: (value) {
                                              widget.rqdByJvCalculationType
                                                  .value = value;
                                              _calculateRqd();
                                            }),
                                        Expanded(
                                            child: Text(
                                          "${AppLocalizations.of(context).rockQualityDesignationSymbol} = 115 - (3.3 x ${AppLocalizations.of(context).jointVolumeSymbol})",
                                          style: TextStyle(
                                              fontSize:
                                                  getFontSizeAccordingToOrientation(
                                                          context) *
                                                      0.018),
                                        )),
                                      ]),
                                      Row(children: [
                                        Radio<RqdByJvCalculationType>(
                                            value: RqdByJvCalculationType
                                                .formulaWith2Point5Jv,
                                            groupValue: rqdByJvCalculationValue,
                                            onChanged: (value) {
                                              widget.rqdByJvCalculationType
                                                  .value = value;
                                              _calculateRqd();
                                            }),
                                        Expanded(
                                            child: Text(
                                          "${AppLocalizations.of(context).rockQualityDesignationSymbol} = 110 - (2.5 x ${AppLocalizations.of(context).jointVolumeSymbol})",
                                          style: TextStyle(
                                              fontSize:
                                                  getFontSizeAccordingToOrientation(
                                                          context) *
                                                      0.018),
                                        )),
                                      ]),
                                      rqdByJvCalculationValue != null
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: getViewPortHeight(
                                                          context) *
                                                      0.03),
                                              child: Text(
                                                "${AppLocalizations.of(context).rockQualityDesignation} = ${widget.rqd.value} %",
                                                style: GoogleFonts.montserrat(
                                                    fontFeatures: [],
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        getFontSizeAccordingToOrientation(
                                                                context) *
                                                            0.019),
                                              ))
                                          : Container()
                                    ])
                              : Container(),
                        )))
      ],
    );
  }
}
