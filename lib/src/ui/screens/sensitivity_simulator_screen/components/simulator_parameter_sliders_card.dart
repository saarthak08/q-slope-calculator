import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SimulatorParameterSlidersCard extends StatelessWidget {
  final double rqd;
  final double jn;
  final double jr;
  final double ja;
  final double oFactor;
  final double jwice;
  final double srf;
  final double actualSlopeAngle;
  final ValueChanged<double> onRqdChanged;
  final ValueChanged<double> onJnChanged;
  final ValueChanged<double> onJrChanged;
  final ValueChanged<double> onJaChanged;
  final ValueChanged<double> onOFactorChanged;
  final ValueChanged<double> onJwiceChanged;
  final ValueChanged<double> onSrfChanged;
  final ValueChanged<double> onActualSlopeAngleChanged;

  const SimulatorParameterSlidersCard({
    super.key,
    required this.rqd,
    required this.jn,
    required this.jr,
    required this.ja,
    required this.oFactor,
    required this.jwice,
    required this.srf,
    required this.actualSlopeAngle,
    required this.onRqdChanged,
    required this.onJnChanged,
    required this.onJrChanged,
    required this.onJaChanged,
    required this.onOFactorChanged,
    required this.onJwiceChanged,
    required this.onSrfChanged,
    required this.onActualSlopeAngleChanged,
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
              l10n.interactiveParameterSliders,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            _sliderRow(
              context,
              title: '${l10n.rockQualityDesignationSymbol} (%)',
              value: rqd,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onRqdChanged,
            ),
            _sliderRow(
              context,
              title: l10n.jointSetNumber,
              value: jn,
              min: 0.5,
              max: 20,
              divisions: 39,
              onChanged: onJnChanged,
            ),
            _sliderRow(
              context,
              title: l10n.jointRoughness,
              value: jr,
              min: 0.5,
              max: 4.0,
              divisions: 35,
              onChanged: onJrChanged,
            ),
            _sliderRow(
              context,
              title: l10n.jointAlteration,
              value: ja,
              min: 0.75,
              max: 20,
              divisions: 77,
              onChanged: onJaChanged,
            ),
            _sliderRow(
              context,
              title: l10n.oFactor,
              value: oFactor,
              min: 0.25,
              max: 2.0,
              divisions: 35,
              onChanged: onOFactorChanged,
            ),
            _sliderRow(
              context,
              title: '${l10n.externalFactorsPageAppBarTitle} (Jwice)',
              value: jwice,
              min: 0.1,
              max: 1.0,
              divisions: 18,
              onChanged: onJwiceChanged,
            ),
            _sliderRow(
              context,
              title: '${l10n.activeStressPageAppBarTitle} (SRF)',
              value: srf,
              min: 0.5,
              max: 20,
              divisions: 39,
              onChanged: onSrfChanged,
            ),
            const Divider(height: 24),
            _sliderRow(
              context,
              title: l10n.actualAngle,
              value: actualSlopeAngle,
              min: 20,
              max: 90,
              divisions: 70,
              color: Colors.blueGrey,
              onChanged: onActualSlopeAngleChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderRow(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getBodyFontSize(context),
                ),
                softWrap: true,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value.toStringAsFixed(value < 10 ? 2 : 1),
              style: TextStyle(
                color: color ?? primaryColor,
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
          activeColor: color ?? primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
