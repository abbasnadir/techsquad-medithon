import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/healthcare_worker/healthcare_worker_dashboard.dart';
import 'package:frontend/features/patient/patient_dashboard.dart';
import 'package:frontend/features/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    
    // Simulate short network delay for the prototype feel
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (user == 'patient' && pass == 'patient123') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PatientDashboard()),
          (route) => false,
        );
      } else if (user == 'nurse' && pass == 'nurse123') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HealthcareWorkerDashboard()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid prototype credentials. Use nurse/nurse123 or patient/patient123')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.columbiaBlue.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.health_and_safety, size: 54, color: AppColors.ming),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'SureStep',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mingDark,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Clubfoot Care & Assessment Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  labelText: 'Email or Username',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.person, color: AppColors.ming),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.lock, color: AppColors.ming),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ming,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: AppColors.palmLeaf, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

