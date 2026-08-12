import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
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
  
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
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
    } else {
      if (mounted) setState(() => _permissionDenied = true);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  Future<void> _processImageFile(File imageFile) async {
    setState(() => _isProcessing = true);
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      
      final bool isMock = poses.isEmpty;
      
      if (mounted) {
        final proceed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => ImageAnalysisScreen(
              imageFile: imageFile, 
              poses: poses,
              viewName: _views[_currentStep],
              isFinalStep: _currentStep == _views.length - 1,
              isMock: isMock,
            ),
          ),
        );
        
        if (proceed == true) {
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
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    try {
      final XFile photo = await _cameraController!.takePicture();
      await _processImageFile(File(photo.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      await _processImageFile(File(file.path));
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1}: ${_views[_currentStep]}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _isProcessing ? null : _pickImage,
            tooltip: 'Upload Image',
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
            const Center(child: CircularProgressIndicator()),
            
          Positioned(
            top: 16, left: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.teal)),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.teal),
                      SizedBox(width: 8),
                      Text('ML Guidance', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_instructions[_currentStep], style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),
          
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 16),
                    Text('Running ML Pose Detection...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: _isProcessing ? null : _captureImage,
              icon: const Icon(Icons.camera),
              label: Text('Capture ${_views[_currentStep]}'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageAnalysisScreen extends StatelessWidget {
  final File imageFile;
  final List<Pose> poses;
  final String viewName;
  final bool isFinalStep;
  final bool isMock;

  const ImageAnalysisScreen({
    super.key, 
    required this.imageFile, 
    required this.poses, 
    required this.viewName, 
    required this.isFinalStep,
    required this.isMock,
  });

  Future<ui.Image> _loadImage() async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$viewName Analysis'),
      ),
      body: FutureBuilder<ui.Image>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Failed to load image.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: snapshot.data!.width.toDouble(),
                      height: snapshot.data!.height.toDouble(),
                      child: CustomPaint(
                        painter: PosePainter(snapshot.data!, poses, isMock, viewName),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isMock 
                      ? 'Demo Mode: Google ML Kit failed to find full body. Displaying simulated keypoints for $viewName.' 
                      : 'Detected real ML keypoints for $viewName successfully.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isMock ? Colors.amber.shade900 : Colors.teal),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isFinalStep) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Mock3DModelScreen()),
                        );
                      } else {
                        Navigator.pop(context, true); 
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(isFinalStep ? 'Finish Assessment' : 'Approve & Next View', style: const TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final ui.Image image;
  final List<Pose> poses;
  final bool isMock;
  final String viewName;

  PosePainter(this.image, this.poses, this.isMock, this.viewName);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..color = Colors.red;
      
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = Colors.tealAccent;

    if (isMock) {
      final w = image.width.toDouble();
      final h = image.height.toDouble();
      final cx = w / 2;
      final cy = h / 2;
      
      Offset ankle, heel, toe;
      if (viewName.contains('Medial')) {
        // Medial (Inside): Heel left, Toes right
        ankle = Offset(cx, cy - h * 0.15);
        heel = Offset(cx - w * 0.15, cy + h * 0.1);
        toe = Offset(cx + w * 0.2, cy + h * 0.15);
        
        canvas.drawCircle(ankle, 20, paint);
        canvas.drawCircle(heel, 20, paint);
        canvas.drawCircle(toe, 20, paint);
        
        canvas.drawLine(ankle, heel, linePaint);
        canvas.drawLine(heel, toe, linePaint);
        canvas.drawLine(ankle, toe, linePaint);
      } else if (viewName.contains('Lateral')) {
        // Lateral (Outside): Heel right, Toes left
        ankle = Offset(cx, cy - h * 0.15);
        heel = Offset(cx + w * 0.15, cy + h * 0.1);
        toe = Offset(cx - w * 0.2, cy + h * 0.15);
        
        canvas.drawCircle(ankle, 20, paint);
        canvas.drawCircle(heel, 20, paint);
        canvas.drawCircle(toe, 20, paint);
        
        canvas.drawLine(ankle, heel, linePaint);
        canvas.drawLine(heel, toe, linePaint);
        canvas.drawLine(ankle, toe, linePaint);
      } else { // Posterior
        // Posterior (Heel): Looking at back of heel, toes hidden
        ankle = Offset(cx, cy - h * 0.15);
        heel = Offset(cx, cy + h * 0.15);
        
        canvas.drawCircle(ankle, 20, paint);
        canvas.drawCircle(heel, 20, paint);
        canvas.drawLine(ankle, heel, linePaint);
      }
      return;
    }

    for (final pose in poses) {
      final landmarksToDraw = [
        PoseLandmarkType.leftAnkle, PoseLandmarkType.rightAnkle,
        PoseLandmarkType.leftHeel, PoseLandmarkType.rightHeel,
        PoseLandmarkType.leftFootIndex, PoseLandmarkType.rightFootIndex,
      ];

      for (var type in landmarksToDraw) {
        final landmark = pose.landmarks[type];
        if (landmark != null && landmark.likelihood > 0.5) {
          canvas.drawCircle(Offset(landmark.x, landmark.y), 20, paint);
        }
      }
      
      void drawLineIfPresent(PoseLandmarkType a, PoseLandmarkType b) {
        final lA = pose.landmarks[a];
        final lB = pose.landmarks[b];
        if (lA != null && lB != null && lA.likelihood > 0.5 && lB.likelihood > 0.5) {
          canvas.drawLine(Offset(lA.x, lA.y), Offset(lB.x, lB.y), linePaint);
        }
      }

      drawLineIfPresent(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel);
      drawLineIfPresent(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex);
      drawLineIfPresent(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex);
      
      drawLineIfPresent(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel);
      drawLineIfPresent(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex);
      drawLineIfPresent(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) => oldDelegate.image != image || oldDelegate.poses != poses || oldDelegate.isMock != isMock;
}
