import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _braceHours = 18;

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  void _logBraceHour() {
    setState(() {
      if (_braceHours < 23) _braceHours++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.palmLeaf,
        content: Text('Brace usage logged successfully!'),
      ),
    );
  }

  void _showTeleConsultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Contact Clinic', style: TextStyle(color: AppColors.mingDark, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Issue Type'),
              items: const [
                DropdownMenuItem(value: 'Pain', child: Text('Pain / Discomfort')),
                DropdownMenuItem(value: 'Swelling', child: Text('Swelling / Redness')),
                DropdownMenuItem(value: 'Brace', child: Text('Brace Broken / Doesn\'t Fit')),
                DropdownMenuItem(value: 'Other', child: Text('Other Question')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Describe the issue...'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt, color: AppColors.ming),
              label: const Text('Attach Photo of Foot', style: TextStyle(color: AppColors.ming)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.opal),
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
                  backgroundColor: AppColors.ming,
                  content: Text('Secure message & photo sent to the clinic!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ming, foregroundColor: Colors.white),
            child: const Text('Send to Doctor'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: const Text('My SureStep Care'),
        backgroundColor: AppColors.ming,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mingDark),
            ),
            const SizedBox(height: 16),
            _buildDailyInfoCard(context),
            const SizedBox(height: 20),
            _buildContactDoctorCard(context),
            const SizedBox(height: 24),
            const Text(
              'My Treatment Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mingDark),
            ),
            const SizedBox(height: 14),
            _buildProgressGraph(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.ming, AppColors.mingDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Brace Tracker',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.palmLeaf,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Active Phase', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Please ensure the Foot Abduction Brace (FAB) is worn for 23 hours today.',
              style: TextStyle(color: AppColors.columbiaBlue, fontSize: 13.5),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Today\'s Compliance:', style: TextStyle(color: Colors.white70)),
                Text('$_braceHours / 23 Hours', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _braceHours / 23, 
                minHeight: 10,
                backgroundColor: Colors.white24, 
                color: AppColors.palmLeafLight,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _braceHours < 23 ? _logBraceHour : null,
                icon: const Icon(Icons.timer),
                label: Text(_braceHours < 23 ? 'Log +1 Hour of Brace Wear' : 'Daily Goal Reached!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.antiFlashWhite,
                  foregroundColor: AppColors.mingDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDoctorCard(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.columbiaBlue, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: AppColors.palmLeaf.withOpacity(0.15),
          child: const Icon(Icons.medical_services, color: AppColors.palmLeaf),
        ),
        title: const Text('Contact Healthcare Worker', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mingDark)),
        subtitle: const Text('Report pain, swelling, or ask questions.', style: TextStyle(color: Color(0xFF4A5568))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.ming),
        onTap: () => _showTeleConsultDialog(context),
      ),
    );
  }

  Widget _buildProgressGraph(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.columbiaBlue, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text('W${value.toInt()}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) => Text(value.toString(), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: AppColors.columbiaBlue)),
              minX: 1,
              maxX: 4,
              minY: 0,
              maxY: 6,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(1, 4.5),
                    FlSpot(2, 3.5),
                    FlSpot(3, 2.5),
                    FlSpot(4, 1.5),
                  ],
                  isCurved: true,
                  color: AppColors.ming,
                  barWidth: 3.5,
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.opal.withOpacity(0.25),
                  ),
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

