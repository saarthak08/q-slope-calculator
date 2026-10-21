import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/barton_jrc_profile.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

/// Modal dialog or bottom sheet allowing geotechnical engineers to visually compare
/// field discontinuity roughness with the 10 canonical Barton & Choubey (1977)
/// JRC profiles and select an empirical Jr rating.
class JrcProfilometerModal extends StatelessWidget {
  final double? currentJr;
  final bool isDialog;

  const JrcProfilometerModal({
    super.key,
    this.currentJr,
    this.isDialog = false,
  });

  static Future<double?> show(BuildContext context, {double? currentJr}) {
    final bool useDialog = kIsWeb || MediaQuery.of(context).size.width > 700;

    if (useDialog) {
      return showDialog<double>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder:
            (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: JrcProfilometerModal(currentJr: currentJr, isDialog: true),
            ),
      );
    }

    return showModalBottomSheet<double>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) =>
              JrcProfilometerModal(currentJr: currentJr, isDialog: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final systemBottomPadding = mediaQuery.padding.bottom;

    if (isDialog) {
      final double dialogHeight = (mediaQuery.size.height * 0.85).clamp(
        360.0,
        750.0,
      );

      return Center(
        child: Container(
          width: min(mediaQuery.size.width * 0.95, 700),
          height: dialogHeight,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E222A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: _buildModalContent(context, theme, isDark, bottomPadding: 20),
        ),
      );
    }

    // Mobile Bottom Sheet: open to 92% screen height, docked at bottom with generous bottom margin
    final double sheetHeight = (mediaQuery.size.height * 0.92).clamp(
      400.0,
      900.0,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: min(mediaQuery.size.width, 700),
        height: sheetHeight,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E222A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: _buildModalContent(
            context,
            theme,
            isDark,
            bottomPadding: max(24.0, systemBottomPadding + 20),
          ),
        ),
      ),
    );
  }

  Widget _buildModalContent(
    BuildContext context,
    ThemeData theme,
    bool isDark, {
    required double bottomPadding,
  }) {
    return Column(
      children: [
        if (!isDialog)
          // Drag handle
          Container(
            width: 44,
            height: 5,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(100),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).jrcProfilometerTitle,
                      style: TextStyle(
                        fontSize: getTitleFontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).jrcProfilometerSubtitle,
                      style: TextStyle(
                        fontSize: getCaptionFontSize(context),
                        color: theme.textTheme.bodyMedium?.color?.withAlpha(
                          180,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: AppLocalizations.of(context).cancel,
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Profiles list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
            itemCount: BartonJrcProfile.allProfiles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final profile = BartonJrcProfile.allProfiles[index];
              final isSelected =
                  currentJr != null &&
                  (currentJr! - profile.typicalJr).abs() < 0.1;

              return InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(profile.typicalJr);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? primaryColor.withAlpha(25)
                            : (isDark
                                ? const Color(0xFF282C34)
                                : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? primaryColor
                              : (isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(35),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'JRC ${profile.jrcRangeLabel}',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getCaptionFontSize(context),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withAlpha(35),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Jr = ${profile.typicalJr}',
                                  style: TextStyle(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getCaptionFontSize(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile.description,
                        style: TextStyle(
                          fontSize: getBodyFontSize(context) * 0.9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // 2D Roughness profile waveform
                      Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF1E222A) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomPaint(
                            painter: _JrcWaveformPainter(
                              offsets: profile.normalizedCurve,
                              color: primaryColor,
                              isDark: isDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _JrcWaveformPainter extends CustomPainter {
  final List<Offset> offsets;
  final Color color;
  final bool isDark;

  _JrcWaveformPainter({
    required this.offsets,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint =
        Paint()
          ..color = isDark ? const Color(0xFF1A1D24) : const Color(0xFFF9FAFB)
          ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Center datum line
    final gridPaint =
        Paint()
          ..color = isDark ? Colors.white10 : Colors.black.withAlpha(15)
          ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(8, size.height / 2),
      Offset(size.width - 8, size.height / 2),
      gridPaint,
    );

    if (offsets.isEmpty) return;

    final path = Path();
    final double paddingX = 12.0;
    final double availW = size.width - (paddingX * 2);
    final double centerY = size.height / 2;
    final double scaleY = size.height * 0.38;

    for (int i = 0; i < offsets.length; i++) {
      final off = offsets[i];
      final px = paddingX + (off.dx * availW);
      final py = centerY - (off.dy * scaleY);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    final linePaint =
        Paint()
          ..color = color
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _JrcWaveformPainter oldDelegate) {
    return oldDelegate.offsets != offsets ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark;
  }
}
