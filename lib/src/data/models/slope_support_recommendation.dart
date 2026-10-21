/// Empirical Slope Support Categories based on Bar & Barton (2017).
enum SlopeSupportCategory {
  unsupportedNatural,
  spotBolting,
  patternBoltingMesh,
  systematicBoltingShotcrete,
  heavyCableBolting,
  slopeReprofiling,
}

/// Detailed recommendation structure for empirical rock slope support
/// based on Q-slope rating and bench height H.
class SlopeSupportRecommendation {
  final SlopeSupportCategory category;
  final int categoryNumber;
  final String title;
  final String summary;
  final String boltSpecification;
  final String shotcreteSpecification;
  final String drainageSpecification;
  final double recommendedBoltLengthMeters;
  final double? recommendedBoltSpacingMeters;
  final double? recommendedShotcreteThicknessMm;
  final bool requiresCableAnchors;
  final bool requiresSlopeFlattening;

  const SlopeSupportRecommendation({
    required this.category,
    required this.categoryNumber,
    required this.title,
    required this.summary,
    required this.boltSpecification,
    required this.shotcreteSpecification,
    required this.drainageSpecification,
    required this.recommendedBoltLengthMeters,
    this.recommendedBoltSpacingMeters,
    this.recommendedShotcreteThicknessMm,
    this.requiresCableAnchors = false,
    this.requiresSlopeFlattening = false,
  });

  static const List<SlopeSupportRecommendation> allCategories = [
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.unsupportedNatural,
      categoryNumber: 1,
      title: "Category 1: Unsupported / Natural Stable",
      summary:
          "Slope is within empirical stable limits. Artificial reinforcement is generally not required.",
      boltSpecification:
          "No systematic bolting required. Routine scaling and berm maintenance.",
      shotcreteSpecification: "None required.",
      drainageSpecification: "Surface water diversion ditches along crest.",
      recommendedBoltLengthMeters: 0.0,
    ),
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.spotBolting,
      categoryNumber: 2,
      title: "Category 2: Spot Bolting & Scaling",
      summary:
          "Near critical boundary. Spot reinforcement recommended for daylighting blocks.",
      boltSpecification:
          "Spot rock bolts (20-25mm diam, resin or cement-grouted threadbar).",
      shotcreteSpecification:
          "Localized shotcrete on friable bands if required.",
      drainageSpecification: "Crest drainage ditches and localized weep holes.",
      recommendedBoltLengthMeters: 3.0,
    ),
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.patternBoltingMesh,
      categoryNumber: 3,
      title: "Category 3: Pattern Bolting & Mesh",
      summary:
          "Slope is oversteepened. Requires pattern rock reinforcement and surface retention.",
      boltSpecification:
          "Pattern bolting on a 2.0m - 2.5m staggered diamond grid.",
      shotcreteSpecification:
          "High-tensile wire mesh or localized 50mm shotcrete.",
      drainageSpecification:
          "Sub-horizontal weep holes (50mm diam, 3m-5m deep).",
      recommendedBoltLengthMeters: 3.5,
      recommendedBoltSpacingMeters: 2.2,
    ),
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.systematicBoltingShotcrete,
      categoryNumber: 4,
      title: "Category 4: Systematic Bolting & Fibre Shotcrete",
      summary:
          "Significantly oversteepened. Systematic pattern bolting with fiber-reinforced shotcrete required.",
      boltSpecification:
          "Systematic fully grouted rebar bolts on a 1.5m - 2.0m grid.",
      shotcreteSpecification:
          "50 - 100mm fibre-reinforced shotcrete (steel or structural polymer fibres).",
      drainageSpecification:
          "Sub-horizontal drainage boreholes (10m - 15m deep, 5° uphole incline).",
      recommendedBoltLengthMeters: 4.5,
      recommendedBoltSpacingMeters: 1.8,
      recommendedShotcreteThicknessMm: 75.0,
    ),
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.heavyCableBolting,
      categoryNumber: 5,
      title: "Category 5: Heavy Support (Cable Anchors + Shotcrete)",
      summary:
          "Severely oversteepened rock mass. Requires deep pre-stressed strand cable anchors and heavy drainage.",
      boltSpecification:
          "High-capacity strand cable bolts (30-60 tonne, 10m - 25m length) with pattern bolts.",
      shotcreteSpecification:
          "100 - 150mm reinforced shotcrete with structural steel mesh.",
      drainageSpecification:
          "Comprehensive array of sub-horizontal drain holes (15m - 30m length, 5m spacing).",
      recommendedBoltLengthMeters: 12.0,
      recommendedBoltSpacingMeters: 1.5,
      recommendedShotcreteThicknessMm: 125.0,
      requiresCableAnchors: true,
    ),
    SlopeSupportRecommendation(
      category: SlopeSupportCategory.slopeReprofiling,
      categoryNumber: 6,
      title: "Category 6: Slope Reprofiling / Flattening Required",
      summary:
          "Exceeds safe practical reinforcement envelope. Bench flattening or redesign required.",
      boltSpecification: "Reinforcement uneconomical or geometrically unsafe.",
      shotcreteSpecification:
          "Not recommended without geotechnical reprofiling.",
      drainageSpecification:
          "Pre-drainage and depressurization prior to excavation.",
      recommendedBoltLengthMeters: 0.0,
      requiresSlopeFlattening: true,
    ),
  ];
}
