import 'package:flutter/material.dart';

/// Get device width
double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// Get device height
double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Get device safe width
double getViewPortWidth(BuildContext context) {
  final EdgeInsets padding = MediaQuery.of(context).padding;
  return getDeviceWidth(context) - padding.left - padding.right;
}

/// Get device safe height
double getViewPortHeight(BuildContext context) {
  final EdgeInsets padding = MediaQuery.of(context).padding;
  return getDeviceHeight(context) - padding.top - padding.bottom;
}
