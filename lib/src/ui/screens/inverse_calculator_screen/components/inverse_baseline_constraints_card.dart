import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';

class InverseBaselineConstraintsCard extends StatelessWidget {
  final double rqd;
  final double jn;
  final double jr;
  final double ja;
  final double oFactor;
  final ValueChanged<double> onRqdChanged;
  final ValueChanged<double> onJnChanged;
  final ValueChanged<double> onJrChanged;
  final ValueChanged<double> onJaChanged;
  final ValueChanged<double> onOFactorChanged;

  const InverseBaselineConstraintsCard({
    super.key,
    required this.rqd,
    required this.jn,
    required this.jr,
    required this.ja,
    required this.oFactor,
    required this.onRqdChanged,
    required this.onJnChanged,
    required this.onJrChanged,
    required this.onJaChanged,
    required this.onOFactorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.baselineConstraints,
          style: TextStyle(
            fontSize: getSubTitleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Sliders for rock mass baseline constraints
        _paramSlider(
          context,
          label: '${l10n.rockQualityDesignationSymbol} (%)',
          value: rqd,
          min: 10,
          max: 100,
          divisions: 90,
          onChanged: onRqdChanged,
        ),
        _paramSlider(
          context,
          label: l10n.jointSetNumber,
          value: jn,
          min: 1,
          max: 15,
          divisions: 14,
          onChanged: onJnChanged,
        ),
        _paramSlider(
          context,
          label: l10n.jointRoughness,
          value: jr,
          min: 0.5,
          max: 4.0,
          divisions: 35,
          onChanged: onJrChanged,
        ),
        _paramSlider(
          context,
          label: l10n.jointAlteration,
          value: ja,
          min: 0.75,
          max: 12.0,
          divisions: 45,
          onChanged: onJaChanged,
        ),
        _paramSlider(
          context,
          label: l10n.oFactor,
          value: oFactor,
          min: 0.25,
          max: 2.0,
          divisions: 35,
          onChanged: onOFactorChanged,
        ),
      ],
    );
  }

  Widget _paramSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
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
              value.toStringAsFixed(value < 5 ? 2 : 0),
              style: TextStyle(
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
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
