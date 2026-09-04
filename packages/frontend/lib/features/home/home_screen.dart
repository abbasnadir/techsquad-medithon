import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: const Text('SureStep'),
        backgroundColor: AppColors.ming,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, size: 64, color: AppColors.ming),
            const SizedBox(height: 16),
            Text(
              'Welcome to SureStep',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.mingDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clubfoot Care & Assessment Platform',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
