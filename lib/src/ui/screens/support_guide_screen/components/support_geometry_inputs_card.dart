import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SupportGeometryInputsCard extends StatelessWidget {
  final double benchHeight;
  final double qSlopeVal;
  final ValueChanged<double> onBenchHeightChanged;
  final ValueChanged<double> onQSlopeChanged;

  const SupportGeometryInputsCard({
    super.key,
    required this.benchHeight,
    required this.qSlopeVal,
    required this.onBenchHeightChanged,
    required this.onQSlopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.benchGeometryInputs,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Bench Height Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.benchHeight,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${benchHeight.toStringAsFixed(1)} m',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: benchHeight,
              min: 5.0,
              max: 80.0,
              divisions: 75,
              activeColor: primaryColor,
              onChanged: onBenchHeightChanged,
            ),
            const SizedBox(height: 8),

            // Q-Slope Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.qSlopeRating,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  qSlopeVal.toStringAsFixed(4),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: qSlopeVal.clamp(0.001, 10.0),
              min: 0.001,
              max: 10.0,
              divisions: 100,
              activeColor: primaryColor,
              onChanged: onQSlopeChanged,
            ),
          ],
        ),
      ),
    );
  }
}
