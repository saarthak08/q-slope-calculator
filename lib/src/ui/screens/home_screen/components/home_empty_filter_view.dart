import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';

class HomeEmptyFilterView extends StatelessWidget {
  final VoidCallback onClearFilters;

  const HomeEmptyFilterView({
    super.key,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).noCalculationsMatchFilter,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(AppLocalizations.of(context).clearFilters),
            ),
          ],
        ),
      ),
    );
  }
}
