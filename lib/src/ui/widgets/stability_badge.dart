import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';

class StabilityBadge extends StatelessWidget {
  final double? qSlope;
  final double? actualSlopeAngle;
  final bool showSafetyMargin;

  const StabilityBadge({
    super.key,
    required this.qSlope,
    required this.actualSlopeAngle,
    this.showSafetyMargin = true,
  });

  @override
  Widget build(BuildContext context) {
    final status = getSlopeStabilityStatus(qSlope, actualSlopeAngle);
    final margin = calculateSafetyMargin(qSlope, actualSlopeAngle);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color fgColor;
    IconData icon;
    String statusText;

    switch (status) {
      case SlopeStabilityStatus.stable:
        bgColor =
            isDark
                ? Colors.green.shade900.withValues(alpha: 0.35)
                : Colors.green.shade50;
        fgColor = isDark ? Colors.greenAccent.shade400 : Colors.green.shade700;
        icon = Icons.check_circle_outline;
        statusText = AppLocalizations.of(context).statusStable;
        break;
      case SlopeStabilityStatus.uncertain:
        bgColor =
            isDark
                ? Colors.amber.shade900.withValues(alpha: 0.35)
                : Colors.amber.shade50;
        fgColor = isDark ? Colors.amberAccent.shade200 : Colors.orange.shade800;
        icon = Icons.warning_amber_rounded;
        statusText = AppLocalizations.of(context).statusUncertain;
        break;
      case SlopeStabilityStatus.unstable:
        bgColor =
            isDark
                ? Colors.red.shade900.withValues(alpha: 0.35)
                : Colors.red.shade50;
        fgColor = isDark ? Colors.redAccent.shade100 : Colors.red.shade700;
        icon = Icons.dangerous_outlined;
        statusText = AppLocalizations.of(context).statusUnstable;
        break;
      case SlopeStabilityStatus.unknown:
        bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade100;
        fgColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
        icon = Icons.help_outline;
        if (qSlope != null && qSlope! > 0) {
          final allowable = calculateSlopeAngle(qSlope!);
          statusText =
              "${AppLocalizations.of(context).slopeAngleSymbol} = ${allowable.toStringAsFixed(1)}°";
        } else {
          statusText = AppLocalizations.of(context).statusUnknown;
        }
        break;
    }

    final marginString =
        (margin != null && showSafetyMargin)
            ? " (Δβ: ${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(1)}°)"
            : "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fgColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fgColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              "$statusText$marginString",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
