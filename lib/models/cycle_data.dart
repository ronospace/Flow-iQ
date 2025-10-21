import 'package:cloud_firestore/cloud_firestore.dart';

/// Core cycle data model for Flow Ai consumer app
/// Synchronized with Flow iQ professional data
class CycleData {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final int? periodLength;
  final double? averageFlow;
  final Map<String, dynamic> symptoms;
  final Map<String, double> moodScores;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSyncedWithFlowIQ;
  final String? flowIQCycleId;

  const CycleData({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    required this.cycleLength,
    this.periodLength,
    this.averageFlow,
    required this.symptoms,
    required this.moodScores,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.isSyncedWithFlowIQ = false,
    this.flowIQCycleId,
  });

  /// Create from Firestore document
  factory CycleData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CycleData(
      id: doc.id,
      userId: data['userId'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null 
          ? (data['endDate'] as Timestamp).toDate() 
          : null,
      cycleLength: data['cycleLength'] ?? 28,
      periodLength: data['periodLength'],
      averageFlow: data['averageFlow']?.toDouble(),
      symptoms: Map<String, dynamic>.from(data['symptoms'] ?? {}),
      moodScores: Map<String, double>.from(
        (data['moodScores'] ?? {}).map((k, v) => MapEntry(k, v.toDouble()))
      ),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isSyncedWithFlowIQ: data['isSyncedWithFlowIQ'] ?? false,
      flowIQCycleId: data['flowIQCycleId'],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'cycleLength': cycleLength,
      'periodLength': periodLength,
      'averageFlow': averageFlow,
      'symptoms': symptoms,
      'moodScores': moodScores,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isSyncedWithFlowIQ': isSyncedWithFlowIQ,
      'flowIQCycleId': flowIQCycleId,
    };
  }

  /// Create copy with updated fields
  CycleData copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? cycleLength,
    int? periodLength,
    double? averageFlow,
    Map<String, dynamic>? symptoms,
    Map<String, double>? moodScores,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSyncedWithFlowIQ,
    String? flowIQCycleId,
  }) {
    return CycleData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      averageFlow: averageFlow ?? this.averageFlow,
      symptoms: symptoms ?? this.symptoms,
      moodScores: moodScores ?? this.moodScores,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSyncedWithFlowIQ: isSyncedWithFlowIQ ?? this.isSyncedWithFlowIQ,
      flowIQCycleId: flowIQCycleId ?? this.flowIQCycleId,
    );
  }

  /// Get current cycle phase
  CyclePhase get currentPhase {
    if (endDate == null) {
      final daysSinceStart = DateTime.now().difference(startDate).inDays;
      if (daysSinceStart <= (periodLength ?? 5)) {
        return CyclePhase.menstrual;
      } else if (daysSinceStart <= 13) {
        return CyclePhase.follicular;
      } else if (daysSinceStart <= 16) {
        return CyclePhase.ovulatory;
      } else {
        return CyclePhase.luteal;
      }
    }
    return CyclePhase.unknown;
  }

  /// Calculate days until next period
  int get daysUntilNextPeriod {
    final daysSinceStart = DateTime.now().difference(startDate).inDays;
    final remainingDays = cycleLength - daysSinceStart;
    return remainingDays > 0 ? remainingDays : 0;
  }

  /// Get cycle completion percentage
  double get completionPercentage {
    final daysSinceStart = DateTime.now().difference(startDate).inDays;
    return (daysSinceStart / cycleLength).clamp(0.0, 1.0);
  }

  @override
  String toString() {
    return 'CycleData(id: $id, startDate: $startDate, cycleLength: $cycleLength, phase: $currentPhase)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CycleData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum CyclePhase {
  menstrual,
  follicular,
  ovulatory,
  luteal,
  unknown,
}

extension CyclePhaseExtension on CyclePhase {
  String get displayName {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulatory:
        return 'Ovulatory';
      case CyclePhase.luteal:
        return 'Luteal';
      case CyclePhase.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Your period is here. Focus on rest and self-care.';
      case CyclePhase.follicular:
        return 'Energy is building. Great time for new activities.';
      case CyclePhase.ovulatory:
        return 'Peak fertility window. You might feel most confident.';
      case CyclePhase.luteal:
        return 'Winding down phase. Listen to your body\'s needs.';
      case CyclePhase.unknown:
        return 'Track more data to get personalized insights.';
    }
  }
}
