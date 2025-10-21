import 'package:flutter/material.dart';

class WearablesSummary {
  final DateTime date;
  final int steps;
  final double distanceKm;
  final int activeMinutes;
  final int heartRateAvg;
  final int heartRateResting;
  final int heartRateMax;
  final double sleepHours;
  final int sleepScore;
  final int stressLevel;
  final double bodyTemperature;
  final int oxygenSaturation;
  final double hrVariability;
  final int caloriesBurned;
  final int floorsClimbed;
  final String deviceType;
  final Map<String, dynamic> rawData;

  WearablesSummary({
    required this.date,
    this.steps = 0,
    this.distanceKm = 0.0,
    this.activeMinutes = 0,
    this.heartRateAvg = 0,
    this.heartRateResting = 0,
    this.heartRateMax = 0,
    this.sleepHours = 0.0,
    this.sleepScore = 0,
    this.stressLevel = 0,
    this.bodyTemperature = 0.0,
    this.oxygenSaturation = 0,
    this.hrVariability = 0.0,
    this.caloriesBurned = 0,
    this.floorsClimbed = 0,
    this.deviceType = 'Unknown',
    this.rawData = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'steps': steps,
      'distanceKm': distanceKm,
      'activeMinutes': activeMinutes,
      'heartRateAvg': heartRateAvg,
      'heartRateResting': heartRateResting,
      'heartRateMax': heartRateMax,
      'sleepHours': sleepHours,
      'sleepScore': sleepScore,
      'stressLevel': stressLevel,
      'bodyTemperature': bodyTemperature,
      'oxygenSaturation': oxygenSaturation,
      'hrVariability': hrVariability,
      'caloriesBurned': caloriesBurned,
      'floorsClimbed': floorsClimbed,
      'deviceType': deviceType,
      'rawData': rawData,
    };
  }

  factory WearablesSummary.fromJson(Map<String, dynamic> json) {
    return WearablesSummary(
      date: DateTime.parse(json['date']),
      steps: json['steps'] ?? 0,
      distanceKm: json['distanceKm']?.toDouble() ?? 0.0,
      activeMinutes: json['activeMinutes'] ?? 0,
      heartRateAvg: json['heartRateAvg'] ?? 0,
      heartRateResting: json['heartRateResting'] ?? 0,
      heartRateMax: json['heartRateMax'] ?? 0,
      sleepHours: json['sleepHours']?.toDouble() ?? 0.0,
      sleepScore: json['sleepScore'] ?? 0,
      stressLevel: json['stressLevel'] ?? 0,
      bodyTemperature: json['bodyTemperature']?.toDouble() ?? 0.0,
      oxygenSaturation: json['oxygenSaturation'] ?? 0,
      hrVariability: json['hrVariability']?.toDouble() ?? 0.0,
      caloriesBurned: json['caloriesBurned'] ?? 0,
      floorsClimbed: json['floorsClimbed'] ?? 0,
      deviceType: json['deviceType'] ?? 'Unknown',
      rawData: json['rawData'] ?? {},
    );
  }

  WearablesSummary copyWith({
    DateTime? date,
    int? steps,
    double? distanceKm,
    int? activeMinutes,
    int? heartRateAvg,
    int? heartRateResting,
    int? heartRateMax,
    double? sleepHours,
    int? sleepScore,
    int? stressLevel,
    double? bodyTemperature,
    int? oxygenSaturation,
    double? hrVariability,
    int? caloriesBurned,
    int? floorsClimbed,
    String? deviceType,
    Map<String, dynamic>? rawData,
  }) {
    return WearablesSummary(
      date: date ?? this.date,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      heartRateAvg: heartRateAvg ?? this.heartRateAvg,
      heartRateResting: heartRateResting ?? this.heartRateResting,
      heartRateMax: heartRateMax ?? this.heartRateMax,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepScore: sleepScore ?? this.sleepScore,
      stressLevel: stressLevel ?? this.stressLevel,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
      hrVariability: hrVariability ?? this.hrVariability,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      floorsClimbed: floorsClimbed ?? this.floorsClimbed,
      deviceType: deviceType ?? this.deviceType,
      rawData: rawData ?? this.rawData,
    );
  }

  // Health status indicators
  String get activityLevel {
    if (steps >= 10000) return 'Very Active';
    if (steps >= 7500) return 'Active';
    if (steps >= 5000) return 'Moderate';
    return 'Low Activity';
  }

  Color get activityColor {
    if (steps >= 10000) return Colors.green;
    if (steps >= 7500) return Colors.lightGreen;
    if (steps >= 5000) return Colors.orange;
    return Colors.red;
  }

  String get sleepQuality {
    if (sleepScore >= 85) return 'Excellent';
    if (sleepScore >= 70) return 'Good';
    if (sleepScore >= 55) return 'Fair';
    return 'Poor';
  }

  Color get sleepColor {
    if (sleepScore >= 85) return Colors.green;
    if (sleepScore >= 70) return Colors.lightGreen;
    if (sleepScore >= 55) return Colors.orange;
    return Colors.red;
  }

  String get stressStatus {
    if (stressLevel <= 25) return 'Low Stress';
    if (stressLevel <= 50) return 'Moderate Stress';
    if (stressLevel <= 75) return 'High Stress';
    return 'Very High Stress';
  }

  Color get stressColor {
    if (stressLevel <= 25) return Colors.green;
    if (stressLevel <= 50) return Colors.yellow;
    if (stressLevel <= 75) return Colors.orange;
    return Colors.red;
  }

  bool get hasAnomalousHeartRate {
    return heartRateResting < 50 || heartRateResting > 100 || 
           heartRateMax > 200 || heartRateAvg > 100;
  }

  bool get hasTemperatureAnomaly {
    return bodyTemperature > 0 && (bodyTemperature < 36.0 || bodyTemperature > 38.0);
  }

  double get fitnessScore {
    double score = 0;
    
    // Steps contribution (0-30 points)
    score += (steps / 10000 * 30).clamp(0, 30);
    
    // Active minutes contribution (0-25 points)
    score += (activeMinutes / 60 * 25).clamp(0, 25);
    
    // Sleep contribution (0-25 points)
    score += (sleepScore / 100 * 25);
    
    // Stress contribution (0-20 points, inverse)
    score += ((100 - stressLevel) / 100 * 20);
    
    return score.clamp(0, 100);
  }

  List<HealthMetric> get keyMetrics {
    return [
      HealthMetric(
        name: 'Steps',
        value: steps.toDouble(),
        unit: 'steps',
        target: 10000,
        icon: Icons.directions_walk,
        color: activityColor,
      ),
      HealthMetric(
        name: 'Sleep',
        value: sleepHours,
        unit: 'hours',
        target: 8.0,
        icon: Icons.bedtime,
        color: sleepColor,
      ),
      HealthMetric(
        name: 'Heart Rate',
        value: heartRateAvg.toDouble(),
        unit: 'bpm',
        target: 80.0,
        icon: Icons.favorite,
        color: hasAnomalousHeartRate ? Colors.red : Colors.green,
      ),
      HealthMetric(
        name: 'Stress',
        value: stressLevel.toDouble(),
        unit: '%',
        target: 25.0,
        icon: Icons.psychology,
        color: stressColor,
        isInverse: true,
      ),
    ];
  }
}

class HealthMetric {
  final String name;
  final double value;
  final String unit;
  final double target;
  final IconData icon;
  final Color color;
  final bool isInverse;

  HealthMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.target,
    required this.icon,
    required this.color,
    this.isInverse = false,
  });

  double get percentage {
    if (isInverse) {
      return ((target - value) / target * 100).clamp(0, 100);
    }
    return (value / target * 100).clamp(0, 100);
  }

  bool get isOnTarget {
    if (isInverse) {
      return value <= target;
    }
    return value >= target;
  }
}
