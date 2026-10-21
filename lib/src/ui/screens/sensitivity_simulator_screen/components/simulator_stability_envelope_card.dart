import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SimulatorStabilityEnvelopeCard extends StatelessWidget {
  final double qVal;
  final double actualSlopeAngle;
  final SlopeStabilityStatus status;

  const SimulatorStabilityEnvelopeCard({
    super.key,
    required this.qVal,
    required this.actualSlopeAngle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.liveStabilityEnvelope,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                primaryXAxis: const LogarithmicAxis(
                  title: AxisTitle(text: 'Q-Slope'),
                  minimum: 0.001,
                  maximum: 100,
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Slope Angle (degrees)'),
                  minimum: 0,
                  maximum: 90,
                  interval: 15,
                ),
                series: <CartesianSeries>[
                  // Line of best fit for stable slopes
                  LineSeries<CartesianCoordinates, double>(
                    dataSource: lineOfBestFitForStableSlopesCoordindates,
                    xValueMapper: (CartesianCoordinates c, _) => c.x,
                    yValueMapper: (CartesianCoordinates c, _) => c.y,
                    color: Colors.blue.shade700,
                    width: 2,
                    name: 'Stable Boundary (β = 20logQ + 65)',
                  ),
                  // Dynamic Active Operating Point
                  ScatterSeries<CartesianCoordinates, double>(
                    dataSource: [
                      CartesianCoordinates(
                        x: qVal.clamp(0.001, 100),
                        y: actualSlopeAngle.clamp(0, 90),
                      ),
                    ],
                    xValueMapper: (CartesianCoordinates c, _) => c.x,
                    yValueMapper: (CartesianCoordinates c, _) => c.y,
                    color:
                        status == SlopeStabilityStatus.stable
                            ? Colors.green
                            : (status == SlopeStabilityStatus.uncertain
                                ? Colors.orange
                                : Colors.red),
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 14,
                      width: 14,
                      shape: DataMarkerType.diamond,
                    ),
                    name: 'Current Operating Point',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
