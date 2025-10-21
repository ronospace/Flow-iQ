import 'package:flutter/material.dart';

/// === CORE ENUMS ===

enum HealthPredictionType {
  cycleIrregularity,
  nextCycleAnomaly,
  fertilityHigh,
  fertilityLow,
  ovulation,
  pregnancyProbability,
  healthConditionRisk,
  moodDisorder,
  seasonalMoodChange,
  lifestyleImpact,
  symptomProgression,
  medicationEffectiveness,
  nutritionalDeficiency,
  sleepDisorder,
  stressImpact,
  exerciseImpact,
}

enum HealthSeverity {
  informational, // Just informative, no action needed
  low,          // Minor concern, lifestyle changes may help
  medium,       // Moderate concern, monitoring recommended
  high,         // Significant concern, medical consultation recommended
}

enum HealthConditionType {
  pcos,
  endometriosis,
  thyroidDysfunction,
  pms,
  pmdd,
  infertility,
  menopause,
  perimenopause,
  fibroids,
  ovariancysts,
  hormoneImbalance,
  ironDeficiency,
  vitaminDDeficiency,
  depression,
  anxiety,
  eatingDisorder,
}

/// === CORE DATA MODELS ===

/// Comprehensive health prediction with AI-generated insights
class HealthPrediction {
  final String id;
  final HealthPredictionType type;
  final String title;
  final String description;
  final double probability; // 0.0 - 1.0
  final Duration timeframe; // When this might occur/be relevant
  final HealthSeverity severity;
  final double confidence; // AI model confidence 0.0 - 1.0
  final List<String> recommendations;
  final List<String>? associatedSymptoms;
  final String? evidenceSource;
  final bool medicalConsultationRecommended;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, dynamic>? additionalData;
  final List<String>? tags;
  
  HealthPrediction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.probability,
    required this.timeframe,
    required this.severity,
    required this.confidence,
    required this.recommendations,
    this.associatedSymptoms,
    this.evidenceSource,
    this.medicalConsultationRecommended = false,
    required this.createdAt,
    this.expiresAt,
    this.additionalData,
    this.tags,
  });
  
  /// Get color for UI display based on severity
  Color get severityColor {
    switch (severity) {
      case HealthSeverity.informational:
        return const Color(0xFF4CAF50); // Green
      case HealthSeverity.low:
        return const Color(0xFF2196F3); // Blue
      case HealthSeverity.medium:
        return const Color(0xFFFF9800); // Orange
      case HealthSeverity.high:
        return const Color(0xFFF44336); // Red
    }
  }
  
  /// Get icon for UI display based on type
  IconData get typeIcon {
    switch (type) {
      case HealthPredictionType.cycleIrregularity:
      case HealthPredictionType.nextCycleAnomaly:
        return Icons.calendar_month;
      case HealthPredictionType.fertilityHigh:
      case HealthPredictionType.fertilityLow:
        return Icons.favorite;
      case HealthPredictionType.ovulation:
        return Icons.brightness_1;
      case HealthPredictionType.pregnancyProbability:
        return Icons.child_care;
      case HealthPredictionType.healthConditionRisk:
        return Icons.health_and_safety;
      case HealthPredictionType.moodDisorder:
      case HealthPredictionType.seasonalMoodChange:
        return Icons.psychology;
      case HealthPredictionType.lifestyleImpact:
        return Icons.emoji_people;
      case HealthPredictionType.symptomProgression:
        return Icons.trending_up;
      case HealthPredictionType.medicationEffectiveness:
        return Icons.medication;
      case HealthPredictionType.nutritionalDeficiency:
        return Icons.restaurant;
      case HealthPredictionType.sleepDisorder:
        return Icons.bedtime;
      case HealthPredictionType.stressImpact:
        return Icons.psychology_alt;
      case HealthPredictionType.exerciseImpact:
        return Icons.fitness_center;
    }
  }
  
  /// Check if prediction is still valid
  bool get isValid {
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }
  
  /// Get priority score for sorting (higher = more important)
  double get priorityScore {
    double score = probability * confidence;
    
    switch (severity) {
      case HealthSeverity.informational:
        score *= 0.5;
        break;
      case HealthSeverity.low:
        score *= 1.0;
        break;
      case HealthSeverity.medium:
        score *= 1.5;
        break;
      case HealthSeverity.high:
        score *= 2.0;
        break;
    }
    
    if (medicalConsultationRecommended) {
      score *= 1.3;
    }
    
    return score;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'probability': probability,
      'timeframe_days': timeframe.inDays,
      'severity': severity.name,
      'confidence': confidence,
      'recommendations': recommendations,
      'associated_symptoms': associatedSymptoms,
      'evidence_source': evidenceSource,
      'medical_consultation_recommended': medicalConsultationRecommended,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'additional_data': additionalData,
      'tags': tags,
    };
  }
  
  factory HealthPrediction.fromJson(Map<String, dynamic> json) {
    return HealthPrediction(
      id: json['id'],
      type: HealthPredictionType.values.byName(json['type']),
      title: json['title'],
      description: json['description'],
      probability: json['probability'].toDouble(),
      timeframe: Duration(days: json['timeframe_days']),
      severity: HealthSeverity.values.byName(json['severity']),
      confidence: json['confidence'].toDouble(),
      recommendations: List<String>.from(json['recommendations']),
      associatedSymptoms: json['associated_symptoms'] != null 
          ? List<String>.from(json['associated_symptoms'])
          : null,
      evidenceSource: json['evidence_source'],
      medicalConsultationRecommended: json['medical_consultation_recommended'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'])
          : null,
      additionalData: json['additional_data'],
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'])
          : null,
    );
  }
  
  HealthPrediction copyWith({
    String? id,
    HealthPredictionType? type,
    String? title,
    String? description,
    double? probability,
    Duration? timeframe,
    HealthSeverity? severity,
    double? confidence,
    List<String>? recommendations,
    List<String>? associatedSymptoms,
    String? evidenceSource,
    bool? medicalConsultationRecommended,
    DateTime? createdAt,
    DateTime? expiresAt,
    Map<String, dynamic>? additionalData,
    List<String>? tags,
  }) {
    return HealthPrediction(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      probability: probability ?? this.probability,
      timeframe: timeframe ?? this.timeframe,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
      recommendations: recommendations ?? this.recommendations,
      associatedSymptoms: associatedSymptoms ?? this.associatedSymptoms,
      evidenceSource: evidenceSource ?? this.evidenceSource,
      medicalConsultationRecommended: medicalConsultationRecommended ?? this.medicalConsultationRecommended,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      additionalData: additionalData ?? this.additionalData,
      tags: tags ?? this.tags,
    );
  }
}

/// Health alert for urgent or important predictions
class HealthAlert {
  final String id;
  final String predictionId;
  final String title;
  final String message;
  final HealthSeverity severity;
  final bool actionRequired;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? dismissedAt;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  
  HealthAlert({
    required this.id,
    required this.predictionId,
    required this.title,
    required this.message,
    required this.severity,
    required this.actionRequired,
    this.isRead = false,
    required this.createdAt,
    this.dismissedAt,
    this.actionUrl,
    this.metadata,
  });
  
  /// Get color for UI display
  Color get alertColor {
    switch (severity) {
      case HealthSeverity.informational:
        return const Color(0xFF4CAF50);
      case HealthSeverity.low:
        return const Color(0xFF2196F3);
      case HealthSeverity.medium:
        return const Color(0xFFFF9800);
      case HealthSeverity.high:
        return const Color(0xFFF44336);
    }
  }
  
  /// Check if alert is dismissed
  bool get isDismissed => dismissedAt != null;
  
  /// Get urgency score for sorting
  int get urgencyScore {
    int score = 0;
    
    switch (severity) {
      case HealthSeverity.informational:
        score = 1;
        break;
      case HealthSeverity.low:
        score = 2;
        break;
      case HealthSeverity.medium:
        score = 3;
        break;
      case HealthSeverity.high:
        score = 4;
        break;
    }
    
    if (actionRequired) score += 2;
    if (!isRead) score += 1;
    
    return score;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prediction_id': predictionId,
      'title': title,
      'message': message,
      'severity': severity.name,
      'action_required': actionRequired,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'dismissed_at': dismissedAt?.toIso8601String(),
      'action_url': actionUrl,
      'metadata': metadata,
    };
  }
  
  factory HealthAlert.fromJson(Map<String, dynamic> json) {
    return HealthAlert(
      id: json['id'],
      predictionId: json['prediction_id'],
      title: json['title'],
      message: json['message'],
      severity: HealthSeverity.values.byName(json['severity']),
      actionRequired: json['action_required'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      dismissedAt: json['dismissed_at'] != null 
          ? DateTime.parse(json['dismissed_at'])
          : null,
      actionUrl: json['action_url'],
      metadata: json['metadata'],
    );
  }
  
  HealthAlert copyWith({
    String? id,
    String? predictionId,
    String? title,
    String? message,
    HealthSeverity? severity,
    bool? actionRequired,
    bool? isRead,
    DateTime? createdAt,
    DateTime? dismissedAt,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return HealthAlert(
      id: id ?? this.id,
      predictionId: predictionId ?? this.predictionId,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      actionRequired: actionRequired ?? this.actionRequired,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Comprehensive health condition assessment
class HealthConditionAssessment {
  final String id;
  final HealthConditionType condition;
  final String name;
  final String description;
  final double riskScore; // 0.0 - 1.0
  final double confidence; // AI model confidence
  final List<String> indicativeSymptoms;
  final List<String> missingSymptoms;
  final List<String> recommendations;
  final List<String> diagnosticTests;
  final bool requiresImmedateAttention;
  final DateTime assessedAt;
  final Map<String, dynamic>? supportingData;
  
  HealthConditionAssessment({
    required this.id,
    required this.condition,
    required this.name,
    required this.description,
    required this.riskScore,
    required this.confidence,
    required this.indicativeSymptoms,
    required this.missingSymptoms,
    required this.recommendations,
    required this.diagnosticTests,
    this.requiresImmedateAttention = false,
    required this.assessedAt,
    this.supportingData,
  });
  
  /// Get severity based on risk score
  HealthSeverity get severity {
    if (riskScore >= 0.8) return HealthSeverity.high;
    if (riskScore >= 0.5) return HealthSeverity.medium;
    if (riskScore >= 0.2) return HealthSeverity.low;
    return HealthSeverity.informational;
  }
  
  /// Get color for UI display
  Color get riskColor {
    if (riskScore >= 0.8) return const Color(0xFFF44336); // Red
    if (riskScore >= 0.5) return const Color(0xFFFF9800); // Orange
    if (riskScore >= 0.2) return const Color(0xFF2196F3); // Blue
    return const Color(0xFF4CAF50); // Green
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'condition': condition.name,
      'name': name,
      'description': description,
      'risk_score': riskScore,
      'confidence': confidence,
      'indicative_symptoms': indicativeSymptoms,
      'missing_symptoms': missingSymptoms,
      'recommendations': recommendations,
      'diagnostic_tests': diagnosticTests,
      'requires_immediate_attention': requiresImmedateAttention,
      'assessed_at': assessedAt.toIso8601String(),
      'supporting_data': supportingData,
    };
  }
  
  factory HealthConditionAssessment.fromJson(Map<String, dynamic> json) {
    return HealthConditionAssessment(
      id: json['id'],
      condition: HealthConditionType.values.byName(json['condition']),
      name: json['name'],
      description: json['description'],
      riskScore: json['risk_score'].toDouble(),
      confidence: json['confidence'].toDouble(),
      indicativeSymptoms: List<String>.from(json['indicative_symptoms']),
      missingSymptoms: List<String>.from(json['missing_symptoms']),
      recommendations: List<String>.from(json['recommendations']),
      diagnosticTests: List<String>.from(json['diagnostic_tests']),
      requiresImmedateAttention: json['requires_immediate_attention'] ?? false,
      assessedAt: DateTime.parse(json['assessed_at']),
      supportingData: json['supporting_data'],
    );
  }
}

/// Personalized health insight generated by AI
class HealthInsight {
  final String id;
  final String title;
  final String content;
  final HealthInsightType type;
  final double relevanceScore; // How relevant to user (0.0 - 1.0)
  final List<String> tags;
  final String? actionableAdvice;
  final DateTime generatedAt;
  final DateTime? expiresAt;
  final bool isPersonalized;
  final String? evidenceSource;
  final Map<String, dynamic>? metadata;
  
  HealthInsight({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.relevanceScore,
    required this.tags,
    this.actionableAdvice,
    required this.generatedAt,
    this.expiresAt,
    this.isPersonalized = true,
    this.evidenceSource,
    this.metadata,
  });
  
  /// Check if insight is still relevant
  bool get isRelevant {
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.name,
      'relevance_score': relevanceScore,
      'tags': tags,
      'actionable_advice': actionableAdvice,
      'generated_at': generatedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_personalized': isPersonalized,
      'evidence_source': evidenceSource,
      'metadata': metadata,
    };
  }
  
  factory HealthInsight.fromJson(Map<String, dynamic> json) {
    return HealthInsight(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: HealthInsightType.values.byName(json['type']),
      relevanceScore: json['relevance_score'].toDouble(),
      tags: List<String>.from(json['tags']),
      actionableAdvice: json['actionable_advice'],
      generatedAt: DateTime.parse(json['generated_at']),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'])
          : null,
      isPersonalized: json['is_personalized'] ?? true,
      evidenceSource: json['evidence_source'],
      metadata: json['metadata'],
    );
  }
}

enum HealthInsightType {
  educational,
  predictive,
  actionable,
  motivational,
  warning,
  celebration,
  trend,
  comparison,
  recommendation,
  research,
}

/// Health trend analysis over time
class HealthTrend {
  final String id;
  final String metric;
  final String description;
  final TrendDirection direction;
  final double changeRate; // Rate of change per unit time
  final double significance; // Statistical significance
  final Duration timeframe;
  final List<HealthTrendPoint> dataPoints;
  final String? interpretation;
  final List<String> recommendations;
  final DateTime analyzedAt;
  
  HealthTrend({
    required this.id,
    required this.metric,
    required this.description,
    required this.direction,
    required this.changeRate,
    required this.significance,
    required this.timeframe,
    required this.dataPoints,
    this.interpretation,
    required this.recommendations,
    required this.analyzedAt,
  });
  
  /// Get color for trend direction
  Color get trendColor {
    switch (direction) {
      case TrendDirection.improving:
        return const Color(0xFF4CAF50);
      case TrendDirection.stable:
        return const Color(0xFF2196F3);
      case TrendDirection.declining:
        return const Color(0xFFFF9800);
      case TrendDirection.concerning:
        return const Color(0xFFF44336);
    }
  }
  
  /// Get icon for trend direction
  IconData get trendIcon {
    switch (direction) {
      case TrendDirection.improving:
        return Icons.trending_up;
      case TrendDirection.stable:
        return Icons.trending_flat;
      case TrendDirection.declining:
        return Icons.trending_down;
      case TrendDirection.concerning:
        return Icons.warning;
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metric': metric,
      'description': description,
      'direction': direction.name,
      'change_rate': changeRate,
      'significance': significance,
      'timeframe_days': timeframe.inDays,
      'data_points': dataPoints.map((p) => p.toJson()).toList(),
      'interpretation': interpretation,
      'recommendations': recommendations,
      'analyzed_at': analyzedAt.toIso8601String(),
    };
  }
  
  factory HealthTrend.fromJson(Map<String, dynamic> json) {
    return HealthTrend(
      id: json['id'],
      metric: json['metric'],
      description: json['description'],
      direction: TrendDirection.values.byName(json['direction']),
      changeRate: json['change_rate'].toDouble(),
      significance: json['significance'].toDouble(),
      timeframe: Duration(days: json['timeframe_days']),
      dataPoints: (json['data_points'] as List)
          .map((p) => HealthTrendPoint.fromJson(p))
          .toList(),
      interpretation: json['interpretation'],
      recommendations: List<String>.from(json['recommendations']),
      analyzedAt: DateTime.parse(json['analyzed_at']),
    );
  }
}

enum TrendDirection {
  improving,
  stable,
  declining,
  concerning,
}

/// Individual data point in health trend
class HealthTrendPoint {
  final DateTime date;
  final double value;
  final String? annotation;
  final Map<String, dynamic>? metadata;
  
  HealthTrendPoint({
    required this.date,
    required this.value,
    this.annotation,
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
      'annotation': annotation,
      'metadata': metadata,
    };
  }
  
  factory HealthTrendPoint.fromJson(Map<String, dynamic> json) {
    return HealthTrendPoint(
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
      annotation: json['annotation'],
      metadata: json['metadata'],
    );
  }
}

/// Comprehensive health score with breakdown
class HealthScore {
  final double overall; // 0-100 overall health score
  final Map<String, double> categoryScores; // Breakdown by category
  final HealthScoreTrend trend;
  final List<String> strengths;
  final List<String> improvementAreas;
  final List<String> recommendations;
  final DateTime calculatedAt;
  final String methodology;
  
  HealthScore({
    required this.overall,
    required this.categoryScores,
    required this.trend,
    required this.strengths,
    required this.improvementAreas,
    required this.recommendations,
    required this.calculatedAt,
    required this.methodology,
  });
  
  /// Get color based on overall score
  Color get scoreColor {
    if (overall >= 80) return const Color(0xFF4CAF50); // Green
    if (overall >= 60) return const Color(0xFF8BC34A); // Light green
    if (overall >= 40) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }
  
  /// Get grade based on overall score
  String get grade {
    if (overall >= 90) return 'A+';
    if (overall >= 85) return 'A';
    if (overall >= 80) return 'A-';
    if (overall >= 75) return 'B+';
    if (overall >= 70) return 'B';
    if (overall >= 65) return 'B-';
    if (overall >= 60) return 'C+';
    if (overall >= 55) return 'C';
    if (overall >= 50) return 'C-';
    if (overall >= 40) return 'D';
    return 'F';
  }
  
  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'category_scores': categoryScores,
      'trend': trend.name,
      'strengths': strengths,
      'improvement_areas': improvementAreas,
      'recommendations': recommendations,
      'calculated_at': calculatedAt.toIso8601String(),
      'methodology': methodology,
    };
  }
  
  factory HealthScore.fromJson(Map<String, dynamic> json) {
    return HealthScore(
      overall: json['overall'].toDouble(),
      categoryScores: Map<String, double>.from(
        json['category_scores'].map((k, v) => MapEntry(k, v.toDouble()))
      ),
      trend: HealthScoreTrend.values.byName(json['trend']),
      strengths: List<String>.from(json['strengths']),
      improvementAreas: List<String>.from(json['improvement_areas']),
      recommendations: List<String>.from(json['recommendations']),
      calculatedAt: DateTime.parse(json['calculated_at']),
      methodology: json['methodology'],
    );
  }
}

enum HealthScoreTrend {
  improving,
  stable,
  declining,
}

/// Intervention recommendation from AI
class HealthIntervention {
  final String id;
  final String title;
  final String description;
  final InterventionType type;
  final InterventionUrgency urgency;
  final List<String> steps;
  final Duration? estimatedTimeToSeeResults;
  final double? expectedImpact; // 0-1 expected improvement
  final List<String> relatedPredictionIds;
  final DateTime recommendedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic>? trackingMetrics;
  
  HealthIntervention({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.urgency,
    required this.steps,
    this.estimatedTimeToSeeResults,
    this.expectedImpact,
    required this.relatedPredictionIds,
    required this.recommendedAt,
    this.startDate,
    this.endDate,
    this.trackingMetrics,
  });
  
  /// Get color based on urgency
  Color get urgencyColor {
    switch (urgency) {
      case InterventionUrgency.immediate:
        return const Color(0xFFF44336);
      case InterventionUrgency.soon:
        return const Color(0xFFFF9800);
      case InterventionUrgency.moderate:
        return const Color(0xFF2196F3);
      case InterventionUrgency.whenConvenient:
        return const Color(0xFF4CAF50);
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'urgency': urgency.name,
      'steps': steps,
      'estimated_time_to_see_results_days': estimatedTimeToSeeResults?.inDays,
      'expected_impact': expectedImpact,
      'related_prediction_ids': relatedPredictionIds,
      'recommended_at': recommendedAt.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'tracking_metrics': trackingMetrics,
    };
  }
  
  factory HealthIntervention.fromJson(Map<String, dynamic> json) {
    return HealthIntervention(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: InterventionType.values.byName(json['type']),
      urgency: InterventionUrgency.values.byName(json['urgency']),
      steps: List<String>.from(json['steps']),
      estimatedTimeToSeeResults: json['estimated_time_to_see_results_days'] != null
          ? Duration(days: json['estimated_time_to_see_results_days'])
          : null,
      expectedImpact: json['expected_impact']?.toDouble(),
      relatedPredictionIds: List<String>.from(json['related_prediction_ids']),
      recommendedAt: DateTime.parse(json['recommended_at']),
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'])
          : null,
      trackingMetrics: json['tracking_metrics'],
    );
  }
}

enum InterventionType {
  lifestyle,
  dietary,
  exercise,
  sleep,
  stress,
  medical,
  supplement,
  behavioral,
  environmental,
  social,
}

enum InterventionUrgency {
  immediate,     // Do this now
  soon,         // Within a week
  moderate,     // Within a month
  whenConvenient, // When you have time
}
