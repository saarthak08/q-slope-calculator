import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SupportCategoryReferenceCard extends StatelessWidget {
  final SlopeSupportRecommendation cat;
  final bool isCurrent;

  const SupportCategoryReferenceCard({
    super.key,
    required this.cat,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: isCurrent ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isCurrent
                ? BorderSide(color: primaryColor, width: 2.0)
                : BorderSide.none,
      ),
      color:
          isCurrent
              ? (isDark
                  ? const Color(0xFF242A36)
                  : primaryColorShade100.withAlpha(50))
              : null,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isCurrent ? primaryColor : Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cat.categoryNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cat.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getSubTitleFontSize(context),
                            color: isCurrent ? primaryColor : null,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.selected,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: getCaptionFontSize(context),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              cat.summary,
              style: TextStyle(
                fontSize: getBodyFontSize(context),
                color: theme.textTheme.bodyMedium?.color,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 10),

            // Engineering specs
            _specRow(context, l10n.rockBolting, cat.boltSpecification),
            if (cat.shotcreteSpecification.isNotEmpty)
              _specRow(
                context,
                l10n.shotcreteRetention,
                cat.shotcreteSpecification,
              ),
            if (cat.drainageSpecification.isNotEmpty)
              _specRow(
                context,
                l10n.subHorizontalDrainage,
                cat.drainageSpecification,
              ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(BuildContext context, String label, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: getBodyFontSize(context),
              fontWeight: FontWeight.w600,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: TextStyle(fontSize: getBodyFontSize(context)),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
