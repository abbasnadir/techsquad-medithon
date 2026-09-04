import 'package:flutter/material.dart';

class AppColors {
  // Serenity Palette
  static const Color opal = Color(0xFFA8BDBF);
  static const Color columbiaBlue = Color(0xFFC5D7D9);
  static const Color ming = Color(0xFF3F7373); // Primary brand color
  static const Color palmLeaf = Color(0xFF768C45); // Secondary / Accent color
  static const Color antiFlashWhite = Color(0xFFF2F1F0); // Background / Light surface

  // Semantic UI Tones
  static const Color mingDark = Color(0xFF284C4C);
  static const Color mingLight = Color(0xFF5A8E8E);
  static const Color palmLeafLight = Color(0xFF8FA859);
  static const Color textDark = Color(0xFF1E2C2E);
  static const Color textMuted = Color(0xFF647B7D);
  static const Color cardSurface = Colors.white;
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.antiFlashWhite,
    cardColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ming,
      onPrimary: Colors.white,
      primaryContainer: AppColors.columbiaBlue,
      onPrimaryContainer: AppColors.mingDark,
      secondary: AppColors.palmLeaf,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.opal,
      surface: Colors.white,
      onSurface: AppColors.textDark,
      surfaceTint: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.ming,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.ming,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.opal),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.opal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.ming, width: 2),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121B1C),
    cardColor: const Color(0xFF1C2829),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.opal,
      onPrimary: AppColors.textDark,
      secondary: AppColors.palmLeafLight,
      surface: Color(0xFF1C2829),
      onSurface: Colors.white,
      surfaceTint: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1C2829),
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1C2829),
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.opal.withOpacity(0.3), width: 1.0),
      ),
    ),
  );
}

