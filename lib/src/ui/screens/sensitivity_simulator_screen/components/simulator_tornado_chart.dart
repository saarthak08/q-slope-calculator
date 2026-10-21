import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SimulatorTornadoChart extends StatelessWidget {
  final List<MapEntry<String, double>> impacts;

  const SimulatorTornadoChart({super.key, required this.impacts});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxImpact = impacts.fold<double>(
      0.1,
      (max, e) => e.value.abs() > max ? e.value.abs() : max,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.parameterSensitivityRanking,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.parameterSensitivityDesc,
              style: TextStyle(
                fontSize: getCaptionFontSize(context),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            ...impacts.map((entry) {
              final double normalized = (entry.value.abs() / maxImpact).clamp(
                0.05,
                1.0,
              );
              return _tornadoBar(context, entry.key, entry.value, normalized);
            }),
          ],
        ),
      ),
    );
  }

  Widget _tornadoBar(
    BuildContext context,
    String name,
    double impact,
    double normalizedWidth,
  ) {
    final bool isPositive = impact >= 0;
    final Color barColor = isPositive ? primaryColor : Colors.deepOrange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getBodyFontSize(context),
              ),
              softWrap: true,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: normalizedWidth,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: barColor.withAlpha(190),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              '${isPositive ? "+" : ""}${impact.toStringAsFixed(2)}°',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getBodyFontSize(context) * 0.9,
                color: barColor,
              ),
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
