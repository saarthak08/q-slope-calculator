import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SupportActiveAssessmentCard extends StatelessWidget {
  final SlopeSupportRecommendation currentRec;

  const SupportActiveAssessmentCard({super.key, required this.currentRec});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryColor.withAlpha(80), width: 1.5),
      ),
      color: isDark ? const Color(0xFF20242D) : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.activeAssessment,
                    style: TextStyle(
                      fontSize: getCaptionFontSize(context),
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(160),
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Category ${currentRec.categoryNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              currentRec.title,
              style: TextStyle(
                fontSize: getTitleFontSize(context),
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 6),
            Text(
              currentRec.summary,
              style: TextStyle(fontSize: getBodyFontSize(context)),
              softWrap: true,
            ),
            const Divider(height: 20),

            // Quick specs
            Row(
              children: [
                Expanded(
                  child: _specBox(
                    context,
                    l10n.boltLength,
                    currentRec.recommendedBoltLengthMeters > 0
                        ? '${currentRec.recommendedBoltLengthMeters} m'
                        : l10n.none,
                  ),
                ),
                if (currentRec.recommendedBoltSpacingMeters != null)
                  Expanded(
                    child: _specBox(
                      context,
                      l10n.boltSpacing,
                      '${currentRec.recommendedBoltSpacingMeters} m',
                    ),
                  ),
                if (currentRec.recommendedShotcreteThicknessMm != null)
                  Expanded(
                    child: _specBox(
                      context,
                      l10n.shotcrete,
                      '${currentRec.recommendedShotcreteThicknessMm!.toStringAsFixed(0)} mm',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specBox(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getCaptionFontSize(context),
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getSubTitleFontSize(context),
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
