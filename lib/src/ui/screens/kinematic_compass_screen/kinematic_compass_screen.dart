import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/components/kinematic_compass_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/components/kinematic_orientation_controls.dart';
import 'package:q_slope_calculator/src/ui/screens/kinematic_compass_screen/components/kinematic_risk_assessment_card.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class KinematicCompassScreenArguments {
  final double slopeDip;
  final double slopeDipDirection;
  final double joint1Dip;
  final double joint1DipDirection;
  final double? joint2Dip;
  final double? joint2DipDirection;
  final double frictionAngle;

  const KinematicCompassScreenArguments({
    this.slopeDip = 65.0,
    this.slopeDipDirection = 120.0,
    this.joint1Dip = 45.0,
    this.joint1DipDirection = 115.0,
    this.joint2Dip,
    this.joint2DipDirection,
    this.frictionAngle = 30.0,
  });
}

class KinematicCompassScreen extends StatefulWidget {
  static const route = '/kinematic-compass';

  final KinematicCompassScreenArguments? arguments;

  const KinematicCompassScreen({super.key, this.arguments});

  @override
  State<KinematicCompassScreen> createState() => _KinematicCompassScreenState();
}

class _KinematicCompassScreenState extends State<KinematicCompassScreen> {
  late double _slopeDip;
  late double _slopeDipDirection;
  late double _joint1Dip;
  late double _joint1DipDirection;
  late double? _joint2Dip;
  late double? _joint2DipDirection;
  late double _frictionAngle;
  late bool _enableJoint2;

  @override
  void initState() {
    super.initState();
    final args = widget.arguments ?? const KinematicCompassScreenArguments();
    _slopeDip = args.slopeDip;
    _slopeDipDirection = args.slopeDipDirection;
    _joint1Dip = args.joint1Dip;
    _joint1DipDirection = args.joint1DipDirection;
    _joint2Dip = args.joint2Dip;
    _joint2DipDirection = args.joint2DipDirection;
    _frictionAngle = args.frictionAngle;
    _enableJoint2 = args.joint2Dip != null && args.joint2DipDirection != null;
  }

  @override
  Widget build(BuildContext context) {
    final vpW = getViewPortWidth(context);

    final analysis = analyzeKinematics(
      slopeDip: _slopeDip,
      slopeDipDirection: _slopeDipDirection,
      joint1Dip: _joint1Dip,
      joint1DipDirection: _joint1DipDirection,
      joint2Dip: _enableJoint2 ? _joint2Dip : null,
      joint2DipDirection: _enableJoint2 ? _joint2DipDirection : null,
      frictionAngle: _frictionAngle,
    );

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.kinematicCompass,
          style: TextStyle(fontSize: getTitleFontSize(context)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          vpW > 700 ? (vpW - 700) / 2 : 16,
          16,
          vpW > 700 ? (vpW - 700) / 2 : 16,
          36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Compass Visualizer Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: KinematicCompassWidget(
                  slopeDip: _slopeDip,
                  slopeDipDirection: _slopeDipDirection,
                  joint1Dip: _joint1Dip,
                  joint1DipDirection: _joint1DipDirection,
                  joint2Dip: _enableJoint2 ? _joint2Dip : null,
                  joint2DipDirection:
                      _enableJoint2 ? _joint2DipDirection : null,
                  frictionAngle: _frictionAngle,
                  size: 260,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Assessment Verdict Card
            KinematicRiskAssessmentCard(analysis: analysis),
            const SizedBox(height: 16),

            // Interactive Orientation Controls
            KinematicOrientationControls(
              slopeDip: _slopeDip,
              slopeDipDirection: _slopeDipDirection,
              joint1Dip: _joint1Dip,
              joint1DipDirection: _joint1DipDirection,
              enableJoint2: _enableJoint2,
              joint2Dip: _joint2Dip,
              joint2DipDirection: _joint2DipDirection,
              frictionAngle: _frictionAngle,
              onSlopeDipChanged: (v) => setState(() => _slopeDip = v),
              onSlopeDipDirectionChanged:
                  (v) => setState(() => _slopeDipDirection = v),
              onJoint1DipChanged: (v) => setState(() => _joint1Dip = v),
              onJoint1DipDirectionChanged:
                  (v) => setState(() => _joint1DipDirection = v),
              onEnableJoint2Changed: (v) {
                setState(() {
                  _enableJoint2 = v;
                  if (v && _joint2Dip == null) {
                    _joint2Dip = 50.0;
                    _joint2DipDirection = 160.0;
                  }
                });
              },
              onJoint2DipChanged: (v) => setState(() => _joint2Dip = v),
              onJoint2DipDirectionChanged:
                  (v) => setState(() => _joint2DipDirection = v),
              onFrictionAngleChanged: (v) => setState(() => _frictionAngle = v),
            ),
            SizedBox(height: getViewPortHeight(context) * 0.04),
          ],
        ),
      ),
    );
  }
}
