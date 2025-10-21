import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Voice input service for speech-to-text functionality
/// Enables users to log symptoms and moods using voice commands
class VoiceInputService extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  
  // Voice recognition state
  bool _isListening = false;
  bool _isAvailable = false;
  String _recognizedText = '';
  double _confidence = 0.0;
  String? _errorMessage;
  
  // Voice command patterns for symptoms
  final Map<String, List<String>> _symptomPatterns = {
    'cramps': ['cramp', 'cramping', 'menstrual cramps', 'period pain', 'abdominal pain'],
    'headache': ['headache', 'head ache', 'migraine', 'head pain'],
    'bloating': ['bloating', 'bloated', 'swollen', 'belly bloated'],
    'breast_tenderness': ['breast tenderness', 'sore breasts', 'breast pain'],
    'fatigue': ['tired', 'fatigue', 'exhausted', 'sleepy', 'low energy'],
    'nausea': ['nausea', 'nauseous', 'feel sick', 'queasy'],
    'back_pain': ['back pain', 'lower back pain', 'back ache'],
    'acne': ['acne', 'pimples', 'breakout', 'skin problems'],
    'mood_swings': ['mood swings', 'moody', 'emotional', 'irritable'],
    'food_cravings': ['food cravings', 'craving', 'hungry', 'appetite'],
  };

  final Map<String, List<String>> _moodPatterns = {
    'happy': ['happy', 'good', 'great', 'wonderful', 'excellent', 'cheerful'],
    'sad': ['sad', 'down', 'low', 'depressed', 'blue'],
    'anxious': ['anxious', 'worried', 'nervous', 'stressed', 'tense'],
    'angry': ['angry', 'mad', 'irritated', 'annoyed', 'frustrated'],
    'calm': ['calm', 'peaceful', 'relaxed', 'serene', 'tranquil'],
    'energetic': ['energetic', 'active', 'pumped', 'motivated', 'lively'],
    'tired': ['tired', 'exhausted', 'drained', 'weary', 'fatigued'],
  };

  // Getters
  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;
  String get recognizedText => _recognizedText;
  double get confidence => _confidence;
  String? get errorMessage => _errorMessage;

  /// Initialize the voice input service
  Future<bool> initialize() async {
    try {
      // Request microphone permission
      final permissionStatus = await Permission.microphone.request();
      if (permissionStatus != PermissionStatus.granted) {
        _errorMessage = 'Microphone permission denied';
        notifyListeners();
        return false;
      }

      // Initialize speech recognition
      _isAvailable = await _speechToText.initialize(
        onError: (error) {
          _errorMessage = error.errorMsg;
          _isListening = false;
          notifyListeners();
        },
        onStatus: (status) {
          _isListening = status == 'listening';
          notifyListeners();
        },
      );

      if (_isAvailable) {
        _errorMessage = null;
        debugPrint('Voice input service initialized successfully');
      } else {
        _errorMessage = 'Speech recognition not available';
      }

      notifyListeners();
      return _isAvailable;
    } catch (e) {
      _errorMessage = 'Error initializing voice input: $e';
      _isAvailable = false;
      notifyListeners();
      return false;
    }
  }

  /// Start listening for voice input
  Future<void> startListening({
    required VoiceInputType inputType,
    Duration? timeout,
  }) async {
    if (!_isAvailable || _isListening) return;

    try {
      _errorMessage = null;
      _recognizedText = '';
      _confidence = 0.0;
      
      final localeId = _getLocaleForInputType(inputType);
      
      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          _confidence = result.confidence;
          notifyListeners();
        },
        listenFor: timeout ?? const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: localeId,
        onSoundLevelChange: (level) {
          // Could be used for visual feedback
        },
      );
    } catch (e) {
      _errorMessage = 'Error starting voice input: $e';
      notifyListeners();
    }
  }

  /// Stop listening for voice input
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _isListening = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error stopping voice input: $e';
      notifyListeners();
    }
  }

  /// Cancel voice input session
  Future<void> cancel() async {
    if (!_isListening) return;

    try {
      await _speechToText.cancel();
      _isListening = false;
      _recognizedText = '';
      _confidence = 0.0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error canceling voice input: $e';
      notifyListeners();
    }
  }

  /// Parse voice input for symptoms
  List<String> parseSymptoms(String voiceInput) {
    final recognizedSymptoms = <String>[];
    final lowerInput = voiceInput.toLowerCase();

    for (final entry in _symptomPatterns.entries) {
      final symptomName = entry.key;
      final patterns = entry.value;

      for (final pattern in patterns) {
        if (lowerInput.contains(pattern.toLowerCase())) {
          recognizedSymptoms.add(_formatSymptomName(symptomName));
          break; // Avoid duplicates for the same symptom
        }
      }
    }

    return recognizedSymptoms;
  }

  /// Parse voice input for mood
  String? parseMood(String voiceInput) {
    final lowerInput = voiceInput.toLowerCase();

    for (final entry in _moodPatterns.entries) {
      final moodName = entry.key;
      final patterns = entry.value;

      for (final pattern in patterns) {
        if (lowerInput.contains(pattern.toLowerCase())) {
          return _formatMoodName(moodName);
        }
      }
    }

    return null;
  }

  /// Process voice input and return structured data
  VoiceInputResult processVoiceInput(String voiceInput, VoiceInputType type) {
    switch (type) {
      case VoiceInputType.symptoms:
        final symptoms = parseSymptoms(voiceInput);
        return VoiceInputResult(
          type: type,
          originalText: voiceInput,
          confidence: _confidence,
          symptoms: symptoms,
        );

      case VoiceInputType.mood:
        final mood = parseMood(voiceInput);
        return VoiceInputResult(
          type: type,
          originalText: voiceInput,
          confidence: _confidence,
          mood: mood,
        );

      case VoiceInputType.general:
        final symptoms = parseSymptoms(voiceInput);
        final mood = parseMood(voiceInput);
        return VoiceInputResult(
          type: type,
          originalText: voiceInput,
          confidence: _confidence,
          symptoms: symptoms,
          mood: mood,
        );

      case VoiceInputType.notes:
        return VoiceInputResult(
          type: type,
          originalText: voiceInput,
          confidence: _confidence,
          notes: voiceInput,
        );
    }
  }

  /// Get current voice input result
  VoiceInputResult? getCurrentResult(VoiceInputType type) {
    if (_recognizedText.isEmpty) return null;
    return processVoiceInput(_recognizedText, type);
  }

  /// Clear current recognition session
  void clearSession() {
    _recognizedText = '';
    _confidence = 0.0;
    _errorMessage = null;
    notifyListeners();
  }

  /// Helper methods
  String _getLocaleForInputType(VoiceInputType type) {
    // Could be customized based on user preferences
    return 'en_US';
  }

  String _formatSymptomName(String symptomKey) {
    return symptomKey.replaceAll('_', ' ').split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatMoodName(String moodKey) {
    return moodKey[0].toUpperCase() + moodKey.substring(1);
  }

  /// Get available voice commands help text
  String getVoiceCommandsHelp(VoiceInputType type) {
    switch (type) {
      case VoiceInputType.symptoms:
        return '''
Try saying things like:
• "I have cramps and a headache"
• "Experiencing bloating today"
• "Feeling tired and moody"
• "My back hurts and I'm nauseous"
        '''.trim();

      case VoiceInputType.mood:
        return '''
Try describing your mood:
• "I'm feeling happy today"
• "I'm anxious and worried"
• "Feeling calm and relaxed"
• "I'm tired and low energy"
        '''.trim();

      case VoiceInputType.general:
        return '''
Tell me how you're feeling:
• "I have cramps and feeling sad"
• "Happy but experiencing headaches"
• "Tired with back pain today"
        '''.trim();

      case VoiceInputType.notes:
        return '''
Share any additional notes:
• General observations about your cycle
• Anything else you'd like to record
        '''.trim();
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}

/// Types of voice input for different contexts
enum VoiceInputType {
  symptoms,
  mood,
  general,
  notes,
}

/// Result of voice input processing
class VoiceInputResult {
  final VoiceInputType type;
  final String originalText;
  final double confidence;
  final List<String>? symptoms;
  final String? mood;
  final String? notes;
  final DateTime timestamp;

  VoiceInputResult({
    required this.type,
    required this.originalText,
    required this.confidence,
    this.symptoms,
    this.mood,
    this.notes,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'originalText': originalText,
      'confidence': confidence,
      'symptoms': symptoms,
      'mood': mood,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get hasResults => 
      (symptoms?.isNotEmpty ?? false) || 
      mood != null || 
      (notes?.isNotEmpty ?? false);

  String get formattedResults {
    final parts = <String>[];
    
    if (symptoms?.isNotEmpty ?? false) {
      parts.add('Symptoms: ${symptoms!.join(", ")}');
    }
    
    if (mood != null) {
      parts.add('Mood: $mood');
    }
    
    if (notes?.isNotEmpty ?? false) {
      parts.add('Notes: $notes');
    }
    
    return parts.join('\n');
  }
}
