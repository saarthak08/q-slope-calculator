import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_text_form_field.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class BlockSizePageBasicInfoWidget extends StatelessWidget {
  final TextEditingController locationIdController;
  final TextEditingController lithologyController;

  const BlockSizePageBasicInfoWidget(
      {super.key,
      required this.locationIdController,
      required this.lithologyController});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: Padding(
              padding:
                  EdgeInsets.only(bottom: getViewPortHeight(context) * 0.01),
              child: Text(
                AppLocalizations.of(context)
                    .blockSizePageBasicInformationSubTitle,
                style: GoogleFonts.poppins(
                    fontSize: getSubtitleLargeFontSize(context),
                    color: Colors.teal),
              ))),
      CustomTextFormField(
        textInputAction: TextInputAction.next,
        textEditingController: locationIdController,
        titleText: AppLocalizations.of(context).locationIdTextInputTitle,
        validate: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).locationIdTextInputRequired;
          }
          return null;
        },
      ),
      SizedBox(
        height: getViewPortHeight(context) * 0.03,
      ),
      CustomTextFormField(
        textInputAction: TextInputAction.next,
        textEditingController: lithologyController,
        titleText: AppLocalizations.of(context).lithologyTextInputTitle,
        validate: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).lithologyTextInputRequired;
          }
          return null;
        },
      )
    ]);
  }
}
