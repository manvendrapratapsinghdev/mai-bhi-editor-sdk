import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_system.dart';

/// Generates Material 3 [ThemeData] from a [DesignSystem].
///
/// WCAG 2.1 AA contrast ratios are maintained when using the default
/// design system. Custom design systems should verify their own contrast.
class MbeTheme {
  MbeTheme._();

  // ── Light theme ─────────────────────────────────────────────────────

  static ThemeData light(DesignSystem ds) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ds.primary,
      primary: ds.primary,
      onPrimary: ds.white,
      secondary: ds.secondary,
      onSecondary: ds.white,
      tertiary: ds.darkGrey,
      error: ds.statusRejected,
      onError: ds.white,
      surface: ds.white,
      onSurface: ds.black,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ds.scaffoldLight,
      textTheme: _textTheme(ds, ds.black),
      appBarTheme: AppBarTheme(
        backgroundColor: ds.primary,
        foregroundColor: ds.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _headingFont(ds,
            fontSize: 20, fontWeight: FontWeight.w700, color: ds.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ds.primary,
          foregroundColor: ds.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ds.radiusMd),
          ),
          textStyle: _bodyFont(ds,
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ds.primary,
          side: BorderSide(color: ds.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ds.radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ds.extraLightGrey,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ds.spacingLg,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.statusRejected),
        ),
        labelStyle: _bodyFont(ds, color: ds.mediumGrey),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ds.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(
          horizontal: ds.spacingLg,
          vertical: 6,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ds.extraLightGrey,
        selectedColor: ds.primaryLight,
        labelStyle: _bodyFont(ds, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ds.radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: ds.divider,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ds.primary,
        unselectedItemColor: ds.mediumGrey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _bodyFont(ds,
            fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _bodyFont(ds, fontSize: 12),
      ),
    );
  }

  // ── Dark theme ──────────────────────────────────────────────────────

  static ThemeData dark(DesignSystem ds) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ds.primary,
      primary: ds.primary,
      onPrimary: ds.white,
      secondary: ds.secondary,
      onSecondary: ds.white,
      tertiary: ds.lightGrey,
      error: ds.statusRejected,
      onError: ds.white,
      surface: ds.surfaceDark,
      onSurface: ds.white,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ds.scaffoldDark,
      textTheme: _textTheme(ds, ds.white),
      appBarTheme: AppBarTheme(
        backgroundColor: ds.primaryDark,
        foregroundColor: ds.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _headingFont(ds,
            fontSize: 20, fontWeight: FontWeight.w700, color: ds.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ds.primary,
          foregroundColor: ds.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ds.radiusMd),
          ),
          textStyle: _bodyFont(ds,
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ds.primaryLight,
          side: BorderSide(color: ds.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ds.radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ds.surfaceDark,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ds.spacingLg,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.mediumGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ds.radiusMd),
          borderSide: BorderSide(color: ds.statusRejected),
        ),
        labelStyle: _bodyFont(ds, color: ds.lightGrey),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: ds.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ds.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(
          horizontal: ds.spacingLg,
          vertical: 6,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ds.surfaceDark,
        selectedColor: ds.primaryDark,
        labelStyle: _bodyFont(ds,
            fontSize: 13, color: ds.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ds.radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: ds.mediumGrey.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ds.primaryLight,
        unselectedItemColor: ds.lightGrey,
        backgroundColor: ds.surfaceDark,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _bodyFont(ds,
            fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _bodyFont(ds, fontSize: 12),
      ),
    );
  }

  // ── Shared text theme ───────────────────────────────────────────────

  static TextTheme _textTheme(DesignSystem ds, Color baseColor) {
    return TextTheme(
      displayLarge: _headingFont(ds,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: baseColor,
          height: 1.25),
      displayMedium: _headingFont(ds,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: baseColor,
          height: 1.29),
      headlineLarge: _headingFont(ds,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: baseColor,
          height: 1.33),
      headlineMedium: _headingFont(ds,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: baseColor,
          height: 1.4),
      titleLarge: _headingFont(ds,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: baseColor,
          height: 1.44),
      titleMedium: _bodyFont(ds,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: baseColor,
          height: 1.5),
      titleSmall: _bodyFont(ds,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: baseColor,
          height: 1.43),
      bodyLarge: _bodyFont(ds,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: baseColor,
          height: 1.5),
      bodyMedium: _bodyFont(ds,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: baseColor,
          height: 1.43),
      bodySmall: _bodyFont(ds,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: baseColor.withValues(alpha: 0.7),
          height: 1.33),
      labelLarge: _bodyFont(ds,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: baseColor,
          letterSpacing: 0.1),
      labelMedium: _bodyFont(ds,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: baseColor,
          letterSpacing: 0.5),
      labelSmall: _bodyFont(ds,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: baseColor.withValues(alpha: 0.7),
          letterSpacing: 0.5),
    );
  }

  // ── Font helpers ────────────────────────────────────────────────────

  static TextStyle _headingFont(
    DesignSystem ds, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.getFont(
      ds.headingFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle _bodyFont(
    DesignSystem ds, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.getFont(
      ds.bodyFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
