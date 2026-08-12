import 'package:flutter/material.dart';
import 'package:frontend/features/scan/scan_flow_screen.dart';
import 'package:frontend/features/patient/patient_dashboard.dart';
import 'package:frontend/features/healthcare_worker/patient_list_screen.dart';

class HealthcareWorkerDashboard extends StatelessWidget {
  const HealthcareWorkerDashboard({super.key});

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
              'Welcome, Healthcare Worker',
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
                MaterialPageRoute(builder: (_) => const PatientListScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.email,
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
          title: const Text('Link Patient Email'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the parent\'s email address to send them a secure link to their child\'s Medithon dashboard.'),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Parent Email', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitation sent successfully!')));
              },
              child: const Text('Send Invite'),
            ),
          ],
        );
      }
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
