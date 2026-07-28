import 'package:flutter/material.dart';

import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';

class OFactorTypeOfFailureWidget extends StatelessWidget {
  final ValueNotifier<OFactorTypeOfFailure?> oFactorTypeOfFailure;
  final OFactorTypeOfFailure? currentValue;
  final ValueNotifier<int?> joint1IndexValueNotifier;
  final ValueNotifier<int?> joint2IndexValueNotifier;
  const OFactorTypeOfFailureWidget({
    super.key,
    required this.oFactorTypeOfFailure,
    required this.currentValue,
    required this.joint1IndexValueNotifier,
    required this.joint2IndexValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getViewPortWidth(context) * 0.01,
          ),
          child: Text(
            AppLocalizations.of(context).typeOfFailure,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: getSubTitleFontSize(context),
            ),
          ),
        ),
        SizedBox(height: getViewPortHeight(context) * 0.01),
        Row(
          children: [
            RadioGroup<OFactorTypeOfFailure>(
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
                joint1IndexValueNotifier.value = null;
                joint2IndexValueNotifier.value = null;
              },
              child: Radio<OFactorTypeOfFailure>(
                value: OFactorTypeOfFailure.planar,
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context).planarFailure,
                style: TextStyle(fontSize: getBodyFontSize(context)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            RadioGroup<OFactorTypeOfFailure>(
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
                joint1IndexValueNotifier.value = null;
                joint2IndexValueNotifier.value = null;
              },
              child: Radio<OFactorTypeOfFailure>(
                value: OFactorTypeOfFailure.wedge,
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context).wedgeFailure,
                style: TextStyle(fontSize: getBodyFontSize(context)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            RadioGroup<OFactorTypeOfFailure>(
              groupValue: currentValue,
              onChanged: (value) {
                oFactorTypeOfFailure.value = value;
              },
              child: Radio<OFactorTypeOfFailure>(
                value: OFactorTypeOfFailure.toppling,
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context).toppling,
                style: TextStyle(fontSize: getBodyFontSize(context)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
