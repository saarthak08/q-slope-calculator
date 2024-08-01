import 'dart:math';

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
