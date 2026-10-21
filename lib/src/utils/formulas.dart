import 'dart:math';

import 'package:q_slope_calculator/src/data/models/cartesian_coordinates.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/kinematic_analysis.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/models/slope_stability_status.dart';
import 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';

export 'package:q_slope_calculator/src/data/models/barton_jrc_profile.dart';
export 'package:q_slope_calculator/src/data/models/cartesian_coordinates.dart';
export 'package:q_slope_calculator/src/data/models/kinematic_analysis.dart';
export 'package:q_slope_calculator/src/data/models/slope_stability_status.dart';
export 'package:q_slope_calculator/src/data/models/slope_support_recommendation.dart';

/// This library contains all the empirical mathematical formulas
/// required for calculating Q-Slope parameters such as RQD, Joint Volume (Jv),
/// and the final Q-Slope stability angle.

double minJointRoughnessValue = 0.5;
double maxJointRoughnessValue = 4;
double minJointAlterationValue = 0.75;
double maxJointAlterationValue = 20;
double minOFactorValue = 0.25;
double maxOFactorValue = 2;

double f2ForToppling = 1;

double minJWiceValue = 0.05;
double maxJWiceValue = 1;

double minSRFa = 0;
double maxSRFa = 20;
double minSRFb = 1;
double maxSRFb = 200;
double minSRFc = 1;
double maxSRFc = 24;

double calculateRqdByDirectMethod(
  double sumOfCorePieces,
  double totalDrillRun,
) {
  if (totalDrillRun <= 0) return 0;
  return (sumOfCorePieces * 100) / totalDrillRun;
}

double calculateJointVolume(
  int numberOfRandomSets,
  List<double> jointSpacings,
  double area,
) {
  double reverseJointSpacingSum = 0;
  for (var spacing in jointSpacings) {
    if (spacing > 0) {
      reverseJointSpacingSum = reverseJointSpacingSum + (1 / spacing);
    }
  }
  final double randomComponent =
      (area > 0) ? (numberOfRandomSets / (5 * sqrt(area))) : 0;
  return reverseJointSpacingSum + randomComponent;
}

double calculateRqdByTwoPointFiveJv(double jv) {
  return 110 - (2.5 * jv);
}

double calculateRqdByThreePointThreeJv(double jv) {
  return 115 - (3.3 * jv);
}

double calculateF1ForPlanarFailure(double alphaJ, double alphaS) {
  double result = (alphaJ - alphaS).abs();
  if (result > 180) {
    result = 360 - result;
  }
  return result;
}

double calculateF1ForWedgeFailure(double alphaI, double alphaS) {
  double result = (alphaI - alphaS).abs();
  if (result > 180) {
    result = 360 - result;
  }
  return result;
}

double calculateF1ForTopplingFailure(double alphaJ, double alphaS) {
  double result = (alphaJ - alphaS).abs();
  if (result <= 180) {
    return 180 - result;
  } else {
    return result - 180;
  }
}

double calculateF3ForPlanarFailure(double betaJ, double betaS) {
  return betaJ - betaS;
}

double calculateF3ForWedgeFailure(double betaI, double betaS) {
  return betaI - betaS;
}

double calculateF3ForTopplingFailure(double betaJ, double betaS) {
  return betaJ + betaS;
}

double calculateOFactorByRomananAdjustmentFactor(
  double f1,
  double f2,
  double f3,
) {
  return 1.9759 * (exp(0.0339 * (f1 * f2 * f3)));
}

double calculateQSlope(QSlope qSlope) {
  OFactor? oFactor = qSlope.oFactor;
  double qSlopeValue;
  if (oFactor != null) {
    final jrList = qSlope.jointCharacter?.jointRoughness;
    final jaList = qSlope.jointCharacter?.jointAlteration;
    final int idx1 =
        (oFactor.indexOfFirstJoint != null &&
                jrList != null &&
                oFactor.indexOfFirstJoint! >= 0 &&
                oFactor.indexOfFirstJoint! < jrList.length)
            ? oFactor.indexOfFirstJoint!
            : 0;
    final double rawJr1 =
        (jrList != null && jrList.isNotEmpty && idx1 < jrList.length)
            ? jrList[idx1]
            : 1.0;
    final double rawJa1 =
        (jaList != null && jaList.isNotEmpty && idx1 < jaList.length)
            ? jaList[idx1]
            : 1.0;
    final double jr1 = rawJr1 > 0 ? rawJr1 : 1.0;
    final double ja1 = rawJa1 > 0 ? rawJa1 : 1.0;

    final double rqd = qSlope.blockSize?.rqd ?? 0;
    final double jn =
        (qSlope.blockSize?.jointSetNumber != null &&
                qSlope.blockSize!.jointSetNumber! > 0)
            ? qSlope.blockSize!.jointSetNumber!
            : (qSlope.blockSize?.numberOfJoints != null &&
                    qSlope.blockSize!.numberOfJoints! > 0
                ? qSlope.blockSize!.numberOfJoints!.toDouble()
                : 1.0);
    final double jwice =
        (qSlope.externalFactors?.environmentalAndGeologicalConditionalNumber !=
                    null &&
                qSlope
                        .externalFactors!
                        .environmentalAndGeologicalConditionalNumber! >
                    0)
            ? qSlope
                .externalFactors!
                .environmentalAndGeologicalConditionalNumber!
            : 1.0;
    final double srf =
        (qSlope.activeStress?.srf != null && qSlope.activeStress!.srf! > 0)
            ? qSlope.activeStress!.srf!
            : 1.0;
    final double o1 =
        (oFactor.oFactorForFirstJoint != null &&
                oFactor.oFactorForFirstJoint! > 0)
            ? oFactor.oFactorForFirstJoint!
            : 1.0;

    qSlopeValue = (rqd / jn) * (jr1 / ja1) * o1 * (jwice / srf);

    // Second joint factor is strictly for wedge failure mechanism
    if (oFactor.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge) {
      if (oFactor.oFactorForSecondJoint != null &&
          oFactor.oFactorForSecondJoint! > 0) {
        qSlopeValue = qSlopeValue * oFactor.oFactorForSecondJoint!;
      }
      if (oFactor.indexOfSecondJoint != null) {
        final int idx2 =
            (jrList != null &&
                    oFactor.indexOfSecondJoint! >= 0 &&
                    oFactor.indexOfSecondJoint! < jrList.length)
                ? oFactor.indexOfSecondJoint!
                : 0;
        final double rawJr2 =
            (jrList != null && jrList.isNotEmpty && idx2 < jrList.length)
                ? jrList[idx2]
                : 1.0;
        final double rawJa2 =
            (jaList != null && jaList.isNotEmpty && idx2 < jaList.length)
                ? jaList[idx2]
                : 1.0;
        final double jr2 = rawJr2 > 0 ? rawJr2 : 1.0;
        final double ja2 = rawJa2 > 0 ? rawJa2 : 1.0;
        qSlopeValue = qSlopeValue * (jr2 / ja2);
      }
    }
    return qSlopeValue;
  }
  return 0;
}

double calculateRatingForF1(double f1) {
  return (16.0 / 25.0) -
      ((3.0 / 500.0) * (180 / pi) * (atan((1.0 / 10.0) * (f1.abs() - 17))));
}

double calculateRatingForF2(double f2) {
  return (9.0 / 16.0) +
      ((1.0 / 195.0) * (180 / pi) * (atan(((17.0 / 100.0) * f2) - 5)));
}

double calculateRatingForF3NonTopplingFailure(double f3) {
  return -30.0 + ((1.0 / 3.0) * (180 / pi) * atan(f3));
}

double calculateRatingForF3TopplingFailure(double f3) {
  return -13.0 - ((1.0 / 7.0) * (180 / pi) * atan(f3 - 120));
}

double calculateJointSetNumber(
  double numberOfJointSets,
  double numberOfRandomSets,
) {
  if (numberOfJointSets == 0) {
    return 0.5;
  } else if (numberOfJointSets == 1 && numberOfRandomSets == 0) {
    return 2;
  } else if (numberOfJointSets == 1 && numberOfRandomSets > 0) {
    return 3;
  } else if (numberOfJointSets == 2 && numberOfRandomSets == 0) {
    return 4;
  } else if (numberOfJointSets == 2 && numberOfRandomSets > 0) {
    return 6;
  } else if (numberOfJointSets == 3 && numberOfRandomSets == 0) {
    return 9;
  } else if (numberOfJointSets == 3 && numberOfRandomSets > 0) {
    return 12;
  } else if (numberOfJointSets == 4) {
    return 15;
  } else {
    return 20;
  }
}

double calculateJwice(
  ExternalFactorsEnvironmentConditions environmentalConditions,
  ExternalFactorsStrengthOfRock strengthOfRock,
  ExternalFactorsStructureType structureType,
) {
  if (environmentalConditions ==
      ExternalFactorsEnvironmentConditions.desertEnvironment) {
    if (structureType == ExternalFactorsStructureType.stable) {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 1.0;
      } else {
        return 0.7;
      }
    } else {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.8;
      } else {
        return 0.5;
      }
    }
  } else if (environmentalConditions ==
      ExternalFactorsEnvironmentConditions.iceWedging) {
    if (structureType == ExternalFactorsStructureType.stable) {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.7;
      } else {
        return 0.6;
      }
    } else {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.5;
      } else {
        return 0.3;
      }
    }
  } else if (environmentalConditions ==
      ExternalFactorsEnvironmentConditions.tropicalStorms) {
    if (structureType == ExternalFactorsStructureType.stable) {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.5;
      } else {
        return 0.3;
      }
    } else {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.1;
      } else {
        return 0.05;
      }
    }
  } else {
    if (structureType == ExternalFactorsStructureType.stable) {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.9;
      } else {
        return 0.5;
      }
    } else {
      if (strengthOfRock == ExternalFactorsStrengthOfRock.competent) {
        return 0.3;
      } else {
        return 0.2;
      }
    }
  }
}

double calculateSlopeAngle(double qSlope) {
  if (qSlope <= 0) return 0;
  return ((log(qSlope) / log(10)) * 20) + 65;
}

/// Calculates the safety margin in degrees (allowable slope angle - actual slope angle).
/// A positive value indicates the actual angle is flatter than allowable (stable margin).
/// A negative value indicates the actual angle is steeper than allowable (oversteepened).
double? calculateSafetyMargin(double? qSlope, double? actualSlopeAngle) {
  if (qSlope == null ||
      qSlope <= 0 ||
      actualSlopeAngle == null ||
      actualSlopeAngle <= 0) {
    return null;
  }
  return calculateSlopeAngle(qSlope) - actualSlopeAngle;
}

/// Evaluates empirical slope stability with a ±2.5° tolerance band around the boundary line:
/// - [SlopeStabilityStatus.stable]: actual angle <= allowable - 2.5°
/// - [SlopeStabilityStatus.uncertain]: within ±2.5° of the allowable boundary
/// - [SlopeStabilityStatus.unstable]: actual angle > allowable + 2.5°
/// - [SlopeStabilityStatus.unknown]: actual slope angle or qSlope is not provided
SlopeStabilityStatus getSlopeStabilityStatus(
  double? qSlope,
  double? actualSlopeAngle,
) {
  if (qSlope == null ||
      qSlope <= 0 ||
      actualSlopeAngle == null ||
      actualSlopeAngle <= 0) {
    return SlopeStabilityStatus.unknown;
  }
  double margin = calculateSafetyMargin(qSlope, actualSlopeAngle)!;
  if (margin >= 2.5) {
    return SlopeStabilityStatus.stable;
  } else if (margin > -2.5) {
    return SlopeStabilityStatus.uncertain;
  } else {
    return SlopeStabilityStatus.unstable;
  }
}

List<CartesianCoordinates> lineOfBestFitForStableSlopesCoordindates = [
  CartesianCoordinates(x: 0.01, y: 25),
  CartesianCoordinates(x: 0.1, y: 45),
  CartesianCoordinates(x: 1, y: 65),
  CartesianCoordinates(x: 10, y: 85),
];

List<CartesianCoordinates> stableSlopeAreaCoordinates = [
  CartesianCoordinates(x: 0.00447, y: 0),
  CartesianCoordinates(x: 0.00447, y: 18),
  CartesianCoordinates(x: 1, y: 65),
  CartesianCoordinates(x: 10, y: 85),
  CartesianCoordinates(x: 100, y: 85),
];

List<CartesianCoordinates> unstableSlopeAreaCoordinates = [
  CartesianCoordinates(x: 0.001, y: 90),
  CartesianCoordinates(x: 10, y: 90),
  CartesianCoordinates(x: 0.00447, y: 22),
  CartesianCoordinates(x: 0.001, y: 22),
];

List<CartesianCoordinates> uncertainSlopeStabilityCoordinates = [
  CartesianCoordinates(x: 0.001, y: 0),
  CartesianCoordinates(x: 0.00447, y: 0),
  CartesianCoordinates(x: 0.00447, y: 18),
  CartesianCoordinates(x: 10, y: 85),
  CartesianCoordinates(x: 100, y: 85),
  CartesianCoordinates(x: 100, y: 90),
  CartesianCoordinates(x: 10, y: 90),
  CartesianCoordinates(x: 0.00447, y: 22),
  CartesianCoordinates(x: 0.001, y: 22),
];

/// Inverse Slope Design:
/// Calculates the required Q-slope to achieve a specified target slope angle (β).
/// From β = 20 * log10(Q_slope) + 65 => Q_req = 10^((β - 65) / 20)
double calculateRequiredQSlope(double targetSlopeAngle) {
  if (targetSlopeAngle <= 0 || targetSlopeAngle >= 90) {
    throw ArgumentError("Target slope angle must be between 0 and 90 degrees");
  }
  return pow(10, (targetSlopeAngle - 65) / 20).toDouble();
}

/// Calculates the required Jwice (environmental/drainage) factor to achieve a target slope angle
/// given fixed rock mass parameters (RQD, Jn, Jr, Ja, O) and active stress (SRF).
double calculateRequiredJwice({
  required double targetSlopeAngle,
  required double rqd,
  required double jn,
  required double jr,
  required double ja,
  required double oFactor,
  required double srf,
}) {
  final double qReq = calculateRequiredQSlope(targetSlopeAngle);
  final double safeJn = jn > 0 ? jn : 1.0;
  final double safeJa = ja > 0 ? ja : 1.0;
  final double safeO = oFactor > 0 ? oFactor : 1.0;
  final double safeSrf = srf > 0 ? srf : 1.0;
  final double rockMassFactor = (rqd / safeJn) * (jr / safeJa) * safeO;
  if (rockMassFactor <= 0) return 0;
  return (qReq * safeSrf) / rockMassFactor;
}

/// Calculates the maximum permissible SRF (stress reduction factor / blasting disturbance)
/// to achieve a target slope angle given fixed rock mass parameters and drainage (Jwice).
double calculateRequiredSRF({
  required double targetSlopeAngle,
  required double rqd,
  required double jn,
  required double jr,
  required double ja,
  required double oFactor,
  required double jwice,
}) {
  final double qReq = calculateRequiredQSlope(targetSlopeAngle);
  if (qReq <= 0) return 1;
  final double safeJn = jn > 0 ? jn : 1.0;
  final double safeJa = ja > 0 ? ja : 1.0;
  final double safeO = oFactor > 0 ? oFactor : 1.0;
  final double safeJwice = jwice > 0 ? jwice : 1.0;
  final double rockMassFactor = (rqd / safeJn) * (jr / safeJa) * safeO;
  return (rockMassFactor * safeJwice) / qReq;
}

/// Computes the empirical rock slope support category and specifications
/// according to Bar & Barton (2017) based on Q-slope, bench height H, and actual slope angle.
SlopeSupportRecommendation getSlopeSupportRecommendation(
  double qSlope, {
  double? benchHeight,
  double? actualSlopeAngle,
}) {
  final double h = benchHeight ?? 15.0; // Standard 15m bench default
  final double? margin = calculateSafetyMargin(qSlope, actualSlopeAngle);

  // Determine category based on safety margin and Q-slope
  if (margin != null) {
    if (margin >= 2.5) {
      return const SlopeSupportRecommendation(
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
      );
    } else if (margin >= -2.5) {
      final double boltL = max(2.5, 2.0 + (0.15 * h));
      return SlopeSupportRecommendation(
        category: SlopeSupportCategory.spotBolting,
        categoryNumber: 2,
        title: "Category 2: Spot Bolting & Scaling",
        summary:
            "Near critical boundary. Spot reinforcement recommended for daylighting blocks.",
        boltSpecification:
            "Spot rock bolts (20-25mm diam, resin or cement-grouted threadbar).",
        shotcreteSpecification:
            "Localized shotcrete on friable bands if required.",
        drainageSpecification:
            "Crest drainage ditches and localized weep holes.",
        recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
      );
    } else if (margin >= -7.5) {
      final double boltL = max(3.0, 2.0 + (0.15 * h));
      return SlopeSupportRecommendation(
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
        recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
        recommendedBoltSpacingMeters: 2.2,
      );
    } else if (margin >= -15.0) {
      final double boltL = max(3.5, 2.0 + (0.18 * h));
      return SlopeSupportRecommendation(
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
        recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
        recommendedBoltSpacingMeters: 1.8,
        recommendedShotcreteThicknessMm: 75.0,
      );
    } else if (margin >= -22.5) {
      final double boltL = max(10.0, 0.40 * h);
      return SlopeSupportRecommendation(
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
        recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
        recommendedBoltSpacingMeters: 1.5,
        recommendedShotcreteThicknessMm: 125.0,
        requiresCableAnchors: true,
      );
    } else {
      return const SlopeSupportRecommendation(
        category: SlopeSupportCategory.slopeReprofiling,
        categoryNumber: 6,
        title: "Category 6: Slope Reprofiling / Flattening Required",
        summary:
            "Exceeds safe practical reinforcement envelope. Bench flattening or redesign required.",
        boltSpecification:
            "Reinforcement uneconomical or geometrically unsafe.",
        shotcreteSpecification:
            "Not recommended without geotechnical reprofiling.",
        drainageSpecification:
            "Pre-drainage and depressurization prior to excavation.",
        recommendedBoltLengthMeters: 0.0,
        requiresSlopeFlattening: true,
      );
    }
  }

  // Fallback categorization based strictly on Q-slope rating
  if (qSlope >= 1.0) {
    return const SlopeSupportRecommendation(
      category: SlopeSupportCategory.unsupportedNatural,
      categoryNumber: 1,
      title: "Category 1: Unsupported / Natural Stable",
      summary: "High quality rock mass. Stable for standard bench geometries.",
      boltSpecification: "Routine scaling and inspection.",
      shotcreteSpecification: "None.",
      drainageSpecification: "Surface water management.",
      recommendedBoltLengthMeters: 0.0,
    );
  } else if (qSlope >= 0.1) {
    final double boltL = max(2.5, 2.0 + (0.15 * h));
    return SlopeSupportRecommendation(
      category: SlopeSupportCategory.spotBolting,
      categoryNumber: 2,
      title: "Category 2: Spot Bolting & Scaling",
      summary: "Moderate rock mass. Spot reinforcement for suspect joints.",
      boltSpecification: "Spot rock bolts (20-25mm diam, 2.5m - 4m length).",
      shotcreteSpecification: "None.",
      drainageSpecification: "Weep holes where groundwater seepage observed.",
      recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
    );
  } else if (qSlope >= 0.03) {
    final double boltL = max(3.0, 2.0 + (0.15 * h));
    return SlopeSupportRecommendation(
      category: SlopeSupportCategory.patternBoltingMesh,
      categoryNumber: 3,
      title: "Category 3: Pattern Bolting & Mesh",
      summary:
          "Weak or heavily jointed rock. Pattern bolting with mesh recommended.",
      boltSpecification: "Pattern bolting on a 2.0m - 2.5m diamond pattern.",
      shotcreteSpecification: "High-tensile wire mesh.",
      drainageSpecification: "Weep holes (50mm diameter).",
      recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
      recommendedBoltSpacingMeters: 2.2,
    );
  } else if (qSlope >= 0.005) {
    final double boltL = max(3.5, 2.0 + (0.18 * h));
    return SlopeSupportRecommendation(
      category: SlopeSupportCategory.systematicBoltingShotcrete,
      categoryNumber: 4,
      title: "Category 4: Systematic Bolting & Fibre Shotcrete",
      summary:
          "Very poor rock mass quality. Requires systematic reinforcement and shotcrete.",
      boltSpecification: "Systematic bolting (1.5m - 2.0m spacing).",
      shotcreteSpecification: "50 - 100mm fibre shotcrete.",
      drainageSpecification:
          "Sub-horizontal drainage boreholes (10m - 15m deep).",
      recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
      recommendedBoltSpacingMeters: 1.8,
      recommendedShotcreteThicknessMm: 75.0,
    );
  } else if (qSlope >= 0.001) {
    final double boltL = max(10.0, 0.40 * h);
    return SlopeSupportRecommendation(
      category: SlopeSupportCategory.heavyCableBolting,
      categoryNumber: 5,
      title: "Category 5: Heavy Support (Cable Anchors + Shotcrete)",
      summary:
          "Extremely poor rock mass. Requires heavy multi-strand cable bolting and shotcrete.",
      boltSpecification:
          "High-capacity strand cable bolts (10m - 25m length) with pattern bolts.",
      shotcreteSpecification: "100 - 150mm reinforced shotcrete.",
      drainageSpecification:
          "Sub-horizontal drain hole array (15m - 30m length).",
      recommendedBoltLengthMeters: double.parse(boltL.toStringAsFixed(2)),
      recommendedBoltSpacingMeters: 1.5,
      recommendedShotcreteThicknessMm: 125.0,
      requiresCableAnchors: true,
    );
  } else {
    return const SlopeSupportRecommendation(
      category: SlopeSupportCategory.slopeReprofiling,
      categoryNumber: 6,
      title: "Category 6: Slope Reprofiling / Flattening Required",
      summary:
          "Extremely weak/faulted rock. Bench flattening or geotechnical reprofiling necessary.",
      boltSpecification:
          "Artificial reinforcement insufficient for steep face.",
      shotcreteSpecification: "Not recommended.",
      drainageSpecification: "Pre-drainage depressurization.",
      recommendedBoltLengthMeters: 0.0,
      requiresSlopeFlattening: true,
    );
  }
}

/// Calculates the trend (bearing, 0-360°) and plunge (dip, 0-90°) of the intersection line
/// between two discontinuity planes given their dip angles and dip directions.
/// Returns a map with 'trend' and 'plunge'.
Map<String, double>? calculateIntersectionLinePlungeAndTrend({
  required double dip1,
  required double dipDir1,
  required double dip2,
  required double dipDir2,
}) {
  const double degToRad = pi / 180.0;
  const double radToDeg = 180.0 / pi;

  // Plane normal vectors (East, North, Up)
  final double d1Rad = dip1 * degToRad;
  final double dd1Rad = dipDir1 * degToRad;
  final double n1x = sin(d1Rad) * sin(dd1Rad);
  final double n1y = sin(d1Rad) * cos(dd1Rad);
  final double n1z = cos(d1Rad);

  final double d2Rad = dip2 * degToRad;
  final double dd2Rad = dipDir2 * degToRad;
  final double n2x = sin(d2Rad) * sin(dd2Rad);
  final double n2y = sin(d2Rad) * cos(dd2Rad);
  final double n2z = cos(d2Rad);

  // Cross product v = n1 x n2
  double vx = (n1y * n2z) - (n1z * n2y);
  double vy = (n1z * n2x) - (n1x * n2z);
  double vz = (n1x * n2y) - (n1y * n2x);

  final double mag = sqrt((vx * vx) + (vy * vy) + (vz * vz));
  if (mag < 1e-6) {
    // Planes are parallel
    return null;
  }

  // Ensure vector points downwards (plunging)
  if (vz > 0) {
    vx = -vx;
    vy = -vy;
    vz = -vz;
  }

  final double plunge = asin((-vz).clamp(0.0, 1.0) / mag) * radToDeg;
  double trend = atan2(vx, vy) * radToDeg;
  if (trend < 0) {
    trend += 360.0;
  }

  return {'trend': trend, 'plunge': plunge};
}

/// Performs comprehensive kinematic stability analysis for a rock slope face
/// against planar, wedge, and toppling failure mechanisms.
KinematicAnalysisResult analyzeKinematics({
  required double slopeDip,
  required double slopeDipDirection,
  required double joint1Dip,
  required double joint1DipDirection,
  double? joint2Dip,
  double? joint2DipDirection,
  double frictionAngle = 30.0,
}) {
  // Angular difference between joint1 and slope dip directions
  double dDirPlanar = (joint1DipDirection - slopeDipDirection).abs();
  if (dDirPlanar > 180) dDirPlanar = 360 - dDirPlanar;

  // Planar failure evaluation:
  // Daylights on slope face: joint1Dip < slopeDip and dips towards face (dDirPlanar < 90°)
  // Sliding possible: joint1Dip > frictionAngle
  // Direction parallel within 20-30°
  final bool planarDaylights = (joint1Dip < slopeDip) && (dDirPlanar < 90.0);
  KinematicRiskLevel planarRisk = KinematicRiskLevel.none;
  if (planarDaylights && joint1Dip >= frictionAngle) {
    if (dDirPlanar <= 20.0) {
      planarRisk = KinematicRiskLevel.critical;
    } else if (dDirPlanar <= 30.0) {
      planarRisk = KinematicRiskLevel.moderate;
    } else if (dDirPlanar <= 45.0) {
      planarRisk = KinematicRiskLevel.low;
    }
  }

  // Toppling failure evaluation:
  // Strikes approximately parallel to slope face, dipping into rock mass
  // Goodman (1980) toppling condition: jointDip + slopeDip >= 90 + frictionAngle
  double dDirToppling =
      (joint1DipDirection - ((slopeDipDirection + 180) % 360)).abs();
  if (dDirToppling > 180) dDirToppling = 360 - dDirToppling;
  KinematicRiskLevel topplingRisk = KinematicRiskLevel.none;
  if (dDirToppling <= 30.0 && (joint1Dip + slopeDip >= 90.0 + frictionAngle)) {
    if (dDirToppling <= 15.0) {
      topplingRisk = KinematicRiskLevel.critical;
    } else {
      topplingRisk = KinematicRiskLevel.moderate;
    }
  }

  // Wedge failure evaluation (requires second joint set)
  KinematicRiskLevel wedgeRisk = KinematicRiskLevel.none;
  double? iTrend;
  double? iPlunge;
  bool wedgeDaylights = false;

  if (joint2Dip != null && joint2DipDirection != null) {
    final intersection = calculateIntersectionLinePlungeAndTrend(
      dip1: joint1Dip,
      dipDir1: joint1DipDirection,
      dip2: joint2Dip,
      dipDir2: joint2DipDirection,
    );
    if (intersection != null) {
      iTrend = intersection['trend']!;
      iPlunge = intersection['plunge']!;

      double dTrend = (iTrend - slopeDipDirection).abs();
      if (dTrend > 180) dTrend = 360 - dTrend;

      wedgeDaylights = (iPlunge < slopeDip) && (dTrend < 90.0);

      if (wedgeDaylights && iPlunge >= frictionAngle && dTrend <= 90.0) {
        if (dTrend <= 30.0) {
          wedgeRisk = KinematicRiskLevel.critical;
        } else if (dTrend <= 60.0) {
          wedgeRisk = KinematicRiskLevel.moderate;
        } else {
          wedgeRisk = KinematicRiskLevel.low;
        }
      }
    }
  }

  String mechanism;
  String recommendation;
  if (planarRisk == KinematicRiskLevel.critical) {
    mechanism =
        "Critical Planar Sliding: Joint 1 daylights on the slope face with dip (${joint1Dip.toStringAsFixed(1)}°) exceeding friction angle ($frictionAngle°).";
    recommendation =
        "Install pattern rockbolts inclined into the rock mass across the sliding plane or flatten slope to < ${joint1Dip.toStringAsFixed(0)}°.";
  } else if (wedgeRisk == KinematicRiskLevel.critical) {
    mechanism =
        "Critical Wedge Sliding: Intersection line (${iPlunge?.toStringAsFixed(1)}° / ${iTrend?.toStringAsFixed(1)}°) daylights on slope face.";
    recommendation =
        "Provide cross-joint stitching bolts or cable anchors across the wedge bounding joints and install drain weep holes.";
  } else if (topplingRisk == KinematicRiskLevel.critical) {
    mechanism =
        "Critical Flexural/Block Toppling: Discontinuities strike parallel to slope and dip steeply into rock mass.";
    recommendation =
        "Install deep horizontal dowels or rock bolts, and maintain wide catch berms to prevent toppling blocks from rolling down.";
  } else if (planarRisk != KinematicRiskLevel.none ||
      wedgeRisk != KinematicRiskLevel.none ||
      topplingRisk != KinematicRiskLevel.none) {
    mechanism =
        "Moderate Kinematic Hazard: Marginal daylighting or oblique discontinuity alignment.";
    recommendation =
        "Verify joint persistence, roughness (JRC), and pore water pressure; routine spot bolting recommended.";
  } else {
    mechanism =
        "Kinematically Stable: Discontinuities do not satisfy daylighting or sliding kinematic failure criteria.";
    recommendation =
        "No structural sliding hazard detected for this slope orientation; maintain standard crest drainage.";
  }

  return KinematicAnalysisResult(
    planarRisk: planarRisk,
    wedgeRisk: wedgeRisk,
    topplingRisk: topplingRisk,
    daylightsOnSlope: planarDaylights || wedgeDaylights,
    intersectionTrend: iTrend,
    intersectionPlunge: iPlunge,
    primaryMechanismDescription: mechanism,
    engineeringRecommendation: recommendation,
  );
}
