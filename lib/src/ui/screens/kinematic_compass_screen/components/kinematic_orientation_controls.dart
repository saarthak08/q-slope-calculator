import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class KinematicOrientationControls extends StatelessWidget {
  final double slopeDip;
  final double slopeDipDirection;
  final double joint1Dip;
  final double joint1DipDirection;
  final bool enableJoint2;
  final double? joint2Dip;
  final double? joint2DipDirection;
  final double frictionAngle;
  final ValueChanged<double> onSlopeDipChanged;
  final ValueChanged<double> onSlopeDipDirectionChanged;
  final ValueChanged<double> onJoint1DipChanged;
  final ValueChanged<double> onJoint1DipDirectionChanged;
  final ValueChanged<bool> onEnableJoint2Changed;
  final ValueChanged<double> onJoint2DipChanged;
  final ValueChanged<double> onJoint2DipDirectionChanged;
  final ValueChanged<double> onFrictionAngleChanged;

  const KinematicOrientationControls({
    super.key,
    required this.slopeDip,
    required this.slopeDipDirection,
    required this.joint1Dip,
    required this.joint1DipDirection,
    required this.enableJoint2,
    required this.joint2Dip,
    required this.joint2DipDirection,
    required this.frictionAngle,
    required this.onSlopeDipChanged,
    required this.onSlopeDipDirectionChanged,
    required this.onJoint1DipChanged,
    required this.onJoint1DipDirectionChanged,
    required this.onEnableJoint2Changed,
    required this.onJoint2DipChanged,
    required this.onJoint2DipDirectionChanged,
    required this.onFrictionAngleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.interactiveOrientationControls,
          style: TextStyle(
            fontSize: getSubTitleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Slope Controls
        _sliderControl(
          context,
          label: l10n.slopeDipDirectionAlphaS,
          value: slopeDipDirection,
          min: 0,
          max: 360,
          unit: '°',
          color: Colors.blue.shade700,
          onChanged: onSlopeDipDirectionChanged,
        ),
        _sliderControl(
          context,
          label: l10n.slopeDipAngleBetaS,
          value: slopeDip,
          min: 10,
          max: 90,
          unit: '°',
          color: Colors.blue.shade700,
          onChanged: onSlopeDipChanged,
        ),
        const Divider(height: 24),

        // Joint 1 Controls
        _sliderControl(
          context,
          label: l10n.joint1DipDirectionAlphaJ1,
          value: joint1DipDirection,
          min: 0,
          max: 360,
          unit: '°',
          color: Colors.red.shade700,
          onChanged: onJoint1DipDirectionChanged,
        ),
        _sliderControl(
          context,
          label: l10n.joint1DipAngleBetaJ1,
          value: joint1Dip,
          min: 5,
          max: 90,
          unit: '°',
          color: Colors.red.shade700,
          onChanged: onJoint1DipChanged,
        ),
        const Divider(height: 24),

        // Second Joint Toggle (Wedge)
        SwitchListTile(
          title: Text(l10n.includeJoint2Wedge),
          subtitle: const Text('Calculates intersection line trend & plunge'),
          value: enableJoint2,
          activeThumbColor: primaryColor,
          onChanged: onEnableJoint2Changed,
        ),

        if (enableJoint2) ...[
          _sliderControl(
            context,
            label: l10n.joint2DipDirectionAlphaJ2,
            value: joint2DipDirection ?? 160.0,
            min: 0,
            max: 360,
            unit: '°',
            color: Colors.purple.shade700,
            onChanged: onJoint2DipDirectionChanged,
          ),
          _sliderControl(
            context,
            label: l10n.joint2DipAngleBetaJ2,
            value: joint2Dip ?? 50.0,
            min: 5,
            max: 90,
            unit: '°',
            color: Colors.purple.shade700,
            onChanged: onJoint2DipChanged,
          ),
          const Divider(height: 24),
        ],

        // Friction Angle Slider
        _sliderControl(
          context,
          label: l10n.basicFrictionAnglePhi,
          value: frictionAngle,
          min: 15,
          max: 50,
          unit: '°',
          color: Colors.teal.shade700,
          onChanged: onFrictionAngleChanged,
        ),
      ],
    );
  }

  Widget _sliderControl(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getBodyFontSize(context),
                ),
                softWrap: true,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toStringAsFixed(0)}$unit',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: getBodyFontSize(context),
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: (max - min).round(),
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
