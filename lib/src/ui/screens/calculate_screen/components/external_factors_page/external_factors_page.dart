import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class ExternalFactorsPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const ExternalFactorsPage(
      {super.key, required this.qSlope, required this.errorTabs});

  @override
  State<ExternalFactorsPage> createState() => _ExternalFactorsPageState();
}

class _ExternalFactorsPageState extends State<ExternalFactorsPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jWice = TextEditingController();
  final tabIndex = 3;
  ExternalFactorsStructureType? _externalFactorsStructureType;
  ExternalFactorsStrengthOfRock? _externalFactorsStrengthOfRock;
  ExternalFactorsEnvironmentConditions? _externalFactorsEnvironmentConditions;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    _jWice.text = qSlope
            .externalFactors?.environmentalAndGeologicalConditionalNumber
            .toString() ??
        "";
    setState(() {
      _externalFactorsEnvironmentConditions =
          qSlope.externalFactors?.externalFactorsEnvironmentConditions;
      _externalFactorsStructureType =
          qSlope.externalFactors?.externalFactorsStructureType;
      _externalFactorsStrengthOfRock =
          qSlope.externalFactors?.externalFactorsStrengthOfRock;
    });
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
                  if (_jWice.text.isNotEmpty &&
                      double.tryParse(_jWice.text) != null &&
                      ((double.parse(_jWice.text) >= minJWiceValue &&
                          double.parse(_jWice.text) <= maxJWiceValue))) {
                    QSlope qSlope = widget.qSlope.value;
                    qSlope.externalFactors = ExternalFactors();
                    qSlope.externalFactors
                            ?.environmentalAndGeologicalConditionalNumber =
                        double.tryParse(_jWice.text) ?? 0;
                    qSlope.externalFactors
                            ?.externalFactorsEnvironmentConditions =
                        _externalFactorsEnvironmentConditions;
                    qSlope.externalFactors?.externalFactorsStrengthOfRock =
                        _externalFactorsStrengthOfRock;
                    qSlope.externalFactors?.externalFactorsStructureType =
                        _externalFactorsStructureType;
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
                                  .externalFactorsPageAppBarTitle,
                              style: GoogleFonts.poppins(
                                  fontSize: getSubtitleLargeFontSize(context),
                                  color: Colors.teal),
                            ))),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(signed: false),
                      textInputAction: TextInputAction.done,
                      textEditingController: _jWice,
                      titleText: AppLocalizations.of(context)
                          .enviornmentalAndGeologicalConditionalNumber,
                      validate: (value) {
                        if ((value == null || value.isEmpty)) {
                          return "${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} ${AppLocalizations.of(context).isRequired}";
                        }
                        if (value.isNotEmpty &&
                            ((double.tryParse(value) ?? 0) < minJWiceValue ||
                                (double.tryParse(value) ?? 0) >
                                    maxJWiceValue)) {
                          return AppLocalizations.of(context)
                              .jWiceInputConstraints;
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: getViewPortHeight(context) * 0.03,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getViewPortWidth(context) * 0.01),
                              child: Text(
                                AppLocalizations.of(context)
                                    .externalFactorStructure,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: getSubTitleFontSize(context)),
                              )),
                          Row(children: [
                            Radio<ExternalFactorsStructureType>(
                                value: ExternalFactorsStructureType.stable,
                                groupValue: _externalFactorsStructureType,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsStructureType = value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).structureStable,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<ExternalFactorsStructureType>(
                                value: ExternalFactorsStructureType.unstable,
                                groupValue: _externalFactorsStructureType,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsStructureType = value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).structureUnstable,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ])
                        ]),
                    SizedBox(
                      height: getViewPortHeight(context) * 0.03,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getViewPortWidth(context) * 0.01),
                              child: Text(
                                AppLocalizations.of(context).strengthOfRock,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: getSubTitleFontSize(context)),
                              )),
                          SizedBox(
                            height: getViewPortHeight(context) * 0.01,
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  left: getViewPortWidth(context) * 0.02),
                              child: Text(
                                AppLocalizations.of(context)
                                    .strengthOfRockCompetentNote,
                                style: GoogleFonts.openSans(
                                    color: Colors.grey.shade700,
                                    fontSize: getCaptionFontSize(context)),
                              )),
                          Row(children: [
                            Radio<ExternalFactorsStrengthOfRock>(
                                value: ExternalFactorsStrengthOfRock.competent,
                                groupValue: _externalFactorsStrengthOfRock,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsStrengthOfRock = value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context)
                                  .strengthOfRockCompetent,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<ExternalFactorsStrengthOfRock>(
                                value:
                                    ExternalFactorsStrengthOfRock.incompetent,
                                groupValue: _externalFactorsStrengthOfRock,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsStrengthOfRock = value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context)
                                  .strengthOfRockInCompetent,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ])
                        ]),
                    SizedBox(
                      height: getViewPortHeight(context) * 0.03,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getViewPortWidth(context) * 0.01),
                              child: Text(
                                AppLocalizations.of(context)
                                    .environmentalConditions,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: getSubTitleFontSize(context)),
                              )),
                          Row(children: [
                            Radio<ExternalFactorsEnvironmentConditions>(
                                value: ExternalFactorsEnvironmentConditions
                                    .desertEnvironment,
                                groupValue:
                                    _externalFactorsEnvironmentConditions,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsEnvironmentConditions =
                                        value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).desertEnvironment,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<ExternalFactorsEnvironmentConditions>(
                                value: ExternalFactorsEnvironmentConditions
                                    .wetEnvironment,
                                groupValue:
                                    _externalFactorsEnvironmentConditions,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsEnvironmentConditions =
                                        value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).wetEnvironment,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<ExternalFactorsEnvironmentConditions>(
                                value: ExternalFactorsEnvironmentConditions
                                    .tropicalStorms,
                                groupValue:
                                    _externalFactorsEnvironmentConditions,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsEnvironmentConditions =
                                        value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).tropicalStorms,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                          Row(children: [
                            Radio<ExternalFactorsEnvironmentConditions>(
                                value: ExternalFactorsEnvironmentConditions
                                    .iceWedging,
                                groupValue:
                                    _externalFactorsEnvironmentConditions,
                                onChanged: (value) {
                                  setState(() {
                                    _externalFactorsEnvironmentConditions =
                                        value;
                                  });
                                }),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).iceWedging,
                              style:
                                  TextStyle(fontSize: getBodyFontSize(context)),
                            )),
                          ]),
                        ]),
                    SizedBox(
                      height: getViewPortHeight(context) * 0.1,
                    ),
                  ],
                ),
              ))),
    );
  }

  @override
  void dispose() {
    _jWice.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
