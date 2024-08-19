import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
      appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserrat(color: Colors.teal),
          backgroundColor: white),
      useMaterial3: true,
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.openSans(),
        titleMedium: GoogleFonts.montserrat(),
        headlineMedium: GoogleFonts.poppins(),
      ),
      scaffoldBackgroundColor: white,
      colorSchemeSeed: Colors.teal,
      splashColor: Colors.teal.withOpacity(0.2),
      disabledColor: Colors.grey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scrollbarTheme: const ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.grey)));
}
