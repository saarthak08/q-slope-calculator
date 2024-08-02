import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_roughness_page/joint_roughness_slider_input_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/next_previous_buttons.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class JointRoughnessPage extends StatefulWidget {
  final ValueNotifier<QSlope?> qSlope;
  final PageController pageController;
  final int maxPageValue;
  final ValueNotifier<int> currentPage;

  const JointRoughnessPage(
      {super.key,
      required this.qSlope,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue});

  @override
  State<JointRoughnessPage> createState() => _JointRoughnessPageState();
}

class _JointRoughnessPageState extends State<JointRoughnessPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jointRoughness = TextEditingController();
  final TextEditingController _jointRoughnessQuotient = TextEditingController();
  final TextEditingController _jointAlteration = TextEditingController();

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    if (qSlope != null) {
      _jointRoughness.text =
          qSlope.jointCharacter?.jointRoughness.toString() ?? "";
      _jointAlteration.text =
          qSlope.jointCharacter?.jointAlteration.toString() ?? "";
    }
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
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JointRoughnessSliderInputWidget(
                    textEditingController: _jointRoughness,
                    imagePath: Assets.jointRoughnessTable,
                    imageTitle:
                        AppLocalizations.of(context).jointRoughnessTable,
                    inputTitle: AppLocalizations.of(context).jointRoughness,
                    maxSliderValue: maxJointRoughnessValue,
                    minSliderValue: minJointRoughnessValue,
                    sliderDivisions: 7,
                    imageHeight: getViewPortHeight(context) * 0.3,
                    validateInput: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .jointRoughnessRequired;
                      }
                      if (value.isNotEmpty &&
                          ((double.tryParse(value) ?? 0) <
                                  minJointRoughnessValue ||
                              (double.tryParse(value) ?? 0) >
                                  maxJointRoughnessValue)) {
                        return AppLocalizations.of(context)
                            .jointRoughnessConstraintsValidation;
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: getViewPortHeight(context) * 0.04,
                      bottom: getViewPortHeight(context) * 0.04,
                    ),
                    child: const DividerWidget(),
                  ),
                  JointRoughnessSliderInputWidget(
                    textEditingController: _jointAlteration,
                    imagePath: Assets.jointAlterationTable,
                    imageTitle:
                        AppLocalizations.of(context).jointAlterationTable,
                    inputTitle: AppLocalizations.of(context).jointAlteration,
                    maxSliderValue: maxJointAlterationValue,
                    minSliderValue: minJointAlterationValue,
                    sliderDivisions: 77,
                    imageHeight: getViewPortHeight(context) * 0.25,
                    validateInput: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                            .jointAlterationRequired;
                      }
                      if (value.isNotEmpty &&
                          ((double.tryParse(value) ?? 0) <
                                  minJointAlterationValue ||
                              (double.tryParse(value) ?? 0) >
                                  maxJointAlterationValue)) {
                        return AppLocalizations.of(context)
                            .jointAlterationConstraintsValidation;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: getViewPortHeight(context) * 0.03,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _jointRoughness,
                      builder: (context, jR, child) => ValueListenableBuilder(
                          valueListenable: _jointAlteration,
                          builder: (context, jA, child) => NextPreviousButtons(
                                pageController: widget.pageController,
                                currentPage: widget.currentPage,
                                maxPageValue: widget.maxPageValue,
                                isNextButtonEnabled: jR.text.isNotEmpty &&
                                    double.tryParse(jR.text) != null &&
                                    double.parse(jR.text) >=
                                        minJointRoughnessValue &&
                                    double.parse(jR.text) <=
                                        maxJointRoughnessValue &&
                                    jA.text.isNotEmpty &&
                                    double.tryParse(jA.text) != null &&
                                    double.parse(jA.text) >=
                                        minJointAlterationValue &&
                                    double.parse(jA.text) <=
                                        maxJointAlterationValue,
                                onNext: () {
                                  QSlope? qSlope = widget.qSlope.value;
                                  if (qSlope != null) {
                                    qSlope.jointCharacter = JointCharacter();
                                    qSlope.jointCharacter?.jointAlteration =
                                        double.tryParse(
                                                _jointAlteration.text) ??
                                            1;
                                    qSlope.jointCharacter?.jointRoughness =
                                        double.tryParse(_jointRoughness.text) ??
                                            0;
                                    widget.qSlope.value = qSlope;
                                  }
                                  return true;
                                },
                              )))
                ],
              )),
        )));
  }

  @override
  void dispose() {
    _jointAlteration.dispose();
    _jointRoughness.dispose();
    _jointRoughnessQuotient.dispose();
    super.dispose();
  }
}
