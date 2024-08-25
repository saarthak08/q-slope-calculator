import 'dart:math';

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
  return alphaJ - alphaS - 180;
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
              (qSlope.blockSize?.numberOfJoints ?? 1)) *
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
          oFactor.oFactorForSecondJoint != null &&
          oFactor.oFactorTypeOfFailure == OFactorTypeOfFailure.wedge) {
        return qSlopeValue *
            (((qSlope.jointCharacter!
                        .jointRoughness![oFactor.indexOfSecondJoint!]) /
                    (qSlope.jointCharacter!
                        .jointAlteration![oFactor.indexOfSecondJoint!])) *
                (oFactor.oFactorForSecondJoint ?? 0));
      }
    } else {
      return qSlopeValue = ((qSlope.blockSize?.rqd ?? 0) /
              (qSlope.blockSize?.numberOfJoints ?? 1)) *
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
  return 16 / 25 - ((3 / 500) * (atan((1 / 10) * (f1.abs() - 17))));
}

double calculateRatingForF2(double f2) {
  return 9 / 16 + ((1 / 195) * (atan(((17 / 100) * f2) - 5)));
}

double calculateRatingForF3NonTopplingFailure(double f3) {
  return -30 + ((1 / 3) * atan(f3));
}

double calculateRatingForF3TopplingFailure(double f3) {
  return -13 - ((1 / 7) * atan(f3 - 120));
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
