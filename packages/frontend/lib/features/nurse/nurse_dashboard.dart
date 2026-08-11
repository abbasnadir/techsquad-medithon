import 'package:flutter/material.dart';
import 'package:frontend/features/scan/scan_flow_screen.dart';
import 'package:frontend/features/patient/patient_dashboard.dart';

class NurseDashboard extends StatelessWidget {
  const NurseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'), // Replace with proper routing
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Nurse',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('What would you like to do today?'),
            const SizedBox(height: 32),
            _buildActionCard(
              context,
              icon: Icons.camera_alt,
              title: 'Scan Patient Foot (CTEV)',
              subtitle: 'Standardized image capture & Pirani assessment',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanFlowScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.search,
              title: 'Find Patient',
              subtitle: 'Search records & track treatment progress',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientDashboard()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
