import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';

class PatientRecord {
  final String name;
  final String id;
  final String age;
  final String guardian;
  final String location;
  final String status;
  final String pirani;
  final String? alert;

  const PatientRecord({
    required this.name,
    required this.id,
    required this.age,
    required this.guardian,
    required this.location,
    required this.status,
    required this.pirani,
    this.alert,
  });
}

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  
  final List<PatientRecord> _allPatients = const [
    PatientRecord(
      name: 'Baby Aarav Sharma',
      id: 'PT-IN-10029',
      age: '4 months',
      guardian: 'Sunita Sharma (Mother)',
      location: 'New Delhi • AIIMS Ortho Unit',
      status: 'Ponseti Casting (Week 4)',
      pirani: '2.5 (Improving)',
      alert: null,
    ),
    PatientRecord(
      name: 'Baby Ananya Iyer',
      id: 'PT-IN-10045',
      age: '2 months',
      guardian: 'Karthik Iyer (Father)',
      location: 'Bengaluru • Manipal Hospital',
      status: 'Ponseti Casting (Week 2)',
      pirani: '4.5 (High Risk)',
      alert: 'ML Alert: Tenotomy evaluation predicted next week',
    ),
    PatientRecord(
      name: 'Baby Vihaan Patel',
      id: 'PT-IN-10088',
      age: '8 months',
      guardian: 'Bhavna Patel (Mother)',
      location: 'Ahmedabad • Civil Hospital',
      status: 'Bracing Phase (FAB 23h/day)',
      pirani: '0.0 (Corrected)',
      alert: 'Tele-Consult Ticket: Parent reported heel friction with brace',
    ),
    PatientRecord(
      name: 'Baby Diya Mukherjee',
      id: 'PT-IN-10112',
      age: '3.5 months',
      guardian: 'Debanjan Mukherjee (Father)',
      location: 'Kolkata • SSKM Medical Unit',
      status: 'Post-Tenotomy Cast (Week 1)',
      pirani: '1.0 (Resolving)',
      alert: null,
    ),
    PatientRecord(
      name: 'Baby Reyansh Gupta',
      id: 'PT-IN-10140',
      age: '1.5 years',
      guardian: 'Pooja Gupta (Mother)',
      location: 'Lucknow • KGMU Orthopedics',
      status: 'Maintenance Bracing (Night-time)',
      pirani: '0.0 (Stable)',
      alert: null,
    ),
  ];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<PatientRecord> get _filteredPatients {
    if (_searchQuery.isEmpty) return _allPatients;
    return _allPatients.where((p) {
      return p.name.toLowerCase().contains(_searchQuery) ||
             p.id.toLowerCase().contains(_searchQuery) ||
             p.location.toLowerCase().contains(_searchQuery) ||
             p.guardian.toLowerCase().contains(_searchQuery) ||
             p.status.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  void _showPatientDetails(BuildContext context, PatientRecord patient) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.opal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.columbiaBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.child_care, color: AppColors.ming, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mingDark),
                        ),
                        Text('ID: ${patient.id} • Age: ${patient.age}', style: const TextStyle(color: Color(0xFF556B6D), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: AppColors.columbiaBlue),
              const SizedBox(height: 12),
              _buildDetailRow('Guardian', patient.guardian),
              const SizedBox(height: 8),
              _buildDetailRow('Clinic / Center', patient.location),
              const SizedBox(height: 8),
              _buildDetailRow('Current Treatment', patient.status),
              const SizedBox(height: 8),
              _buildDetailRow('Latest Pirani Score', patient.pirani, isHighlight: true),
              if (patient.alert != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF1EE),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8B4A8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFC04B35), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          patient.alert!,
                          style: const TextStyle(color: Color(0xFF9E3420), fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.ming,
                            content: Text('Contacting guardian via WhatsApp / SMS...'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline, color: AppColors.ming, size: 18),
                      label: const Text('Contact', style: TextStyle(color: AppColors.ming, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.ming),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.palmLeaf,
                            content: Text('Opening Pirani history chart & full records...'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history_edu, color: Colors.white, size: 18),
                      label: const Text('Full History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ming,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13.5, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.palmLeaf : AppColors.mingDark,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final patients = _filteredPatients;

    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: const Text('Patient Directory'),
        backgroundColor: AppColors.ming,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Search by Name, ID, Clinic, or Guardian...',
                hintStyle: const TextStyle(color: Color(0xFF889C9E)),
                prefixIcon: const Icon(Icons.search, color: AppColors.ming),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: patients.isEmpty
                ? const Center(
                    child: Text(
                      'No matching patients found.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final p = patients[index];
                      return _buildPatientTile(context, patient: p);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTile(BuildContext context, {required PatientRecord patient}) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
      ),
      child: InkWell(
        onTap: () => _showPatientDetails(context, patient),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.columbiaBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.child_care, color: AppColors.ming),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.mingDark)),
                          Text('ID: ${patient.id} • ${patient.age}', style: const TextStyle(color: Color(0xFF556B6D), fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.ming),
                ],
              ),
              const Divider(height: 24, color: AppColors.columbiaBlue),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Phase:', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                  Text(patient.status, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Latest Pirani Score:', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                  Text(
                    patient.pirani, 
                    style: const TextStyle(color: AppColors.palmLeaf, fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ],
              ),
              if (patient.alert != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF1EE), 
                    borderRadius: BorderRadius.circular(8), 
                    border: Border.all(color: const Color(0xFFE8B4A8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFC04B35), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          patient.alert!, 
                          style: const TextStyle(color: Color(0xFF9E3420), fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
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

