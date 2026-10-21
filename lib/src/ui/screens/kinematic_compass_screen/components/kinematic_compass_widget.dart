import 'dart:math';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

/// Interactive polar kinematic stereonet / compass visualizer.
/// Displays slope face, discontinuity planes, intersection lines,
/// and daylighting failure envelope.
class KinematicCompassWidget extends StatelessWidget {
  final double slopeDip;
  final double slopeDipDirection;
  final double joint1Dip;
  final double joint1DipDirection;
  final double? joint2Dip;
  final double? joint2DipDirection;
  final double frictionAngle;
  final double size;

  const KinematicCompassWidget({
    super.key,
    required this.slopeDip,
    required this.slopeDipDirection,
    required this.joint1Dip,
    required this.joint1DipDirection,
    this.joint2Dip,
    this.joint2DipDirection,
    this.frictionAngle = 30.0,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final result = analyzeKinematics(
      slopeDip: slopeDip,
      slopeDipDirection: slopeDipDirection,
      joint1Dip: joint1Dip,
      joint1DipDirection: joint1DipDirection,
      joint2Dip: joint2Dip,
      joint2DipDirection: joint2DipDirection,
      frictionAngle: frictionAngle,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _KinematicCompassPainter(
              slopeDip: slopeDip,
              slopeDipDirection: slopeDipDirection,
              joint1Dip: joint1Dip,
              joint1DipDirection: joint1DipDirection,
              joint2Dip: joint2Dip,
              joint2DipDirection: joint2DipDirection,
              intersectionTrend: result.intersectionTrend,
              intersectionPlunge: result.intersectionPlunge,
              frictionAngle: frictionAngle,
              isDark: isDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _legendItem(
              Colors.blue.shade700,
              '${AppLocalizations.of(context).slopeFace} (${slopeDip.toStringAsFixed(0)}° / ${slopeDipDirection.toStringAsFixed(0)}°)',
            ),
            _legendItem(
              Colors.red.shade700,
              '${AppLocalizations.of(context).joint1} (${joint1Dip.toStringAsFixed(0)}° / ${joint1DipDirection.toStringAsFixed(0)}°)',
            ),
            if (joint2Dip != null && joint2DipDirection != null)
              _legendItem(
                Colors.purple.shade700,
                '${AppLocalizations.of(context).joint2} (${joint2Dip!.toStringAsFixed(0)}° / ${joint2DipDirection!.toStringAsFixed(0)}°)',
              ),
            if (result.intersectionPlunge != null)
              _legendItem(
                Colors.amber.shade800,
                '${AppLocalizations.of(context).wedgeIntersectionLine} (${result.intersectionPlunge!.toStringAsFixed(0)}° / ${result.intersectionTrend!.toStringAsFixed(0)}°)',
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Kinematic Risk Summary Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _riskChip(
              context,
              AppLocalizations.of(context).kinematicPlanar,
              result.planarRisk,
            ),
            const SizedBox(width: 8),
            _riskChip(
              context,
              AppLocalizations.of(context).kinematicWedge,
              result.wedgeRisk,
            ),
            const SizedBox(width: 8),
            _riskChip(
              context,
              AppLocalizations.of(context).kinematicToppling,
              result.topplingRisk,
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _riskLabel(AppLocalizations l10n, KinematicRiskLevel risk) {
    switch (risk) {
      case KinematicRiskLevel.critical:
        return l10n.riskCritical;
      case KinematicRiskLevel.moderate:
        return l10n.riskModerate;
      case KinematicRiskLevel.low:
        return l10n.riskLow;
      case KinematicRiskLevel.none:
        return l10n.riskNone;
    }
  }

  Widget _riskChip(BuildContext context, String mode, KinematicRiskLevel risk) {
    final l10n = AppLocalizations.of(context);
    Color bg;
    Color fg;
    switch (risk) {
      case KinematicRiskLevel.critical:
        bg = Colors.red.shade100;
        fg = Colors.red.shade900;
        break;
      case KinematicRiskLevel.moderate:
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade900;
        break;
      case KinematicRiskLevel.low:
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade900;
        break;
      case KinematicRiskLevel.none:
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withAlpha(80)),
      ),
      child: Text(
        '$mode: ${_riskLabel(l10n, risk)}',
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: getCaptionFontSize(context) * 0.95,
        ),
      ),
    );
  }
}

class _KinematicCompassPainter extends CustomPainter {
  final double slopeDip;
  final double slopeDipDirection;
  final double joint1Dip;
  final double joint1DipDirection;
  final double? joint2Dip;
  final double? joint2DipDirection;
  final double? intersectionTrend;
  final double? intersectionPlunge;
  final double frictionAngle;
  final bool isDark;

  _KinematicCompassPainter({
    required this.slopeDip,
    required this.slopeDipDirection,
    required this.joint1Dip,
    required this.joint1DipDirection,
    this.joint2Dip,
    this.joint2DipDirection,
    this.intersectionTrend,
    this.intersectionPlunge,
    required this.frictionAngle,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 24;

    // Outer circle
    final dialPaint =
        Paint()
          ..color = isDark ? const Color(0xFF232730) : const Color(0xFFF3F4F6)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, dialPaint);

    final borderPaint =
        Paint()
          ..color = isDark ? Colors.white24 : Colors.grey.shade400
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, borderPaint);

    // Friction cone circle (radius proportional to 90 - frictionAngle)
    final frictionRadius = radius * (1.0 - (frictionAngle / 90.0));
    final frictionPaint =
        Paint()
          ..color = Colors.amber.withAlpha(isDark ? 30 : 25)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, frictionRadius, frictionPaint);

    final frictionBorder =
        Paint()
          ..color = Colors.amber.shade700.withAlpha(120)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
    canvas.drawCircle(center, frictionRadius, frictionBorder);

    // Cardinal directions
    _drawCardinalLabels(canvas, center, radius);

    // Daylighting daylight envelope arc for slope
    _drawDaylightEnvelope(canvas, center, radius);

    // Discontinuity 1 strike line and dip arrow
    _drawDiscontinuityPlane(
      canvas,
      center,
      radius,
      joint1Dip,
      joint1DipDirection,
      Colors.red.shade700,
    );

    // Discontinuity 2 if present
    if (joint2Dip != null && joint2DipDirection != null) {
      _drawDiscontinuityPlane(
        canvas,
        center,
        radius,
        joint2Dip!,
        joint2DipDirection!,
        Colors.purple.shade700,
      );
    }

    // Slope Face plane
    _drawDiscontinuityPlane(
      canvas,
      center,
      radius,
      slopeDip,
      slopeDipDirection,
      Colors.blue.shade700,
      isSlope: true,
    );

    // Wedge Intersection Pole / Vector
    if (intersectionTrend != null && intersectionPlunge != null) {
      final double rad = (intersectionTrend! - 90) * (pi / 180.0);
      // Plunge distance from center (0° = outer edge, 90° = center in stereonet)
      final double pDist = radius * (1.0 - (intersectionPlunge! / 90.0));
      final polePos = Offset(
        center.dx + (cos(rad) * pDist),
        center.dy + (sin(rad) * pDist),
      );

      final wedgePaint =
          Paint()
            ..color = Colors.amber.shade800
            ..style = PaintingStyle.fill;
      canvas.drawCircle(polePos, 6, wedgePaint);

      final wedgeBorder =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
      canvas.drawCircle(polePos, 6, wedgeBorder);
    }
  }

  void _drawCardinalLabels(Canvas canvas, Offset center, double radius) {
    const textStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawText(String text, Offset pos) {
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          pos.dx - (textPainter.width / 2),
          pos.dy - (textPainter.height / 2),
        ),
      );
    }

    drawText('N', Offset(center.dx, center.dy - radius - 12));
    drawText('S', Offset(center.dx, center.dy + radius + 12));
    drawText('E', Offset(center.dx + radius + 12, center.dy));
    drawText('W', Offset(center.dx - radius - 12, center.dy));
  }

  void _drawDaylightEnvelope(Canvas canvas, Offset center, double radius) {
    // Daylighting critical sector centered at slope dip direction
    final double radDir = (slopeDipDirection - 90) * (pi / 180.0);
    final envelopePaint =
        Paint()
          ..color = Colors.blue.withAlpha(isDark ? 25 : 20)
          ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      radDir - (pi / 4),
      pi / 2,
      true,
      envelopePaint,
    );
  }

  void _drawDiscontinuityPlane(
    Canvas canvas,
    Offset center,
    double radius,
    double dip,
    double dipDirection,
    Color color, {
    bool isSlope = false,
  }) {
    final double strikeDir1 = (dipDirection - 90 + 360) % 360;
    final double strikeDir2 = (dipDirection + 90) % 360;

    final double rad1 = (strikeDir1 - 90) * (pi / 180.0);
    final double rad2 = (strikeDir2 - 90) * (pi / 180.0);

    final p1 = Offset(
      center.dx + (cos(rad1) * radius),
      center.dy + (sin(rad1) * radius),
    );
    final p2 = Offset(
      center.dx + (cos(rad2) * radius),
      center.dy + (sin(rad2) * radius),
    );

    // Great circle arc or line representing plane strike
    final linePaint =
        Paint()
          ..color = color
          ..strokeWidth = isSlope ? 2.5 : 1.8
          ..style = PaintingStyle.stroke;
    canvas.drawLine(p1, p2, linePaint);

    // Dip direction arrow
    final double radDip = (dipDirection - 90) * (pi / 180.0);
    final double arrowDist = radius * (dip / 90.0) * 0.7;
    final arrowEnd = Offset(
      center.dx + (cos(radDip) * arrowDist),
      center.dy + (sin(radDip) * arrowDist),
    );

    final arrowPaint =
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, arrowEnd, arrowPaint);

    // Small arrow head
    final double headLen = 6.0;
    canvas.drawLine(
      arrowEnd,
      Offset(
        arrowEnd.dx - (headLen * cos(radDip - (pi / 6))),
        arrowEnd.dy - (headLen * sin(radDip - (pi / 6))),
      ),
      arrowPaint,
    );
    canvas.drawLine(
      arrowEnd,
      Offset(
        arrowEnd.dx - (headLen * cos(radDip + (pi / 6))),
        arrowEnd.dy - (headLen * sin(radDip + (pi / 6))),
      ),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _KinematicCompassPainter oldDelegate) {
    return oldDelegate.slopeDip != slopeDip ||
        oldDelegate.slopeDipDirection != slopeDipDirection ||
        oldDelegate.joint1Dip != joint1Dip ||
        oldDelegate.joint1DipDirection != joint1DipDirection ||
        oldDelegate.joint2Dip != joint2Dip ||
        oldDelegate.joint2DipDirection != joint2DipDirection ||
        oldDelegate.frictionAngle != frictionAngle ||
        oldDelegate.isDark != isDark;
  }
}
