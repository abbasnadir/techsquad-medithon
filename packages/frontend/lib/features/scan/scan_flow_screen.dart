import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/scan/mock_3d_model_screen.dart';
import 'dart:ui' as ui;

class ScanFlowScreen extends StatefulWidget {
  const ScanFlowScreen({super.key});

  @override
  State<ScanFlowScreen> createState() => _ScanFlowScreenState();
}

class _ScanFlowScreenState extends State<ScanFlowScreen> {
  int _currentStep = 0;
  final List<String> _views = ['Medial (Inside) View', 'Lateral (Outside) View', 'Posterior (Heel) View'];
  final List<String> _instructions = [
    'Position the camera facing the inside of the foot. Ensure the inner arch is visible.',
    'Position the camera facing the outside of the foot. Ensure the outer curve is visible.',
    'Position the camera directly behind the heel. Ensure the Achilles tendon is centered.'
  ];

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _permissionDenied = false;
  bool _isProcessing = false;
  
  PoseDetector? _poseDetector;

  @override
  void initState() {
    super.initState();
    try {
      if (!kIsWeb) {
        _poseDetector = PoseDetector(options: PoseDetectorOptions());
      }
    } catch (_) {}
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          if (mounted) setState(() => _permissionDenied = true);
          return;
        }
      }
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _cameraController!.initialize();
        if (mounted) setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      // Camera may not be accessible on some desktop/web configurations
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector?.close();
    super.dispose();
  }

  Future<void> _processImageFile(XFile photo) async {
    setState(() => _isProcessing = true);
    try {
      final Uint8List imageBytes = await photo.readAsBytes();
      List<Pose> poses = [];
      bool isMock = true;

      if (_poseDetector != null && !kIsWeb) {
        try {
          final inputImage = InputImage.fromFilePath(photo.path);
          poses = await _poseDetector!.processImage(inputImage);
          isMock = poses.isEmpty;
        } catch (_) {
          isMock = true;
        }
      }
      
      if (mounted) {
        final proceed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => ImageAnalysisScreen(
              imageBytes: imageBytes, 
              poses: poses,
              viewName: _views[_currentStep],
              isFinalStep: _currentStep == _views.length - 1,
              isMock: isMock,
            ),
          ),
        );
        
        if (proceed == true && mounted) {
          if (_currentStep < _views.length - 1) {
            setState(() => _currentStep++);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      // If camera not ready, open gallery/file picker directly
      await _pickImage();
      return;
    }
    try {
      final XFile photo = await _cameraController!.takePicture();
      await _processImageFile(photo);
    } catch (e) {
      await _pickImage();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      await _processImageFile(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera Error')),
        body: const Center(child: Text('Camera permission required.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: Text('CTEV Scan: Step ${_currentStep + 1} of 3'),
        backgroundColor: AppColors.ming,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _isProcessing ? null : _pickImage,
            tooltip: 'Upload from Gallery',
          )
        ],
      ),
      body: Stack(
        children: [
          if (_isCameraInitialized)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator(color: AppColors.ming)),
            
          // Top Guidance & Step Indicator Card
          Positioned(
            top: 16, left: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.columbiaBlue, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.camera_enhance, color: AppColors.ming, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _views[_currentStep],
                            style: const TextStyle(color: AppColors.mingDark, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.palmLeaf.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Step ${_currentStep + 1} of 3',
                          style: const TextStyle(color: AppColors.palmLeaf, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _instructions[_currentStep], 
                    style: const TextStyle(color: Color(0xFF374151), fontSize: 13.5, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.ming),
                        SizedBox(height: 16),
                        Text('Analyzing anatomical markers...', style: TextStyle(color: AppColors.mingDark, fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
          // Bottom Capture Bar
          Positioned(
            bottom: 28,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _captureImage,
                    icon: const Icon(Icons.camera_alt),
                    label: Text('Capture ${_views[_currentStep]}'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.ming,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.photo_library, color: AppColors.ming),
                    onPressed: _isProcessing ? null : _pickImage,
                    tooltip: 'Upload Image',
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageAnalysisScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final List<Pose> poses;
  final String viewName;
  final bool isFinalStep;
  final bool isMock;

  const ImageAnalysisScreen({
    super.key, 
    required this.imageBytes, 
    required this.poses, 
    required this.viewName, 
    required this.isFinalStep,
    required this.isMock,
  });

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  ui.Image? _loadedImage;
  Map<String, Offset> _keypoints = {};
  String? _activeDraggingKey;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final codec = await ui.instantiateImageCodec(widget.imageBytes);
    final frameInfo = await codec.getNextFrame();
    final img = frameInfo.image;
    
    final w = img.width.toDouble();
    final h = img.height.toDouble();

    // Position default markers on the lower leg / foot region
    Map<String, Offset> initialPoints = {};
    if (widget.viewName.contains('Medial')) {
      // Medial (Inside view): Calf/Ankle top-center, Heel lower-left, Toes lower-right
      initialPoints['Ankle'] = Offset(w * 0.50, h * 0.70);
      initialPoints['Heel'] = Offset(w * 0.36, h * 0.85);
      initialPoints['Toes'] = Offset(w * 0.66, h * 0.86);
    } else if (widget.viewName.contains('Lateral')) {
      // Lateral (Outside view): Ankle top-center, Heel lower-right, Toes lower-left
      initialPoints['Ankle'] = Offset(w * 0.50, h * 0.70);
      initialPoints['Heel'] = Offset(w * 0.64, h * 0.85);
      initialPoints['Toes'] = Offset(w * 0.34, h * 0.86);
    } else {
      // Posterior (Heel view): Calf, Ankle/Achilles, Heel base
      initialPoints['Calf'] = Offset(w * 0.50, h * 0.62);
      initialPoints['Ankle'] = Offset(w * 0.50, h * 0.74);
      initialPoints['Heel'] = Offset(w * 0.50, h * 0.88);
    }

    if (mounted) {
      setState(() {
        _loadedImage = img;
        _keypoints = initialPoints;
      });
    }
  }

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    if (_loadedImage == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Convert local position inside FittedBox to image coordinate space
    final w = _loadedImage!.width.toDouble();
    final h = _loadedImage!.height.toDouble();
    final scale = constraints.maxWidth / w;
    final renderedHeight = h * scale;
    final touchOffset = Offset(
      details.localPosition.dx / scale,
      details.localPosition.dy / scale,
    );

    // Find nearest landmark within 60px (image coords)
    String? nearestKey;
    double minDistance = 60.0 / scale; // scaled threshold

    _keypoints.forEach((key, point) {
      final d = (point - touchOffset).distance;
      if (d < minDistance) {
        minDistance = d;
        nearestKey = key;
      }
    });

    _activeDraggingKey = nearestKey;
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_loadedImage == null || _activeDraggingKey == null) return;

    final w = _loadedImage!.width.toDouble();
    final h = _loadedImage!.height.toDouble();
    final scale = constraints.maxWidth / w;

    final newOffset = Offset(
      (details.localPosition.dx / scale).clamp(0.0, w),
      (details.localPosition.dy / scale).clamp(0.0, h),
    );

    setState(() {
      _keypoints[_activeDraggingKey!] = newOffset;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _activeDraggingKey = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.antiFlashWhite,
      appBar: AppBar(
        title: Text('${widget.viewName} Alignment'),
        backgroundColor: AppColors.ming,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Markers',
            onPressed: _loadImage,
          ),
        ],
      ),
      body: _loadedImage == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.ming))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.columbiaBlue, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.touch_app, color: AppColors.ming, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Drag markers directly onto the baby\'s leg & foot landmarks.',
                            style: TextStyle(color: AppColors.mingDark, fontSize: 13.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.columbiaBlue, width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onPanStart: (d) => _onPanStart(d, constraints),
                          onPanUpdate: (d) => _onPanUpdate(d, constraints),
                          onPanEnd: _onPanEnd,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: _loadedImage!.width.toDouble(),
                              height: _loadedImage!.height.toDouble(),
                              child: CustomPaint(
                                painter: FootLandmarkPainter(
                                  image: _loadedImage!,
                                  keypoints: _keypoints,
                                  viewName: widget.viewName,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (widget.isFinalStep) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Mock3DModelScreen()),
                          );
                        } else {
                          Navigator.pop(context, true); 
                        }
                      },
                      icon: Icon(widget.isFinalStep ? Icons.auto_graph : Icons.check_circle),
                      label: Text(
                        widget.isFinalStep ? 'Generate 3D Assessment' : 'Confirm & Next View', 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isFinalStep ? AppColors.palmLeaf : AppColors.ming,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class FootLandmarkPainter extends CustomPainter {
  final ui.Image image;
  final Map<String, Offset> keypoints;
  final String viewName;

  FootLandmarkPainter({
    required this.image,
    required this.keypoints,
    required this.viewName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the background image
    canvas.drawImage(image, Offset.zero, Paint());

    // 2. Line Paint for anatomical connections
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..color = AppColors.ming;

    // Connect the points
    final pointsList = keypoints.values.toList();
    if (pointsList.length >= 2) {
      for (int i = 0; i < pointsList.length - 1; i++) {
        canvas.drawLine(pointsList[i], pointsList[i + 1], linePaint);
      }
      if (pointsList.length == 3 && !viewName.contains('Posterior')) {
        final dashedPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..color = AppColors.opal;
        canvas.drawLine(pointsList[0], pointsList[2], dashedPaint);
      }
    }

    // 3. Draw Landmark Nodes and Text Labels
    final outerGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.opal.withOpacity(0.45);

    final nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.palmLeaf;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.white;

    keypoints.forEach((label, point) {
      // Outer glow
      canvas.drawCircle(point, 32, outerGlowPaint);
      // Inner node
      canvas.drawCircle(point, 20, nodePaint);
      // White border
      canvas.drawCircle(point, 20, borderPaint);

      // Label background & text
      final textSpan = TextSpan(
        text: ' $label ',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          backgroundColor: AppColors.mingDark,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = Offset(point.dx - (textPainter.width / 2), point.dy - 55);
      textPainter.paint(canvas, textOffset);
    });
  }

  @override
  bool shouldRepaint(covariant FootLandmarkPainter oldDelegate) => true;
}

