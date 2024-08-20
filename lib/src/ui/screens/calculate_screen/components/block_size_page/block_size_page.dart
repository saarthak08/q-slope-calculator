import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/basic_info_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/direct_method_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/joint_volume_widget.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class BlockSizePage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const BlockSizePage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<BlockSizePage> createState() => _BlockSizePageState();
}

class _BlockSizePageState extends State<BlockSizePage>
    with AutomaticKeepAliveClientMixin {
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
    rqdByJvCalculationType.value = qSlope.blockSize?.rqdByJvCalculationType;
    setState(() {
      rqdCalculationType = qSlope.blockSize?.rqdCalculationType;
    });
    super.initState();
  }

  void _setQSlope() {
    if (_locationIdController.text.isNotEmpty &&
        _lithologyController.text.isNotEmpty &&
        rqd.value != null) {
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
      qSlope.blockSize?.rqd = rqd.value ?? 0;
      qSlope.blockSize?.rqdByJvCalculationType = rqdByJvCalculationType.value;
      qSlope.blockSize?.rqdCalculationType = rqdCalculationType;
      qSlope.blockSize?.sumOfCorePieces =
          double.tryParse(_sumOfCorePiecesController.text);
      qSlope.blockSize?.totalDrillRun =
          double.tryParse(_totalDrillRunController.text);
      widget.qSlope.value = qSlope;
      widget.errorTabs.value[tabIndex] = false;
    } else {
      widget.errorTabs.value[tabIndex] = true;
    }
    widget.errorTabs.value = List.from(widget.errorTabs.value);
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
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlockSizePageBasicInfoWidget(
                    locationIdController: _locationIdController,
                    lithologyController: _lithologyController),
                Container(
                  margin: EdgeInsets.only(
                    top: getViewPortHeight(context) * 0.04,
                    bottom: getViewPortHeight(context) * 0.02,
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
                                  setQSlope: _setQSlope,
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
    for (var controller in _jointSpacingControllers.value) {
      controller.dispose();
    }
    _jointSpacingControllers.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
