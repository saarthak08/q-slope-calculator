import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/next_previous_buttons.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/romana_adjustment_factor_widget.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class OFactorPage extends StatefulWidget {
  final ValueNotifier<QSlope?> qSlope;
  final PageController pageController;
  final int maxPageValue;
  final ValueNotifier<int> currentPage;

  const OFactorPage(
      {super.key,
      required this.qSlope,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue});

  @override
  State<OFactorPage> createState() => _OFactorPageState();
}

class _OFactorPageState extends State<OFactorPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _oFactor = TextEditingController();
  final TextEditingController _alphaI = TextEditingController();
  final TextEditingController _alphaJ = TextEditingController();
  final TextEditingController _alphaS = TextEditingController();
  final TextEditingController _betaI = TextEditingController();
  final TextEditingController _betaJ = TextEditingController();
  final TextEditingController _betaS = TextEditingController();
  final TextEditingController f1 = TextEditingController();
  final TextEditingController f2 = TextEditingController();
  final TextEditingController f3 = TextEditingController();
  final ValueNotifier<OFactorTypeOfFailure?> _oFactorTypeOfFailure =
      ValueNotifier(null);
  OFactorCalculationType? _oFactorCalculationType;

  @override
  void initState() {
    QSlope? qSlope = widget.qSlope.value;
    if (qSlope != null) {
      _oFactor.text = qSlope.oFactor?.oFactor.toString() ?? "";
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
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getViewPortWidth(context) * 0.01),
                        child: Text(
                          AppLocalizations.of(context).oFactor,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontSize:
                                  getFontSizeAccordingToOrientation(context) *
                                      0.02),
                        )),
                    Row(children: [
                      Radio<OFactorCalculationType>(
                          value: OFactorCalculationType.value,
                          groupValue: _oFactorCalculationType,
                          onChanged: (value) {
                            setState(() {
                              _oFactorCalculationType = value;
                            });
                            _oFactor.text = "";
                          }),
                      Expanded(
                          child: Text(
                        AppLocalizations.of(context).oFactorByValue,
                        style: TextStyle(
                            fontSize:
                                getFontSizeAccordingToOrientation(context) *
                                    0.018),
                      )),
                    ]),
                    Row(children: [
                      Radio<OFactorCalculationType>(
                          value: OFactorCalculationType.romanaAdjacentFactor,
                          groupValue: _oFactorCalculationType,
                          onChanged: (value) {
                            setState(() {
                              _oFactorCalculationType = value;
                            });
                            _oFactor.text = "";
                          }),
                      Expanded(
                          child: Text(
                        AppLocalizations.of(context)
                            .oFactorByRomanaAdjustmentFactor,
                        style: TextStyle(
                            fontSize:
                                getFontSizeAccordingToOrientation(context) *
                                    0.018),
                      )),
                    ]),
                    Container(
                        margin: EdgeInsets.only(
                            top: getViewPortHeight(context) * 0.02),
                        key: const ValueKey<int>(1),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          child: _oFactorCalculationType ==
                                  OFactorCalculationType.value
                              ? CustomTextFormField(
                                  type: const TextInputType.numberWithOptions(
                                      signed: false),
                                  textInputAction: TextInputAction.done,
                                  textEditingController: _oFactor,
                                  titleText:
                                      AppLocalizations.of(context).oFactorValue,
                                  validate: (value) {
                                    if (_oFactorCalculationType ==
                                            OFactorCalculationType.value &&
                                        (value == null || value.isEmpty)) {
                                      return "${AppLocalizations.of(context).oFactor} ${AppLocalizations.of(context).isRequired}";
                                    }
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        ((double.tryParse(value) ?? 0) <
                                                minOFactorValue ||
                                            (double.tryParse(value) ?? 0) >
                                                maxOFactorValue)) {
                                      return AppLocalizations.of(context)
                                          .oFactorValueInputConstraints;
                                    }
                                    return null;
                                  },
                                )
                              : _oFactorCalculationType ==
                                      OFactorCalculationType
                                          .romanaAdjacentFactor
                                  ? OFactorRomanaAdjustmentFactorWidget(
                                      oFactorTypeOfFailure:
                                          _oFactorTypeOfFailure,
                                      alphaI: _alphaI,
                                      alphaJ: _alphaJ,
                                      alphaS: _alphaS,
                                      betaI: _betaI,
                                      betaJ: _betaJ,
                                      betaS: _betaS,
                                      f1: f1,
                                      f2: f2,
                                      f3: f3,
                                      oFactor: _oFactor)
                                  : Container(),
                        )),
                    SizedBox(
                      height: getViewPortHeight(context) * 0.1,
                    ),
                  ],
                )),
          ))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ValueListenableBuilder(
              valueListenable: _oFactor,
              builder: (context, oF, child) => NextPreviousButtons(
                    pageController: widget.pageController,
                    currentPage: widget.currentPage,
                    maxPageValue: widget.maxPageValue,
                    isNextButtonEnabled: oF.text.isNotEmpty &&
                        double.tryParse(oF.text) != null &&
                        ((_oFactorCalculationType ==
                                    OFactorCalculationType.value &&
                                double.parse(oF.text) >= minOFactorValue &&
                                double.parse(oF.text) <= maxOFactorValue) ||
                            (_oFactorCalculationType ==
                                OFactorCalculationType.romanaAdjacentFactor)),
                    onNext: () {
                      QSlope? qSlope = widget.qSlope.value;
                      if (qSlope != null) {
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
                        qSlope.oFactor?.oFactor =
                            double.tryParse(_oFactor.text) ?? 0;
                        qSlope.oFactor?.oFactorTypeOfFailure =
                            _oFactorTypeOfFailure.value;
                        qSlope.oFactor?.oFactorCalculationType =
                            _oFactorCalculationType;
                        widget.qSlope.value = qSlope;
                      }
                      return true;
                    },
                  )))
    ]);
  }

  @override
  void dispose() {
    _oFactor.dispose();
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
