import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_character_page/joint_character_value_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class JointCharacterPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const JointCharacterPage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<JointCharacterPage> createState() => _JointCharacterPageState();
}

class _JointCharacterPageState extends State<JointCharacterPage> {
  final tabIndex = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<TextEditingController> _jointRoughnessControllers;
  late List<TextEditingController> _jointWavinessControllers;
  late List<TextEditingController> _jointSmoothnessControllers;
  late List<TextEditingController> _jointAlterationControllers;
  JrCalculationType? jrCalculationType;
  int numberOfJoints = -1;

  void _initiateControllers(QSlope qSlope) {
    int? joints = qSlope.blockSize?.numberOfJoints ?? 0;
    if (joints != numberOfJoints) {
      _jointRoughnessControllers = List.generate(
          joints,
          (jointIndex) => TextEditingController(
              text: qSlope.jointCharacter?.jointRoughness?[jointIndex]
                      .toString() ??
                  ""));
      _jointAlterationControllers = List.generate(
          joints,
          (jointIndex) => TextEditingController(
              text: qSlope.jointCharacter?.jointAlteration?[jointIndex]
                      .toString() ??
                  ""));
      jrCalculationType = qSlope.jointCharacter?.jrCalculationType;
      _jointSmoothnessControllers = List.generate(
          joints,
          (jointIndex) => TextEditingController(
              text: qSlope.jointCharacter?.jointSmoothness?[jointIndex]
                      .toString() ??
                  ""));
      _jointWavinessControllers = List.generate(
          joints,
          (jointIndex) => TextEditingController(
              text: qSlope.jointCharacter?.jointWaviness?[jointIndex]
                      .toString() ??
                  ""));
      numberOfJoints = joints;
    }
  }

  void _onFormChange() {
    if (jrCalculationType != null && _jointAlterationControllers.isNotEmpty) {
      bool errors = false;
      if (jrCalculationType == JrCalculationType.jr) {
        for (var controller in _jointRoughnessControllers) {
          if (double.tryParse(controller.text) == null ||
              double.parse(controller.text) < minJointRoughnessValue ||
              double.parse(controller.text) > maxJointRoughnessValue) {
            errors = true;
            break;
          }
        }
      }
      if (jrCalculationType == JrCalculationType.palmstorm) {
        for (var controller in _jointSmoothnessControllers) {
          if (double.tryParse(controller.text) == null) {
            errors = true;
            break;
          }
        }
        for (var controller in _jointWavinessControllers) {
          if (double.tryParse(controller.text) == null) {
            errors = true;
            break;
          }
        }
      }
      for (var controller in _jointAlterationControllers) {
        if (controller.text.isEmpty ||
            double.tryParse(controller.text) == null ||
            double.parse(controller.text) < minJointAlterationValue ||
            double.parse(controller.text) > maxJointAlterationValue) {
          errors = true;
          break;
        }
      }
      if (!errors) {
        QSlope qSlope = widget.qSlope.value;
        qSlope.jointCharacter = JointCharacter();
        qSlope.jointCharacter?.jrCalculationType = jrCalculationType;
        qSlope.jointCharacter?.jointAlteration ??= List.empty(growable: true);
        for (var controller in _jointAlterationControllers) {
          qSlope.jointCharacter?.jointAlteration
              ?.add(double.tryParse(controller.text) ?? 1);
        }
        qSlope.jointCharacter?.jointRoughness ??= List.empty(growable: true);
        for (var controller in _jointRoughnessControllers) {
          qSlope.jointCharacter?.jointRoughness
              ?.add(double.tryParse(controller.text) ?? 0);
        }
        if (qSlope.jointCharacter?.jrCalculationType ==
            JrCalculationType.palmstorm) {
          qSlope.jointCharacter?.jointWaviness ??= List.empty(growable: true);
          qSlope.jointCharacter?.jointSmoothness ??= List.empty(growable: true);
          for (var controller in _jointWavinessControllers) {
            qSlope.jointCharacter?.jointWaviness
                ?.add(double.tryParse(controller.text) ?? 0);
          }
          for (var controller in _jointSmoothnessControllers) {
            qSlope.jointCharacter?.jointSmoothness
                ?.add(double.tryParse(controller.text) ?? 0);
          }
        }
        widget.qSlope.value = qSlope;
        widget.errorTabs.value[tabIndex] = false;
      } else {
        widget.errorTabs.value[tabIndex] = true;
      }
    } else {
      widget.errorTabs.value[tabIndex] = true;
    }
    widget.errorTabs.value = List.from(widget.errorTabs.value);
  }

  void _resetJrControlllers() {
    for (var controller in _jointRoughnessControllers) {
      controller.text = "";
    }
    for (var controller in _jointWavinessControllers) {
      controller.text = "";
    }
    for (var controller in _jointSmoothnessControllers) {
      controller.text = "";
    }
  }

  @override
  void initState() {
    _initiateControllers(widget.qSlope.value);
    super.initState();
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
                _onFormChange();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: getViewPortHeight(context) * 0.02,
                              bottom: getViewPortHeight(context) * 0.03),
                          child: Text(
                            AppLocalizations.of(context)
                                .joinCharacterPageAppBarTitle,
                            style: GoogleFonts.poppins(
                                fontSize: getSubtitleLargeFontSize(context),
                                color: primaryColor),
                          ))),
                  Text(
                    AppLocalizations.of(context).jointRoughness,
                    style: TextStyle(
                        fontSize: getSubTitleFontSize(context),
                        fontWeight: FontWeight.w500),
                  ),
                  Row(children: [
                    Radio<JrCalculationType>(
                        value: JrCalculationType.jr,
                        groupValue: jrCalculationType,
                        onChanged: (value) {
                          setState(() {
                            jrCalculationType = value;
                          });
                          _resetJrControlllers();
                        }),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).jointRoughnessByValue,
                      style: TextStyle(fontSize: getBodyFontSize(context)),
                    )),
                  ]),
                  Row(children: [
                    Radio<JrCalculationType>(
                        value: JrCalculationType.palmstorm,
                        groupValue: jrCalculationType,
                        onChanged: (value) {
                          setState(() {
                            jrCalculationType = value;
                          });
                          _resetJrControlllers();
                        }),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).jointRoughnessByPalmstrom,
                      style: TextStyle(fontSize: getBodyFontSize(context)),
                    )),
                  ]),
                  SizedBox(
                    height: getViewPortHeight(context) * 0.03,
                  ),
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: jrCalculationType == JrCalculationType.jr
                          ? JointCharacterValueWidget(
                              inputTitle: AppLocalizations.of(context)
                                  .jointRoughnessInputTitle,
                              imagePath: Assets.jointRoughnessTable,
                              inputPlaceholderText: AppLocalizations.of(context)
                                  .jointRoughnessSymbol,
                              validateInput: (value) {
                                if (value == null || value.isEmpty) {
                                  return "";
                                }
                                if (value.isNotEmpty &&
                                    ((double.tryParse(value) ?? 0) <
                                            minJointRoughnessValue ||
                                        (double.tryParse(value) ?? 0) >
                                            maxJointRoughnessValue)) {
                                  return "";
                                }
                                return null;
                              },
                              textEditingControllers:
                                  _jointRoughnessControllers,
                            )
                          : jrCalculationType == JrCalculationType.palmstorm
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    JointCharacterValueWidget(
                                      jointRoughnessControllers:
                                          _jointRoughnessControllers,
                                      jointSmoothnessControllers:
                                          _jointSmoothnessControllers,
                                      inputTitle: AppLocalizations.of(context)
                                          .jointWavyness,
                                      inputPlaceholderText:
                                          AppLocalizations.of(context)
                                              .jointWavynessSymbol,
                                      validateInput: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "";
                                        }
                                        return null;
                                      },
                                      textEditingControllers:
                                          _jointWavinessControllers,
                                    ),
                                    JointCharacterValueWidget(
                                      jointRoughnessControllers:
                                          _jointRoughnessControllers,
                                      jointWavynessControllers:
                                          _jointWavinessControllers,
                                      inputTitle: AppLocalizations.of(context)
                                          .jointSmoothness,
                                      inputPlaceholderText:
                                          AppLocalizations.of(context)
                                              .jointSmoothnessSymbol,
                                      validateInput: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "";
                                        }
                                        return null;
                                      },
                                      textEditingControllers:
                                          _jointSmoothnessControllers,
                                    ),
                                    JointCharacterValueWidget(
                                      readOnly: true,
                                      shouldIncludeIndexInPlaceholderText:
                                          false,
                                      inputTitle: AppLocalizations.of(context)
                                          .jointRoughnessWithLimits,
                                      inputPlaceholderText:
                                          "${AppLocalizations.of(context).jointRoughnessSymbol} = ${AppLocalizations.of(context).jointWavynessSymbol} x ${AppLocalizations.of(context).jointSmoothnessSymbol}",
                                      validateInput: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "";
                                        }
                                        if (value.isNotEmpty &&
                                            ((double.tryParse(value) ?? 0) <
                                                    minJointRoughnessValue ||
                                                (double.tryParse(value) ?? 0) >
                                                    maxJointRoughnessValue)) {
                                          return "";
                                        }
                                        return null;
                                      },
                                      textEditingControllers:
                                          _jointRoughnessControllers,
                                    ),
                                  ],
                                )
                              : Container()),
                  SizedBox(
                    height: getViewPortHeight(context) * 0.02,
                  ),
                  Text(
                    AppLocalizations.of(context).jointAlteration,
                    style: TextStyle(
                        fontSize: getSubTitleFontSize(context),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: getViewPortHeight(context) * 0.01,
                  ),
                  JointCharacterValueWidget(
                    inputTitle:
                        AppLocalizations.of(context).jointAlterationInputTitle,
                    imagePath: Assets.jointAlterationTable,
                    inputPlaceholderText:
                        AppLocalizations.of(context).jointAlterationSymbol,
                    validateInput: (value) {
                      if (value == null || value.isEmpty) {
                        return "";
                      }
                      if (value.isNotEmpty &&
                          ((double.tryParse(value) ?? 0) <
                                  minJointAlterationValue ||
                              (double.tryParse(value) ?? 0) >
                                  maxJointAlterationValue)) {
                        return "";
                      }
                      return null;
                    },
                    textEditingControllers: _jointAlterationControllers,
                  ),
                  SizedBox(
                    height: getViewPortHeight(context) * 0.1,
                  ),
                ],
              )),
        )));
  }

  @override
  void dispose() {
    for (var jointRoughnessController in _jointRoughnessControllers) {
      jointRoughnessController.dispose();
    }
    for (var jointAlterationController in _jointAlterationControllers) {
      jointAlterationController.dispose();
    }
    for (var controller in _jointWavinessControllers) {
      controller.dispose();
    }
    for (var controller in _jointSmoothnessControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
