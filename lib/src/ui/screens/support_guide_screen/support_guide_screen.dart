import 'package:flutter/material.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/components/support_active_assessment_card.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/components/support_category_reference_card.dart';
import 'package:q_slope_calculator/src/ui/screens/support_guide_screen/components/support_geometry_inputs_card.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class SupportGuideScreenArguments {
  final QSlope? qSlope;

  const SupportGuideScreenArguments({this.qSlope});
}

class SupportGuideScreen extends StatefulWidget {
  static const route = '/support-guide';

  final SupportGuideScreenArguments? arguments;

  const SupportGuideScreen({super.key, this.arguments});

  @override
  State<SupportGuideScreen> createState() => _SupportGuideScreenState();
}

class _SupportGuideScreenState extends State<SupportGuideScreen> {
  late double _benchHeight;
  late double _qSlopeVal;
  late double _actualSlopeAngle;

  @override
  void initState() {
    super.initState();
    final slope = widget.arguments?.qSlope;
    _benchHeight = slope?.benchHeight ?? 15.0;
    _qSlopeVal = slope?.qSlope ?? 0.5;
    _actualSlopeAngle = slope?.slopeAngleByUser ?? 65.0;
  }

  @override
  Widget build(BuildContext context) {
    final vpW = getViewPortWidth(context);

    final currentRec = getSlopeSupportRecommendation(
      _qSlopeVal,
      benchHeight: _benchHeight,
      actualSlopeAngle: _actualSlopeAngle,
    );

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.slopeSupportGuide,
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
          vpW > 800 ? (vpW - 800) / 2 : 16,
          16,
          vpW > 800 ? (vpW - 800) / 2 : 16,
          36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Active Geotechnical Recommendation Card
            SupportActiveAssessmentCard(currentRec: currentRec),
            const SizedBox(height: 16),

            // Controls for Bench Height & Q-Slope
            SupportGeometryInputsCard(
              benchHeight: _benchHeight,
              qSlopeVal: _qSlopeVal,
              onBenchHeightChanged: (v) => setState(() => _benchHeight = v),
              onQSlopeChanged: (v) => setState(() => _qSlopeVal = v),
            ),
            const SizedBox(height: 20),

            // All 6 Support Categories Reference Cards
            Text(
              l10n.bartonBarCategories,
              style: TextStyle(
                fontSize: getSubTitleFontSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ...SlopeSupportRecommendation.allCategories.map(
              (cat) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SupportCategoryReferenceCard(
                  cat: cat,
                  isCurrent: cat.categoryNumber == currentRec.categoryNumber,
                ),
              ),
            ),
            SizedBox(height: getViewPortHeight(context) * 0.04),
          ],
        ),
      ),
    );
  }
}
