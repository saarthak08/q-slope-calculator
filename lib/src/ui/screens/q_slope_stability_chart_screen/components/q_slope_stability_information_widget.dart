import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/generated/l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class QSlopeStabilityInformationWidget extends StatelessWidget {
  final double qSlopeValue;
  final double? slopeAngleByUser;
  final bool isSinglePoint;
  final int index;
  const QSlopeStabilityInformationWidget({
    super.key,
    required this.qSlopeValue,
    required this.isSinglePoint,
    this.slopeAngleByUser,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final vpH = getViewPortHeight(context);
    final vpW = getViewPortWidth(context);
    return Container(
      padding: EdgeInsets.only(left: vpW * 0.05, right: vpW * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          isSinglePoint
              ? Container()
              : Text(
                "${AppLocalizations.of(context).point} ${AppLocalizations.of(context).chartPointAnnotation}-${index + 1}",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: getSubTitleFontSize(context),
                ),
              ),
          Container(
            padding: EdgeInsets.only(top: vpH * 0.02),
            child: Text(
              "${AppLocalizations.of(context).qSlopeSymbol} = ${qSlopeValue.toStringAsFixed(4)}",
              style: GoogleFonts.montserrat(
                fontSize: getSubTitleFontSize(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: vpH * 0.02),
            child: Text(
              "${AppLocalizations.of(context).slopeAngleProvidedAsInput} = ${slopeAngleByUser != null ? slopeAngleByUser?.toStringAsFixed(4) : AppLocalizations.of(context).notProvided}",
              style: GoogleFonts.montserrat(
                fontSize: getSubTitleFontSize(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: vpH * 0.02),
            child: Text(
              AppLocalizations.of(context).slopeAngleQSlopeFormula,
              style: GoogleFonts.montserrat(
                fontSize: getSubTitleFontSize(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: vpH * 0.02),
            child: Text(
              "${AppLocalizations.of(context).slopeAngleSymbol} = 20 x log(${qSlopeValue.toStringAsFixed(4)}) + 65${AppLocalizations.of(context).degreesSymbol}",
              style: GoogleFonts.montserrat(
                fontSize: getSubTitleFontSize(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: vpH * 0.02),
            child: Text(
              "${AppLocalizations.of(context).slopeAngleSymbol} = ${calculateSlopeAngle(qSlopeValue).toStringAsFixed(0)}${AppLocalizations.of(context).degreesSymbol}",
              style: GoogleFonts.montserrat(
                fontSize: getSubTitleFontSize(context),
              ),
            ),
          ),
          SizedBox(height: vpH * 0.05),
        ],
      ),
    );
  }
}
