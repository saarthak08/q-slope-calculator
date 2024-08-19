import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

double getTitleFontSize(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 20;
  } else {
    return 22;
  }
}

double getSubtitleLargeFontSize(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 18;
  } else {
    return 20;
  }
}

double getSubTitleFontSize(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 16;
  } else {
    return 18;
  }
}

double getCaptionFontSize(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 12;
  } else {
    return 14;
  }
}

double getBodyFontSize(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 14;
  } else {
    return 16;
  }
}
