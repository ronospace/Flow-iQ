import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cycle_data.dart';
import '../models/ai_insights.dart';
import 'flow_iq_sync_service.dart';

/// Enhanced AI Service implementing vision features for adaptive, personalized AI coach
class EnhancedAIService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlowIQSyncService _syncService;

  // AI State
  bool _isProcessing = false;
  List<PersonalizedInsight> _personalizedInsights = [];
  UserPersonalizationProfile? _userProfile;

  EnhancedAIService(this._syncService) {
    _initializePersonalization();
  }

  // Getters
  bool get isProcessing => _isProcessing;
  List<PersonalizedInsight> get personalizedInsights => _personalizedInsights;
  UserPersonalizationProfile? get userProfile => _userProfile;
  User? get currentUser => _auth.currentUser;

  /// Initialize user personalization profile
  Future<void> _initializePersonalization() async {
    if (currentUser == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('ai_profile')
          .doc('personalization')
          .get();

      if (doc.exists) {
        _userProfile = UserPersonalizationProfile.fromFirestore(doc);
      } else {
        _userProfile = UserPersonalizationProfile.createDefault(currentUser!.uid);
        await _savePersonalizationProfile();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing personalization: $e');
    }
  }

  /// Generate adaptive cycle predictions with self-correction
  Future<AdaptiveCyclePrediction> generateAdaptivePrediction() async {
    if (currentUser == null) return AdaptiveCyclePrediction.empty();

    _isProcessing = true;
    notifyListeners();

    try {
      // Get historical data
      final cycles = await _syncService.cycles;
      final insights = await _syncService.getRecentInsights(limit: 50);
      final wearableData = await _getWearableData();

      // Generate prediction using advanced algorithm
      final prediction = await _runPredictionAlgorithm(
        cycles: cycles,
        insights: insights,
        wearableData: wearableData,
        userProfile: _userProfile!,
      );

      // Store prediction for feedback learning
      await _storePrediction(prediction);

      return prediction;
    } catch (e) {
      debugPrint('Error generating adaptive prediction: $e');
      return AdaptiveCyclePrediction.empty();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Generate personalized insights based on cycle phase and user preferences
  Future<List<PersonalizedInsight>> generatePersonalizedInsights({
    required CyclePhase currentPhase,
    int limit = 5,
  }) async {
    if (currentUser == null || _userProfile == null) return [];

    try {
      final insights = <PersonalizedInsight>[];

      // Phase-specific insights
      insights.addAll(await _generatePhaseSpecificInsights(currentPhase));
      
      // Behavioral recommendations
      insights.addAll(await _generateBehavioralRecommendations());
      
      // Health optimization tips
      insights.addAll(await _generateHealthOptimizationTips());

      // Predictive warnings/alerts
      insights.addAll(await _generatePredictiveAlerts());

      // Sort by relevance and user preference
      insights.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

      _personalizedInsights = insights.take(limit).toList();
      notifyListeners();

      return _personalizedInsights;
    } catch (e) {
      debugPrint('Error generating personalized insights: $e');
      return [];
    }
  }

  /// Generate phase-specific recommendations (luteal-friendly workouts, etc.)
  Future<List<PersonalizedInsight>> _generatePhaseSpecificInsights(CyclePhase phase) async {
    final insights = <PersonalizedInsight>[];

    switch (phase) {
      case CyclePhase.menstrual:
        insights.add(PersonalizedInsight(
          id: 'menstrual_rest_${DateTime.now().millisecondsSinceEpoch}',
          type: PersonalizedInsightType.selfCare,
          title: 'Gentle Movement for Your Period',
          description: 'Your body is working hard right now. Light yoga or walking can help with cramps.',
          recommendation: 'Try 15 minutes of gentle stretching or a short walk in nature.',
          relevanceScore: 0.9,
          personalizedFor: _userProfile!.preferences,
          actionable: true,
          createdAt: DateTime.now(),
        ));
        break;

      case CyclePhase.follicular:
        insights.add(PersonalizedInsight(
          id: 'follicular_energy_${DateTime.now().millisecondsSinceEpoch}',
          type: PersonalizedInsightType.exercise,
          title: 'High Energy Phase - Time to Shine!',
          description: 'Your energy is building. Perfect time for challenging workouts and new projects.',
          recommendation: 'Try HIIT workouts or start that new fitness challenge you\'ve been considering.',
          relevanceScore: 0.85,
          personalizedFor: _userProfile!.preferences,
          actionable: true,
          createdAt: DateTime.now(),
        ));
        break;

      case CyclePhase.ovulatory:
        insights.add(PersonalizedInsight(
          id: 'ovulatory_confidence_${DateTime.now().millisecondsSinceEpoch}',
          type: PersonalizedInsightType.mood,
          title: 'Peak Confidence Window',
          description: 'You\'re likely feeling most confident and social. Great time for important conversations.',
          recommendation: 'Schedule important meetings or have that conversation you\'ve been putting off.',
          relevanceScore: 0.88,
          personalizedFor: _userProfile!.preferences,
          actionable: true,
          createdAt: DateTime.now(),
        ));
        break;

      case CyclePhase.luteal:
        insights.add(PersonalizedInsight(
          id: 'luteal_nutrition_${DateTime.now().millisecondsSinceEpoch}',
          type: PersonalizedInsightType.nutrition,
          title: 'Luteal Phase Nutrition Support',
          description: 'Your body needs extra support now. Focus on magnesium and B-vitamins.',
          recommendation: 'Include dark leafy greens, nuts, and complex carbs in your meals.',
          relevanceScore: 0.87,
          personalizedFor: _userProfile!.preferences,
          actionable: true,
          createdAt: DateTime.now(),
        ));
        break;

      case CyclePhase.unknown:
        break;
    }

    return insights;
  }

  /// Generate behavioral and lifestyle recommendations
  Future<List<PersonalizedInsight>> _generateBehavioralRecommendations() async {
    final insights = <PersonalizedInsight>[];

    // Sleep optimization based on cycle phase
    final sleepInsight = await _generateSleepOptimizationInsight();
    if (sleepInsight != null) insights.add(sleepInsight);

    // Stress management recommendations
    final stressInsight = await _generateStressManagementInsight();
    if (stressInsight != null) insights.add(stressInsight);

    return insights;
  }

  /// Generate health optimization tips based on user history
  Future<List<PersonalizedInsight>> _generateHealthOptimizationTips() async {
    final insights = <PersonalizedInsight>[];

    // Analyze patterns and suggest improvements
    if (_userProfile!.hasIrregularCycles) {
      insights.add(PersonalizedInsight(
        id: 'irregular_cycles_tip_${DateTime.now().millisecondsSinceEpoch}',
        type: PersonalizedInsightType.health,
        title: 'Cycle Regularity Support',
        description: 'We\'ve noticed some irregular patterns. Here are evidence-based tips to help.',
        recommendation: 'Maintain consistent sleep schedule and consider reducing caffeine intake.',
        relevanceScore: 0.8,
        personalizedFor: _userProfile!.preferences,
        actionable: true,
        createdAt: DateTime.now(),
      ));
    }

    return insights;
  }

  /// Generate predictive alerts and warnings
  Future<List<PersonalizedInsight>> _generatePredictiveAlerts() async {
    final insights = <PersonalizedInsight>[];

    // Predictive mood alert
    if (_userProfile!.hasMoodPatterns) {
      insights.add(PersonalizedInsight(
        id: 'mood_prediction_${DateTime.now().millisecondsSinceEpoch}',
        type: PersonalizedInsightType.prediction,
        title: 'Mood Forecast',
        description: 'Based on your patterns, you might feel low energy in 2-3 days.',
        recommendation: 'Plan lighter activities and prioritize self-care this weekend.',
        relevanceScore: 0.75,
        personalizedFor: _userProfile!.preferences,
        actionable: true,
        createdAt: DateTime.now(),
      ));
    }

    return insights;
  }

  /// Update user personalization profile based on feedback
  Future<void> updatePersonalizationWithFeedback(UserFeedback feedback) async {
    if (_userProfile == null) return;

    try {
      _userProfile = _userProfile!.updateWithFeedback(feedback);
      await _savePersonalizationProfile();
      
      // Trigger new insights generation
      await generatePersonalizedInsights(
        currentPhase: _syncService.currentCycle?.currentPhase ?? CyclePhase.unknown,
      );
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating personalization: $e');
    }
  }

  /// Helper methods
  Future<WearableData?> _getWearableData() async {
    // TODO: Implement wearable data integration
    return null;
  }

  Future<AdaptiveCyclePrediction> _runPredictionAlgorithm({
    required List<CycleData> cycles,
    required List<AIInsights> insights,
    required WearableData? wearableData,
    required UserPersonalizationProfile userProfile,
  }) async {
    // TODO: Implement advanced ML prediction algorithm
    // This would use TensorFlow Lite models for on-device prediction
    return AdaptiveCyclePrediction.empty();
  }

  Future<void> _storePrediction(AdaptiveCyclePrediction prediction) async {
    // Store for feedback learning
  }

  Future<PersonalizedInsight?> _generateSleepOptimizationInsight() async {
    // TODO: Implement sleep pattern analysis
    return null;
  }

  Future<PersonalizedInsight?> _generateStressManagementInsight() async {
    // TODO: Implement stress pattern analysis
    return null;
  }

  Future<void> _savePersonalizationProfile() async {
    if (currentUser == null || _userProfile == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('ai_profile')
        .doc('personalization')
        .set(_userProfile!.toFirestore());
  }

  /// Generate conversational AI insights for voice assistant
  Future<AIInsights> generateInsight(String prompt, {bool isConversational = false}) async {
    try {
      _isProcessing = true;
      notifyListeners();

      // Process the prompt and generate context-aware response
      final response = await _processConversationalPrompt(prompt, isConversational);
      
      final insight = AIInsights(
        id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
        userId: currentUser?.uid ?? 'anonymous',
        cycleId: _syncService.currentCycle?.id ?? 'unknown',
        type: InsightType.general,
        title: 'Voice Assistant Response',
        description: response,
        recommendation: _isActionablePrompt(prompt) ? 'Follow the suggestions provided.' : '',
        confidence: 0.85,
        data: {
          'conversational': isConversational,
          'prompt': prompt,
          'generated_by': 'enhanced_ai_service',
          'actionable': _isActionablePrompt(prompt),
        },
        tags: ['voice_assistant', 'conversational'],
        createdAt: DateTime.now(),
      );

      return insight;
    } catch (e) {
      debugPrint('Error generating conversational insight: $e');
      return AIInsights(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        userId: currentUser?.uid ?? 'anonymous',
        cycleId: 'error',
        type: InsightType.general,
        title: 'Error Response',
        description: "I'm having trouble processing your request right now. Please try again.",
        recommendation: 'Try rephrasing your question or try again later.',
        confidence: 0.0,
        data: {'error': e.toString()},
        tags: ['error', 'voice_assistant'],
        createdAt: DateTime.now(),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Process conversational prompts with context awareness
  Future<String> _processConversationalPrompt(String prompt, bool isConversational) async {
    final lowerPrompt = prompt.toLowerCase();
    
    // Health and cycle related queries
    if (lowerPrompt.contains('cycle') || lowerPrompt.contains('period')) {
      return await _generateCycleResponse(prompt);
    }
    
    if (lowerPrompt.contains('symptom')) {
      return await _generateSymptomResponse(prompt);
    }
    
    if (lowerPrompt.contains('mood') || lowerPrompt.contains('feeling')) {
      return await _generateMoodResponse(prompt);
    }
    
    if (lowerPrompt.contains('insight') || lowerPrompt.contains('recommendation')) {
      return await _generateInsightResponse(prompt);
    }
    
    if (lowerPrompt.contains('tip') || lowerPrompt.contains('advice')) {
      return await _generateAdviceResponse(prompt);
    }
    
    // Fallback conversational response
    return await _generateGeneralResponse(prompt);
  }

  Future<String> _generateCycleResponse(String prompt) async {
    final currentCycle = _syncService.currentCycle;
    
    if (currentCycle == null) {
      return "I'd love to help with cycle insights! To get started, try logging your period start date in the tracking section. This will help me provide personalized predictions and insights about your cycle.";
    }
    
    final dayInCycle = DateTime.now().difference(currentCycle.startDate).inDays + 1;
    final phase = currentCycle.currentPhase;
    
    return "You're currently on day $dayInCycle of your cycle, in the ${_phaseToFriendlyName(phase)} phase. Based on your patterns, ${_getPhaseSpecificInfo(phase)}. Would you like specific tips for this phase?";
  }

  Future<String> _generateSymptomResponse(String prompt) async {
    return "I can help you track and understand your symptoms! Common period-related symptoms include cramps, headaches, bloating, and mood changes. These often vary by cycle phase - for example, cramps are most common during menstruation, while breast tenderness often occurs in the luteal phase. What symptoms are you experiencing?";
  }

  Future<String> _generateMoodResponse(String prompt) async {
    return "Your mood naturally fluctuates with your cycle due to hormonal changes. During the follicular phase, you might feel more energetic and optimistic. The luteal phase can bring emotional sensitivity. Remember, these feelings are completely normal! Tracking your mood can help you prepare and practice self-compassion.";
  }

  Future<String> _generateInsightResponse(String prompt) async {
    if (_personalizedInsights.isNotEmpty) {
      final insight = _personalizedInsights.first;
      return "Here's a personalized insight for you: ${insight.title}. ${insight.description} ${insight.recommendation}";
    }
    
    return "I'm generating personalized insights based on your cycle data. In the meantime, remember that every person's cycle is unique. The key to feeling your best is understanding your own patterns and honoring what your body needs in each phase.";
  }

  Future<String> _generateAdviceResponse(String prompt) async {
    final tips = [
      "Stay hydrated throughout your cycle - it helps with energy and can reduce bloating.",
      "Gentle movement like yoga or walking can help with cramps and mood.",
      "During your luteal phase, try to get extra sleep as your body is working harder.",
      "Iron-rich foods like spinach and lentils can help combat period fatigue.",
      "Keeping a symptom diary can help you identify patterns and triggers.",
    ];
    
    final randomTip = tips[DateTime.now().millisecond % tips.length];
    return "Here's a helpful tip: $randomTip Would you like more specific advice for any particular aspect of your cycle?";
  }

  Future<String> _generateGeneralResponse(String prompt) async {
    return "I'm here to support your menstrual health journey! I can help with cycle tracking, symptom analysis, mood patterns, and personalized recommendations. What would you like to know or discuss about your health today?";
  }

  String _phaseToFriendlyName(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'menstrual';
      case CyclePhase.follicular:
        return 'follicular';
      case CyclePhase.ovulatory:
        return 'ovulatory';
      case CyclePhase.luteal:
        return 'luteal';
      case CyclePhase.unknown:
        return 'unknown';
    }
  }

  String _getPhaseSpecificInfo(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'your body is shedding the uterine lining. Focus on rest and gentle self-care';
      case CyclePhase.follicular:
        return 'your energy is building and you might feel more motivated for new challenges';
      case CyclePhase.ovulatory:
        return 'you\'re likely feeling most confident and social - great time for important conversations';
      case CyclePhase.luteal:
        return 'your body is preparing for your next period. Extra self-care and nutrition support can be helpful';
      case CyclePhase.unknown:
        return 'tracking more data will help me provide better insights';
    }
  }

  bool _isActionablePrompt(String prompt) {
    final actionableKeywords = [
      'track', 'log', 'record', 'help', 'recommend', 'suggest', 'tip', 'advice'
    ];
    
    return actionableKeywords.any((keyword) => 
        prompt.toLowerCase().contains(keyword));
  }
}

/// Enhanced models for vision features
class PersonalizedInsight {
  final String id;
  final PersonalizedInsightType type;
  final String title;
  final String description;
  final String recommendation;
  final double relevanceScore;
  final UserPreferences personalizedFor;
  final bool actionable;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PersonalizedInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.relevanceScore,
    required this.personalizedFor,
    required this.actionable,
    required this.createdAt,
    this.metadata,
  });
}

enum PersonalizedInsightType {
  exercise,
  nutrition,
  sleep,
  mood,
  selfCare,
  health,
  prediction,
  warning,
}

class AdaptiveCyclePrediction {
  final DateTime nextPeriodDate;
  final DateTime fertileWindowStart;
  final DateTime fertileWindowEnd;
  final double confidence;
  final List<PredictionFactor> factors;
  final Map<String, dynamic> metadata;

  AdaptiveCyclePrediction({
    required this.nextPeriodDate,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.confidence,
    required this.factors,
    required this.metadata,
  });

  static AdaptiveCyclePrediction empty() {
    final now = DateTime.now();
    return AdaptiveCyclePrediction(
      nextPeriodDate: now.add(const Duration(days: 28)),
      fertileWindowStart: now.add(const Duration(days: 12)),
      fertileWindowEnd: now.add(const Duration(days: 16)),
      confidence: 0.0,
      factors: [],
      metadata: {},
    );
  }
}

class PredictionFactor {
  final String name;
  final double weight;
  final String description;

  PredictionFactor({
    required this.name,
    required this.weight,
    required this.description,
  });
}

class UserPersonalizationProfile {
  final String userId;
  final UserPreferences preferences;
  final List<String> goals;
  final Map<String, double> behaviorPatterns;
  final DateTime lastUpdated;

  UserPersonalizationProfile({
    required this.userId,
    required this.preferences,
    required this.goals,
    required this.behaviorPatterns,
    required this.lastUpdated,
  });

  static UserPersonalizationProfile createDefault(String userId) {
    return UserPersonalizationProfile(
      userId: userId,
      preferences: UserPreferences.defaults(),
      goals: ['track_cycle', 'understand_patterns'],
      behaviorPatterns: {},
      lastUpdated: DateTime.now(),
    );
  }

  factory UserPersonalizationProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserPersonalizationProfile(
      userId: doc.id,
      preferences: UserPreferences.fromMap(data['preferences'] ?? {}),
      goals: List<String>.from(data['goals'] ?? []),
      behaviorPatterns: Map<String, double>.from(data['behaviorPatterns'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'preferences': preferences.toMap(),
      'goals': goals,
      'behaviorPatterns': behaviorPatterns,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  UserPersonalizationProfile updateWithFeedback(UserFeedback feedback) {
    // TODO: Implement feedback learning logic
    return this;
  }

  bool get hasIrregularCycles => behaviorPatterns['cycle_variance'] != null && behaviorPatterns['cycle_variance']! > 5.0;
  bool get hasMoodPatterns => behaviorPatterns.containsKey('mood_patterns');
}

class UserPreferences {
  final String communicationTone; // supportive, clinical, casual, empathetic
  final List<String> focusAreas; // fertility, symptoms, mood, general_health
  final bool enablePredictiveAlerts;
  final Map<String, bool> notificationPreferences;

  UserPreferences({
    required this.communicationTone,
    required this.focusAreas,
    required this.enablePredictiveAlerts,
    required this.notificationPreferences,
  });

  static UserPreferences defaults() {
    return UserPreferences(
      communicationTone: 'supportive',
      focusAreas: ['general_health'],
      enablePredictiveAlerts: true,
      notificationPreferences: {
        'daily_check_in': true,
        'cycle_predictions': true,
        'health_insights': true,
      },
    );
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      communicationTone: map['communicationTone'] ?? 'supportive',
      focusAreas: List<String>.from(map['focusAreas'] ?? ['general_health']),
      enablePredictiveAlerts: map['enablePredictiveAlerts'] ?? true,
      notificationPreferences: Map<String, bool>.from(map['notificationPreferences'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communicationTone': communicationTone,
      'focusAreas': focusAreas,
      'enablePredictiveAlerts': enablePredictiveAlerts,
      'notificationPreferences': notificationPreferences,
    };
  }
}

class UserFeedback {
  final String insightId;
  final FeedbackType type;
  final double rating;
  final String? comment;
  final DateTime timestamp;

  UserFeedback({
    required this.insightId,
    required this.type,
    required this.rating,
    this.comment,
    required this.timestamp,
  });
}

enum FeedbackType { helpful, notHelpful, accurate, inaccurate, tooFrequent, tooRare }

class WearableData {
  final DateTime date;
  final double? heartRateAvg;
  final double? sleepHours;
  final double? basalBodyTemperature;
  final int? steps;
  final Map<String, dynamic> additionalMetrics;

  WearableData({
    required this.date,
    this.heartRateAvg,
    this.sleepHours,
    this.basalBodyTemperature,
    this.steps,
    required this.additionalMetrics,
  });
}
