import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OFactorValueWidget extends StatelessWidget {
  final OFactorCalculationType? oFactorCalculationType;
  final OFactorTypeOfFailure? oFactorTypeOfFailure;
  final TextEditingController joint1OFactor;
  final TextEditingController joint2OFactor;
  final int? joint1Index;
  final int? joint2Index;

  const OFactorValueWidget(
      {super.key,
      this.oFactorCalculationType,
      this.oFactorTypeOfFailure,
      required this.joint1OFactor,
      required this.joint2OFactor,
      this.joint1Index,
      this.joint2Index});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CustomTextFormField(
              type: const TextInputType.numberWithOptions(signed: false),
              textInputAction: TextInputAction.done,
              textEditingController: joint1OFactor,
              titleText:
                  "${AppLocalizations.of(context).oFactorValueFor} ${AppLocalizations.of(context).jointSymbol}${(joint1Index ?? 0) + 1} ${AppLocalizations.of(context).oFactorConstraints}",
              validate: (value) {
                if (oFactorCalculationType == OFactorCalculationType.value &&
                    (value == null || value.isEmpty)) {
                  return "";
                }
                if (value != null &&
                    value.isNotEmpty &&
                    ((double.tryParse(value) ?? 0) < minOFactorValue ||
                        (double.tryParse(value) ?? 0) > maxOFactorValue)) {
                  return "";
                }
                return null;
              },
            ),
          ),
          oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
              ? Flexible(
                  child: Container(
                  margin:
                      EdgeInsets.only(left: getViewPortWidth(context) * 0.02),
                  child: CustomTextFormField(
                    type: const TextInputType.numberWithOptions(signed: false),
                    textInputAction: TextInputAction.done,
                    textEditingController: joint2OFactor,
                    titleText:
                        "${AppLocalizations.of(context).oFactorValueFor} ${AppLocalizations.of(context).jointSymbol}${(joint2Index ?? 1) + 1} ${AppLocalizations.of(context).oFactorConstraints}",
                    validate: (value) {
                      if (oFactorCalculationType ==
                              OFactorCalculationType.value &&
                          (value == null || value.isEmpty)) {
                        return "";
                      }
                      if (value != null &&
                          value.isNotEmpty &&
                          ((double.tryParse(value) ?? 0) < minOFactorValue ||
                              (double.tryParse(value) ?? 0) >
                                  maxOFactorValue)) {
                        return "";
                      }
                      return null;
                    },
                  ),
                ))
              : Container()
        ]);
  }
}
