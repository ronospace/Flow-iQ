import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for integrating with Apple Health and Google Fit
/// Provides access to sleep, heart rate, steps, and other health metrics
class WearablesDataService extends ChangeNotifier {
  final Health _health = Health();
  
  // Sync state
  bool _isConnected = false;
  bool _isLoading = false;
  DateTime? _lastSyncTime;
  String? _errorMessage;
  
  // Health data
  List<HealthDataPoint> _healthData = [];
  WearablesSummary? _todaysSummary;
  Map<DateTime, WearablesSummary> _historicalData = {};

  // Health data types we're interested in
  static const List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.WEIGHT,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.WATER,
    // Activity and fitness
    HealthDataType.WORKOUT,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.FLIGHTS_CLIMBED,
  ];

  // Getters
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get errorMessage => _errorMessage;
  List<HealthDataPoint> get healthData => _healthData;
  WearablesSummary? get todaysSummary => _todaysSummary;

  /// Initialize wearables data service
  Future<bool> initialize() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

      // Check if health data is available
      final isAvailable = await _health.hasPermissions(_healthDataTypes);
      
      if (isAvailable == null || !isAvailable) {
        // Request permissions
        final permissions = await _health.requestAuthorization(_healthDataTypes);
        if (!permissions) {
          _errorMessage = 'Health data permissions denied';
          _isConnected = false;
          WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
          return false;
        }
      }

      _isConnected = true;
      debugPrint('Wearables data service initialized successfully');
      
      // Load today's data
      await syncTodaysData();
      
      return true;
    } catch (e) {
      _errorMessage = 'Error initializing wearables: $e';
      _isConnected = false;
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  /// Sync today's wearables data
  Future<void> syncTodaysData() async {
    if (!_isConnected) return;

    try {
      _isLoading = true;
      notifyListeners();

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Fetch health data for today
      final healthData = await _health.getHealthDataFromTypes(
        types: _healthDataTypes,
        startTime: startOfDay,
        endTime: endOfDay,
      );

      _healthData = healthData;
      _todaysSummary = _processTodaysData(healthData);
      _lastSyncTime = DateTime.now();
      
      debugPrint('Synced ${healthData.length} health data points for today');
    } catch (e) {
      _errorMessage = 'Error syncing today\'s data: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sync historical wearables data
  Future<void> syncHistoricalData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isConnected) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Fetch health data for date range
      final healthData = await _health.getHealthDataFromTypes(
        types: _healthDataTypes,
        startTime: startDate,
        endTime: endDate,
      );

      // Group data by date and process
      final groupedData = _groupHealthDataByDate(healthData);
      
      for (final entry in groupedData.entries) {
        final date = entry.key;
        final dayData = entry.value;
        _historicalData[date] = _processHealthData(dayData);
      }

      _lastSyncTime = DateTime.now();
      
      debugPrint('Synced historical data for ${groupedData.length} days');
    } catch (e) {
      _errorMessage = 'Error syncing historical data: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get wearables summary for specific date
  WearablesSummary? getDataForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _historicalData[dateKey];
  }

  /// Get sleep data for specific date range
  Future<List<SleepData>> getSleepData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isConnected) return [];

    try {
      final sleepTypes = [
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_IN_BED,
      ];

      final healthData = await _health.getHealthDataFromTypes(
        types: sleepTypes,
        startTime: startDate,
        endTime: endDate,
      );

      return _processSleepData(healthData);
    } catch (e) {
      debugPrint('Error getting sleep data: $e');
      return [];
    }
  }

  /// Get heart rate data for specific date range
  Future<List<HeartRateData>> getHeartRateData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isConnected) return [];

    try {
      final heartRateTypes = [
        HealthDataType.HEART_RATE,
        HealthDataType.RESTING_HEART_RATE,
      ];

      final healthData = await _health.getHealthDataFromTypes(
        types: heartRateTypes,
        startTime: startDate,
        endTime: endDate,
      );

      return _processHeartRateData(healthData);
    } catch (e) {
      debugPrint('Error getting heart rate data: $e');
      return [];
    }
  }

  /// Write menstrual flow data to health app
  Future<bool> writeMenstrualFlowData({
    required DateTime date,
    required MenstrualFlow flow,
  }) async {
    if (!_isConnected) return false;

    try {
      // Note: MENSTRUAL_FLOW might not be available in all health plugin versions
      // This is a placeholder for when the type becomes available
      final success = false; // await _health.writeHealthData(...);

      if (success) {
        debugPrint('Successfully wrote menstrual flow data');
      }

      return success;
    } catch (e) {
      debugPrint('Error writing menstrual flow data: $e');
      return false;
    }
  }

  /// Process today's health data into summary
  WearablesSummary _processTodaysData(List<HealthDataPoint> data) {
    return _processHealthData(data);
  }

  /// Process health data into summary
  WearablesSummary _processHealthData(List<HealthDataPoint> data) {
    int? steps;
    double? avgHeartRate;
    double? restingHeartRate;
    double? sleepHours;
    double? deepSleepHours;
    double? remSleepHours;
    double? basalEnergyBurned;
    double? activeEnergyBurned;
    double? bodyTemperature;
    double? heartRateVariability;
    double? bloodOxygen;
    double? respiratoryRate;
    double? weight;
    double? systolicBP;
    double? diastolicBP;
    double? waterIntake;
    double? distance;
    int? flightsClimbed;

    final heartRateValues = <double>[];

    for (final point in data) {
      switch (point.type) {
        case HealthDataType.STEPS:
          steps = (steps ?? 0) + (point.value as num).toInt();
          break;
        case HealthDataType.HEART_RATE:
          final hr = (point.value as num).toDouble();
          heartRateValues.add(hr);
          avgHeartRate = avgHeartRate == null ? hr : (avgHeartRate + hr) / 2;
          break;
        case HealthDataType.RESTING_HEART_RATE:
          restingHeartRate = (point.value as num).toDouble();
          break;
        case HealthDataType.SLEEP_ASLEEP:
          final duration = point.dateTo.difference(point.dateFrom).inMinutes / 60.0;
          sleepHours = (sleepHours ?? 0) + duration;
          break;
        case HealthDataType.SLEEP_DEEP:
          final duration = point.dateTo.difference(point.dateFrom).inMinutes / 60.0;
          deepSleepHours = (deepSleepHours ?? 0) + duration;
          break;
        case HealthDataType.SLEEP_REM:
          final duration = point.dateTo.difference(point.dateFrom).inMinutes / 60.0;
          remSleepHours = (remSleepHours ?? 0) + duration;
          break;
        case HealthDataType.BASAL_ENERGY_BURNED:
          basalEnergyBurned = (basalEnergyBurned ?? 0) + (point.value as num).toDouble();
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          activeEnergyBurned = (activeEnergyBurned ?? 0) + (point.value as num).toDouble();
          break;
        case HealthDataType.BODY_TEMPERATURE:
          bodyTemperature = (point.value as num).toDouble();
          break;
        case HealthDataType.HEART_RATE_VARIABILITY_SDNN:
          heartRateVariability = (point.value as num).toDouble();
          break;
        case HealthDataType.BLOOD_OXYGEN:
          bloodOxygen = (point.value as num).toDouble();
          break;
        case HealthDataType.RESPIRATORY_RATE:
          respiratoryRate = (point.value as num).toDouble();
          break;
        case HealthDataType.WEIGHT:
          weight = (point.value as num).toDouble();
          break;
        case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
          systolicBP = (point.value as num).toDouble();
          break;
        case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
          diastolicBP = (point.value as num).toDouble();
          break;
        case HealthDataType.WATER:
          waterIntake = (waterIntake ?? 0) + (point.value as num).toDouble();
          break;
        case HealthDataType.DISTANCE_WALKING_RUNNING:
          distance = (distance ?? 0) + (point.value as num).toDouble();
          break;
        case HealthDataType.FLIGHTS_CLIMBED:
          flightsClimbed = (flightsClimbed ?? 0) + (point.value as num).toInt();
          break;
        default:
          break;
      }
    }

    return WearablesSummary(
      date: data.isNotEmpty ? data.first.dateFrom : DateTime.now(),
      steps: steps,
      averageHeartRate: avgHeartRate,
      restingHeartRate: restingHeartRate,
      sleepHours: sleepHours,
      deepSleepHours: deepSleepHours,
      remSleepHours: remSleepHours,
      basalEnergyBurned: basalEnergyBurned,
      activeEnergyBurned: activeEnergyBurned,
      bodyTemperature: bodyTemperature,
      heartRateVariability: heartRateVariability,
      bloodOxygen: bloodOxygen,
      respiratoryRate: respiratoryRate,
      weight: weight,
      systolicBloodPressure: systolicBP,
      diastolicBloodPressure: diastolicBP,
      waterIntake: waterIntake,
      distanceWalkingRunning: distance,
      flightsClimbed: flightsClimbed,
    );
  }

  /// Group health data by date
  Map<DateTime, List<HealthDataPoint>> _groupHealthDataByDate(List<HealthDataPoint> data) {
    final Map<DateTime, List<HealthDataPoint>> grouped = {};

    for (final point in data) {
      final dateKey = DateTime(
        point.dateFrom.year,
        point.dateFrom.month,
        point.dateFrom.day,
      );

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(point);
    }

    return grouped;
  }

  /// Process sleep data
  List<SleepData> _processSleepData(List<HealthDataPoint> data) {
    final sleepSessions = <SleepData>[];

    final sleepPeriods = data.where((d) => d.type == HealthDataType.SLEEP_ASLEEP).toList();
    
    for (final period in sleepPeriods) {
      sleepSessions.add(SleepData(
        date: period.dateFrom,
        sleepStart: period.dateFrom,
        sleepEnd: period.dateTo,
        sleepDuration: period.dateTo.difference(period.dateFrom),
      ));
    }

    return sleepSessions;
  }

  /// Process heart rate data
  List<HeartRateData> _processHeartRateData(List<HealthDataPoint> data) {
    final heartRateData = <HeartRateData>[];

    for (final point in data) {
      heartRateData.add(HeartRateData(
        timestamp: point.dateFrom,
        value: (point.value as num).toDouble(),
        type: point.type == HealthDataType.RESTING_HEART_RATE 
            ? HeartRateType.resting 
            : HeartRateType.active,
      ));
    }

    return heartRateData;
  }

  /// Clear cached data
  void clearCache() {
    _healthData.clear();
    _historicalData.clear();
    _todaysSummary = null;
    notifyListeners();
  }

  /// Check if health data is available for today
  bool get hasTodaysData => _todaysSummary != null;

  /// Get data availability status
  Map<String, bool> get dataAvailability {
    return {
      'steps': _todaysSummary?.steps != null,
      'heart_rate': _todaysSummary?.averageHeartRate != null,
      'sleep': _todaysSummary?.sleepHours != null,
      'temperature': _todaysSummary?.bodyTemperature != null,
    };
  }
}

/// Wearables data summary for a specific day
class WearablesSummary {
  final DateTime date;
  final int? steps;
  final double? averageHeartRate;
  final double? restingHeartRate;
  final double? sleepHours;
  final double? deepSleepHours;
  final double? remSleepHours;
  final double? basalEnergyBurned;
  final double? activeEnergyBurned;
  final double? bodyTemperature;
  final double? heartRateVariability;
  final double? bloodOxygen;
  final double? respiratoryRate;
  final double? weight;
  final double? systolicBloodPressure;
  final double? diastolicBloodPressure;
  final double? waterIntake;
  final double? distanceWalkingRunning;
  final int? flightsClimbed;

  WearablesSummary({
    required this.date,
    this.steps,
    this.averageHeartRate,
    this.restingHeartRate,
    this.sleepHours,
    this.deepSleepHours,
    this.remSleepHours,
    this.basalEnergyBurned,
    this.activeEnergyBurned,
    this.bodyTemperature,
    this.heartRateVariability,
    this.bloodOxygen,
    this.respiratoryRate,
    this.weight,
    this.systolicBloodPressure,
    this.diastolicBloodPressure,
    this.waterIntake,
    this.distanceWalkingRunning,
    this.flightsClimbed,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'steps': steps,
      'averageHeartRate': averageHeartRate,
      'restingHeartRate': restingHeartRate,
      'sleepHours': sleepHours,
      'deepSleepHours': deepSleepHours,
      'remSleepHours': remSleepHours,
      'basalEnergyBurned': basalEnergyBurned,
      'activeEnergyBurned': activeEnergyBurned,
      'bodyTemperature': bodyTemperature,
      'heartRateVariability': heartRateVariability,
      'bloodOxygen': bloodOxygen,
      'respiratoryRate': respiratoryRate,
      'weight': weight,
      'systolicBloodPressure': systolicBloodPressure,
      'diastolicBloodPressure': diastolicBloodPressure,
      'waterIntake': waterIntake,
      'distanceWalkingRunning': distanceWalkingRunning,
      'flightsClimbed': flightsClimbed,
    };
  }

  bool get hasData => 
      steps != null || 
      averageHeartRate != null || 
      sleepHours != null || 
      bodyTemperature != null ||
      heartRateVariability != null ||
      bloodOxygen != null;

  /// Calculate sleep quality score based on available sleep data
  double? get sleepQualityScore {
    if (sleepHours == null) return null;
    
    double score = 0.0;
    int factors = 0;
    
    // Sleep duration (7-9 hours optimal)
    if (sleepHours! >= 7 && sleepHours! <= 9) {
      score += 40;
    } else if (sleepHours! >= 6 && sleepHours! <= 10) {
      score += 30;
    } else {
      score += 20;
    }
    factors++;
    
    // Deep sleep percentage (20-25% optimal)
    if (deepSleepHours != null && sleepHours! > 0) {
      final deepPercent = (deepSleepHours! / sleepHours!) * 100;
      if (deepPercent >= 20 && deepPercent <= 25) {
        score += 30;
      } else if (deepPercent >= 15 && deepPercent <= 30) {
        score += 20;
      } else {
        score += 10;
      }
      factors++;
    }
    
    // REM sleep percentage (20-25% optimal)
    if (remSleepHours != null && sleepHours! > 0) {
      final remPercent = (remSleepHours! / sleepHours!) * 100;
      if (remPercent >= 20 && remPercent <= 25) {
        score += 30;
      } else if (remPercent >= 15 && remPercent <= 30) {
        score += 20;
      } else {
        score += 10;
      }
      factors++;
    }
    
    return factors > 0 ? (score / factors) * (100 / 40) : null; // Normalize to 0-100
  }

  /// Calculate overall wellness score based on available metrics
  double? get wellnessScore {
    double totalScore = 0.0;
    int metricCount = 0;
    
    // Sleep score (weight: 30%)
    final sleepScore = sleepQualityScore;
    if (sleepScore != null) {
      totalScore += sleepScore * 0.3;
      metricCount++;
    }
    
    // Activity score based on steps (weight: 25%)
    if (steps != null) {
      double activityScore = 0;
      if (steps! >= 10000) {
        activityScore = 100;
      } else if (steps! >= 7500) {
        activityScore = 80;
      } else if (steps! >= 5000) {
        activityScore = 60;
      } else {
        activityScore = 40;
      }
      totalScore += activityScore * 0.25;
      metricCount++;
    }
    
    // Heart rate score (weight: 20%)
    if (restingHeartRate != null) {
      double hrScore = 0;
      if (restingHeartRate! >= 60 && restingHeartRate! <= 80) {
        hrScore = 100;
      } else if (restingHeartRate! >= 50 && restingHeartRate! <= 90) {
        hrScore = 80;
      } else {
        hrScore = 60;
      }
      totalScore += hrScore * 0.2;
      metricCount++;
    }
    
    // Blood oxygen score (weight: 15%)
    if (bloodOxygen != null) {
      double oxygenScore = 0;
      if (bloodOxygen! >= 95) {
        oxygenScore = 100;
      } else if (bloodOxygen! >= 90) {
        oxygenScore = 80;
      } else {
        oxygenScore = 60;
      }
      totalScore += oxygenScore * 0.15;
      metricCount++;
    }
    
    // HRV score (weight: 10%)
    if (heartRateVariability != null) {
      double hrvScore = 0;
      if (heartRateVariability! >= 40) {
        hrvScore = 100;
      } else if (heartRateVariability! >= 20) {
        hrvScore = 80;
      } else {
        hrvScore = 60;
      }
      totalScore += hrvScore * 0.1;
      metricCount++;
    }
    
    return metricCount > 0 ? totalScore / (metricCount * 0.2) : null;
  }

  /// Get menstrual health relevant metrics
  Map<String, double?> get menstrualHealthMetrics {
    return {
      'sleep_quality': sleepQualityScore,
      'hrv': heartRateVariability,
      'resting_hr': restingHeartRate,
      'body_temp': bodyTemperature,
      'activity_level': steps?.toDouble(),
      'stress_indicator': heartRateVariability != null && restingHeartRate != null 
          ? (restingHeartRate! / (heartRateVariability! + 1)) : null,
    };
  }
}

/// Sleep data model
class SleepData {
  final DateTime date;
  final DateTime sleepStart;
  final DateTime sleepEnd;
  final Duration sleepDuration;

  SleepData({
    required this.date,
    required this.sleepStart,
    required this.sleepEnd,
    required this.sleepDuration,
  });

  double get sleepHours => sleepDuration.inMinutes / 60.0;
}

/// Heart rate data model
class HeartRateData {
  final DateTime timestamp;
  final double value;
  final HeartRateType type;

  HeartRateData({
    required this.timestamp,
    required this.value,
    required this.type,
  });
}

enum HeartRateType { resting, active }

/// Menstrual flow levels
enum MenstrualFlow {
  none,
  light,
  medium,
  heavy,
}

extension MenstrualFlowExtension on MenstrualFlow {
  double get numericValue {
    switch (this) {
      case MenstrualFlow.none:
        return 1.0;
      case MenstrualFlow.light:
        return 2.0;
      case MenstrualFlow.medium:
        return 3.0;
      case MenstrualFlow.heavy:
        return 4.0;
    }
  }

  String get displayName {
    switch (this) {
      case MenstrualFlow.none:
        return 'None';
      case MenstrualFlow.light:
        return 'Light';
      case MenstrualFlow.medium:
        return 'Medium';
      case MenstrualFlow.heavy:
        return 'Heavy';
    }
  }
}
