import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import '../services/voice_input_service.dart';

/// Multimodal input service that combines voice, photo, and text analysis
/// for comprehensive symptom and mood tracking
class MultimodalInputService extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final VoiceInputService _voiceService;
  
  // Camera state
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  
  // Analysis state
  bool _isAnalyzing = false;
  String? _errorMessage;
  
  // Analysis results
  List<MultimodalAnalysisResult> _analysisHistory = [];

  MultimodalInputService(this._voiceService);

  // Getters
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  List<MultimodalAnalysisResult> get analysisHistory => _analysisHistory;
  CameraController? get cameraController => _cameraController;

  /// Initialize multimodal input service
  Future<bool> initialize() async {
    try {
      // Request permissions
      final permissionsGranted = await _requestPermissions();
      if (!permissionsGranted) {
        _errorMessage = 'Permissions denied for camera and/or microphone';
        notifyListeners();
        return false;
      }

      // Initialize camera
      await _initializeCamera();
      
      // Initialize voice service
      await _voiceService.initialize();

      _errorMessage = null;
      debugPrint('Multimodal input service initialized successfully');
      return true;
    } catch (e) {
      _errorMessage = 'Error initializing multimodal service: $e';
      debugPrint(_errorMessage);
      return false;
    }
  }

  /// Request necessary permissions
  Future<bool> _requestPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();
    final photosPermission = await Permission.photos.request();

    return cameraPermission.isGranted && 
           microphonePermission.isGranted && 
           photosPermission.isGranted;
  }

  /// Initialize camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use front camera for selfies (mood analysis)
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isCameraInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      _isCameraInitialized = false;
    }
  }

  /// Capture and analyze mood selfie
  Future<MultimodalAnalysisResult?> captureMoodSelfie() async {
    if (!_isCameraInitialized || _cameraController == null) {
      _errorMessage = 'Camera not initialized';
      notifyListeners();
      return null;
    }

    try {
      _isAnalyzing = true;
      _errorMessage = null;
      notifyListeners();

      // Capture image
      final XFile imageFile = await _cameraController!.takePicture();
      
      // Analyze mood from image
      final moodAnalysis = await _analyzeMoodFromImage(imageFile.path);
      
      // Create result
      final result = MultimodalAnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MultimodalInputType.moodSelfie,
        timestamp: DateTime.now(),
        imagePath: imageFile.path,
        moodAnalysis: moodAnalysis,
      );

      _analysisHistory.insert(0, result);
      return result;
    } catch (e) {
      _errorMessage = 'Error capturing mood selfie: $e';
      debugPrint(_errorMessage);
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Analyze skin condition from photo
  Future<MultimodalAnalysisResult?> analyzeSkinPhoto() async {
    try {
      _isAnalyzing = true;
      _errorMessage = null;
      notifyListeners();

      // Pick image from gallery or camera
      final XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (imageFile == null) {
        return null;
      }

      // Analyze skin condition
      final skinAnalysis = await _analyzeSkinFromImage(imageFile.path);

      // Create result
      final result = MultimodalAnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MultimodalInputType.skinAnalysis,
        timestamp: DateTime.now(),
        imagePath: imageFile.path,
        skinAnalysis: skinAnalysis,
      );

      _analysisHistory.insert(0, result);
      return result;
    } catch (e) {
      _errorMessage = 'Error analyzing skin photo: $e';
      debugPrint(_errorMessage);
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Combined voice and visual analysis
  Future<MultimodalAnalysisResult?> performCombinedAnalysis({
    required String voiceDescription,
    XFile? supportingImage,
  }) async {
    try {
      _isAnalyzing = true;
      _errorMessage = null;
      notifyListeners();

      // Analyze voice input
      final voiceResult = _voiceService.processVoiceInput(
        voiceDescription, 
        VoiceInputType.general,
      );

      // Analyze supporting image if provided
      ImageAnalysis? imageAnalysis;
      if (supportingImage != null) {
        imageAnalysis = await _analyzeGeneralImage(supportingImage.path);
      }

      // Create combined result
      final result = MultimodalAnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MultimodalInputType.combined,
        timestamp: DateTime.now(),
        voiceInput: voiceDescription,
        voiceResult: voiceResult,
        imagePath: supportingImage?.path,
        imageAnalysis: imageAnalysis,
      );

      _analysisHistory.insert(0, result);
      return result;
    } catch (e) {
      _errorMessage = 'Error performing combined analysis: $e';
      debugPrint(_errorMessage);
      return null;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Analyze mood from facial image
  Future<MoodAnalysis> _analyzeMoodFromImage(String imagePath) async {
    // Simulate AI mood analysis from facial features
    // In a real implementation, this would use ML models like FaceNet or emotion recognition APIs
    
    try {
      // Load and process image
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Invalid image format');
      }

      // Simulate mood analysis based on image properties
      final brightness = _calculateImageBrightness(image);
      final contrast = _calculateImageContrast(image);
      
      // Simple heuristic-based mood detection (placeholder for real AI)
      String detectedMood;
      double confidence;
      
      if (brightness > 150 && contrast > 50) {
        detectedMood = 'Happy';
        confidence = 0.8;
      } else if (brightness < 100) {
        detectedMood = 'Tired';
        confidence = 0.7;
      } else if (contrast < 30) {
        detectedMood = 'Calm';
        confidence = 0.6;
      } else {
        detectedMood = 'Neutral';
        confidence = 0.5;
      }

      return MoodAnalysis(
        detectedMood: detectedMood,
        confidence: confidence,
        analysisMethod: 'Facial feature analysis',
        additionalData: {
          'brightness': brightness,
          'contrast': contrast,
          'image_size': '${image.width}x${image.height}',
        },
      );
    } catch (e) {
      debugPrint('Error in mood analysis: $e');
      return MoodAnalysis(
        detectedMood: 'Unknown',
        confidence: 0.0,
        analysisMethod: 'Error during analysis',
        additionalData: {'error': e.toString()},
      );
    }
  }

  /// Analyze skin condition from image
  Future<SkinAnalysis> _analyzeSkinFromImage(String imagePath) async {
    // Simulate AI skin analysis
    // In a real implementation, this would use dermatology ML models
    
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Invalid image format');
      }

      // Simulate skin analysis based on color analysis
      final avgRed = _calculateAverageColorChannel(image, ColorChannel.red);
      final avgGreen = _calculateAverageColorChannel(image, ColorChannel.green);
      final avgBlue = _calculateAverageColorChannel(image, ColorChannel.blue);
      
      // Simple heuristic-based skin condition detection
      List<String> detectedConditions = [];
      double overallConfidence = 0.6;
      
      if (avgRed > avgGreen && avgRed > avgBlue) {
        detectedConditions.add('Redness/Inflammation');
      }
      
      if (avgRed > 180 && avgGreen < 120 && avgBlue < 120) {
        detectedConditions.add('Acne breakout');
        overallConfidence = 0.7;
      }
      
      if (detectedConditions.isEmpty) {
        detectedConditions.add('Normal skin tone');
        overallConfidence = 0.8;
      }

      return SkinAnalysis(
        detectedConditions: detectedConditions,
        confidence: overallConfidence,
        skinTone: _determineSkinTone(avgRed, avgGreen, avgBlue),
        recommendations: _generateSkinRecommendations(detectedConditions),
        analysisMethod: 'Color-based skin analysis',
        additionalData: {
          'avg_red': avgRed,
          'avg_green': avgGreen,
          'avg_blue': avgBlue,
        },
      );
    } catch (e) {
      debugPrint('Error in skin analysis: $e');
      return SkinAnalysis(
        detectedConditions: ['Analysis error'],
        confidence: 0.0,
        skinTone: 'Unknown',
        recommendations: ['Please try again with better lighting'],
        analysisMethod: 'Error during analysis',
        additionalData: {'error': e.toString()},
      );
    }
  }

  /// Analyze general image for context
  Future<ImageAnalysis> _analyzeGeneralImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Invalid image format');
      }

      // Basic image analysis
      final brightness = _calculateImageBrightness(image);
      final dominantColor = _getDominantColor(image);
      
      return ImageAnalysis(
        imageQuality: brightness > 100 ? 'Good' : 'Poor lighting',
        dominantColors: [dominantColor],
        analysisMethod: 'Basic image processing',
        confidence: 0.6,
        additionalData: {
          'brightness': brightness,
          'dimensions': '${image.width}x${image.height}',
        },
      );
    } catch (e) {
      debugPrint('Error in general image analysis: $e');
      return ImageAnalysis(
        imageQuality: 'Analysis failed',
        dominantColors: [],
        analysisMethod: 'Error during analysis',
        confidence: 0.0,
        additionalData: {'error': e.toString()},
      );
    }
  }

  /// Helper methods for image processing
  double _calculateImageBrightness(img.Image image) {
    int totalBrightness = 0;
    int pixelCount = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        totalBrightness += ((r + g + b) ~/ 3);
        pixelCount++;
      }
    }
    
    return totalBrightness / pixelCount;
  }

  double _calculateImageContrast(img.Image image) {
    // Simplified contrast calculation
    final brightness = _calculateImageBrightness(image);
    double sumSquaredDiff = 0;
    int pixelCount = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        final pixelBrightness = (r + g + b) / 3;
        sumSquaredDiff += (pixelBrightness - brightness) * (pixelBrightness - brightness);
        pixelCount++;
      }
    }
    
    return sumSquaredDiff / pixelCount;
  }

  double _calculateAverageColorChannel(img.Image image, ColorChannel channel) {
    int totalValue = 0;
    int pixelCount = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        switch (channel) {
          case ColorChannel.red:
            totalValue += pixel.r.toInt();
            break;
          case ColorChannel.green:
            totalValue += pixel.g.toInt();
            break;
          case ColorChannel.blue:
            totalValue += pixel.b.toInt();
            break;
        }
        pixelCount++;
      }
    }
    
    return totalValue / pixelCount;
  }

  String _getDominantColor(img.Image image) {
    final avgRed = _calculateAverageColorChannel(image, ColorChannel.red);
    final avgGreen = _calculateAverageColorChannel(image, ColorChannel.green);
    final avgBlue = _calculateAverageColorChannel(image, ColorChannel.blue);
    
    if (avgRed > avgGreen && avgRed > avgBlue) {
      return 'Red tones';
    } else if (avgGreen > avgRed && avgGreen > avgBlue) {
      return 'Green tones';
    } else if (avgBlue > avgRed && avgBlue > avgGreen) {
      return 'Blue tones';
    } else {
      return 'Neutral tones';
    }
  }

  String _determineSkinTone(double avgRed, double avgGreen, double avgBlue) {
    if (avgRed > 200 && avgGreen > 180 && avgBlue > 160) {
      return 'Light';
    } else if (avgRed > 160 && avgGreen > 140 && avgBlue > 120) {
      return 'Medium';
    } else {
      return 'Dark';
    }
  }

  List<String> _generateSkinRecommendations(List<String> conditions) {
    final recommendations = <String>[];
    
    for (final condition in conditions) {
      switch (condition.toLowerCase()) {
        case 'redness/inflammation':
          recommendations.add('Consider anti-inflammatory skincare');
          recommendations.add('Track hormonal changes');
          break;
        case 'acne breakout':
          recommendations.add('Monitor cycle phase correlation');
          recommendations.add('Consider stress and diet factors');
          break;
        default:
          recommendations.add('Maintain current skincare routine');
      }
    }
    
    return recommendations;
  }

  /// Clear analysis history
  void clearHistory() {
    _analysisHistory.clear();
    notifyListeners();
  }

  /// Get analysis by ID
  MultimodalAnalysisResult? getAnalysisById(String id) {
    try {
      return _analysisHistory.firstWhere((result) => result.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

/// Types of multimodal input
enum MultimodalInputType {
  moodSelfie,
  skinAnalysis,
  combined,
}

enum ColorChannel { red, green, blue }

/// Analysis result containing multiple input modalities
class MultimodalAnalysisResult {
  final String id;
  final MultimodalInputType type;
  final DateTime timestamp;
  final String? voiceInput;
  final VoiceInputResult? voiceResult;
  final String? imagePath;
  final MoodAnalysis? moodAnalysis;
  final SkinAnalysis? skinAnalysis;
  final ImageAnalysis? imageAnalysis;

  MultimodalAnalysisResult({
    required this.id,
    required this.type,
    required this.timestamp,
    this.voiceInput,
    this.voiceResult,
    this.imagePath,
    this.moodAnalysis,
    this.skinAnalysis,
    this.imageAnalysis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'voiceInput': voiceInput,
      'voiceResult': voiceResult?.toMap(),
      'imagePath': imagePath,
      'moodAnalysis': moodAnalysis?.toMap(),
      'skinAnalysis': skinAnalysis?.toMap(),
      'imageAnalysis': imageAnalysis?.toMap(),
    };
  }

  String get summary {
    final parts = <String>[];
    
    if (moodAnalysis != null) {
      parts.add('Mood: ${moodAnalysis!.detectedMood}');
    }
    
    if (skinAnalysis != null) {
      parts.add('Skin: ${skinAnalysis!.detectedConditions.join(', ')}');
    }
    
    if (voiceResult?.hasResults ?? false) {
      parts.add('Voice: ${voiceResult!.formattedResults}');
    }
    
    return parts.isNotEmpty ? parts.join(' | ') : 'No significant findings';
  }
}

/// Mood analysis result
class MoodAnalysis {
  final String detectedMood;
  final double confidence;
  final String analysisMethod;
  final Map<String, dynamic> additionalData;

  MoodAnalysis({
    required this.detectedMood,
    required this.confidence,
    required this.analysisMethod,
    required this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'detectedMood': detectedMood,
      'confidence': confidence,
      'analysisMethod': analysisMethod,
      'additionalData': additionalData,
    };
  }
}

/// Skin analysis result
class SkinAnalysis {
  final List<String> detectedConditions;
  final double confidence;
  final String skinTone;
  final List<String> recommendations;
  final String analysisMethod;
  final Map<String, dynamic> additionalData;

  SkinAnalysis({
    required this.detectedConditions,
    required this.confidence,
    required this.skinTone,
    required this.recommendations,
    required this.analysisMethod,
    required this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'detectedConditions': detectedConditions,
      'confidence': confidence,
      'skinTone': skinTone,
      'recommendations': recommendations,
      'analysisMethod': analysisMethod,
      'additionalData': additionalData,
    };
  }
}

/// General image analysis result
class ImageAnalysis {
  final String imageQuality;
  final List<String> dominantColors;
  final String analysisMethod;
  final double confidence;
  final Map<String, dynamic> additionalData;

  ImageAnalysis({
    required this.imageQuality,
    required this.dominantColors,
    required this.analysisMethod,
    required this.confidence,
    required this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageQuality': imageQuality,
      'dominantColors': dominantColors,
      'analysisMethod': analysisMethod,
      'confidence': confidence,
      'additionalData': additionalData,
    };
  }
}
