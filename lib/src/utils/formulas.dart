import 'dart:math';

import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';

double minJointRoughnessValue = 0.5;
double maxJointRoughnessValue = 4;
double minJointAlterationValue = 0.75;
double maxJointAlterationValue = 20;
double minOFactorValue = 0.25;
double maxOFactorValue = 2;

double f2ForToppling = 1;

double minJWiceValue = 0.05;
double maxJWiceValue = 1;

double minSRFa = 2.5;
double maxSRFa = 20;
double minSRFb = 1;
double maxSRFb = 200;
double minSRFc = 1;
double maxSRFc = 24;

double calculateRqdByDirectMethod(
    double sumOfCorePieces, double totalDrillRun) {
  return (sumOfCorePieces * 100) / totalDrillRun;
}

double calculateJointVolume(
    int numberOfRandomSets, List<double> jointSpacings, double area) {
  double reverseJointSpacingSum = 0;
  for (var spacing in jointSpacings) {
    reverseJointSpacingSum = reverseJointSpacingSum + (1 / spacing);
  }
  return reverseJointSpacingSum + (numberOfRandomSets / (5 * sqrt(area)));
}

double calculateRqdByTwoPointFiveJv(double jv) {
  return 110 - (2.5 * jv);
}

double calculateRqdByThreePointThreeJv(double jv) {
  return 115 - (3.3 * jv);
}

double calculateF1ForPlanarFailure(double alphaJ, double alphaS) {
  return alphaJ - alphaS;
}

double calculateF1ForWedgeFailure(double alphaI, double alphaS) {
  return alphaI - alphaS;
}

double calculateF1ForTopplingFailure(double alphaJ, double alphaS) {
  return (alphaJ - alphaS) - 180;
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
    double f1, double f2, double f3) {
  return 1.9759 * (exp(0.0339 * (f1 * f2 * f3)));
}

double calculateQSlope(QSlope qSlope) {
  OFactor? oFactor = qSlope.oFactor;
  double qSlopeValue;
  if (oFactor != null) {
    if (oFactor.oFactorCalculationType == OFactorCalculationType.value) {
      qSlopeValue = ((qSlope.blockSize?.rqd ?? 0) /
              (qSlope.blockSize?.jointSetNumber ?? 1)) *
          ((qSlope.jointCharacter!
                  .jointRoughness![oFactor.indexOfFirstJoint!]) /
              (qSlope.jointCharacter!
                  .jointAlteration![oFactor.indexOfFirstJoint!])) *
          (oFactor.oFactorForFirstJoint ?? 0) *
          ((qSlope.externalFactors
                      ?.environmentalAndGeologicalConditionalNumber ??
                  0) /
              (qSlope.activeStress?.srf ?? 1));
      if (oFactor.indexOfSecondJoint != null &&
          oFactor.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge) {
        qSlopeValue = qSlopeValue *
            ((qSlope.jointCharacter!
                    .jointRoughness![oFactor.indexOfSecondJoint!]) /
                (qSlope.jointCharacter!
                    .jointAlteration![oFactor.indexOfSecondJoint!]));
      }
      if (oFactor.oFactorCalculationType == OFactorCalculationType.value &&
          oFactor.oFactorForSecondJoint != null) {
        qSlopeValue = qSlopeValue * (oFactor.oFactorForSecondJoint ?? 0);
      }
      return qSlopeValue;
    } else {
      return qSlopeValue = ((qSlope.blockSize?.rqd ?? 0) /
              (qSlope.blockSize?.jointSetNumber ?? 1)) *
          ((qSlope.jointCharacter!
                  .jointRoughness![oFactor.indexOfFirstJoint!]) /
              (qSlope.jointCharacter!
                  .jointAlteration![oFactor.indexOfFirstJoint!])) *
          (oFactor.oFactorForFirstJoint ?? 0) *
          ((qSlope.externalFactors
                      ?.environmentalAndGeologicalConditionalNumber ??
                  0) /
              (qSlope.activeStress?.srf ?? 1));
    }
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
    double numberOfJointSets, double numberOfRandomSets) {
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
    ExternalFactorsStructureType structureType) {
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
