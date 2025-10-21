import 'package:flutter/material.dart';

/// === CORE ENUMS ===

enum FeelingsTimeOfDay {
  morning,
  evening,
}

enum FeelingsQuestionType {
  scale,
  multiSelect,
  text,
  boolean,
}

enum FeelingsPatternType {
  weekday,
  menstrualCycle,
  seasonal,
  timeOfDay,
  stress,
  sleep,
}

enum FeelingsInsightType {
  celebration,
  positive,
  neutral,
  awareness,
  support,
  intervention,
}

enum FeelingsNotificationType {
  morningPrompt,
  eveningPrompt,
  intervention,
  streak,
  pattern,
}

/// === CORE DATA MODELS ===

/// Main entry for daily feelings with intelligent metadata
class DailyFeelingsEntry {
  final String id;
  final DateTime date;
  final FeelingsTimeOfDay timeOfDay;
  final int overallFeeling; // 1-10 scale
  final Map<String, int> detailedFeelings; // Specific feeling categories
  final String? notes;
  final List<String> selectedMoods; // Emoji mood tags
  final Map<String, dynamic> additionalContext;
  
  // Cycle tracking integration
  final String? menstrualPhase;
  final int? cycleDay;
  
  // Metadata
  final DateTime timestamp;
  final String? weatherCondition;
  final double? stressLevel;
  final double? energyLevel;
  final double? sleepQuality;
  
  DailyFeelingsEntry({
    required this.id,
    required this.date,
    required this.timeOfDay,
    required this.overallFeeling,
    required this.detailedFeelings,
    this.notes,
    required this.selectedMoods,
    required this.additionalContext,
    this.menstrualPhase,
    this.cycleDay,
    required this.timestamp,
    this.weatherCondition,
    this.stressLevel,
    this.energyLevel,
    this.sleepQuality,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'timeOfDay': timeOfDay.name,
      'overallFeeling': overallFeeling,
      'detailedFeelings': detailedFeelings,
      'notes': notes,
      'selectedMoods': selectedMoods,
      'additionalContext': additionalContext,
      'menstrualPhase': menstrualPhase,
      'cycleDay': cycleDay,
      'timestamp': timestamp.toIso8601String(),
      'weatherCondition': weatherCondition,
      'stressLevel': stressLevel,
      'energyLevel': energyLevel,
      'sleepQuality': sleepQuality,
    };
  }
  
  factory DailyFeelingsEntry.fromJson(Map<String, dynamic> json) {
    return DailyFeelingsEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      timeOfDay: FeelingsTimeOfDay.values.byName(json['timeOfDay']),
      overallFeeling: json['overallFeeling'],
      detailedFeelings: Map<String, int>.from(json['detailedFeelings']),
      notes: json['notes'],
      selectedMoods: List<String>.from(json['selectedMoods']),
      additionalContext: Map<String, dynamic>.from(json['additionalContext']),
      menstrualPhase: json['menstrualPhase'],
      cycleDay: json['cycleDay'],
      timestamp: DateTime.parse(json['timestamp']),
      weatherCondition: json['weatherCondition'],
      stressLevel: json['stressLevel']?.toDouble(),
      energyLevel: json['energyLevel']?.toDouble(),
      sleepQuality: json['sleepQuality']?.toDouble(),
    );
  }
  
  DailyFeelingsEntry copyWith({
    String? id,
    DateTime? date,
    FeelingsTimeOfDay? timeOfDay,
    int? overallFeeling,
    Map<String, int>? detailedFeelings,
    String? notes,
    List<String>? selectedMoods,
    Map<String, dynamic>? additionalContext,
    String? menstrualPhase,
    int? cycleDay,
    DateTime? timestamp,
    String? weatherCondition,
    double? stressLevel,
    double? energyLevel,
    double? sleepQuality,
  }) {
    return DailyFeelingsEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      overallFeeling: overallFeeling ?? this.overallFeeling,
      detailedFeelings: detailedFeelings ?? this.detailedFeelings,
      notes: notes ?? this.notes,
      selectedMoods: selectedMoods ?? this.selectedMoods,
      additionalContext: additionalContext ?? this.additionalContext,
      menstrualPhase: menstrualPhase ?? this.menstrualPhase,
      cycleDay: cycleDay ?? this.cycleDay,
      timestamp: timestamp ?? this.timestamp,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
    );
  }
}

/// Intelligent question generation for contextual feelings tracking
class FeelingsQuestion {
  final String id;
  final String text;
  final FeelingsQuestionType type;
  final bool required;
  
  // For scale questions
  final int? scaleMin;
  final int? scaleMax;
  final List<String>? scaleLabels;
  
  // For multiple choice questions
  final List<String>? options;
  
  // Question metadata
  final Map<String, dynamic>? metadata;
  
  FeelingsQuestion({
    required this.id,
    required this.text,
    required this.type,
    this.required = false,
    this.scaleMin,
    this.scaleMax,
    this.scaleLabels,
    this.options,
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'required': required,
      'scaleMin': scaleMin,
      'scaleMax': scaleMax,
      'scaleLabels': scaleLabels,
      'options': options,
      'metadata': metadata,
    };
  }
  
  factory FeelingsQuestion.fromJson(Map<String, dynamic> json) {
    return FeelingsQuestion(
      id: json['id'],
      text: json['text'],
      type: FeelingsQuestionType.values.byName(json['type']),
      required: json['required'] ?? false,
      scaleMin: json['scaleMin'],
      scaleMax: json['scaleMax'],
      scaleLabels: json['scaleLabels'] != null ? List<String>.from(json['scaleLabels']) : null,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }
}

/// Pattern detection results from intelligent analysis
class FeelingsPattern {
  final String id;
  final FeelingsPatternType type;
  final String description;
  final double confidence; // 0.0 to 1.0
  final Map<String, dynamic> context;
  final DateTime detectedAt;
  
  // Pattern visualization data
  final List<double>? chartData;
  final Map<String, String>? visualizationHints;
  
  FeelingsPattern({
    required this.id,
    required this.type,
    required this.description,
    required this.confidence,
    required this.context,
    DateTime? detectedAt,
    this.chartData,
    this.visualizationHints,
  }) : detectedAt = detectedAt ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'confidence': confidence,
      'context': context,
      'detectedAt': detectedAt.toIso8601String(),
      'chartData': chartData,
      'visualizationHints': visualizationHints,
    };
  }
  
  factory FeelingsPattern.fromJson(Map<String, dynamic> json) {
    return FeelingsPattern(
      id: json['id'],
      type: FeelingsPatternType.values.byName(json['type']),
      description: json['description'],
      confidence: json['confidence'].toDouble(),
      context: Map<String, dynamic>.from(json['context']),
      detectedAt: DateTime.parse(json['detectedAt']),
      chartData: json['chartData'] != null ? List<double>.from(json['chartData']) : null,
      visualizationHints: json['visualizationHints'] != null ? Map<String, String>.from(json['visualizationHints']) : null,
    );
  }
}

/// AI-generated insights based on feelings patterns and data
class FeelingsInsight {
  final String id;
  final String content;
  final FeelingsInsightType type;
  final String? actionSuggestion;
  final DateTime generatedAt;
  final DailyFeelingsEntry? relevantEntry;
  final List<String>? relevantPatternIds;
  
  // Insight metadata
  final bool isPersonalized;
  final double confidence;
  final Map<String, dynamic>? supportingData;
  
  FeelingsInsight({
    required this.id,
    required this.content,
    required this.type,
    this.actionSuggestion,
    required this.generatedAt,
    this.relevantEntry,
    this.relevantPatternIds,
    this.isPersonalized = true,
    this.confidence = 1.0,
    this.supportingData,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'actionSuggestion': actionSuggestion,
      'generatedAt': generatedAt.toIso8601String(),
      'relevantEntry': relevantEntry?.toJson(),
      'relevantPatternIds': relevantPatternIds,
      'isPersonalized': isPersonalized,
      'confidence': confidence,
      'supportingData': supportingData,
    };
  }
  
  factory FeelingsInsight.fromJson(Map<String, dynamic> json) {
    return FeelingsInsight(
      id: json['id'],
      content: json['content'],
      type: FeelingsInsightType.values.byName(json['type']),
      actionSuggestion: json['actionSuggestion'],
      generatedAt: DateTime.parse(json['generatedAt']),
      relevantEntry: json['relevantEntry'] != null ? DailyFeelingsEntry.fromJson(json['relevantEntry']) : null,
      relevantPatternIds: json['relevantPatternIds'] != null ? List<String>.from(json['relevantPatternIds']) : null,
      isPersonalized: json['isPersonalized'] ?? true,
      confidence: json['confidence']?.toDouble() ?? 1.0,
      supportingData: json['supportingData'] != null ? Map<String, dynamic>.from(json['supportingData']) : null,
    );
  }
}

/// Smart notification system for feelings prompts
class FeelingsNotification {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final FeelingsNotificationType type;
  final Map<String, dynamic>? payload;
  final bool isDelivered;
  final bool isInteractedWith;
  
  FeelingsNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.type,
    this.payload,
    this.isDelivered = false,
    this.isInteractedWith = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(),
      'type': type.name,
      'payload': payload,
      'isDelivered': isDelivered,
      'isInteractedWith': isInteractedWith,
    };
  }
  
  factory FeelingsNotification.fromJson(Map<String, dynamic> json) {
    return FeelingsNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      type: FeelingsNotificationType.values.byName(json['type']),
      payload: json['payload'] != null ? Map<String, dynamic>.from(json['payload']) : null,
      isDelivered: json['isDelivered'] ?? false,
      isInteractedWith: json['isInteractedWith'] ?? false,
    );
  }
}

/// Result of submitting daily feelings with intelligent feedback
class FeelingsSubmissionResult {
  final bool success;
  final String? error;
  final int? streak;
  final FeelingsInsight? insight;
  final String? encouragement;
  final DateTime? nextPromptTime;
  final List<FeelingsPattern>? newPatterns;
  
  FeelingsSubmissionResult({
    required this.success,
    this.error,
    this.streak,
    this.insight,
    this.encouragement,
    this.nextPromptTime,
    this.newPatterns,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'streak': streak,
      'insight': insight?.toJson(),
      'encouragement': encouragement,
      'nextPromptTime': nextPromptTime?.toIso8601String(),
      'newPatterns': newPatterns?.map((p) => p.toJson()).toList(),
    };
  }
  
  factory FeelingsSubmissionResult.fromJson(Map<String, dynamic> json) {
    return FeelingsSubmissionResult(
      success: json['success'],
      error: json['error'],
      streak: json['streak'],
      insight: json['insight'] != null ? FeelingsInsight.fromJson(json['insight']) : null,
      encouragement: json['encouragement'],
      nextPromptTime: json['nextPromptTime'] != null ? DateTime.parse(json['nextPromptTime']) : null,
      newPatterns: json['newPatterns'] != null 
          ? (json['newPatterns'] as List).map((p) => FeelingsPattern.fromJson(p)).toList()
          : null,
    );
  }
}

/// Comprehensive analytics for feelings performance over time
class FeelingsPerformanceAnalytics {
  final int totalEntries;
  final double averageFeeling;
  final double overallTrend; // Positive = improving, negative = declining
  
  // Time-specific analytics
  final double morningAverage;
  final double eveningAverage;
  final double morningTrend;
  final double eveningTrend;
  
  // Engagement metrics
  final int streak;
  final double consistencyScore; // Percentage of days tracked
  
  // Advanced analytics (Flow iQ Clinical)
  final Map<String, double> phaseCorrelations;
  final List<FeelingsPattern> detectedPatterns;
  final List<FeelingsInsight> insights;
  
  // Visualization data
  final List<ChartDataPoint> chartData;
  final Map<String, List<double>> categoryTrends;
  
  FeelingsPerformanceAnalytics({
    required this.totalEntries,
    required this.averageFeeling,
    required this.overallTrend,
    required this.morningAverage,
    required this.eveningAverage,
    required this.morningTrend,
    required this.eveningTrend,
    required this.streak,
    required this.consistencyScore,
    required this.phaseCorrelations,
    required this.detectedPatterns,
    required this.insights,
    List<ChartDataPoint>? chartData,
    Map<String, List<double>>? categoryTrends,
  }) : chartData = chartData ?? [],
       categoryTrends = categoryTrends ?? {};
  
  factory FeelingsPerformanceAnalytics.empty() {
    return FeelingsPerformanceAnalytics(
      totalEntries: 0,
      averageFeeling: 0,
      overallTrend: 0,
      morningAverage: 0,
      eveningAverage: 0,
      morningTrend: 0,
      eveningTrend: 0,
      streak: 0,
      consistencyScore: 0,
      phaseCorrelations: {},
      detectedPatterns: [],
      insights: [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'totalEntries': totalEntries,
      'averageFeeling': averageFeeling,
      'overallTrend': overallTrend,
      'morningAverage': morningAverage,
      'eveningAverage': eveningAverage,
      'morningTrend': morningTrend,
      'eveningTrend': eveningTrend,
      'streak': streak,
      'consistencyScore': consistencyScore,
      'phaseCorrelations': phaseCorrelations,
      'detectedPatterns': detectedPatterns.map((p) => p.toJson()).toList(),
      'insights': insights.map((i) => i.toJson()).toList(),
      'chartData': chartData.map((d) => d.toJson()).toList(),
      'categoryTrends': categoryTrends,
    };
  }
  
  factory FeelingsPerformanceAnalytics.fromJson(Map<String, dynamic> json) {
    return FeelingsPerformanceAnalytics(
      totalEntries: json['totalEntries'],
      averageFeeling: json['averageFeeling'].toDouble(),
      overallTrend: json['overallTrend'].toDouble(),
      morningAverage: json['morningAverage'].toDouble(),
      eveningAverage: json['eveningAverage'].toDouble(),
      morningTrend: json['morningTrend'].toDouble(),
      eveningTrend: json['eveningTrend'].toDouble(),
      streak: json['streak'],
      consistencyScore: json['consistencyScore'].toDouble(),
      phaseCorrelations: Map<String, double>.from(json['phaseCorrelations']),
      detectedPatterns: (json['detectedPatterns'] as List).map((p) => FeelingsPattern.fromJson(p)).toList(),
      insights: (json['insights'] as List).map((i) => FeelingsInsight.fromJson(i)).toList(),
      chartData: (json['chartData'] as List).map((d) => ChartDataPoint.fromJson(d)).toList(),
      categoryTrends: Map<String, List<double>>.from(
        json['categoryTrends'].map((key, value) => MapEntry(key, List<double>.from(value)))
      ),
    );
  }
}

/// Data point for feelings visualization charts
class ChartDataPoint {
  final DateTime date;
  final double value;
  final FeelingsTimeOfDay? timeOfDay;
  final String? category;
  final Map<String, dynamic>? metadata;
  
  ChartDataPoint({
    required this.date,
    required this.value,
    this.timeOfDay,
    this.category,
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
      'timeOfDay': timeOfDay?.name,
      'category': category,
      'metadata': metadata,
    };
  }
  
  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
      timeOfDay: json['timeOfDay'] != null ? FeelingsTimeOfDay.values.byName(json['timeOfDay']) : null,
      category: json['category'],
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }
}

/// Configuration for feelings tracking customization
class FeelingsTrackingConfig {
  final bool enableMorningPrompts;
  final bool enableEveningPrompts;
  final TimeOfDay morningPromptTime;
  final TimeOfDay eveningPromptTime;
  final bool enablePatternDetection;
  final bool enableCycleCorrelation;
  final int maxHistoryDays;
  final List<String> customMoodTags;
  final Map<String, bool> questionCategories;
  
  // Clinical settings (Flow iQ)
  final bool enableClinicalInsights;
  final bool shareWithProvider;
  final String? providerId;
  
  FeelingsTrackingConfig({
    this.enableMorningPrompts = true,
    this.enableEveningPrompts = true,
    this.morningPromptTime = const TimeOfDay(hour: 9, minute: 0),
    this.eveningPromptTime = const TimeOfDay(hour: 20, minute: 0),
    this.enablePatternDetection = true,
    this.enableCycleCorrelation = true,
    this.maxHistoryDays = 365,
    this.customMoodTags = const [],
    this.questionCategories = const {},
    this.enableClinicalInsights = false,
    this.shareWithProvider = false,
    this.providerId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'enableMorningPrompts': enableMorningPrompts,
      'enableEveningPrompts': enableEveningPrompts,
      'morningPromptTime': '${morningPromptTime.hour}:${morningPromptTime.minute}',
      'eveningPromptTime': '${eveningPromptTime.hour}:${eveningPromptTime.minute}',
      'enablePatternDetection': enablePatternDetection,
      'enableCycleCorrelation': enableCycleCorrelation,
      'maxHistoryDays': maxHistoryDays,
      'customMoodTags': customMoodTags,
      'questionCategories': questionCategories,
      'enableClinicalInsights': enableClinicalInsights,
      'shareWithProvider': shareWithProvider,
      'providerId': providerId,
    };
  }
  
  factory FeelingsTrackingConfig.fromJson(Map<String, dynamic> json) {
    final morningTime = json['morningPromptTime'].split(':');
    final eveningTime = json['eveningPromptTime'].split(':');
    
    return FeelingsTrackingConfig(
      enableMorningPrompts: json['enableMorningPrompts'],
      enableEveningPrompts: json['enableEveningPrompts'],
      morningPromptTime: TimeOfDay(hour: int.parse(morningTime[0]), minute: int.parse(morningTime[1])),
      eveningPromptTime: TimeOfDay(hour: int.parse(eveningTime[0]), minute: int.parse(eveningTime[1])),
      enablePatternDetection: json['enablePatternDetection'],
      enableCycleCorrelation: json['enableCycleCorrelation'],
      maxHistoryDays: json['maxHistoryDays'],
      customMoodTags: List<String>.from(json['customMoodTags']),
      questionCategories: Map<String, bool>.from(json['questionCategories']),
      enableClinicalInsights: json['enableClinicalInsights'],
      shareWithProvider: json['shareWithProvider'],
      providerId: json['providerId'],
    );
  }
}
