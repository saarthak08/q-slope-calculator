import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserrat(color: primaryColor),
          backgroundColor: white),
      useMaterial3: true,
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.openSans(),
        titleMedium: GoogleFonts.montserrat(),
        headlineMedium: GoogleFonts.poppins(),
      ),
      scaffoldBackgroundColor: white,
      colorSchemeSeed: primaryColor,
      splashColor: primaryColor.withOpacity(0.2),
      disabledColor: Colors.grey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scrollbarTheme: const ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.grey)));
}

Color primaryColor = Colors.teal;
Color primaryColorShade100 = Colors.teal.shade100;
