import 'package:cloud_firestore/cloud_firestore.dart';

/// AI-powered insights and recommendations for Flow Ai users
class AIInsights {
  final String id;
  final String userId;
  final String cycleId;
  final InsightType type;
  final String title;
  final String description;
  final String recommendation;
  final double confidence;
  final Map<String, dynamic> data;
  final List<String> tags;
  final bool isRead;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const AIInsights({
    required this.id,
    required this.userId,
    required this.cycleId,
    required this.type,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.confidence,
    required this.data,
    required this.tags,
    this.isRead = false,
    this.isPinned = false,
    required this.createdAt,
    this.expiresAt,
  });

  factory AIInsights.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AIInsights(
      id: doc.id,
      userId: data['userId'] ?? '',
      cycleId: data['cycleId'] ?? '',
      type: InsightType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => InsightType.general,
      ),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      recommendation: data['recommendation'] ?? '',
      confidence: data['confidence']?.toDouble() ?? 0.0,
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
      isRead: data['isRead'] ?? false,
      isPinned: data['isPinned'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'cycleId': cycleId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'recommendation': recommendation,
      'confidence': confidence,
      'data': data,
      'tags': tags,
      'isRead': isRead,
      'isPinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }

  AIInsights copyWith({
    String? id,
    String? userId,
    String? cycleId,
    InsightType? type,
    String? title,
    String? description,
    String? recommendation,
    double? confidence,
    Map<String, dynamic>? data,
    List<String>? tags,
    bool? isRead,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return AIInsights(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cycleId: cycleId ?? this.cycleId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      recommendation: recommendation ?? this.recommendation,
      confidence: confidence ?? this.confidence,
      data: data ?? this.data,
      tags: tags ?? this.tags,
      isRead: isRead ?? this.isRead,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  bool get isHighConfidence => confidence >= 0.8;
  bool get isMediumConfidence => confidence >= 0.6 && confidence < 0.8;
  bool get isLowConfidence => confidence < 0.6;

  @override
  String toString() {
    return 'AIInsights(id: $id, type: $type, title: $title, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AIInsights && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum InsightType {
  cyclePattern,
  symptomCorrelation,
  moodTracking,
  fertilityWindow,
  healthRecommendation,
  nutritionAdvice,
  exerciseGuidance,
  sleepOptimization,
  stressManagement,
  general,
}

extension InsightTypeExtension on InsightType {
  String get displayName {
    switch (this) {
      case InsightType.cyclePattern:
        return 'Cycle Pattern';
      case InsightType.symptomCorrelation:
        return 'Symptom Correlation';
      case InsightType.moodTracking:
        return 'Mood Insights';
      case InsightType.fertilityWindow:
        return 'Fertility Window';
      case InsightType.healthRecommendation:
        return 'Health Recommendation';
      case InsightType.nutritionAdvice:
        return 'Nutrition Advice';
      case InsightType.exerciseGuidance:
        return 'Exercise Guidance';
      case InsightType.sleepOptimization:
        return 'Sleep Optimization';
      case InsightType.stressManagement:
        return 'Stress Management';
      case InsightType.general:
        return 'General Insight';
    }
  }

  String get icon {
    switch (this) {
      case InsightType.cyclePattern:
        return '📊';
      case InsightType.symptomCorrelation:
        return '🔍';
      case InsightType.moodTracking:
        return '😊';
      case InsightType.fertilityWindow:
        return '🌸';
      case InsightType.healthRecommendation:
        return '💊';
      case InsightType.nutritionAdvice:
        return '🥗';
      case InsightType.exerciseGuidance:
        return '🏃‍♀️';
      case InsightType.sleepOptimization:
        return '😴';
      case InsightType.stressManagement:
        return '🧘‍♀️';
      case InsightType.general:
        return '💡';
    }
  }
}

/// Predefined AI insight templates
class AIInsightTemplates {
  static AIInsights cycleLengthPattern({
    required String userId,
    required String cycleId,
    required int averageLength,
    required double variance,
  }) {
    return AIInsights(
      id: '',
      userId: userId,
      cycleId: cycleId,
      type: InsightType.cyclePattern,
      title: 'Your Cycle Pattern Analysis',
      description: 'Your average cycle length is $averageLength days with a variance of ${variance.toStringAsFixed(1)} days.',
      recommendation: variance < 2.0 
          ? 'Your cycles are very regular! Keep maintaining your healthy lifestyle.'
          : 'Your cycles show some variation. Consider tracking stress, sleep, and exercise patterns.',
      confidence: variance < 2.0 ? 0.9 : 0.7,
      data: {
        'averageLength': averageLength,
        'variance': variance,
        'regularity': variance < 2.0 ? 'high' : 'moderate',
      },
      tags: ['cycle', 'pattern', 'analysis'],
      createdAt: DateTime.now(),
    );
  }

  static AIInsights moodSymptomCorrelation({
    required String userId,
    required String cycleId,
    required String symptom,
    required String phase,
    required double correlation,
  }) {
    return AIInsights(
      id: '',
      userId: userId,
      cycleId: cycleId,
      type: InsightType.symptomCorrelation,
      title: 'Mood and $symptom Connection',
      description: 'We noticed $symptom tends to occur during your $phase phase.',
      recommendation: 'Try tracking mood alongside physical symptoms for better insights.',
      confidence: correlation.abs(),
      data: {
        'symptom': symptom,
        'phase': phase,
        'correlation': correlation,
      },
      tags: ['mood', 'symptoms', 'correlation'],
      createdAt: DateTime.now(),
    );
  }

  static AIInsights fertilityWindowPredict({
    required String userId,
    required String cycleId,
    required DateTime predictedOvulation,
    required int daysUntil,
  }) {
    return AIInsights(
      id: '',
      userId: userId,
      cycleId: cycleId,
      type: InsightType.fertilityWindow,
      title: 'Fertility Window Prediction',
      description: 'Your fertile window is predicted to start in $daysUntil days.',
      recommendation: 'Track cervical fluid and basal body temperature for more accurate predictions.',
      confidence: 0.8,
      data: {
        'predictedOvulation': predictedOvulation.toIso8601String(),
        'daysUntil': daysUntil,
        'fertileStart': predictedOvulation.subtract(const Duration(days: 5)).toIso8601String(),
        'fertileEnd': predictedOvulation.add(const Duration(days: 1)).toIso8601String(),
      },
      tags: ['fertility', 'ovulation', 'prediction'],
      createdAt: DateTime.now(),
      expiresAt: predictedOvulation.add(const Duration(days: 2)),
    );
  }
}
