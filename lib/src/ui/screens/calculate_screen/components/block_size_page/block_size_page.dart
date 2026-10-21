import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/geo_utils.dart';
import 'package:q_slope_calculator/src/utils/image_utils.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

class BlockSizePage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const BlockSizePage({
    super.key,
    required this.qSlope,
    required this.errorTabs,
  });

  @override
  State<BlockSizePage> createState() => _BlockSizePageState();
}

class _BlockSizePageState extends State<BlockSizePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _locationIdController = TextEditingController();
  final TextEditingController _lithologyController = TextEditingController();
  final TextEditingController _slopeAngleByUserController =
      TextEditingController();
  final TextEditingController _benchHeightController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _elevationController = TextEditingController();
  final ValueNotifier<List<String>> _photoPaths = ValueNotifier([]);
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
    _slopeAngleByUserController.text =
        qSlope.slopeAngleByUser?.toString() ?? '';
    _benchHeightController.text = qSlope.benchHeight?.toString() ?? '';
    _latitudeController.text = qSlope.latitude?.toString() ?? '';
    _longitudeController.text = qSlope.longitude?.toString() ?? '';
    _elevationController.text = qSlope.elevation?.toString() ?? '';
    _photoPaths.value = List.from(qSlope.photoPaths ?? []);
    final existingRqd = qSlope.blockSize?.rqd;
    double? sumOfCorePieces = qSlope.blockSize?.sumOfCorePieces;
    double? totalDrillRun = qSlope.blockSize?.totalDrillRun;

    if (existingRqd != null &&
        (sumOfCorePieces == null || totalDrillRun == null)) {
      sumOfCorePieces ??= existingRqd;
      totalDrillRun ??= 100.0;
      qSlope.blockSize?.sumOfCorePieces = sumOfCorePieces;
      qSlope.blockSize?.totalDrillRun = totalDrillRun;
    }

    _sumOfCorePiecesController.text =
        sumOfCorePieces != null
            ? (sumOfCorePieces % 1 == 0
                ? sumOfCorePieces.toInt().toString()
                : sumOfCorePieces.toString())
            : '';
    _totalDrillRunController.text =
        totalDrillRun != null
            ? (totalDrillRun % 1 == 0
                ? totalDrillRun.toInt().toString()
                : totalDrillRun.toString())
            : '';
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
        qSlope.blockSize?.numberOfJoints?.toString() ??
        (qSlope.jointCharacter?.jointRoughness?.length.toString() ?? '');
    int intNumOfJoints = int.tryParse(_numberOfJointsController.text) ?? 0;
    if (intNumOfJoints > 0 && intNumOfJoints <= 100) {
      List<TextEditingController> currentControllers = List.from(
        _jointSpacingControllers.value,
      );
      while (currentControllers.length < intNumOfJoints) {
        currentControllers.add(TextEditingController(text: '1.0'));
      }
      _jointSpacingControllers.value = currentControllers;
    }
    _numberOfRandomSetsController.text =
        qSlope.blockSize?.numberOfRandomSets?.toString() ?? '0';
    _areaController.text =
        qSlope.blockSize?.areaInSquareMeters?.toString() ?? '';
    rqd.value = qSlope.blockSize?.rqd;
    jointVolume.value = qSlope.blockSize?.jointVolume;
    final double? existingJn = qSlope.blockSize?.jointSetNumber;
    if (existingJn != null && existingJn > 0) {
      _jointSetNumberController.text = existingJn.toString();
    } else if (intNumOfJoints > 0) {
      final double derivedJn = calculateJointSetNumber(
        intNumOfJoints.toDouble(),
        (qSlope.blockSize?.numberOfRandomSets ?? 0).toDouble(),
      );
      _jointSetNumberController.text = derivedJn.toString();
    } else {
      _jointSetNumberController.text = "";
    }
    rqdByJvCalculationType.value = qSlope.blockSize?.rqdByJvCalculationType;
    setState(() {
      rqdCalculationType =
          qSlope.blockSize?.rqdCalculationType ??
          (qSlope.blockSize?.rqd != null
              ? RqdCalculationType.directMethod
              : null);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setQSlope();
      }
    });
    super.initState();
  }

  void _calculateRqdByJointVolumeMethod() {
    double? numberOfJoints = double.tryParse(_numberOfJointsController.text);
    double? numberOfRandomSets = double.tryParse(
      _numberOfRandomSetsController.text,
    );
    if (numberOfRandomSets != null && numberOfJoints != null) {
      double jointSetNumber = calculateJointSetNumber(
        numberOfJoints,
        numberOfRandomSets,
      );
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
        jointVolume.value = double.tryParse(
          calculateJointVolume(
            int.tryParse(_numberOfRandomSetsController.text) ?? 0,
            spacings,
            double.tryParse(_areaController.text) ?? 1.0,
          ).toStringAsFixed(4),
        );
        if (rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith2Point5Jv) {
          rqd.value = double.tryParse(
            calculateRqdByTwoPointFiveJv(
              jointVolume.value ?? 0,
            ).toStringAsFixed(4),
          );
          _setQSlope();
        }
        if (rqdByJvCalculationType.value ==
            RqdByJvCalculationType.formulaWith3Point3Jv) {
          rqd.value = double.tryParse(
            calculateRqdByThreePointThreeJv(
              jointVolume.value ?? 0,
            ).toStringAsFixed(4),
          );
          _setQSlope();
        }
      }
    }
  }

  void _setQSlope() {
    final hasLocation = _locationIdController.text.isNotEmpty;
    final hasLithology = _lithologyController.text.isNotEmpty;
    final hasRqd = rqd.value != null;
    final hasJoints = _numberOfJointsController.text.isNotEmpty;
    final hasJn = _jointSetNumberController.text.isNotEmpty;

    if (hasLocation && hasLithology && hasRqd && hasJoints && hasJn) {
      QSlope qSlope = widget.qSlope.value;
      qSlope.lithology = _lithologyController.text;
      qSlope.locationId = _locationIdController.text;
      qSlope.slopeAngleByUser = double.tryParse(
        _slopeAngleByUserController.text,
      );
      qSlope.benchHeight = double.tryParse(_benchHeightController.text);
      qSlope.latitude = double.tryParse(_latitudeController.text);
      qSlope.longitude = double.tryParse(_longitudeController.text);
      qSlope.elevation = double.tryParse(_elevationController.text);
      qSlope.photoPaths =
          _photoPaths.value.isNotEmpty ? _photoPaths.value : null;
      qSlope.blockSize ??= BlockSize();
      qSlope.blockSize?.areaInSquareMeters = double.tryParse(
        _areaController.text,
      );
      qSlope.blockSize?.jointSpacingInMeters = jointSpacings.value;
      qSlope.blockSize?.jointVolume = jointVolume.value;
      qSlope.blockSize?.numberOfJoints =
          int.tryParse(_numberOfJointsController.text) ?? 1;
      qSlope.blockSize?.numberOfRandomSets =
          int.tryParse(_numberOfRandomSetsController.text) ?? 0;
      qSlope.blockSize?.rqd = rqd.value;
      qSlope.blockSize?.rqdByJvCalculationType = rqdByJvCalculationType.value;
      qSlope.blockSize?.rqdCalculationType = rqdCalculationType;
      qSlope.blockSize?.sumOfCorePieces = double.tryParse(
        _sumOfCorePiecesController.text,
      );
      qSlope.blockSize?.totalDrillRun = double.tryParse(
        _totalDrillRunController.text,
      );
      qSlope.blockSize?.jointSetNumber = double.tryParse(
        _jointSetNumberController.text,
      );
      widget.qSlope.value = qSlope;
      widget.errorTabs.value[tabIndex] = false;
    } else {
      widget.errorTabs.value[tabIndex] = true;
    }
    widget.errorTabs.value = List.from(widget.errorTabs.value);
  }

  Future<void> _handleCaptureGps() async {
    final pos = await GeoUtils.getCurrentLocation();
    if (pos != null) {
      setState(() {
        _latitudeController.text = pos.latitude.toStringAsFixed(6);
        _longitudeController.text = pos.longitude.toStringAsFixed(6);
        if (pos.altitude != null) {
          _elevationController.text = pos.altitude!.toStringAsFixed(1);
        }
      });
      _setQSlope();
      if (mounted) {
        toastification.show(
          context: context,
          title: Text(AppLocalizations.of(context).gpsCaptured),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } else {
      if (mounted) {
        toastification.show(
          context: context,
          title: Text(AppLocalizations.of(context).gpsFailed),
          type: ToastificationType.warning,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _handleViewMap() async {
    final lat = double.tryParse(_latitudeController.text);
    final lng = double.tryParse(_longitudeController.text);
    if (lat != null && lng != null) {
      await GeoUtils.openInMap(lat, lng);
    }
  }

  Future<void> _handleAddPhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (sheetContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: primaryColor),
                    title: Text(l10n.takePhoto),
                    onTap:
                        () => Navigator.pop(sheetContext, ImageSource.camera),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library, color: primaryColor),
                    title: Text(l10n.pickFromGallery),
                    onTap:
                        () => Navigator.pop(sheetContext, ImageSource.gallery),
                  ),
                ],
              ),
            ),
          ),
    );

    if (source != null) {
      final path = await ImageUtils.captureOrPickImage(
        fromCamera: source == ImageSource.camera,
      );
      if (path != null) {
        _photoPaths.value = [..._photoPaths.value, path];
        _setQSlope();
      }
    }
  }

  void _handleRemovePhoto(int index) {
    final current = List<String>.from(_photoPaths.value);
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      _photoPaths.value = current;
      _setQSlope();
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
            vertical: getViewPortHeight(context) * 0.04,
          ),
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
                  lithologyController: _lithologyController,
                  slopeAngleByUserController: _slopeAngleByUserController,
                  benchHeightController: _benchHeightController,
                  latitudeController: _latitudeController,
                  longitudeController: _longitudeController,
                  elevationController: _elevationController,
                  photoPaths: _photoPaths,
                  onCaptureGps: _handleCaptureGps,
                  onViewMap: _handleViewMap,
                  onAddPhoto: _handleAddPhoto,
                  onRemovePhoto: _handleRemovePhoto,
                ),
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
                      bottom: getViewPortHeight(context) * 0.03,
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).blockSizePageBlockSizeSubTitle,
                      style: GoogleFonts.poppins(
                        fontSize: getSubtitleLargeFontSize(context),
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                CustomTextFormField(
                  type: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  textInputAction: TextInputAction.next,
                  textEditingController: _numberOfJointsController,
                  titleText:
                      AppLocalizations.of(context).numberOfJointsTextInputTitle,
                  validate: (value) {
                    if (rqdCalculationType == RqdCalculationType.jv &&
                        (value == null || value.isEmpty)) {
                      return AppLocalizations.of(
                        context,
                      ).numberOfJointsTextInputRequired;
                    }
                    if (value != null &&
                        value.isNotEmpty &&
                        (int.tryParse(value) ?? 0) > 100) {
                      return AppLocalizations.of(
                        context,
                      ).numberOfJointsNotMoreThanHundred;
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
                          growable: true,
                        );
                        for (
                          int i = 0;
                          i < intValue - _jointSpacingControllers.value.length;
                          i++
                        ) {
                          controller.add(TextEditingController());
                        }
                        _jointSpacingControllers.value = controller;
                      }
                    }
                    _calculateRqdByJointVolumeMethod();
                  },
                ),
                SizedBox(height: getViewPortHeight(context) * 0.03),
                CustomTextFormField(
                  onChanged: (value) {
                    _calculateRqdByJointVolumeMethod();
                  },
                  type: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  textInputAction: TextInputAction.next,
                  textEditingController: _numberOfRandomSetsController,
                  titleText:
                      AppLocalizations.of(
                        context,
                      ).numberOfRandomSetsTextInputTitle,
                  validate: (value) {
                    if (rqdCalculationType == RqdCalculationType.jv &&
                        (value == null || value.isEmpty)) {
                      return AppLocalizations.of(
                        context,
                      ).numberOfRandomSetsTextInputRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: getViewPortHeight(context) * 0.03),
                CustomTextFormField(
                  onChanged: (value) {
                    _calculateRqdByJointVolumeMethod();
                  },
                  icon: Icons.help_outline,
                  onClickIcon: () {
                    Navigator.pushNamed(
                      context,
                      PhotoViewScreen.route,
                      arguments: const AssetImage(Assets.jointSetNumberTable),
                    );
                  },
                  type: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  textEditingController: _jointSetNumberController,
                  titleText: AppLocalizations.of(context).jointSetNumber,
                ),
                SizedBox(height: getViewPortHeight(context) * 0.04),
                Text(
                  AppLocalizations.of(
                    context,
                  ).rockQualityDesignationCalculation,
                  style: TextStyle(fontSize: getSubTitleFontSize(context)),
                ),
                Row(
                  children: [
                    RadioGroup<RqdCalculationType>(
                      groupValue: rqdCalculationType,
                      onChanged: (value) {
                        setState(() {
                          rqdCalculationType = value;
                        });
                        rqd.value = null;
                      },
                      child: Radio<RqdCalculationType>(
                        value: RqdCalculationType.jv,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).byUsingJointVolumeMethod,
                        style: TextStyle(fontSize: getBodyFontSize(context)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    RadioGroup<RqdCalculationType>(
                      groupValue: rqdCalculationType,
                      onChanged: (value) {
                        setState(() {
                          rqdCalculationType = value;
                        });
                        if (_sumOfCorePiecesController.text.isNotEmpty &&
                            _totalDrillRunController.text.isNotEmpty) {
                          final sum =
                              double.tryParse(
                                _sumOfCorePiecesController.text,
                              ) ??
                              0;
                          final total =
                              double.tryParse(_totalDrillRunController.text) ??
                              100;
                          if (total != 0) {
                            rqd.value = double.tryParse(
                              calculateRqdByDirectMethod(
                                sum,
                                total,
                              ).toStringAsFixed(4),
                            );
                            _setQSlope();
                          }
                        } else {
                          rqd.value = null;
                        }
                      },
                      child: Radio<RqdCalculationType>(
                        value: RqdCalculationType.directMethod,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).byUsingDirectMethod,
                        style: TextStyle(fontSize: getBodyFontSize(context)),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: getViewPortHeight(context) * 0.02,
                  ),
                  key: const ValueKey<int>(1),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child:
                        rqdCalculationType == RqdCalculationType.directMethod
                            ? BlockSizePageDirectMethodWidget(
                              setQSlope: _setQSlope,
                              rqd: rqd,
                              sumOfCorePiecesController:
                                  _sumOfCorePiecesController,
                              totalDrillRunController: _totalDrillRunController,
                              rqdCalculationType: rqdCalculationType,
                            )
                            : rqdCalculationType == RqdCalculationType.jv
                            ? BlockSizePageJoinVolumeWidget(
                              calculateRqdByJointVolumeMethod:
                                  _calculateRqdByJointVolumeMethod,
                              jointSetNumberController:
                                  _jointSetNumberController,
                              jointSpacings: jointSpacings,
                              numberOfJointsController:
                                  _numberOfJointsController,
                              jointSpacingControllers: _jointSpacingControllers,
                              numberOfRandomSetsController:
                                  _numberOfRandomSetsController,
                              areaController: _areaController,
                              rqd: rqd,
                              rqdByJvCalculationType: rqdByJvCalculationType,
                              jointVolume: jointVolume,
                            )
                            : Container(),
                  ),
                ),
                SizedBox(height: getViewPortHeight(context) * 0.1),
              ],
            ),
          ),
        ),
      ),
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
