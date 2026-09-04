import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:frontend/features/scan/scan_flow_screen.dart';
import 'package:frontend/features/healthcare_worker/patient_list_screen.dart';

class HealthcareWorkerDashboard extends StatelessWidget {
  const HealthcareWorkerDashboard({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: const Text('Clinical Dashboard'),
        backgroundColor: AppColors.ming,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Healthcare Worker',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mingDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select an action below to begin patient care.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildActionCard(
              context,
              icon: Icons.camera_alt,
              iconBg: AppColors.columbiaBlue.withOpacity(0.5),
              iconColor: AppColors.ming,
              title: 'Scan Patient Foot (CTEV)',
              subtitle: 'Standardized image capture & Pirani assessment',
              badge: 'AI Powered',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanFlowScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.search,
              iconBg: AppColors.opal.withOpacity(0.35),
              iconColor: AppColors.mingDark,
              title: 'Find Patient',
              subtitle: 'Search records & track treatment progress',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientListScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.email,
              iconBg: AppColors.palmLeaf.withOpacity(0.15),
              iconColor: AppColors.palmLeaf,
              title: 'Link Patient Email',
              subtitle: 'Grant a parent access to their child\'s dashboard',
              onTap: () => _showLinkEmailDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLinkEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Link Patient Email', style: TextStyle(color: AppColors.mingDark, fontWeight: FontWeight.bold)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the parent\'s email address to send them a secure link to their child\'s SureStep dashboard.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Parent Email',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.ming),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.palmLeaf,
                    content: Text('Invitation sent successfully!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ming, foregroundColor: Colors.white),
              child: const Text('Send Invite'),
            ),
          ],
        );
      }
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon, 
    required Color iconBg,
    required Color iconColor,
    required String title, 
    required String subtitle, 
    String? badge,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 30, color: iconColor),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title, 
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: AppColors.mingDark,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.palmLeaf.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badge, 
                              style: const TextStyle(
                                color: AppColors.palmLeaf, 
                                fontSize: 11, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle, 
                      style: const TextStyle(
                        color: Color(0xFF4A5568), 
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.ming, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

