import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

/// Minimum horizontal margin
double getMinHorizontalMargin(BuildContext context) {
  return getViewPortWidth(context) * 0.04;
}

/// Max horizontal margin
double getMaxHorizontalMargin(BuildContext context) {
  return getViewPortWidth(context) * 0.06;
}

/// Minimum vertical margin
double getMinVerticalMargin(BuildContext context) {
  return getViewPortHeight(context) * 0.02;
}

/// Medium vertical margin
double getMidVerticalMargin(BuildContext context) {
  return getViewPortHeight(context) * 0.04;
}

/// Max vertical margin
double getMaxVerticalMargin(BuildContext context) {
  return getViewPortHeight(context) * 0.06;
}
