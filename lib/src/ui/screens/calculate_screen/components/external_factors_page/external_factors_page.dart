import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/photo_view_screen/photo_view_screen.dart';
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

class _ExternalFactorsPageState extends State<ExternalFactorsPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _jWice = TextEditingController();
  final tabIndex = 3;
  ExternalFactorsStructureType? _externalFactorsStructureType;
  ExternalFactorsStrengthOfRock? _externalFactorsStrengthOfRock;
  ExternalFactorsEnvironmentConditions? _externalFactorsEnvironmentConditions;
  ExternalFactorsCalculationType? _externalFactorsCalculationType;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    _jWice.text = qSlope
            .externalFactors?.environmentalAndGeologicalConditionalNumber
            .toString() ??
        "";
    setState(() {
      _externalFactorsCalculationType =
          qSlope.externalFactors?.externalFactorsCalculationType;
      _externalFactorsEnvironmentConditions =
          qSlope.externalFactors?.externalFactorsEnvironmentConditions;
      _externalFactorsStructureType =
          qSlope.externalFactors?.externalFactorsStructureType;
      _externalFactorsStrengthOfRock =
          qSlope.externalFactors?.externalFactorsStrengthOfRock;
    });
    super.initState();
  }

  void _setQSlope() {
    if (_jWice.text.isNotEmpty &&
        double.tryParse(_jWice.text) != null &&
        ((double.parse(_jWice.text) >= minJWiceValue &&
            double.parse(_jWice.text) <= maxJWiceValue))) {
      QSlope qSlope = widget.qSlope.value;
      qSlope.externalFactors = ExternalFactors();
      qSlope.externalFactors?.environmentalAndGeologicalConditionalNumber =
          double.tryParse(_jWice.text) ?? 0;
      qSlope.externalFactors?.externalFactorsEnvironmentConditions =
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
  }

  void _calculateJwice() {
    if (_externalFactorsEnvironmentConditions != null &&
        _externalFactorsStrengthOfRock != null &&
        _externalFactorsStructureType != null) {
      _jWice.text = calculateJwice(_externalFactorsEnvironmentConditions!,
              _externalFactorsStrengthOfRock!, _externalFactorsStructureType!)
          .toStringAsFixed(4);
    }
    _setQSlope();
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
                    _setQSlope();
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
                                      fontSize:
                                          getSubtitleLargeFontSize(context),
                                      color: Colors.teal),
                                ))),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getViewPortWidth(context) * 0.01),
                            child: Text(
                              AppLocalizations.of(context).jWiceCalculationBy,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: getSubTitleFontSize(context)),
                            )),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.01,
                        ),
                        Row(children: [
                          Radio<ExternalFactorsCalculationType>(
                              value: ExternalFactorsCalculationType.value,
                              groupValue: _externalFactorsCalculationType,
                              onChanged: (value) {
                                setState(() {
                                  _externalFactorsCalculationType = value;
                                });
                              }),
                          Expanded(
                              child: Text(
                            AppLocalizations.of(context)
                                .jWiceCalculationByValue,
                            style:
                                TextStyle(fontSize: getBodyFontSize(context)),
                          )),
                        ]),
                        Row(children: [
                          Radio<ExternalFactorsCalculationType>(
                              value: ExternalFactorsCalculationType.factors,
                              groupValue: _externalFactorsCalculationType,
                              onChanged: (value) {
                                setState(() {
                                  _externalFactorsCalculationType = value;
                                });
                              }),
                          Expanded(
                              child: Text(
                            AppLocalizations.of(context)
                                .jWiceCalculcationByExternalFactors,
                            style:
                                TextStyle(fontSize: getBodyFontSize(context)),
                          )),
                        ]),
                        SizedBox(
                          height: getViewPortHeight(context) * 0.03,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          child: _externalFactorsCalculationType ==
                                  ExternalFactorsCalculationType.value
                              ? CustomTextFormField(
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
                                )
                              : _externalFactorsCalculationType ==
                                      ExternalFactorsCalculationType.factors
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 10,
                                                  child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              getViewPortWidth(
                                                                      context) *
                                                                  0.01),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .externalFactorsPageAppBarTitle,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                getSubTitleFontSize(
                                                                    context)),
                                                      ))),
                                              Flexible(
                                                  child: InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      PhotoViewScreen.route,
                                                      arguments:
                                                          const AssetImage(
                                                              Assets
                                                                  .jWiceTable));
                                                },
                                                child: const Icon(
                                                  Icons.help_outline,
                                                  size: 20,
                                                ),
                                              ))
                                            ]),
                                        SizedBox(
                                          height:
                                              getViewPortHeight(context) * 0.01,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          getViewPortWidth(
                                                                  context) *
                                                              0.01),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .externalFactorStructure,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize:
                                                            getSubTitleFontSize(
                                                                context)),
                                                  )),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsStructureType>(
                                                    value:
                                                        ExternalFactorsStructureType
                                                            .stable,
                                                    groupValue:
                                                        _externalFactorsStructureType,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsStructureType =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .structureStable,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsStructureType>(
                                                    value:
                                                        ExternalFactorsStructureType
                                                            .unstable,
                                                    groupValue:
                                                        _externalFactorsStructureType,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsStructureType =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .structureUnstable,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ])
                                            ]),
                                        SizedBox(
                                          height:
                                              getViewPortHeight(context) * 0.03,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          getViewPortWidth(
                                                                  context) *
                                                              0.01),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .strengthOfRock,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize:
                                                            getSubTitleFontSize(
                                                                context)),
                                                  )),
                                              SizedBox(
                                                height:
                                                    getViewPortHeight(context) *
                                                        0.01,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: getViewPortWidth(
                                                              context) *
                                                          0.02),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .strengthOfRockCompetentNote,
                                                    style: GoogleFonts.openSans(
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontSize:
                                                            getCaptionFontSize(
                                                                context)),
                                                  )),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsStrengthOfRock>(
                                                    value:
                                                        ExternalFactorsStrengthOfRock
                                                            .competent,
                                                    groupValue:
                                                        _externalFactorsStrengthOfRock,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsStrengthOfRock =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .strengthOfRockCompetent,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsStrengthOfRock>(
                                                    value:
                                                        ExternalFactorsStrengthOfRock
                                                            .incompetent,
                                                    groupValue:
                                                        _externalFactorsStrengthOfRock,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsStrengthOfRock =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .strengthOfRockInCompetent,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ])
                                            ]),
                                        SizedBox(
                                          height:
                                              getViewPortHeight(context) * 0.03,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          getViewPortWidth(
                                                                  context) *
                                                              0.01),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .environmentalConditions,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize:
                                                            getSubTitleFontSize(
                                                                context)),
                                                  )),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsEnvironmentConditions>(
                                                    value:
                                                        ExternalFactorsEnvironmentConditions
                                                            .desertEnvironment,
                                                    groupValue:
                                                        _externalFactorsEnvironmentConditions,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsEnvironmentConditions =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .desertEnvironment,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsEnvironmentConditions>(
                                                    value:
                                                        ExternalFactorsEnvironmentConditions
                                                            .wetEnvironment,
                                                    groupValue:
                                                        _externalFactorsEnvironmentConditions,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsEnvironmentConditions =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .wetEnvironment,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsEnvironmentConditions>(
                                                    value:
                                                        ExternalFactorsEnvironmentConditions
                                                            .tropicalStorms,
                                                    groupValue:
                                                        _externalFactorsEnvironmentConditions,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsEnvironmentConditions =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .tropicalStorms,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              Row(children: [
                                                Radio<
                                                        ExternalFactorsEnvironmentConditions>(
                                                    value:
                                                        ExternalFactorsEnvironmentConditions
                                                            .iceWedging,
                                                    groupValue:
                                                        _externalFactorsEnvironmentConditions,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _externalFactorsEnvironmentConditions =
                                                            value;
                                                      });
                                                      _calculateJwice();
                                                    }),
                                                Expanded(
                                                    child: Text(
                                                  AppLocalizations.of(context)
                                                      .iceWedging,
                                                  style: TextStyle(
                                                      fontSize: getBodyFontSize(
                                                          context)),
                                                )),
                                              ]),
                                              SizedBox(
                                                height:
                                                    getViewPortHeight(context) *
                                                        0.02,
                                              ),
                                              _externalFactorsEnvironmentConditions != null &&
                                                      _externalFactorsStrengthOfRock !=
                                                          null &&
                                                      _externalFactorsStructureType !=
                                                          null
                                                  ? Text(
                                                      "${AppLocalizations.of(context).enviornmentalAndGeologicalConditionalNumberSymbol} = ${_jWice.text}",
                                                      style: GoogleFonts.montserrat(
                                                          fontFeatures: [],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              getSubTitleFontSize(
                                                                  context)),
                                                    )
                                                  : Container(),
                                            ]),
                                        SizedBox(
                                          height:
                                              getViewPortHeight(context) * 0.1,
                                        ),
                                      ],
                                    )
                                  : Container(),
                        )
                      ])))),
    );
  }

  @override
  void dispose() {
    _jWice.dispose();
    super.dispose();
  }
}
