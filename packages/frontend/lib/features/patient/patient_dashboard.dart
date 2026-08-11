import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(context),
            const SizedBox(height: 24),
            const Text(
              'Pirani Score Progress (Right Foot)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProgressGraph(context),
            const SizedBox(height: 24),
            const Text(
              'Visit History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildVisitHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: const Icon(Icons.person, size: 40, color: Colors.teal),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Demo Child 01', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('ID: MED-0012', style: TextStyle(color: Colors.grey)),
                  Text('Age: 6 months | Bilateral CTEV', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressGraph(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text('W${value.toInt()}', style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toString(), style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
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
                  color: Colors.teal,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitHistory() {
    final visits = [
      {'date': 'Oct 12, 2026', 'score': '1.5', 'action': 'Tenotomy scheduled'},
      {'date': 'Oct 5, 2026', 'score': '2.5', 'action': 'Cast 3 applied'},
      {'date': 'Sep 28, 2026', 'score': '3.5', 'action': 'Cast 2 applied'},
      {'date': 'Sep 21, 2026', 'score': '4.5', 'action': 'Cast 1 applied'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Text('W${4 - index}'),
            ),
            title: Text(visit['date']!),
            subtitle: Text(visit['action']!),
            trailing: Text('Score: ${visit['score']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      },
    );
  }
}
