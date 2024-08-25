import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OFactorTypeOfFailureWidget extends StatelessWidget {
  final ValueNotifier<OFactorTypeOfFailure?> oFactorTypeOfFailure;
  final OFactorTypeOfFailure? currentValue;
  const OFactorTypeOfFailureWidget(
      {super.key,
      required this.oFactorTypeOfFailure,
      required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getViewPortWidth(context) * 0.01),
            child: Text(
              AppLocalizations.of(context).typeOfFailure,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: getSubTitleFontSize(context)),
            )),
        SizedBox(
          height: getViewPortHeight(context) * 0.01,
        ),
        Row(children: [
          Radio<OFactorTypeOfFailure>(
              value: OFactorTypeOfFailure.planar,
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
              }),
          Expanded(
              child: Text(
            AppLocalizations.of(context).planarFailure,
            style: TextStyle(fontSize: getBodyFontSize(context)),
          )),
        ]),
        Row(children: [
          Radio<OFactorTypeOfFailure>(
              value: OFactorTypeOfFailure.wedge,
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
              }),
          Expanded(
              child: Text(
            AppLocalizations.of(context).wedgeFailure,
            style: TextStyle(fontSize: getBodyFontSize(context)),
          )),
        ]),
        Row(children: [
          Radio<OFactorTypeOfFailure>(
              value: OFactorTypeOfFailure.toppling,
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
              }),
          Expanded(
              child: Text(
            AppLocalizations.of(context).toppling,
            style: TextStyle(fontSize: getBodyFontSize(context)),
          )),
        ]),
      ],
    );
  }
}
