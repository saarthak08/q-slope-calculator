import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';
import 'package:q_slope_calculator/src/ui/widgets/stability_badge.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SimulatorOperatingPointCard extends StatelessWidget {
  final double qVal;
  final double actualSlopeAngle;
  final double allowableBeta;
  final double safetyMargin;
  final SlopeSupportRecommendation support;

  const SimulatorOperatingPointCard({
    super.key,
    required this.qVal,
    required this.actualSlopeAngle,
    required this.allowableBeta,
    required this.safetyMargin,
    required this.support,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.qSlopeRating,
                        style: TextStyle(
                          fontSize: getCaptionFontSize(context),
                          color: theme.textTheme.bodyMedium?.color?.withAlpha(
                            160,
                          ),
                        ),
                      ),
                      Text(
                        qVal.toStringAsFixed(4),
                        style: TextStyle(
                          fontSize: getTitleFontSize(context) * 1.3,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StabilityBadge(
                  qSlope: qVal,
                  actualSlopeAngle: actualSlopeAngle,
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _metricCol(
                    context,
                    l10n.allowableAngle,
                    '${allowableBeta.toStringAsFixed(1)}°',
                  ),
                ),
                Expanded(
                  child: _metricCol(
                    context,
                    l10n.actualAngle,
                    '${actualSlopeAngle.toStringAsFixed(1)}°',
                  ),
                ),
                Expanded(
                  child: _metricCol(
                    context,
                    l10n.safetyMargin,
                    '${safetyMargin >= 0 ? "+" : ""}${safetyMargin.toStringAsFixed(1)}°',
                    color:
                        safetyMargin >= 2.5
                            ? Colors.green.shade700
                            : (safetyMargin > -2.5
                                ? Colors.orange.shade700
                                : Colors.red.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Support recommendation preview chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                support.title,
                style: TextStyle(
                  fontSize: getBodyFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCol(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
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
            color: color,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
