import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/home/home_screen.dart';

void main() {
  runApp(const MedithonApp());
}

class MedithonApp extends StatelessWidget {
  const MedithonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medithon App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Adapts to device lightweight preferences
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
