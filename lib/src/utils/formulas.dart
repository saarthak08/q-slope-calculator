import 'dart:math';

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
  return ((qSlope.blockSize?.rqd ?? 0) /
          (qSlope.blockSize?.numberOfJoints ?? 1)) *
      ((qSlope.jointCharacter?.jointRoughness ?? 0) /
          (qSlope.jointCharacter?.jointAlteration ?? 1)) *
      (qSlope.oFactor?.oFactor ?? 0) *
      ((qSlope.externalFactors?.environmentalAndGeologicalConditionalNumber ??
              0) /
          (qSlope.activeStress?.srf ?? 1));
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
