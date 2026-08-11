import 'package:flutter/material.dart';

class AppTheme {
  // Optimized for lightweight devices (minimal shadows, simple colors, native performance)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
  );
}
