import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/components/simulator_operating_point_card.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/components/simulator_parameter_sliders_card.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/components/simulator_stability_envelope_card.dart';
import 'package:q_slope_calculator/src/ui/screens/sensitivity_simulator_screen/components/simulator_tornado_chart.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

class SensitivitySimulatorScreenArguments {
  final QSlope? qSlope;

  const SensitivitySimulatorScreenArguments({this.qSlope});
}

class SensitivitySimulatorScreen extends StatefulWidget {
  static const route = '/sensitivity-simulator';

  final SensitivitySimulatorScreenArguments arguments;

  const SensitivitySimulatorScreen({
    super.key,
    this.arguments = const SensitivitySimulatorScreenArguments(),
  });

  @override
  State<SensitivitySimulatorScreen> createState() =>
      _SensitivitySimulatorScreenState();
}

class _SensitivitySimulatorScreenState
    extends State<SensitivitySimulatorScreen> {
  late double _rqd;
  late double _jn;
  late double _jr;
  late double _ja;
  late double _oFactor;
  late double _jwice;
  late double _srf;
  late double _actualSlopeAngle;
  late String _scenarioTitle;

  @override
  void initState() {
    super.initState();
    final slope = widget.arguments.qSlope;
    _rqd = slope?.blockSize?.rqd ?? 80.0;
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
            : 1.0;
    _oFactor = slope?.oFactor?.oFactorForFirstJoint ?? 1.0;
    _jwice =
        slope?.externalFactors?.environmentalAndGeologicalConditionalNumber ??
        0.7;
    _srf = slope?.activeStress?.srf ?? 2.5;
    _actualSlopeAngle = slope?.slopeAngleByUser ?? 60.0;
    _scenarioTitle =
        slope != null
            ? '${slope.locationId ?? "Slope"} (Simulated)'
            : 'Simulated Scenario';
  }

  double _computeQSlope() {
    return (_rqd / _jn) * (_jr / _ja) * _oFactor * (_jwice / _srf);
  }

  List<MapEntry<String, double>> _computeSensitivityImpacts() {
    final double baseQ = _computeQSlope();
    final double baseBeta = calculateSlopeAngle(baseQ);

    final double rqdHighQ =
        ((_rqd * 1.2).clamp(0.0, 100.0) / _jn) *
        (_jr / _ja) *
        _oFactor *
        (_jwice / _srf);
    final double jnHighQ =
        (_rqd / (_jn * 1.2)) * (_jr / _ja) * _oFactor * (_jwice / _srf);
    final double jrHighQ =
        (_rqd / _jn) * ((_jr * 1.2) / _ja) * _oFactor * (_jwice / _srf);
    final double jaHighQ =
        (_rqd / _jn) * (_jr / (_ja * 1.2)) * _oFactor * (_jwice / _srf);
    final double oHighQ =
        (_rqd / _jn) * (_jr / _ja) * (_oFactor * 1.2) * (_jwice / _srf);
    final double jwiceHighQ =
        (_rqd / _jn) *
        (_jr / _ja) *
        _oFactor *
        ((_jwice * 1.2).clamp(0.1, 1.0) / _srf);
    final double srfHighQ =
        (_rqd / _jn) * (_jr / _ja) * _oFactor * (_jwice / (_srf * 1.2));

    final Map<String, double> impacts = {
      'RQD (+20%)': calculateSlopeAngle(rqdHighQ) - baseBeta,
      'Jn (+20%)': calculateSlopeAngle(jnHighQ) - baseBeta,
      'Jr (+20%)': calculateSlopeAngle(jrHighQ) - baseBeta,
      'Ja (+20%)': calculateSlopeAngle(jaHighQ) - baseBeta,
      'O-Factor (+20%)': calculateSlopeAngle(oHighQ) - baseBeta,
      'Jwice (+20%)': calculateSlopeAngle(jwiceHighQ) - baseBeta,
      'SRF (+20%)': calculateSlopeAngle(srfHighQ) - baseBeta,
    };

    final sorted =
        impacts.entries.toList()
          ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    return sorted;
  }

  void _saveScenario() {
    final double qVal = _computeQSlope();
    const uuid = Uuid();
    final l10n = AppLocalizations.of(context);
    final newScenario = QSlope(
      id: uuid.v4(),
      locationId: _scenarioTitle,
      lithology: widget.arguments.qSlope?.lithology ?? l10n.simulatedRockMass,
      blockSize: BlockSize(
        rqd: _rqd,
        jointSetNumber: _jn,
        numberOfJoints: 1,
        numberOfRandomSets: 0,
      ),
      jointCharacter: JointCharacter(
        jointRoughness: [_jr],
        jointAlteration: [_ja],
      ),
      oFactor: OFactor(
        indexOfFirstJoint: 0,
        oFactorForFirstJoint: _oFactor,
        oFactorCalculationType: OFactorCalculationType.value,
      ),
      externalFactors: ExternalFactors(
        environmentalAndGeologicalConditionalNumber: _jwice,
        externalFactorsCalculationType: ExternalFactorsCalculationType.value,
      ),
      activeStress: ActiveStress(srf: _srf),
      qSlope: qVal,
      slopeAngleByUser: _actualSlopeAngle,
      createdAt: DateTime.now(),
      latitude: widget.arguments.qSlope?.latitude,
      longitude: widget.arguments.qSlope?.longitude,
      elevation: widget.arguments.qSlope?.elevation,
      benchHeight: widget.arguments.qSlope?.benchHeight,
      imagePaths:
          widget.arguments.qSlope?.imagePaths != null
              ? List.from(widget.arguments.qSlope!.imagePaths!)
              : null,
    );

    context.read<QSlopeListCubit>().saveQSlopeToList(newScenario);

    toastification.show(
      context: context,
      title: Text(l10n.scenarioSavedSuccess(_scenarioTitle)),
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vpW = getViewPortWidth(context);

    final double qVal = _computeQSlope();
    final double allowableBeta = calculateSlopeAngle(qVal);
    final double safetyMargin = allowableBeta - _actualSlopeAngle;
    final SlopeStabilityStatus status = getSlopeStabilityStatus(
      qVal,
      _actualSlopeAngle,
    );
    final support = getSlopeSupportRecommendation(
      qVal,
      actualSlopeAngle: _actualSlopeAngle,
    );
    final impacts = _computeSensitivityImpacts();

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.sensitivitySimulator,
            style: TextStyle(fontSize: getTitleFontSize(context)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_as_outlined),
            color: primaryColor,
            tooltip: l10n.saveAsScenario,
            onPressed: _saveScenario,
          ),
        ],
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
            // Live Results Operating Point
            SimulatorOperatingPointCard(
              qVal: qVal,
              actualSlopeAngle: _actualSlopeAngle,
              allowableBeta: allowableBeta,
              safetyMargin: safetyMargin,
              support: support,
            ),
            const SizedBox(height: 16),

            // Live Stability Envelope Mini Chart
            SimulatorStabilityEnvelopeCard(
              qVal: qVal,
              actualSlopeAngle: _actualSlopeAngle,
              status: status,
            ),
            const SizedBox(height: 16),

            // Tornado Parameter Impact Breakdown
            SimulatorTornadoChart(impacts: impacts),
            const SizedBox(height: 16),

            // Interactive Sliders Card
            SimulatorParameterSlidersCard(
              rqd: _rqd,
              jn: _jn,
              jr: _jr,
              ja: _ja,
              oFactor: _oFactor,
              jwice: _jwice,
              srf: _srf,
              actualSlopeAngle: _actualSlopeAngle,
              onRqdChanged: (v) => setState(() => _rqd = v),
              onJnChanged: (v) => setState(() => _jn = v),
              onJrChanged: (v) => setState(() => _jr = v),
              onJaChanged: (v) => setState(() => _ja = v),
              onOFactorChanged: (v) => setState(() => _oFactor = v),
              onJwiceChanged: (v) => setState(() => _jwice = v),
              onSrfChanged: (v) => setState(() => _srf = v),
              onActualSlopeAngleChanged:
                  (v) => setState(() => _actualSlopeAngle = v),
            ),
            SizedBox(height: getViewPortHeight(context) * 0.04),
          ],
        ),
      ),
    );
  }
}
