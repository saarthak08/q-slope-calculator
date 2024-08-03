import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/next_previous_buttons.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class ExternalFactorsPage extends StatefulWidget {
  final ValueNotifier<QSlope?> qSlope;
  final PageController pageController;
  final int maxPageValue;
  final ValueNotifier<int> currentPage;

  const ExternalFactorsPage(
      {super.key,
      required this.qSlope,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue});

  @override
  State<ExternalFactorsPage> createState() => _ExternalFactorsPageState();
}

class _ExternalFactorsPageState extends State<ExternalFactorsPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jWice = TextEditingController();
  ExternalFactorsStructureType? _externalFactorsStructureType;
  ExternalFactorsStrengthOfRock? _externalFactorsStrengthOfRock;
  ExternalFactorsEnvironmentConditions? _externalFactorsEnvironmentConditions;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    if (qSlope != null) {
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
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
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
                        CustomTextFormField(
                          type: const TextInputType.numberWithOptions(
                              signed: false),
                          textInputAction: TextInputAction.done,
                          textEditingController: _jWice,
                          titleText: AppLocalizations.of(context)
                              .enviornmentalAndGeologicalConditionalNumber,
                          validate: (value) {
                            if ((value == null || value.isEmpty)) {
                              return "${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} ${AppLocalizations.of(context).isRequired}";
                            }
                            if (value.isNotEmpty &&
                                ((double.tryParse(value) ?? 0) <
                                        minJWiceValue ||
                                    (double.tryParse(value) ?? 0) >
                                        maxJWiceValue)) {
                              return AppLocalizations.of(context)
                                  .jWiceInputConstraints;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.02,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getViewPortWidth(context) * 0.01),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .externalFactorStructure,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize:
                                            getViewPortHeight(context) * 0.02),
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
                                )),
                              ]),
                              Row(children: [
                                Radio<ExternalFactorsStructureType>(
                                    value:
                                        ExternalFactorsStructureType.unstable,
                                    groupValue: _externalFactorsStructureType,
                                    onChanged: (value) {
                                      setState(() {
                                        _externalFactorsStructureType = value;
                                      });
                                    }),
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .structureUnstable,
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
                                )),
                              ])
                            ]),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.02,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getViewPortWidth(context) * 0.01),
                                  child: Text(
                                    AppLocalizations.of(context).strengthOfRock,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize:
                                            getViewPortHeight(context) * 0.02),
                                  )),
                              Row(children: [
                                Radio<ExternalFactorsStrengthOfRock>(
                                    value:
                                        ExternalFactorsStrengthOfRock.competent,
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
                                )),
                              ]),
                              Row(children: [
                                Radio<ExternalFactorsStrengthOfRock>(
                                    value: ExternalFactorsStrengthOfRock
                                        .incompetent,
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
                                )),
                              ])
                            ]),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.02,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getViewPortWidth(context) * 0.01),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .environmentalConditions,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize:
                                            getViewPortHeight(context) * 0.02),
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
                                  AppLocalizations.of(context)
                                      .desertEnvironment,
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
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
                                  style: TextStyle(
                                      fontSize:
                                          getViewPortHeight(context) * 0.018),
                                )),
                              ]),
                            ]),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.1,
                        ),
                      ],
                    ),
                  )))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ValueListenableBuilder(
              valueListenable: _jWice,
              builder: (context, jWice, child) => NextPreviousButtons(
                    pageController: widget.pageController,
                    currentPage: widget.currentPage,
                    maxPageValue: widget.maxPageValue,
                    isNextButtonEnabled: jWice.text.isNotEmpty &&
                        double.tryParse(jWice.text) != null &&
                        ((double.parse(jWice.text) >= minJWiceValue &&
                            double.parse(jWice.text) <= maxJWiceValue)),
                    onNext: () {
                      QSlope? qSlope = widget.qSlope.value;
                      if (qSlope != null) {
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
                      }
                      return true;
                    },
                  )))
    ]);
  }

  @override
  void dispose() {
    _jWice.dispose();
    super.dispose();
  }
}
