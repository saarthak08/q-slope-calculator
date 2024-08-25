import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OFactorRatingWidget extends StatelessWidget {
  final OFactorTypeOfFailure? oFactorTypeOfFailure;
  final TextEditingController f1;
  final TextEditingController f2;
  final TextEditingController f3;
  final TextEditingController ratingForF1;
  final TextEditingController ratingForF2;
  final TextEditingController ratingForF3;

  const OFactorRatingWidget(
      {super.key,
      required this.oFactorTypeOfFailure,
      required this.f1,
      required this.f2,
      required this.f3,
      required this.ratingForF1,
      required this.ratingForF2,
      required this.ratingForF3});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppLocalizations.of(context).ratingForF1} = ${AppLocalizations.of(context).formulaForRatingForF1}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.02,
        ),
        Text(
          "${AppLocalizations.of(context).ratingForF2} = ${AppLocalizations.of(context).formulaForRatingForF2}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.02,
        ),
        Text(
          oFactorTypeOfFailure == OFactorTypeOfFailure.toppling
              ? "${AppLocalizations.of(context).ratingForF3} = ${AppLocalizations.of(context).formulaForRatingForF3ForTopplingFailure}"
              : "${AppLocalizations.of(context).ratingForF3} = ${AppLocalizations.of(context).formulaForRatingForF3ForNonTopplingFailure}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
        Text(
          "${AppLocalizations.of(context).ratingForF1} = ${ratingForF1.text}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.02,
        ),
        Text(
          "${AppLocalizations.of(context).ratingForF2} = ${ratingForF2.text}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.02,
        ),
        Text(
          "${AppLocalizations.of(context).ratingForF3} = ${ratingForF3.text}",
          style: GoogleFonts.montserrat(
              fontFeatures: [],
              fontWeight: FontWeight.w600,
              fontSize: getSubTitleFontSize(context)),
        ),
        SizedBox(
          height: getViewPortHeight(context) * 0.03,
        ),
      ],
    );
  }
}
