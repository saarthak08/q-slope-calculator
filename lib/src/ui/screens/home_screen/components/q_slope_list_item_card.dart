import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/widgets/stability_badge.dart';
import 'package:q_slope_calculator/src/utils/date_time_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class QSlopeListItemCard extends StatelessWidget {
  final QSlope item;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool?> onCheckboxChanged;

  const QSlopeListItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: getViewPortHeight(context) * 0.015),
      child: Row(
        children: [
          if (isSelectionMode)
            Container(
              margin: EdgeInsets.only(right: getViewPortWidth(context) * 0.005),
              child: Checkbox(value: isSelected, onChanged: onCheckboxChanged),
            ),
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(8),
              borderOnForeground: true,
              type: MaterialType.card,
              elevation: 1,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onLongPress: onLongPress,
                onTap: onTap,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context).listLocationId}: ${item.locationId ?? ''}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${AppLocalizations.of(context).listLithology}: ${item.lithology ?? ''}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    StabilityBadge(
                      qSlope: item.qSlope,
                      actualSlopeAngle: item.slopeAngleByUser,
                      showSafetyMargin: false,
                    ),
                  ],
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          "${AppLocalizations.of(context).qSlopeSymbol}: ${item.qSlope?.toStringAsFixed(4) ?? '-'}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 6,
                        child: Text(
                          item.createdAt != null
                              ? (formatDateTime(item.createdAt!) ?? '')
                              : '',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
