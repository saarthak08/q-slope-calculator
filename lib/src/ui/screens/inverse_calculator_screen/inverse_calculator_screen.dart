import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/components/inverse_baseline_constraints_card.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/components/inverse_feasibility_card.dart';
import 'package:q_slope_calculator/src/ui/screens/inverse_calculator_screen/components/inverse_target_angle_card.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class InverseCalculatorScreenArguments {
  final QSlope? qSlope;

  const InverseCalculatorScreenArguments({this.qSlope});
}

class InverseCalculatorScreen extends StatefulWidget {
  static const route = '/inverse-calculator';

  final InverseCalculatorScreenArguments? arguments;

  const InverseCalculatorScreen({super.key, this.arguments});

  @override
  State<InverseCalculatorScreen> createState() =>
      _InverseCalculatorScreenState();
}

class _InverseCalculatorScreenState extends State<InverseCalculatorScreen> {
  late double _targetAngle;
  late double _benchHeight;
  late double _rqd;
  late double _jn;
  late double _jr;
  late double _ja;
  late double _oFactor;
  late double _currentJwice;
  late double _currentSrf;

  @override
  void initState() {
    super.initState();
    final slope = widget.arguments?.qSlope;
    _targetAngle = slope?.slopeAngleByUser ?? 70.0;
    _benchHeight = slope?.benchHeight ?? 15.0;
    _rqd = slope?.blockSize?.rqd ?? 75.0;
    _jn = slope?.blockSize?.jointSetNumber ?? 4.0;
    _jr =
        (slope?.jointCharacter?.jointRoughness != null &&
                slope!.jointCharacter!.jointRoughness!.isNotEmpty)
            ? slope.jointCharacter!.jointRoughness!.first
            : 1.5;
    _ja =
        (slope?.jointCharacter?.jointAlteration != null &&
                slope!.jointCharacter!.jointAlteration!.isNotEmpty)
            ? slope.jointCharacter!.jointAlteration!.first
            : 2.0;
    _oFactor = slope?.oFactor?.oFactorForFirstJoint ?? 0.9;
    _currentJwice =
        slope?.externalFactors?.environmentalAndGeologicalConditionalNumber ??
        0.7;
    _currentSrf = slope?.activeStress?.srf ?? 2.5;
  }

  @override
  Widget build(BuildContext context) {
    final vpW = getViewPortWidth(context);

    final double requiredQ = calculateRequiredQSlope(_targetAngle);
    final double rockMassBaselineFactor = (_rqd / _jn) * (_jr / _ja) * _oFactor;

    final double requiredJwiceRatio =
        rockMassBaselineFactor > 0
            ? (requiredQ * _currentSrf) / rockMassBaselineFactor
            : 1.0;
    final bool drainageFeasible = requiredJwiceRatio <= 1.0;

    final double permissibleSrf =
        (requiredQ > 0 && rockMassBaselineFactor > 0)
            ? (rockMassBaselineFactor * _currentJwice) / requiredQ
            : 1.0;
    final bool stressFeasible = permissibleSrf >= 1.0;

    final support = getSlopeSupportRecommendation(
      requiredQ,
      benchHeight: _benchHeight,
      actualSlopeAngle: _targetAngle,
    );

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.inverseDesignCalculator,
            style: TextStyle(fontSize: getTitleFontSize(context)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          vpW > 800 ? (vpW - 800) / 2 : 16,
          16,
          vpW > 800 ? (vpW - 800) / 2 : 16,
          36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Slope Angle & Required Q-Slope Card
            InverseTargetAngleCard(
              targetAngle: _targetAngle,
              requiredQ: requiredQ,
              benchHeight: _benchHeight,
              onTargetAngleChanged: (v) => setState(() => _targetAngle = v),
              onBenchHeightChanged: (v) => setState(() => _benchHeight = v),
            ),
            const SizedBox(height: 16),

            // Engineering Requirements & Feasibility
            InverseFeasibilityCard(
              targetAngle: _targetAngle,
              benchHeight: _benchHeight,
              currentJwice: _currentJwice,
              currentSrf: _currentSrf,
              requiredJwiceRatio: requiredJwiceRatio,
              permissibleSrf: permissibleSrf,
              drainageFeasible: drainageFeasible,
              stressFeasible: stressFeasible,
              support: support,
            ),
            const SizedBox(height: 16),

            // Baseline Rock Mass Constraints Card
            InverseBaselineConstraintsCard(
              rqd: _rqd,
              jn: _jn,
              jr: _jr,
              ja: _ja,
              oFactor: _oFactor,
              onRqdChanged: (v) => setState(() => _rqd = v),
              onJnChanged: (v) => setState(() => _jn = v),
              onJrChanged: (v) => setState(() => _jr = v),
              onJaChanged: (v) => setState(() => _ja = v),
              onOFactorChanged: (v) => setState(() => _oFactor = v),
            ),
            SizedBox(height: getViewPortHeight(context) * 0.04),
          ],
        ),
      ),
    );
  }
}
