import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class BlockSizePageDirectMethodWidget extends StatelessWidget {
  final TextEditingController sumOfCorePiecesController;
  final TextEditingController totalDrillRunController;
  final RqdCalculationType? rqdCalculationType;
  final ValueNotifier<double?> rqd;
  const BlockSizePageDirectMethodWidget(
      {super.key,
      required this.sumOfCorePiecesController,
      required this.totalDrillRunController,
      required this.rqdCalculationType,
      required this.rqd});

  void _calculateRqd() {
    if (sumOfCorePiecesController.text.isNotEmpty &&
        totalDrillRunController.text.isNotEmpty &&
        int.tryParse(totalDrillRunController.text) != 0) {
      rqd.value = double.tryParse(calculateRqdByDirectMethod(
              double.tryParse(sumOfCorePiecesController.text) ?? 0,
              double.tryParse(totalDrillRunController.text) ?? 1)
          .toStringAsFixed(4));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          type: const TextInputType.numberWithOptions(signed: false),
          textInputAction: TextInputAction.next,
          textEditingController: sumOfCorePiecesController,
          titleText: AppLocalizations.of(context).sumOfCorePiecesTextInputTitle,
          validate: (value) {
            if (rqdCalculationType == RqdCalculationType.directMethod &&
                (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)
                  .sumOfCorePiecesTextInputRequired;
            }
            return null;
          },
          onChanged: (value) {
            _calculateRqd();
          },
          hintText: AppLocalizations.of(context).sumOfCorePiecesTextInputHint,
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
        CustomTextFormField(
          type: const TextInputType.numberWithOptions(signed: false),
          textInputAction: TextInputAction.done,
          textEditingController: totalDrillRunController,
          titleText: AppLocalizations.of(context).totalDrillRunTextInputTitle,
          validate: (value) {
            if (rqdCalculationType == RqdCalculationType.directMethod &&
                (value == null || value.isEmpty)) {
              return AppLocalizations.of(context)
                  .totalDrillRunTextInputRequired;
            }
            if (value != null && value.isNotEmpty && int.tryParse(value) == 0) {
              return AppLocalizations.of(context).totalDrillRunTextNotZero;
            }
            return null;
          },
          onChanged: (value) {
            _calculateRqd();
          },
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.05,
        ),
        Text(
          "${AppLocalizations.of(context).rockQualityDesignation} = ((${AppLocalizations.of(context).sumOfCorePieces}) / (${AppLocalizations.of(context).totalDrillRun})) x 100 %",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getViewPortHeight(context) * 0.019),
        ),
        ValueListenableBuilder(
            valueListenable: rqd,
            builder: (context, rqdValue, child) => rqdValue != null
                ? Container(
                    margin:
                        EdgeInsets.only(top: getViewPortHeight(context) * 0.03),
                    child: Text(
                      "${AppLocalizations.of(context).rockQualityDesignation} = ${rqdValue.toStringAsFixed(4)} %",
                      style: GoogleFonts.montserrat(
                          fontFeatures: [],
                          fontWeight: FontWeight.w600,
                          fontSize: getViewPortHeight(context) * 0.019),
                    ))
                : Container())
      ],
    );
  }
}
