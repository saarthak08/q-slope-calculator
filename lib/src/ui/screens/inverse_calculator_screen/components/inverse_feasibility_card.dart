import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/sensitivity_simulator_screen.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class InverseFeasibilityCard extends StatelessWidget {
  final double targetAngle;
  final double benchHeight;
  final double currentJwice;
  final double currentSrf;
  final double requiredJwiceRatio;
  final double permissibleSrf;
  final bool drainageFeasible;
  final bool stressFeasible;
  final SlopeSupportRecommendation support;

  const InverseFeasibilityCard({
    super.key,
    required this.targetAngle,
    required this.benchHeight,
    required this.currentJwice,
    required this.currentSrf,
    required this.requiredJwiceRatio,
    required this.permissibleSrf,
    required this.drainageFeasible,
    required this.stressFeasible,
    required this.support,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
              l10n.engineeringFeasibility,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Drainage Option
            _feasibilityTile(
              context,
              title: 'Option A: Stabilization via Depressurization (Jwice)',
              description:
                  'Required Jwice with current SRF (${currentSrf.toStringAsFixed(1)}): ${requiredJwiceRatio.toStringAsFixed(2)}',
              feasible: drainageFeasible,
              feasibleText:
                  'Feasible via horizontal borehole drainage array (target Jwice = ${requiredJwiceRatio.toStringAsFixed(2)})',
              infeasibleText:
                  'Insufficient: Even completely dry rock (Jwice = 1.0) cannot safely support ${targetAngle.toStringAsFixed(0)}° without artificial support.',
            ),
            const SizedBox(height: 12),

            // Controlled Blasting / Stress Option
            _feasibilityTile(
              context,
              title: 'Option B: Stabilization via Controlled Blasting (SRF)',
              description:
                  'Permissible SRF with current Jwice (${currentJwice.toStringAsFixed(2)}): ${permissibleSrf.toStringAsFixed(1)}',
              feasible: stressFeasible,
              feasibleText:
                  'Feasible via pre-split / smooth blasting to maintain SRF ≤ ${permissibleSrf.toStringAsFixed(1)}',
              infeasibleText:
                  'Stress reduction alone is insufficient (required SRF < 1.0). Rock reinforcement or bench flattening required.',
            ),
            const SizedBox(height: 16),

            // Support Recommendations preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282C34) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.construction, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          support.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getSubTitleFontSize(context),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    support.boltSpecification,
                    style: TextStyle(fontSize: getBodyFontSize(context)),
                    softWrap: true,
                  ),
                  if (support.recommendedBoltLengthMeters > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Recommended Bolt Length: L ≈ ${support.recommendedBoltLengthMeters} m',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: getBodyFontSize(context),
                      ),
                      softWrap: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Test in Simulator Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tune),
                label: Text(l10n.openInSimulator, softWrap: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SensitivitySimulatorScreen.route,
                    arguments: SensitivitySimulatorScreenArguments(
                      qSlope: QSlope(
                        id: 'inverse_design',
                        locationId:
                            'Target ${targetAngle.toStringAsFixed(0)}° Design',
                        slopeAngleByUser: targetAngle,
                        benchHeight: benchHeight,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feasibilityTile(
    BuildContext context, {
    required String title,
    required String description,
    required bool feasible,
    required String feasibleText,
    required String infeasibleText,
  }) {
    final color = feasible ? Colors.teal : Colors.orange.shade800;
    final icon = feasible ? Icons.check_circle : Icons.warning_rounded;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getSubTitleFontSize(context),
                    color: color,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: getBodyFontSize(context),
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 6),
          Text(
            feasible ? feasibleText : infeasibleText,
            style: TextStyle(
              fontSize: getBodyFontSize(context),
              fontWeight: FontWeight.w600,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
