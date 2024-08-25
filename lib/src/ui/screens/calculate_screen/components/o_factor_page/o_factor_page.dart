import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/joints_of_failure_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/o_factor_value_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/romana_adjustment_factor_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/type_of_failure_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class OFactorPage extends StatefulWidget {
  final ValueNotifier<QSlope> qSlope;
  final ValueNotifier<List<bool>> errorTabs;

  const OFactorPage({super.key, required this.qSlope, required this.errorTabs});

  @override
  State<OFactorPage> createState() => _OFactorPageState();
}

class _OFactorPageState extends State<OFactorPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _alphaI = TextEditingController();
  final TextEditingController _alphaJ = TextEditingController();
  final TextEditingController _alphaS = TextEditingController();
  final TextEditingController _betaI = TextEditingController();
  final TextEditingController _betaJ = TextEditingController();
  final TextEditingController _betaS = TextEditingController();
  final TextEditingController f1 = TextEditingController();
  final TextEditingController f2 = TextEditingController();
  final TextEditingController f3 = TextEditingController();
  final TextEditingController _joint1OFactor = TextEditingController();
  final TextEditingController _joint2OFactor = TextEditingController();
  final ValueNotifier<int?> _joint1Index = ValueNotifier(null);
  final ValueNotifier<int?> _joint2Index = ValueNotifier(null);
  final TextEditingController ratingForF1 = TextEditingController();
  final TextEditingController ratingForF2 = TextEditingController();
  final TextEditingController ratingForF3 = TextEditingController();

  final ValueNotifier<OFactorTypeOfFailure?> _oFactorTypeOfFailure =
      ValueNotifier(null);
  OFactorCalculationType? _oFactorCalculationType;
  final tabIndex = 2;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    _joint1OFactor.text = qSlope.oFactor?.oFactorForFirstJoint.toString() ?? "";
    _joint2OFactor.text =
        qSlope.oFactor?.oFactorForSecondJoint.toString() ?? "";
    _joint1Index.value = qSlope.oFactor?.indexOfFirstJoint;
    _joint2Index.value = qSlope.oFactor?.indexOfSecondJoint;
    ratingForF1.text = qSlope.oFactor?.ratingForF1?.toString() ?? "";
    ratingForF2.text = qSlope.oFactor?.ratingForF2?.toString() ?? "";
    ratingForF3.text = qSlope.oFactor?.ratingForF3?.toString() ?? "";
    _alphaI.text = qSlope.oFactor?.alphaI.toString() ?? "";
    _alphaJ.text = qSlope.oFactor?.alphaJ.toString() ?? "";
    _alphaS.text = qSlope.oFactor?.alphaS.toString() ?? "";
    _betaI.text = qSlope.oFactor?.betaI.toString() ?? "";
    _betaJ.text = qSlope.oFactor?.betaJ.toString() ?? "";
    _betaS.text = qSlope.oFactor?.betaS.toString() ?? "";
    f1.text = qSlope.oFactor?.f1.toString() ?? "";
    f2.text = qSlope.oFactor?.f2.toString() ?? "";
    f3.text = qSlope.oFactor?.f3.toString() ?? "";
    _oFactorTypeOfFailure.value = qSlope.oFactor?.oFactorTypeOfFailure;
    setState(() {
      _oFactorCalculationType = qSlope.oFactor?.oFactorCalculationType;
    });
    super.initState();
  }

  void _setQSlope() {
    if (_oFactorTypeOfFailure.value != null &&
        _oFactorCalculationType != null &&
        _joint1Index.value != null &&
        _joint1OFactor.text.isNotEmpty &&
        double.tryParse(_joint1OFactor.text) != null &&
        double.parse(_joint1OFactor.text) >= minOFactorValue &&
        double.parse(_joint1OFactor.text) <= maxOFactorValue) {
      if (_oFactorTypeOfFailure.value == OFactorTypeOfFailure.wedge &&
          _joint2Index.value == null) {
        widget.errorTabs.value[tabIndex] = true;
      } else {
        QSlope qSlope = widget.qSlope.value;
        qSlope.oFactor = OFactor();
        qSlope.oFactor?.alphaI = double.tryParse(_alphaI.text);
        qSlope.oFactor?.alphaJ = double.tryParse(_alphaJ.text);
        qSlope.oFactor?.alphaS = double.tryParse(_alphaS.text);
        qSlope.oFactor?.betaI = double.tryParse(_betaI.text);
        qSlope.oFactor?.betaJ = double.tryParse(_betaJ.text);
        qSlope.oFactor?.betaS = double.tryParse(_betaS.text);
        qSlope.oFactor?.f1 = double.tryParse(f1.text);
        qSlope.oFactor?.f2 = double.tryParse(f2.text);
        qSlope.oFactor?.f3 = double.tryParse(f3.text);
        qSlope.oFactor?.ratingForF1 = double.tryParse(ratingForF1.text);
        qSlope.oFactor?.ratingForF2 = double.tryParse(ratingForF2.text);
        qSlope.oFactor?.ratingForF3 = double.tryParse(ratingForF3.text);
        qSlope.oFactor?.oFactorForFirstJoint =
            double.tryParse(_joint1OFactor.text) ?? 0;
        qSlope.oFactor?.oFactorForSecondJoint =
            double.tryParse(_joint2OFactor.text) ?? 0;
        qSlope.oFactor?.indexOfFirstJoint = _joint1Index.value;
        qSlope.oFactor?.indexOfSecondJoint = _joint2Index.value;
        qSlope.oFactor?.oFactorTypeOfFailure = _oFactorTypeOfFailure.value;
        qSlope.oFactor?.oFactorCalculationType = _oFactorCalculationType;
        widget.qSlope.value = qSlope;
        widget.errorTabs.value[tabIndex] = false;
      }
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
                    vertical: getViewPortHeight(context) * 0.02),
                child: Form(
                    key: formKey,
                    onChanged: () {
                      formKey.currentState?.validate();
                      _setQSlope();
                    },
                    child: ValueListenableBuilder(
                        valueListenable: _oFactorTypeOfFailure,
                        builder: (context, oFactorTypeOfFailure, child) =>
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: getViewPortHeight(context) *
                                                  0.02,
                                              bottom:
                                                  getViewPortHeight(context) *
                                                      0.02),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .oFactor,
                                            style: GoogleFonts.poppins(
                                                fontSize:
                                                    getSubtitleLargeFontSize(
                                                        context),
                                                color: Colors.teal),
                                          ))),
                                  OFactorTypeOfFailureWidget(
                                      oFactorTypeOfFailure:
                                          _oFactorTypeOfFailure,
                                      currentValue: oFactorTypeOfFailure),
                                  SizedBox(
                                    height: getViewPortHeight(context) * 0.01,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _joint1Index,
                                    builder: (context, joint1Index, child) =>
                                        ValueListenableBuilder(
                                            valueListenable: _joint2Index,
                                            builder: (context, joint2Index,
                                                    child) =>
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      OFactorJointsOfFailureWidget(
                                                        setQSlope: _setQSlope,
                                                        joint1IndexValueNotifier:
                                                            _joint1Index,
                                                        joint2IndexValueNotifier:
                                                            _joint2Index,
                                                        qSlope: widget.qSlope,
                                                        joint1Index:
                                                            joint1Index,
                                                        joint2Index:
                                                            joint2Index,
                                                        oFactorTypeOfFailure:
                                                            oFactorTypeOfFailure,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            getViewPortHeight(
                                                                    context) *
                                                                0.04,
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  getViewPortWidth(
                                                                          context) *
                                                                      0.01),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .oFactorCalculation,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black87,
                                                                fontSize:
                                                                    getSubTitleFontSize(
                                                                        context)),
                                                          )),
                                                      Row(children: [
                                                        Radio<
                                                                OFactorCalculationType>(
                                                            value:
                                                                OFactorCalculationType
                                                                    .value,
                                                            groupValue:
                                                                _oFactorCalculationType,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _oFactorCalculationType =
                                                                    value;
                                                              });
                                                              _joint1OFactor
                                                                  .text = "";
                                                              _joint2OFactor
                                                                  .text = "";
                                                            }),
                                                        Expanded(
                                                            child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .oFactorByValue,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getBodyFontSize(
                                                                      context)),
                                                        )),
                                                      ]),
                                                      Row(children: [
                                                        Radio<
                                                                OFactorCalculationType>(
                                                            value: OFactorCalculationType
                                                                .romanaAdjacentFactor,
                                                            groupValue:
                                                                _oFactorCalculationType,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _oFactorCalculationType =
                                                                    value;
                                                              });
                                                              _joint1OFactor
                                                                  .text = "";
                                                              _joint2OFactor
                                                                  .text = "";
                                                            }),
                                                        Expanded(
                                                            child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .oFactorByRomanaAdjustmentFactor,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getBodyFontSize(
                                                                      context)),
                                                        )),
                                                      ]),
                                                      Container(
                                                          margin: EdgeInsets.only(
                                                              top: getViewPortHeight(
                                                                      context) *
                                                                  0.02),
                                                          key: const ValueKey<
                                                              int>(1),
                                                          child:
                                                              AnimatedSwitcher(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            transitionBuilder: (Widget
                                                                    child,
                                                                Animation<
                                                                        double>
                                                                    animation) {
                                                              return FadeTransition(
                                                                  opacity:
                                                                      animation,
                                                                  child: child);
                                                            },
                                                            child: _oFactorCalculationType ==
                                                                    OFactorCalculationType
                                                                        .value
                                                                ? OFactorValueWidget(
                                                                    joint1OFactor:
                                                                        _joint1OFactor,
                                                                    joint2OFactor:
                                                                        _joint2OFactor,
                                                                    joint1Index:
                                                                        joint1Index,
                                                                    joint2Index:
                                                                        joint2Index,
                                                                    oFactorCalculationType:
                                                                        _oFactorCalculationType,
                                                                    oFactorTypeOfFailure:
                                                                        oFactorTypeOfFailure,
                                                                  )
                                                                : _oFactorCalculationType ==
                                                                        OFactorCalculationType
                                                                            .romanaAdjacentFactor
                                                                    ? OFactorRomanaAdjustmentFactorWidget(
                                                                        setQSlope:
                                                                            _setQSlope,
                                                                        oFactorTypeOfFailure:
                                                                            oFactorTypeOfFailure,
                                                                        alphaI:
                                                                            _alphaI,
                                                                        alphaJ:
                                                                            _alphaJ,
                                                                        alphaS:
                                                                            _alphaS,
                                                                        betaI:
                                                                            _betaI,
                                                                        betaJ:
                                                                            _betaJ,
                                                                        betaS:
                                                                            _betaS,
                                                                        f1: f1,
                                                                        f2: f2,
                                                                        f3: f3,
                                                                        oFactor:
                                                                            _joint1OFactor,
                                                                        ratingForF1:
                                                                            ratingForF1,
                                                                        ratingForF2:
                                                                            ratingForF2,
                                                                        ratingForF3:
                                                                            ratingForF3,
                                                                      )
                                                                    : Container(),
                                                          )),
                                                      SizedBox(
                                                        height:
                                                            getViewPortHeight(
                                                                    context) *
                                                                0.1,
                                                      ),
                                                    ])),
                                  )
                                ]))))));
  }

  @override
  void dispose() {
    _joint1OFactor.dispose();
    _joint2OFactor.dispose();
    _joint1Index.dispose();
    _joint2Index.dispose();
    _alphaI.dispose();
    _alphaJ.dispose();
    _alphaS.dispose();
    _betaI.dispose();
    _betaJ.dispose();
    _betaS.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    _oFactorTypeOfFailure.dispose();
    super.dispose();
  }
}
