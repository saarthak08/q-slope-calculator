import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/basic_info_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/direct_method_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/joint_volume_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class BlockSizePage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const BlockSizePage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<BlockSizePage> createState() => _BlockSizePageState();
}

class _BlockSizePageState extends State<BlockSizePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _locationIdController = TextEditingController();
  final TextEditingController _lithologyController = TextEditingController();
  final TextEditingController _sumOfCorePiecesController =
      TextEditingController();
  final TextEditingController _totalDrillRunController =
      TextEditingController();
  final ValueNotifier<List<TextEditingController>> _jointSpacingControllers =
      ValueNotifier(List.empty());
  final ValueNotifier<List<double>> jointSpacings = ValueNotifier(List.empty());
  final TextEditingController _numberOfJointsController =
      TextEditingController();
  final TextEditingController _numberOfRandomSetsController =
      TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final ValueNotifier<double?> rqd = ValueNotifier(null);
  final ValueNotifier<double?> jointVolume = ValueNotifier(null);
  final ValueNotifier<RqdByJvCalculationType?> rqdByJvCalculationType =
      ValueNotifier(null);
  final TextEditingController _jointSetNumberController =
      TextEditingController();
  RqdCalculationType? rqdCalculationType;
  final tabIndex = 0;

  @override
  void initState() {
    QSlope qSlope = widget.qSlope.value;
    _locationIdController.text = qSlope.locationId ?? "";
    _lithologyController.text = qSlope.lithology ?? "";
    _sumOfCorePiecesController.text =
        qSlope.blockSize?.sumOfCorePieces.toString() ?? '';
    _totalDrillRunController.text =
        qSlope.blockSize?.totalDrillRun.toString() ?? '';
    if (qSlope.blockSize != null &&
        qSlope.blockSize!.jointSpacingInMeters != null &&
        qSlope.blockSize!.jointSpacingInMeters!.isNotEmpty) {
      List<TextEditingController> controllers = List.empty(growable: true);
      for (var spacing in qSlope.blockSize!.jointSpacingInMeters!) {
        TextEditingController t = TextEditingController();
        t.text = spacing.toString();
        controllers.add(t);
      }
      _jointSpacingControllers.value = controllers;
    }
    jointSpacings.value = qSlope.blockSize?.jointSpacingInMeters ?? [];
    _numberOfJointsController.text =
        qSlope.blockSize?.numberOfJoints?.toString() ?? '';
    _numberOfRandomSetsController.text =
        qSlope.blockSize?.numberOfRandomSets?.toString() ?? '';
    _areaController.text =
        qSlope.blockSize?.areaInSquareMeters?.toString() ?? '';
    rqd.value = qSlope.blockSize?.rqd;
    jointVolume.value = qSlope.blockSize?.jointVolume;
    _jointSetNumberController.text =
        qSlope.blockSize?.jointSetNumber?.toString() ?? "";
    rqdByJvCalculationType.value = qSlope.blockSize?.rqdByJvCalculationType;
    setState(() {
      rqdCalculationType = qSlope.blockSize?.rqdCalculationType;
    });
    super.initState();
  }

  void _calculateRqdByJointVolumeMethod() {
    double? numberOfJoints = double.tryParse(_numberOfJointsController.text);
    double? numberOfRandomSets =
        double.tryParse(_numberOfRandomSetsController.text);
    if (numberOfRandomSets != null && numberOfJoints != null) {
      double jointSetNumber =
          calculateJointSetNumber(numberOfJoints, numberOfRandomSets);
      _jointSetNumberController.text = jointSetNumber.toString();
      _setQSlope();
    }
    if (numberOfJoints != null &&
        numberOfRandomSets != null &&
        _areaController.text.isNotEmpty &&
        double.tryParse(_areaController.text) != 0 &&
        _jointSpacingControllers.value.isNotEmpty &&
        _jointSetNumberController.text.isNotEmpty) {
      bool emptySpacing = false;
      for (var controller in _jointSpacingControllers.value) {
        if ((double.tryParse(controller.text) ?? 0) == 0.0) {
          emptySpacing = true;
          break;
        }
      }
      if (!emptySpacing) {
        List<double> spacings = List.empty(growable: true);
        for (var controller in _jointSpacingControllers.value) {
          spacings.add(double.tryParse(controller.text) ?? 1);
        }
        jointSpacings.value = spacings;
        jointVolume.value = double.tryParse(calculateJointVolume(
                int.tryParse(_numberOfRandomSetsController.text) ?? 0,
                spacings,
                double.tryParse(_areaController.text) ?? 1.0)
            .toStringAsFixed(4));
        if (rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith2Point5Jv) {
          rqd.value = double.tryParse(
              calculateRqdByTwoPointFiveJv(jointVolume.value ?? 0)
                  .toStringAsFixed(4));
          _setQSlope();
        }
        if (rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith3Point3Jv) {
          rqd.value = double.tryParse(
              calculateRqdByTwoPointFiveJv(jointVolume.value ?? 0)
                  .toStringAsFixed(4));
          _setQSlope();
        }
      }
    }
  }

  void _setQSlope() {
    if (_locationIdController.text.isNotEmpty &&
        _lithologyController.text.isNotEmpty &&
        rqd.value != null &&
        _numberOfJointsController.text.isNotEmpty &&
        _numberOfRandomSetsController.text.isNotEmpty &&
        _jointSetNumberController.text.isNotEmpty) {
      QSlope qSlope = widget.qSlope.value;
      qSlope.lithology = _lithologyController.text;
      qSlope.locationId = _locationIdController.text;
      qSlope.blockSize = BlockSize();
      qSlope.blockSize?.areaInSquareMeters =
          double.tryParse(_areaController.text);
      qSlope.blockSize?.jointSpacingInMeters = jointSpacings.value;
      qSlope.blockSize?.jointVolume = jointVolume.value;
      qSlope.blockSize?.numberOfJoints =
          int.tryParse(_numberOfJointsController.text);
      qSlope.blockSize?.numberOfRandomSets =
          int.tryParse(_numberOfRandomSetsController.text);
      qSlope.blockSize?.rqd = rqd.value;
      qSlope.blockSize?.rqdByJvCalculationType = rqdByJvCalculationType.value;
      qSlope.blockSize?.rqdCalculationType = rqdCalculationType;
      qSlope.blockSize?.sumOfCorePieces =
          double.tryParse(_sumOfCorePiecesController.text);
      qSlope.blockSize?.totalDrillRun =
          double.tryParse(_totalDrillRunController.text);
      qSlope.blockSize?.jointSetNumber =
          double.tryParse(_jointSetNumberController.text);
      widget.qSlope.value = qSlope;
      widget.errorTabs.value[tabIndex] = false;
    } else {
      widget.errorTabs.value[tabIndex] = true;
    }
    widget.errorTabs.value = List.from(widget.errorTabs.value);
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
            vertical: getViewPortHeight(context) * 0.04),
        child: Form(
            key: formKey,
            onChanged: () {
              formKey.currentState?.validate();
              _setQSlope();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlockSizePageBasicInfoWidget(
                    locationIdController: _locationIdController,
                    lithologyController: _lithologyController),
                Container(
                  margin: EdgeInsets.only(
                    top: getViewPortHeight(context) * 0.06,
                    bottom: getViewPortHeight(context) * 0.03,
                  ),
                  child: const DividerWidget(),
                ),
                Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: getViewPortHeight(context) * 0.03),
                        child: Text(
                          AppLocalizations.of(context)
                              .blockSizePageBlockSizeSubTitle,
                          style: GoogleFonts.poppins(
                              fontSize: getSubtitleLargeFontSize(context),
                              color: Colors.teal),
                        ))),
                CustomTextFormField(
                  type: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  textInputAction: TextInputAction.next,
                  textEditingController: _numberOfJointsController,
                  titleText:
                      AppLocalizations.of(context).numberOfJointsTextInputTitle,
                  validate: (value) {
                    if (rqdCalculationType == RqdCalculationType.jv &&
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
                      if (_jointSpacingControllers.value.length < intValue &&
                          intValue <= 100) {
                        List<TextEditingController> controller = List.from(
                            _jointSpacingControllers.value,
                            growable: true);
                        for (int i = 0;
                            i <
                                intValue -
                                    _jointSpacingControllers.value.length;
                            i++) {
                          controller.add(TextEditingController());
                        }
                        _jointSpacingControllers.value = controller;
                      }
                    }
                    _calculateRqdByJointVolumeMethod();
                  },
                ),
                SizedBox(
                  height: getViewPortHeight(context) * 0.03,
                ),
                CustomTextFormField(
                  onChanged: (value) {
                    _calculateRqdByJointVolumeMethod();
                  },
                  type: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  textInputAction: TextInputAction.next,
                  textEditingController: _numberOfRandomSetsController,
                  titleText: AppLocalizations.of(context)
                      .numberOfRandomSetsTextInputTitle,
                  validate: (value) {
                    if (rqdCalculationType == RqdCalculationType.jv &&
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
                    _calculateRqdByJointVolumeMethod();
                  },
                  icon: Icons.help_outline,
                  onClickIcon: () {
                    Navigator.pushNamed(context, PhotoViewScreen.route,
                        arguments:
                            const AssetImage(Assets.jointSetNumberTable));
                  },
                  type: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  textInputAction: TextInputAction.next,
                  textEditingController: _jointSetNumberController,
                  titleText: AppLocalizations.of(context).jointSetNumber,
                ),
                SizedBox(
                  height: getViewPortHeight(context) * 0.04,
                ),
                Text(
                  AppLocalizations.of(context)
                      .rockQualityDesignationCalculation,
                  style: TextStyle(fontSize: getSubTitleFontSize(context)),
                ),
                Row(children: [
                  Radio<RqdCalculationType>(
                      value: RqdCalculationType.jv,
                      groupValue: rqdCalculationType,
                      onChanged: (value) {
                        setState(() {
                          rqdCalculationType = value;
                        });
                        rqd.value = null;
                      }),
                  Expanded(
                      child: Text(
                    AppLocalizations.of(context).byUsingJointVolumeMethod,
                    style: TextStyle(fontSize: getBodyFontSize(context)),
                  )),
                ]),
                Row(children: [
                  Radio<RqdCalculationType>(
                      value: RqdCalculationType.directMethod,
                      groupValue: rqdCalculationType,
                      onChanged: (value) {
                        setState(() {
                          rqdCalculationType = value;
                        });
                        rqd.value = null;
                      }),
                  Expanded(
                      child: Text(
                    AppLocalizations.of(context).byUsingDirectMethod,
                    style: TextStyle(fontSize: getBodyFontSize(context)),
                  )),
                ]),
                Container(
                    margin:
                        EdgeInsets.only(top: getViewPortHeight(context) * 0.02),
                    key: const ValueKey<int>(1),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: rqdCalculationType ==
                              RqdCalculationType.directMethod
                          ? BlockSizePageDirectMethodWidget(
                              setQSlope: _setQSlope,
                              rqd: rqd,
                              sumOfCorePiecesController:
                                  _sumOfCorePiecesController,
                              totalDrillRunController: _totalDrillRunController,
                              rqdCalculationType: rqdCalculationType)
                          : rqdCalculationType == RqdCalculationType.jv
                              ? BlockSizePageJoinVolumeWidget(
                                  calculateRqdByJointVolumeMethod:
                                      _calculateRqdByJointVolumeMethod,
                                  jointSetNumberController:
                                      _jointSetNumberController,
                                  jointSpacings: jointSpacings,
                                  numberOfJointsController:
                                      _numberOfJointsController,
                                  jointSpacingControllers:
                                      _jointSpacingControllers,
                                  numberOfRandomSetsController:
                                      _numberOfRandomSetsController,
                                  areaController: _areaController,
                                  rqd: rqd,
                                  rqdByJvCalculationType:
                                      rqdByJvCalculationType,
                                  jointVolume: jointVolume,
                                )
                              : Container(),
                    )),
                SizedBox(
                  height: getViewPortHeight(context) * 0.1,
                ),
              ],
            )),
      )),
    );
  }

  @override
  void dispose() {
    _locationIdController.dispose();
    _areaController.dispose();
    _lithologyController.dispose();
    _totalDrillRunController.dispose();
    _numberOfJointsController.dispose();
    _numberOfRandomSetsController.dispose();
    _sumOfCorePiecesController.dispose();
    rqd.dispose();
    jointSpacings.dispose();
    jointVolume.dispose();
    rqdByJvCalculationType.dispose();
    _jointSetNumberController.dispose();
    for (var controller in _jointSpacingControllers.value) {
      controller.dispose();
    }
    _jointSpacingControllers.dispose();
    super.dispose();
  }
}
