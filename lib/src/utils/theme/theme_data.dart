import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.montserrat(color: primaryColor),
      backgroundColor: white,
      iconTheme: IconThemeData(color: primaryColor),
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.montserrat(),
      headlineMedium: GoogleFonts.poppins(),
    ),
    scaffoldBackgroundColor: white,
    colorSchemeSeed: primaryColor,
    splashColor: primaryColor.withValues(alpha: 0.2),
    disabledColor: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.grey),
    ),
  );
}

ThemeData getDarkThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.montserrat(color: Colors.tealAccent),
      backgroundColor: Colors.grey.shade900,
      iconTheme: IconThemeData(color: Colors.tealAccent),
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.openSans(color: Colors.white70),
      titleMedium: GoogleFonts.montserrat(color: Colors.white),
      headlineMedium: GoogleFonts.poppins(color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorSchemeSeed: Colors.teal,
    splashColor: Colors.teal.withValues(alpha: 0.2),
    disabledColor: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.grey),
    ),
  );
}

Color primaryColor = Colors.teal;
Color primaryColorShade100 = Colors.teal.shade100;
