import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'healthcare_worker';
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.palmLeaf,
          content: Text('Registration successful! Please login with your credentials.'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.ming,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join SureStep',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mingDark),
              ),
              const SizedBox(height: 6),
              const Text(
                'Register as a healthcare worker or patient/parent.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _usernameCtrl,
                style: const TextStyle(color: AppColors.textDark),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person, color: AppColors.ming),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: AppColors.textDark),
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email, color: AppColors.ming),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                style: const TextStyle(color: AppColors.textDark),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: AppColors.ming),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: 'I am a...',
                  prefixIcon: Icon(Icons.badge, color: AppColors.ming),
                ),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 'healthcare_worker', child: Text('Healthcare Worker / Clinician')),
                  DropdownMenuItem(value: 'patient', child: Text('Patient / Parent')),
                ],
                onChanged: (val) => setState(() => _role = val!),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ming,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                    : const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
