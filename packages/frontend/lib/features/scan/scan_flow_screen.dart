import 'package:flutter/material.dart';

class ScanFlowScreen extends StatefulWidget {
  const ScanFlowScreen({super.key});

  @override
  State<ScanFlowScreen> createState() => _ScanFlowScreenState();
}

class _ScanFlowScreenState extends State<ScanFlowScreen> {
  int _currentStep = 0;
  final List<String> _views = ['Medial View', 'Lateral View', 'Posterior View'];

  void _nextStep() {
    if (_currentStep < _views.length - 1) {
      setState(() => _currentStep++);
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Complete'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pirani Score: 3.5 (Demo)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text('Confidence: High', style: TextStyle(color: Colors.green)),
            SizedBox(height: 16),
            Text('Note: This is a prototype estimate. Clinician review recommended.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close scan flow
            },
            child: const Text('Save Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standardized Capture'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_views.length, (index) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: _currentStep >= index ? Colors.teal : Colors.grey.shade300,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 4),
                    Text(_views[index], style: const TextStyle(fontSize: 12)),
                  ],
                );
              }),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.camera, size: 100, color: Colors.white24),
                  Positioned(
                    bottom: 30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Align foot for ${_views[_currentStep]}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: _nextStep,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture & Validate'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
