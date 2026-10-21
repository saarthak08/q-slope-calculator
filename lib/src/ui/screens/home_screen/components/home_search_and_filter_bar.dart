import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope_sort_option.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

export 'package:q_slope_calculator/src/data/models/q_slope_sort_option.dart';

class HomeSearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode? focusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final SlopeStabilityStatus? selectedStatus;
  final ValueChanged<SlopeStabilityStatus?> onStatusFilterChanged;
  final QSlopeSortOption selectedSort;
  final ValueChanged<QSlopeSortOption> onSortChanged;

  const HomeSearchAndFilterBar({
    super.key,
    required this.searchController,
    this.focusNode,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.selectedStatus,
    required this.onStatusFilterChanged,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: searchController,
                    focusNode: focusNode,
                    onTapOutside: (event) {
                      focusNode?.unfocus();
                    },
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchPlaceholder,
                      hintStyle: TextStyle(
                        fontSize: getCaptionFontSize(context),
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                        size: 20,
                      ),
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: onSearchCleared,
                              )
                              : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: primaryColorShade100,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color:
                              isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<QSlopeSortOption>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(Icons.sort, color: primaryColor, size: 20),
                ),
                tooltip: AppLocalizations.of(context).sortBy,
                onSelected: onSortChanged,
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: QSlopeSortOption.dateNewest,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.dateNewest)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortDateNewest),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: QSlopeSortOption.dateOldest,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.dateOldest)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortDateOldest),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: QSlopeSortOption.qSlopeHigh,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.qSlopeHigh)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortQSlopeHigh),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: QSlopeSortOption.qSlopeLow,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.qSlopeLow)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortQSlopeLow),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: QSlopeSortOption.locationAZ,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.locationAZ)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortLocationAZ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: QSlopeSortOption.locationZA,
                        child: Row(
                          children: [
                            if (selectedSort == QSlopeSortOption.locationZA)
                              Icon(Icons.check, size: 16, color: primaryColor)
                            else
                              const SizedBox(width: 16),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).sortLocationZA),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: AppLocalizations.of(context).filterAll,
                  isSelected: selectedStatus == null,
                  onSelected: () => onStatusFilterChanged(null),
                  context: context,
                ),
                const SizedBox(width: 6),
                _buildFilterChip(
                  label: AppLocalizations.of(context).statusStable,
                  color: Colors.green,
                  isSelected: selectedStatus == SlopeStabilityStatus.stable,
                  onSelected:
                      () => onStatusFilterChanged(
                        selectedStatus == SlopeStabilityStatus.stable
                            ? null
                            : SlopeStabilityStatus.stable,
                      ),
                  context: context,
                ),
                const SizedBox(width: 6),
                _buildFilterChip(
                  label: AppLocalizations.of(context).statusUncertain,
                  color: Colors.orange,
                  isSelected: selectedStatus == SlopeStabilityStatus.uncertain,
                  onSelected:
                      () => onStatusFilterChanged(
                        selectedStatus == SlopeStabilityStatus.uncertain
                            ? null
                            : SlopeStabilityStatus.uncertain,
                      ),
                  context: context,
                ),
                const SizedBox(width: 6),
                _buildFilterChip(
                  label: AppLocalizations.of(context).statusUnstable,
                  color: Colors.red,
                  isSelected: selectedStatus == SlopeStabilityStatus.unstable,
                  onSelected:
                      () => onStatusFilterChanged(
                        selectedStatus == SlopeStabilityStatus.unstable
                            ? null
                            : SlopeStabilityStatus.unstable,
                      ),
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    Color? color,
    required bool isSelected,
    required VoidCallback onSelected,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? primaryColor;

    return FilterChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color:
              isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
      selectedColor: effectiveColor,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      side: BorderSide(
        color:
            isSelected
                ? effectiveColor
                : (color?.withValues(alpha: 0.5) ??
                    (isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      onSelected: (_) => onSelected(),
    );
  }
}
