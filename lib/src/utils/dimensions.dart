import 'package:flutter/material.dart';

/// Get device width
double getDeviceWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

/// Get device height
double getDeviceHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
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
