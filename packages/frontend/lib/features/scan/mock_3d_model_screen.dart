import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';

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
        backgroundColor: Colors.white,
        title: const Text('Data Collection Consent', style: TextStyle(color: AppColors.mingDark, fontWeight: FontWeight.bold)),
        content: const Text(
          'Help us improve! Do you consent to securely uploading this anonymized 3-view scan to help train future Clubfoot AI models?',
          style: TextStyle(color: AppColors.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.ming,
                  content: Text('Record saved locally.'),
                ),
              );
            },
            child: const Text('No, thanks', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.palmLeaf,
                  content: Text('Record saved & anonymized data shared!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ming, foregroundColor: Colors.white),
            child: const Text('Yes, I consent'),
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
        title: const Text('3D CTEV Reconstruction'), 
        backgroundColor: AppColors.ming, 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isGenerating) ...[
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.ming, strokeWidth: 3.5),
                        const SizedBox(height: 24),
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            String step = 'Fusing Medial & Lateral views...';
                            if (_progressController.value > 0.25) step = 'Aligning Posterior markers...';
                            if (_progressController.value > 0.5) step = 'Extrapolating 3D Point Cloud...';
                            if (_progressController.value > 0.75) step = 'Calculating automated Pirani Score...';
                            return Column(
                              children: [
                                Text(
                                  step, 
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.mingDark, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: _progressController.value,
                                    backgroundColor: AppColors.columbiaBlue.withOpacity(0.4),
                                    color: AppColors.palmLeaf,
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // 3D Canvas Card
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.view_in_ar, color: AppColors.ming, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Interactive 3D Anatomical Model', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: AppColors.mingDark),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.columbiaBlue.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Auto-Rotating', style: TextStyle(fontSize: 10.5, color: AppColors.mingDark, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 260,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.opal.withOpacity(0.4)),
                          ),
                          child: AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: WireframeFootPainter(_rotationController.value * 2 * pi),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Pirani Score Assessment Card
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: AppColors.columbiaBlue, width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Assessment Result',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.mingDark),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF1EE),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE8B4A8)),
                              ),
                              child: const Text(
                                'High Severity',
                                style: TextStyle(color: Color(0xFF9E3420), fontWeight: FontWeight.bold, fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.ming.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.ming.withOpacity(0.3)),
                              ),
                              child: const Column(
                                children: [
                                  Text('Pirani Score', style: TextStyle(fontSize: 11, color: AppColors.mingDark)),
                                  SizedBox(height: 2),
                                  Text('4.5 / 6.0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ming)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• Hindfoot Score (HFCS): 2.5', style: TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('• Midfoot Score (MFCS): 2.0', style: TextStyle(fontSize: 12.5, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('• Recommendation: Ponseti Cast 3', style: TextStyle(fontSize: 12.5, color: AppColors.palmLeaf, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showConsentDialog(context),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Save Assessment & Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ming,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
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

class WireframeFootPainter extends CustomPainter {
  final double angleY;
  WireframeFootPainter(this.angleY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ming.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final dotPaint = Paint()..color = AppColors.palmLeaf;

    // Format: [x, y, z]
    final List<List<double>> points3D = [
      [0, -85, 0],   // 0: Ankle
      [-26, 68, -18], // 1: Heel Left
      [26, 68, -18],  // 2: Heel Right
      [0, 85, 34],   // 3: Heel Back
      [-34, 18, 68], // 4: Toe 1 (Outer)
      [-9, 26, 78],  // 5: Toe 2
      [18, 26, 68],  // 6: Toe 3
      [34, 18, 52],  // 7: Toe 4 (Inner)
      [0, 42, 18],   // 8: Arch
    ];

    final cx = size.width / 2;
    final cy = size.height / 2;

    List<Offset> projected = [];
    for (var p in points3D) {
      double x = p[0] * cos(angleY) - p[2] * sin(angleY);
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

