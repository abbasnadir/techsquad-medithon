import 'dart:math';
import 'package:flutter/material.dart';

class Mock3DModelScreen extends StatefulWidget {
  const Mock3DModelScreen({super.key});

  @override
  State<Mock3DModelScreen> createState() => _Mock3DModelScreenState();
}

class _Mock3DModelScreenState extends State<Mock3DModelScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _progressController;
  bool _isGenerating = true;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    
    _progressController.forward().then((_) {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _progressController.dispose();
    super.dispose();
  }
  
  void _showConsentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Collection Consent'),
        content: const Text('Help us improve! Do you consent to securely uploading this anonymized 3-view scan to help train future Clubfoot AI models?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record saved locally.')));
            },
            child: const Text('No, thanks', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record saved & anonymized data shared!')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            child: const Text('Yes, I consent'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('3D Reconstruction'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating) ...[
              const CircularProgressIndicator(color: Colors.tealAccent),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  String step = 'Fusing Medial & Lateral views...';
                  if (_progressController.value > 0.25) step = 'Aligning Posterior markers...';
                  if (_progressController.value > 0.5) step = 'Extrapolating 3D Point Cloud...';
                  if (_progressController.value > 0.75) step = 'Calculating automated Pirani Score...';
                  return Text(step, style: const TextStyle(color: Colors.tealAccent, fontSize: 16));
                }
              ),
            ] else ...[
              SizedBox(
                width: 300,
                height: 300,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WireframeFootPainter(_rotationController.value * 2 * pi),
                    );
                  }
                ),
              ),
              const SizedBox(height: 32),
              const Text('3D Model Generated Successfully', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Automated Pirani Score: 4.5', style: TextStyle(color: Colors.tealAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _showConsentDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
                ),
                child: const Text('Save Assessment', style: TextStyle(color: Colors.white, fontSize: 18)),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class WireframeFootPainter extends CustomPainter {
  final double angleY;
  WireframeFootPainter(this.angleY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final dotPaint = Paint()..color = Colors.redAccent;

    // Format: [x, y, z]
    final List<List<double>> points3D = [
      [0, -100, 0], // 0: Ankle
      [-30, 80, -20], // 1: Heel Left
      [30, 80, -20], // 2: Heel Right
      [0, 100, 40],  // 3: Heel Back
      [-40, 20, 80], // 4: Toe 1 (Outer)
      [-10, 30, 90], // 5: Toe 2
      [20, 30, 80],  // 6: Toe 3
      [40, 20, 60],  // 7: Toe 4 (Inner)
      [0, 50, 20],   // 8: Arch
    ];

    final cx = size.width / 2;
    final cy = size.height / 2;

    List<Offset> projected = [];
    for (var p in points3D) {
      double x = p[0] * cos(angleY) - p[2] * sin(angleY);
      double z = p[0] * sin(angleY) + p[2] * cos(angleY);
      double y = p[1];
      
      projected.add(Offset(cx + x, cy + y));
      canvas.drawCircle(Offset(cx + x, cy + y), 5, dotPaint);
    }

    void drawLine(int i, int j) => canvas.drawLine(projected[i], projected[j], paint);
    
    drawLine(0, 1); drawLine(0, 2); drawLine(0, 3);
    drawLine(1, 2); drawLine(2, 3); drawLine(3, 1);
    drawLine(0, 8);
    drawLine(8, 4); drawLine(8, 5); drawLine(8, 6); drawLine(8, 7);
    drawLine(1, 4); drawLine(2, 7);
    drawLine(4, 5); drawLine(5, 6); drawLine(6, 7);
  }

  @override
  bool shouldRepaint(covariant WireframeFootPainter old) => old.angleY != angleY;
}
