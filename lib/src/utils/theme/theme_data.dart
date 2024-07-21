import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
      useMaterial3: true,
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.raleway(),
        titleMedium: GoogleFonts.montserrat(),
        headlineMedium: GoogleFonts.rubik(),
      ),
      colorSchemeSeed: Colors.teal,
      splashColor: white,
      disabledColor: Colors.grey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scrollbarTheme: const ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.grey)));
}
