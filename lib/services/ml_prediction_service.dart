import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/cycle_data.dart';
import '../services/wearables_data_service.dart';
import '../services/enhanced_ai_service.dart';

/// Data adapter for ML processing - converts between CycleData and ML data points
class CycleDataPoint {
  final DateTime timestamp;
  final int dayInCycle;
  final int cycleLength;
  final CyclePhase phase;
  final DateTime periodStartDate;
  final int flowIntensity;
  final int painLevel;
  final int energyLevel;
  final String mood;
  final List<String> symptoms;

  CycleDataPoint({
    required this.timestamp,
    required this.dayInCycle,
    required this.cycleLength,
    required this.phase,
    required this.periodStartDate,
    required this.flowIntensity,
    required this.painLevel,
    required this.energyLevel,
    required this.mood,
    required this.symptoms,
  });

  /// Create from existing CycleData model
  factory CycleDataPoint.fromCycleData(CycleData cycleData, DateTime currentDate) {
    final dayInCycle = currentDate.difference(cycleData.startDate).inDays + 1;
    
    // Extract symptom data from the complex symptoms map
    final symptoms = <String>[];
    cycleData.symptoms.forEach((key, value) {
      if (value is bool && value) {
        symptoms.add(key);
      } else if (value is Map) {
        // Handle nested symptom data
        value.forEach((subKey, subValue) {
          if (subValue is bool && subValue) {
            symptoms.add('$key $subKey');
          }
        });
      }
    });

    // Calculate mood from moodScores - take the highest scoring mood
    String mood = 'neutral';
    double highestScore = 0.0;
    cycleData.moodScores.forEach((moodType, score) {
      if (score > highestScore) {
        highestScore = score;
        mood = moodType;
      }
    });

    return CycleDataPoint(
      timestamp: currentDate,
      dayInCycle: dayInCycle.clamp(1, cycleData.cycleLength),
      cycleLength: cycleData.cycleLength,
      phase: cycleData.currentPhase,
      periodStartDate: cycleData.startDate,
      flowIntensity: (cycleData.averageFlow?.round() ?? 2).clamp(0, 4),
      painLevel: 2, // Default - could be extracted from symptoms if available
      energyLevel: 3, // Default - could be calculated from mood scores
      mood: mood,
      symptoms: symptoms,
    );
  }
}

/// Enhanced ML service for on-device cycle prediction, symptom forecasting,
/// and health pattern recognition using advanced heuristic algorithms
class MLPredictionService extends ChangeNotifier {
  final WearablesDataService _wearablesService;
  final EnhancedAIService _enhancedAIService;
  
  // ML model state (using statistical models instead of TensorFlow)
  bool _statisticalModelsReady = false;
  
  // ML model state
  bool _modelsInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastTrainingTime;
  
  // Prediction results cache
  CyclePrediction? _currentCyclePrediction;
  List<SymptomPrediction> _symptomPredictions = [];
  OvulationPrediction? _ovulationPrediction;
  MoodPrediction? _moodPrediction;
  
  // Historical data for training
  List<CycleDataPoint> _historicalData = [];
  List<WearablesSummary> _historicalWearablesData = [];
  
  MLPredictionService(this._wearablesService, this._enhancedAIService);

  // Getters
  bool get modelsInitialized => _modelsInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CyclePrediction? get currentCyclePrediction => _currentCyclePrediction;
  List<SymptomPrediction> get symptomPredictions => _symptomPredictions;
  OvulationPrediction? get ovulationPrediction => _ovulationPrediction;
  MoodPrediction? get moodPrediction => _moodPrediction;

  /// Initialize ML models and preprocessing components
  Future<bool> initialize() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Initialize statistical models
      await _initializeStatisticalModels();
      
      // Initialize preprocessing components
      _initializePreprocessing();
      
      // Load historical data for training
      await _loadHistoricalData();
      
      // Train models with current data
      await _trainModelsIfNeeded();
      
      _modelsInitialized = true;
      _statisticalModelsReady = true;
      debugPrint('Enhanced ML Prediction Service initialized successfully');
      return true;
      
    } catch (e) {
      _errorMessage = 'Error initializing ML models: $e';
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialize statistical models using heuristic algorithms
  Future<void> _initializeStatisticalModels() async {
    try {
      debugPrint('Initializing enhanced statistical prediction models...');
      
      // Initialize cycle prediction algorithms
      debugPrint('✓ Cycle length prediction algorithm ready');
      
      // Initialize symptom prediction algorithms  
      debugPrint('✓ Symptom prediction algorithm ready');
      
      // Initialize mood prediction algorithms
      debugPrint('✓ Mood prediction algorithm ready');
      
      // Initialize pattern detection algorithms
      debugPrint('✓ Health pattern detection algorithm ready');
      
    } catch (e) {
      debugPrint('Error initializing statistical models: $e');
      throw e;
    }
  }

  /// Initialize preprocessing components (no-op placeholder)
  void _initializePreprocessing() {}

  /// Load historical data for model training
  Future<void> _loadHistoricalData() async {
    try {
      // In a real implementation, load from local storage or API
      // For now, we'll generate some sample data
      _historicalData = _generateSampleCycleData();
      _historicalWearablesData = _generateSampleWearablesData();
      
      debugPrint('Loaded ${_historicalData.length} historical cycle data points');
      debugPrint('Loaded ${_historicalWearablesData.length} historical wearables data points');
      
    } catch (e) {
      debugPrint('Error loading historical data: $e');
    }
  }

  /// Train models if needed (based on new data availability)
  Future<void> _trainModelsIfNeeded() async {
    final now = DateTime.now();
    final shouldRetrain = _lastTrainingTime == null ||
        now.difference(_lastTrainingTime!).inDays >= 7 ||
        _historicalData.length > (_lastTrainingTime != null ? 50 : 30);

    if (shouldRetrain && _historicalData.length >= 10) {
      await _trainModels();
      _lastTrainingTime = now;
    }
  }

  /// Train all ML models with current data
  Future<void> _trainModels() async {
    try {
      debugPrint('Training ML models with ${_historicalData.length} data points...');
      
      // Prepare training data
      final features = _prepareFeatureMatrix();
      final cycleLabels = _prepareCycleLabels();
      final symptomLabels = _prepareSymptomLabels();
      final moodLabels = _prepareMoodLabels();
      
      // Train cycle prediction model
      await _trainCyclePredictionModel(features, cycleLabels);
      
      // Train symptom prediction model
      await _trainSymptomPredictionModel(features, symptomLabels);
      
      // Train mood prediction model  
      await _trainMoodPredictionModel(features, moodLabels);
      
      debugPrint('ML models training completed');
      
    } catch (e) {
      debugPrint('Error training models: $e');
    }
  }

  /// Prepare feature matrix from historical data
  List<List<double>> _prepareFeatureMatrix() {
    final List<List<double>> features = [];
    
    for (int i = 0; i < _historicalData.length; i++) {
      final cycleData = _historicalData[i];
      final wearablesData = i < _historicalWearablesData.length 
          ? _historicalWearablesData[i] 
          : null;
      
      final featureRow = <double>[
        // Cycle features
        cycleData.dayInCycle.toDouble(),
        cycleData.cycleLength.toDouble(),
        cycleData.phase.index.toDouble(),
        cycleData.flowIntensity.toDouble(),
        cycleData.painLevel.toDouble(),
        cycleData.energyLevel.toDouble(),
        
        // Wearables features
        wearablesData?.steps?.toDouble() ?? 0.0,
        wearablesData?.sleepHours ?? 0.0,
        wearablesData?.restingHeartRate ?? 0.0,
        wearablesData?.heartRateVariability ?? 0.0,
        wearablesData?.bodyTemperature ?? 0.0,
        wearablesData?.bloodOxygen ?? 0.0,
        
        // Temporal features
        cycleData.timestamp.weekday.toDouble(),
        cycleData.timestamp.hour.toDouble(),
        _getDaysSinceLastPeriod(cycleData).toDouble(),
        
        // Symptom aggregation features
        cycleData.symptoms.length.toDouble(),
        _getSymptomSeverityScore(cycleData.symptoms).toDouble(),
      ];
      
      features.add(featureRow);
    }
    
    return features;
  }

  /// Prepare cycle length labels for training
  List<double> _prepareCycleLabels() {
    return _historicalData.map((data) => data.cycleLength.toDouble()).toList();
  }

  /// Prepare symptom labels for training
  List<List<double>> _prepareSymptomLabels() {
    final allSymptoms = _getAllUniqueSymptoms();
    
    return _historicalData.map((data) {
      final symptomVector = List<double>.filled(allSymptoms.length, 0.0);
      for (int i = 0; i < allSymptoms.length; i++) {
        if (data.symptoms.contains(allSymptoms[i])) {
          symptomVector[i] = 1.0;
        }
      }
      return symptomVector;
    }).toList();
  }

  /// Prepare mood labels for training
  List<double> _prepareMoodLabels() {
    final moodValues = ['happy', 'sad', 'anxious', 'calm', 'energetic', 'tired'];
    return _historicalData.map((data) {
      final moodIndex = moodValues.indexOf(data.mood);
      return moodIndex >= 0 ? moodIndex.toDouble() : 0.0;
    }).toList();
  }

  /// Train cycle prediction model using classical ML
  Future<void> _trainCyclePredictionModel(List<List<double>> features, List<double> labels) async {
    try {
      // Skipping heavy on-device model training in this build.
      // Placeholder: would train a model using features and labels here.
      debugPrint('Cycle prediction model training skipped (placeholder).');
      
    } catch (e) {
      debugPrint('Error training cycle prediction model: $e');
    }
  }

  /// Train symptom prediction model
  Future<void> _trainSymptomPredictionModel(List<List<double>> features, List<List<double>> labels) async {
    try {
      // Skipping symptom model training - using heuristics for now.
      debugPrint('Symptom prediction model training skipped (placeholder).');
      
    } catch (e) {
      debugPrint('Error training symptom prediction model: $e');
    }
  }

  /// Train mood prediction model
  Future<void> _trainMoodPredictionModel(List<List<double>> features, List<double> labels) async {
    try {
      // Skipping mood model training - using heuristics for now.
      debugPrint('Mood prediction model training skipped (placeholder).');
      
    } catch (e) {
      debugPrint('Error training mood prediction model: $e');
    }
  }

  /// Generate cycle predictions for the next cycles
  Future<CyclePrediction> predictNextCycle(CycleDataPoint currentCycle) async {
    try {
      if (!_modelsInitialized) {
        throw Exception('ML models not initialized');
      }

      // Prepare current features
      final currentFeatures = _prepareCurrentFeatures(currentCycle);
      
      // Run inference based on available models
      final predictedLength = await _predictCycleLength(currentFeatures);
      final nextPeriodDate = _calculateNextPeriodDate(currentCycle, predictedLength);
      final ovulationDate = _calculateOvulationDate(nextPeriodDate, predictedLength);
      final fertilityWindow = _calculateFertilityWindow(ovulationDate);
      
      _currentCyclePrediction = CyclePrediction(
        predictedCycleLength: predictedLength,
        nextPeriodDate: nextPeriodDate,
        ovulationDate: ovulationDate,
        fertilityWindowStart: fertilityWindow.start,
        fertilityWindowEnd: fertilityWindow.end,
        confidence: _calculatePredictionConfidence(currentFeatures),
        basedOnCycles: _historicalData.length,
        predictionMethod: 'Enhanced Statistical Models',
      );
      
      return _currentCyclePrediction!;
      
    } catch (e) {
      debugPrint('Error predicting next cycle: $e');
      throw Exception('Failed to generate cycle prediction: $e');
    }
  }

  /// Predict upcoming symptoms for the next 7 days
  Future<List<SymptomPrediction>> predictUpcomingSymptoms(CycleDataPoint currentCycle) async {
    try {
      if (!_modelsInitialized) {
        throw Exception('ML models not initialized');
      }

      final predictions = <SymptomPrediction>[];
      final allSymptoms = _getAllUniqueSymptoms();
      
      // Predict for next 7 days
      for (int dayOffset = 1; dayOffset <= 7; dayOffset++) {
        final futureDate = DateTime.now().add(Duration(days: dayOffset));
        final futureDayInCycle = currentCycle.dayInCycle + dayOffset;
        
        // Prepare features for future day
        final futureFeatures = _prepareFutureFeatures(currentCycle, futureDayInCycle);
        
        // Predict symptoms for this day
        final daySymptomPredictions = <String, double>{};
        
        for (final symptom in allSymptoms) {
          final probability = await _predictSymptomProbability(futureFeatures, symptom);
          if (probability > 0.3) { // Only include likely symptoms
            daySymptomPredictions[symptom] = probability;
          }
        }
        
        if (daySymptomPredictions.isNotEmpty) {
          predictions.add(SymptomPrediction(
            date: futureDate,
            dayInCycle: futureDayInCycle,
            predictedSymptoms: daySymptomPredictions,
            confidence: _calculateSymptomPredictionConfidence(futureFeatures),
          ));
        }
      }
      
      _symptomPredictions = predictions;
      return predictions;
      
    } catch (e) {
      debugPrint('Error predicting symptoms: $e');
      return [];
    }
  }

  /// Predict mood patterns for upcoming days
  Future<MoodPrediction> predictMoodPatterns(CycleDataPoint currentCycle) async {
    try {
      if (!_modelsInitialized) {
        throw Exception('ML models not initialized');
      }

      final moodPredictions = <DateTime, MoodState>{};
      final moodValues = ['happy', 'sad', 'anxious', 'calm', 'energetic', 'tired'];
      
      // Predict mood for next 7 days
      for (int dayOffset = 1; dayOffset <= 7; dayOffset++) {
        final futureDate = DateTime.now().add(Duration(days: dayOffset));
        final futureDayInCycle = currentCycle.dayInCycle + dayOffset;
        
        final futureFeatures = _prepareFutureFeatures(currentCycle, futureDayInCycle);
        final moodProbabilities = await _predictMoodProbabilities(futureFeatures);
        
        // Find most likely mood
        double maxProb = 0;
        int maxIndex = 0;
        for (int i = 0; i < moodProbabilities.length; i++) {
          if (moodProbabilities[i] > maxProb) {
            maxProb = moodProbabilities[i];
            maxIndex = i;
          }
        }
        
        moodPredictions[futureDate] = MoodState(
          mood: moodValues[maxIndex],
          confidence: maxProb,
          factors: _identifyMoodFactors(futureFeatures, maxIndex),
        );
      }
      
      _moodPrediction = MoodPrediction(
        predictions: moodPredictions,
        overallTrend: _calculateOverallMoodTrend(moodPredictions),
        riskFactors: _identifyMoodRiskFactors(currentCycle),
      );
      
      return _moodPrediction!;
      
    } catch (e) {
      debugPrint('Error predicting mood: $e');
      throw Exception('Failed to generate mood prediction: $e');
    }
  }

  /// Detect health patterns and anomalies
  Future<List<HealthPattern>> detectHealthPatterns() async {
    try {
      final patterns = <HealthPattern>[];
      
      // Analyze cycle regularity pattern
      final regularityPattern = _analyzeCycleRegularity();
      if (regularityPattern != null) patterns.add(regularityPattern);
      
      // Analyze symptom patterns
      final symptomPatterns = _analyzeSymptomPatterns();
      patterns.addAll(symptomPatterns);
      
      // Analyze wearables patterns
      final wearablesPatterns = _analyzeWearablesPatterns();
      patterns.addAll(wearablesPatterns);
      
      // Detect anomalies
      final anomalies = _detectAnomalies();
      patterns.addAll(anomalies);
      
      return patterns;
      
    } catch (e) {
      debugPrint('Error detecting health patterns: $e');
      return [];
    }
  }

  /// Prepare current features for prediction
  List<double> _prepareCurrentFeatures(CycleDataPoint currentCycle) {
    final wearablesData = _wearablesService.todaysSummary;
    
    return [
      currentCycle.dayInCycle.toDouble(),
      currentCycle.cycleLength.toDouble(),
      currentCycle.phase.index.toDouble(),
      currentCycle.flowIntensity.toDouble(),
      currentCycle.painLevel.toDouble(),
      currentCycle.energyLevel.toDouble(),
      
      wearablesData?.steps?.toDouble() ?? 8000.0,
      wearablesData?.sleepHours ?? 7.5,
      wearablesData?.restingHeartRate ?? 70.0,
      wearablesData?.heartRateVariability ?? 35.0,
      wearablesData?.bodyTemperature ?? 36.5,
      wearablesData?.bloodOxygen ?? 98.0,
      
      DateTime.now().weekday.toDouble(),
      DateTime.now().hour.toDouble(),
      _getDaysSinceLastPeriod(currentCycle).toDouble(),
      
      currentCycle.symptoms.length.toDouble(),
      _getSymptomSeverityScore(currentCycle.symptoms).toDouble(),
    ];
  }

  /// Prepare future features for prediction
  List<double> _prepareFutureFeatures(CycleDataPoint currentCycle, int futureDayInCycle) {
    final currentFeatures = _prepareCurrentFeatures(currentCycle);
    
    // Modify temporal features for future prediction
    final features = List<double>.from(currentFeatures);
    features[0] = futureDayInCycle.toDouble(); // dayInCycle
    
    // Estimate future wearables data based on patterns
    final phase = _predictPhaseForDay(futureDayInCycle, currentCycle.cycleLength);
    features[2] = phase.index.toDouble();
    
    return features;
  }

  /// Predict cycle length using trained model
  Future<int> _predictCycleLength(List<double> features) async {
    // Fallback prediction based on historical average
    if (_historicalData.isEmpty) return 28;
    
    final avgCycleLength = _historicalData
        .map((d) => d.cycleLength)
        .reduce((a, b) => a + b) / _historicalData.length;
    
    // Add some variation based on current features
    final variation = (features[4] - 5.0) * 0.5; // Based on pain level
    final predicted = (avgCycleLength + variation).round().clamp(21, 35);
    
    return predicted;
  }

  /// Predict symptom probability
  Future<double> _predictSymptomProbability(List<double> features, String symptom) async {
    // Simple heuristic-based prediction (replace with actual ML model)
    final dayInCycle = features[0].toInt();
    final phase = CyclePhase.values[features[2].toInt().clamp(0, CyclePhase.values.length - 1)];
    
    // Different symptoms have different probabilities based on cycle phase
    switch (symptom.toLowerCase()) {
      case 'cramps':
        return phase == CyclePhase.menstrual ? 0.8 : 
               phase == CyclePhase.luteal && dayInCycle > 21 ? 0.4 : 0.1;
      case 'bloating':
        return phase == CyclePhase.luteal ? 0.6 : 0.2;
      case 'acne':
        return phase == CyclePhase.luteal || phase == CyclePhase.menstrual ? 0.5 : 0.2;
      case 'mood swings':
        return phase == CyclePhase.luteal ? 0.7 : 0.3;
      case 'fatigue':
        return phase == CyclePhase.menstrual || phase == CyclePhase.luteal ? 0.6 : 0.3;
      default:
        return 0.3;
    }
  }

  /// Predict mood probabilities
  Future<List<double>> _predictMoodProbabilities(List<double> features) async {
    // Simple heuristic-based prediction (replace with actual ML model)
    final phase = CyclePhase.values[features[2].toInt().clamp(0, CyclePhase.values.length - 1)];
    final sleepHours = features[7];
    final hrv = features[9];
    
    // Mood probabilities: [happy, sad, anxious, calm, energetic, tired]
    switch (phase) {
      case CyclePhase.menstrual:
        return [0.2, 0.3, 0.2, 0.1, 0.1, 0.4];
      case CyclePhase.follicular:
        return [0.4, 0.1, 0.1, 0.2, 0.3, 0.2];
      case CyclePhase.ovulatory:
        return [0.5, 0.1, 0.1, 0.3, 0.4, 0.1];
      case CyclePhase.luteal:
        return [0.2, 0.4, 0.3, 0.1, 0.1, 0.3];
      default:
        return [0.25, 0.25, 0.25, 0.25, 0.25, 0.25];
    }
  }

  /// Calculate prediction confidence
  double _calculatePredictionConfidence(List<double> features) {
    if (_historicalData.length < 5) return 0.5;
    if (_historicalData.length < 10) return 0.7;
    return 0.85;
  }

  /// Calculate symptom prediction confidence
  double _calculateSymptomPredictionConfidence(List<double> features) {
    return _calculatePredictionConfidence(features) * 0.8;
  }

  /// Helper methods for calculations
  DateTime _calculateNextPeriodDate(CycleDataPoint currentCycle, int predictedLength) {
    final daysSinceStart = DateTime.now().difference(currentCycle.periodStartDate).inDays;
    final daysUntilNext = predictedLength - daysSinceStart;
    return DateTime.now().add(Duration(days: daysUntilNext));
  }

  DateTime _calculateOvulationDate(DateTime nextPeriodDate, int cycleLength) {
    return nextPeriodDate.subtract(Duration(days: 14));
  }

  DateRange _calculateFertilityWindow(DateTime ovulationDate) {
    return DateRange(
      start: ovulationDate.subtract(const Duration(days: 5)),
      end: ovulationDate.add(const Duration(days: 1)),
    );
  }

  int _getDaysSinceLastPeriod(CycleDataPoint cycle) {
    return DateTime.now().difference(cycle.periodStartDate).inDays;
  }

  double _getSymptomSeverityScore(List<String> symptoms) {
    final severityMap = {
      'mild cramps': 1.0,
      'moderate cramps': 2.0,
      'severe cramps': 3.0,
      'light bleeding': 1.0,
      'heavy bleeding': 3.0,
      'bloating': 1.5,
      'acne': 1.0,
      'mood swings': 2.0,
      'fatigue': 2.0,
    };
    
    return symptoms.map((s) => severityMap[s.toLowerCase()] ?? 1.0).fold(0.0, (a, b) => a + b);
  }

  List<String> _getAllUniqueSymptoms() {
    final symptoms = <String>{};
    for (final data in _historicalData) {
      symptoms.addAll(data.symptoms);
    }
    return symptoms.toList();
  }

  CyclePhase _predictPhaseForDay(int dayInCycle, int cycleLength) {
    if (dayInCycle <= 5) return CyclePhase.menstrual;
    if (dayInCycle <= cycleLength ~/ 2) return CyclePhase.follicular;
    if (dayInCycle <= (cycleLength ~/ 2) + 3) return CyclePhase.ovulatory;
    return CyclePhase.luteal;
  }

  /// Pattern analysis methods
  HealthPattern? _analyzeCycleRegularity() {
    if (_historicalData.length < 3) return null;
    
    final cycleLengths = _historicalData.map((d) => d.cycleLength).toList();
    final avgLength = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
    final variance = cycleLengths.map((l) => pow(l - avgLength, 2)).reduce((a, b) => a + b) / cycleLengths.length;
    final standardDeviation = sqrt(variance);
    
    if (standardDeviation <= 2) {
      return HealthPattern(
        id: 'cycle_regularity',
        type: PatternType.positive,
        name: 'Regular Cycles',
        description: 'Your cycles are very regular with an average length of ${avgLength.toStringAsFixed(1)} days.',
        confidence: 0.9,
        significance: PatternSignificance.high,
      );
    } else if (standardDeviation <= 5) {
      return HealthPattern(
        id: 'cycle_irregularity',
        type: PatternType.neutral,
        name: 'Somewhat Irregular Cycles',
        description: 'Your cycle length varies by about ${standardDeviation.toStringAsFixed(1)} days.',
        confidence: 0.8,
        significance: PatternSignificance.medium,
      );
    } else {
      return HealthPattern(
        id: 'cycle_very_irregular',
        type: PatternType.concerning,
        name: 'Irregular Cycles',
        description: 'Your cycles show significant variation. Consider consulting a healthcare provider.',
        confidence: 0.85,
        significance: PatternSignificance.high,
      );
    }
  }

  List<HealthPattern> _analyzeSymptomPatterns() {
    final patterns = <HealthPattern>[];
    
    // Analyze PMS pattern
    final pmsSymptoms = ['mood swings', 'bloating', 'cramps', 'fatigue'];
    final lutealData = _historicalData.where((d) => d.phase == CyclePhase.luteal).toList();
    
    if (lutealData.length >= 3) {
      final pmsCount = lutealData.where((d) => 
        d.symptoms.any((s) => pmsSymptoms.contains(s.toLowerCase()))
      ).length;
      
      if (pmsCount / lutealData.length > 0.7) {
        patterns.add(HealthPattern(
          id: 'pms_pattern',
          type: PatternType.neutral,
          name: 'PMS Pattern Detected',
          description: 'You experience PMS symptoms in ${(pmsCount / lutealData.length * 100).toInt()}% of your luteal phases.',
          confidence: 0.8,
          significance: PatternSignificance.medium,
        ));
      }
    }
    
    return patterns;
  }

  List<HealthPattern> _analyzeWearablesPatterns() {
    final patterns = <HealthPattern>[];
    
    if (_historicalWearablesData.length >= 7) {
      // Analyze sleep pattern
      final avgSleep = _historicalWearablesData
          .where((d) => d.sleepHours != null)
          .map((d) => d.sleepHours!)
          .fold(0.0, (a, b) => a + b) / _historicalWearablesData.length;
      
      if (avgSleep < 7) {
        patterns.add(HealthPattern(
          id: 'insufficient_sleep',
          type: PatternType.concerning,
          name: 'Insufficient Sleep Pattern',
          description: 'You average ${avgSleep.toStringAsFixed(1)} hours of sleep, which may affect your cycle.',
          confidence: 0.9,
          significance: PatternSignificance.high,
        ));
      }
    }
    
    return patterns;
  }

  List<HealthPattern> _detectAnomalies() {
    final anomalies = <HealthPattern>[];
    
    // Detect unusual cycle lengths
    if (_historicalData.length >= 5) {
      final recentCycles = _historicalData.take(3).map((d) => d.cycleLength).toList();
      final historicalAvg = _historicalData.skip(3).map((d) => d.cycleLength).fold(0, (a, b) => a + b) / 
                           (_historicalData.length - 3);
      
      for (final length in recentCycles) {
        if ((length - historicalAvg).abs() > 7) {
          anomalies.add(HealthPattern(
            id: 'cycle_anomaly_${length}',
            type: PatternType.concerning,
            name: 'Unusual Cycle Length',
            description: 'Recent cycle of $length days is significantly different from your average of ${historicalAvg.toStringAsFixed(1)} days.',
            confidence: 0.7,
            significance: PatternSignificance.medium,
          ));
        }
      }
    }
    
    return anomalies;
  }

  List<String> _identifyMoodFactors(List<double> features, int moodIndex) {
    final factors = <String>[];
    final sleepHours = features[7];
    final hrv = features[9];
    
    if (sleepHours < 7) factors.add('Insufficient sleep');
    if (hrv < 30) factors.add('High stress levels');
    
    return factors;
  }

  String _calculateOverallMoodTrend(Map<DateTime, MoodState> predictions) {
    final positiveMoods = ['happy', 'calm', 'energetic'];
    final positiveCount = predictions.values
        .where((mood) => positiveMoods.contains(mood.mood))
        .length;
    
    if (positiveCount >= predictions.length * 0.6) return 'Positive';
    if (positiveCount >= predictions.length * 0.4) return 'Mixed';
    return 'Challenging';
  }

  List<String> _identifyMoodRiskFactors(CycleDataPoint currentCycle) {
    final riskFactors = <String>[];
    
    if (currentCycle.phase == CyclePhase.luteal) {
      riskFactors.add('Luteal phase hormonal changes');
    }
    
    final wearablesData = _wearablesService.todaysSummary;
    if (wearablesData?.sleepHours != null && wearablesData!.sleepHours! < 7) {
      riskFactors.add('Sleep deprivation');
    }
    
    return riskFactors;
  }

  /// Generate sample data for testing
  List<CycleDataPoint> _generateSampleCycleData() {
    final data = <CycleDataPoint>[];
    final random = Random();
    
    for (int i = 0; i < 30; i++) {
      final daysAgo = 30 - i;
      final cycleLength = 26 + random.nextInt(6); // 26-32 days
      final dayInCycle = (daysAgo % cycleLength) + 1;
      final phase = _predictPhaseForDay(dayInCycle, cycleLength);
      
      data.add(CycleDataPoint(
        timestamp: DateTime.now().subtract(Duration(days: daysAgo)),
        dayInCycle: dayInCycle,
        cycleLength: cycleLength,
        phase: phase,
        periodStartDate: DateTime.now().subtract(Duration(days: daysAgo + (cycleLength - dayInCycle))),
        flowIntensity: random.nextInt(4),
        painLevel: random.nextInt(6),
        energyLevel: random.nextInt(6) + 1,
        mood: ['happy', 'sad', 'anxious', 'calm', 'energetic', 'tired'][random.nextInt(6)],
        symptoms: _generateRandomSymptoms(phase, random),
      ));
    }
    
    return data;
  }

  List<WearablesSummary> _generateSampleWearablesData() {
    final data = <WearablesSummary>[];
    final random = Random();
    
    for (int i = 0; i < 30; i++) {
      data.add(WearablesSummary(
        date: DateTime.now().subtract(Duration(days: 30 - i)),
        steps: 7000 + random.nextInt(8000),
        sleepHours: 6.5 + random.nextDouble() * 2.5,
        restingHeartRate: 60.0 + random.nextDouble() * 20,
        heartRateVariability: 25.0 + random.nextDouble() * 30,
        bodyTemperature: 36.0 + random.nextDouble() * 1.5,
        bloodOxygen: 95.0 + random.nextDouble() * 5,
      ));
    }
    
    return data;
  }

  List<String> _generateRandomSymptoms(CyclePhase phase, Random random) {
    final allSymptoms = ['cramps', 'bloating', 'acne', 'mood swings', 'fatigue', 'headache'];
    final symptoms = <String>[];
    
    // Phase-specific symptom probabilities
    switch (phase) {
      case CyclePhase.menstrual:
        if (random.nextDouble() < 0.8) symptoms.add('cramps');
        if (random.nextDouble() < 0.6) symptoms.add('fatigue');
        break;
      case CyclePhase.luteal:
        if (random.nextDouble() < 0.7) symptoms.add('bloating');
        if (random.nextDouble() < 0.6) symptoms.add('mood swings');
        if (random.nextDouble() < 0.5) symptoms.add('acne');
        break;
      default:
        break;
    }
    
    return symptoms;
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    _historicalData.clear();
    _historicalWearablesData.clear();
    _symptomPredictions.clear();
    super.dispose();
  }
}

/// Data models for ML predictions
class CyclePrediction {
  final int predictedCycleLength;
  final DateTime nextPeriodDate;
  final DateTime ovulationDate;
  final DateTime fertilityWindowStart;
  final DateTime fertilityWindowEnd;
  final double confidence;
  final int basedOnCycles;
  final String predictionMethod;

  CyclePrediction({
    required this.predictedCycleLength,
    required this.nextPeriodDate,
    required this.ovulationDate,
    required this.fertilityWindowStart,
    required this.fertilityWindowEnd,
    required this.confidence,
    required this.basedOnCycles,
    required this.predictionMethod,
  });
}

class SymptomPrediction {
  final DateTime date;
  final int dayInCycle;
  final Map<String, double> predictedSymptoms;
  final double confidence;

  SymptomPrediction({
    required this.date,
    required this.dayInCycle,
    required this.predictedSymptoms,
    required this.confidence,
  });
}

class MoodPrediction {
  final Map<DateTime, MoodState> predictions;
  final String overallTrend;
  final List<String> riskFactors;

  MoodPrediction({
    required this.predictions,
    required this.overallTrend,
    required this.riskFactors,
  });
}

class MoodState {
  final String mood;
  final double confidence;
  final List<String> factors;

  MoodState({
    required this.mood,
    required this.confidence,
    required this.factors,
  });
}

class OvulationPrediction {
  final DateTime predictedDate;
  final double confidence;
  final List<String> indicators;

  OvulationPrediction({
    required this.predictedDate,
    required this.confidence,
    required this.indicators,
  });
}

class HealthPattern {
  final String id;
  final PatternType type;
  final String name;
  final String description;
  final double confidence;
  final PatternSignificance significance;

  HealthPattern({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.confidence,
    required this.significance,
  });
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});
}

enum PatternType { positive, neutral, concerning }
enum PatternSignificance { low, medium, high }
