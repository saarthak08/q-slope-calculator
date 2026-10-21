import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class InverseTargetAngleCard extends StatelessWidget {
  final double targetAngle;
  final double requiredQ;
  final double benchHeight;
  final ValueChanged<double> onTargetAngleChanged;
  final ValueChanged<double> onBenchHeightChanged;

  const InverseTargetAngleCard({
    super.key,
    required this.targetAngle,
    required this.requiredQ,
    required this.benchHeight,
    required this.onTargetAngleChanged,
    required this.onBenchHeightChanged,
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
            Text(
              l10n.targetSlopeAngle,
              style: TextStyle(
                fontSize: getCaptionFontSize(context),
                color: theme.textTheme.bodyMedium?.color?.withAlpha(160),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${targetAngle.toStringAsFixed(1)}°',
              style: TextStyle(
                fontSize: getTitleFontSize(context) * 1.4,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Slider(
              value: targetAngle,
              min: 20.0,
              max: 88.0,
              divisions: 68,
              activeColor: primaryColor,
              onChanged: onTargetAngleChanged,
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _metricCol(
                    context,
                    l10n.requiredQSlope,
                    requiredQ.toStringAsFixed(4),
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  child: _metricCol(
                    context,
                    l10n.benchHeight,
                    '${benchHeight.toStringAsFixed(0)} m',
                  ),
                ),
              ],
            ),
            Slider(
              value: benchHeight,
              min: 5.0,
              max: 60.0,
              divisions: 55,
              activeColor: Colors.blueGrey,
              onChanged: onBenchHeightChanged,
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
