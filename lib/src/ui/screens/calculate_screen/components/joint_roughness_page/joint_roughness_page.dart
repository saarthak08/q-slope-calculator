import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_roughness_page/joint_roughness_slider_input_widget.dart';
import 'package:q_slope_calculator/src/ui/widgets/divider_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class JointRoughnessPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const JointRoughnessPage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<JointRoughnessPage> createState() => _JointRoughnessPageState();
}

class _JointRoughnessPageState extends State<JointRoughnessPage>
    with AutomaticKeepAliveClientMixin {
  final tabIndex = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jointRoughness = TextEditingController();
  final TextEditingController _jointRoughnessQuotient = TextEditingController();
  final TextEditingController _jointAlteration = TextEditingController();

  @override
  void initState() {
    QSlope qSlope = widget.qSlope.value;
    _jointRoughness.text =
        qSlope.jointCharacter?.jointRoughness.toString() ?? "";
    _jointAlteration.text =
        qSlope.jointCharacter?.jointAlteration.toString() ?? "";

    super.initState();
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
                if (_jointRoughness.text.isNotEmpty &&
                    double.tryParse(_jointRoughness.text) != null &&
                    double.parse(_jointRoughness.text) >=
                        minJointRoughnessValue &&
                    double.parse(_jointRoughness.text) <=
                        maxJointRoughnessValue &&
                    _jointAlteration.text.isNotEmpty &&
                    double.tryParse(_jointAlteration.text) != null &&
                    double.parse(_jointAlteration.text) >=
                        minJointAlterationValue &&
                    double.parse(_jointAlteration.text) <=
                        maxJointAlterationValue) {
                  QSlope qSlope = widget.qSlope.value;
                  qSlope.jointCharacter = JointCharacter();
                  qSlope.jointCharacter?.jointAlteration =
                      double.tryParse(_jointAlteration.text) ?? 1;
                  qSlope.jointCharacter?.jointRoughness =
                      double.tryParse(_jointRoughness.text) ?? 0;
                  widget.qSlope.value = qSlope;

                  widget.errorTabs.value[tabIndex] = false;
                } else {
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
                              top: getViewPortHeight(context) * 0.02,
                              bottom: getViewPortHeight(context) * 0.03),
                          child: Text(
                            AppLocalizations.of(context)
                                .joinCharacterPageAppBarTitle,
                            style: GoogleFonts.poppins(
                                fontSize: getSubtitleLargeFontSize(context),
                                color: Colors.teal),
                          ))),
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
                      top: getViewPortHeight(context) * 0.06,
                      bottom: getViewPortHeight(context) * 0.06,
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
                    height: getViewPortHeight(context) * 0.1,
                  ),
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

  @override
  bool get wantKeepAlive => true;
}
