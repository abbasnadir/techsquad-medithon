import 'package:flutter/material.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Directory')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Name or Patient ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPatientTile(
                  context,
                  name: 'Baby John Doe',
                  id: 'PT-10029',
                  status: 'Ponseti Casting (Week 4)',
                  pirani: '2.5 (Improving)',
                  alert: null,
                ),
                _buildPatientTile(
                  context,
                  name: 'Baby Sarah Smith',
                  id: 'PT-10045',
                  status: 'Ponseti Casting (Week 2)',
                  pirani: '4.5 (High Risk)',
                  alert: 'ML Alert: Tenotomy predicted next week',
                ),
                _buildPatientTile(
                  context,
                  name: 'Baby Liam Chen',
                  id: 'PT-10088',
                  status: 'Bracing Phase',
                  pirani: '0.0 (Corrected)',
                  alert: 'Tele-Consult Ticket: Parent reported brace pain',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTile(BuildContext context, {required String name, required String id, required String status, required String pirani, String? alert}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prototype: Opening detailed medical record...')));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.child_care, color: Colors.white)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('ID: $id', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Phase:', style: TextStyle(color: Colors.grey)),
                  Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Latest Pirani Score:', style: TextStyle(color: Colors.grey)),
                  Text(pirani, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ],
              ),
              if (alert != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(alert, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
