import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
//------theme text------
  static final baseTextTheme = GoogleFonts.poppinsTextTheme().copyWith(
    bodySmall: GoogleFonts.poppins(
      fontSize: Sizes.s16sp,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: Sizes.s18sp,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: Sizes.s20sp,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: Sizes.s17sp,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: Sizes.s25sp,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: Sizes.s30sp,
      fontWeight: FontWeight.w800,
    ),
  );

  //------Light theme------
  static ThemeData light(BuildContext context) {
    final theme = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFFFF9E9E),
        secondary: Color(0xFFFFB3B3),
        primaryContainer: Color(0xFFFFDCDC),
        secondaryContainer: Color(0xFFFFEAEA),
        tertiary: Colors.white,
      ),
      scaffoldBackground: const Color(0xFFF9F9FB),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: true,
        useTextTheme: true,
        textButtonSchemeColor: SchemeColor.primary,
        elevatedButtonSchemeColor: SchemeColor.primary,
      ),
      textTheme: baseTextTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: theme.colorScheme.primary,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2E2E2E)),
        titleTextStyle: baseTextTheme.headlineMedium?.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }

  //------Dark theme------
  static ThemeData dark(BuildContext context) {
    final theme = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFFFF9E9E),
        secondary: Color(0xFFFFB3B3),
        primaryContainer: Color(0xFFFFDCDC),
        secondaryContainer: Color(0xFF4A4A4A),
        tertiary: Colors.white,
      ),
      scaffoldBackground: const Color(0xFF1E1E1E),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: true,
        useTextTheme: true,
        textButtonSchemeColor: SchemeColor.primary,
        elevatedButtonSchemeColor: SchemeColor.primary,
      ),
      textTheme: baseTextTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: theme.colorScheme.primary,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: baseTextTheme.headlineMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
