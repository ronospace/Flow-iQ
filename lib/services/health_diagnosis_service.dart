import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_diagnosis.dart';
import '../models/cycle_data.dart';
import '../models/ai_insights.dart';
import 'flow_iq_sync_service.dart';

/// Service for health diagnosis, condition screening, and symptom analysis
class HealthDiagnosisService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlowIQSyncService _syncService;

  List<HealthDiagnosis> _diagnoses = [];
  bool _isAnalyzing = false;

  HealthDiagnosisService(this._syncService);

  // Getters
  List<HealthDiagnosis> get diagnoses => _diagnoses;
  bool get isAnalyzing => _isAnalyzing;
  User? get currentUser => _auth.currentUser;

  /// Load user's diagnosis history
  Future<void> loadDiagnoses() async {
    if (currentUser == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('health_diagnoses')
          .orderBy('createdAt', descending: true)
          .get();

      _diagnoses = snapshot.docs
          .map((doc) => HealthDiagnosis.fromFirestore(doc))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading diagnoses: $e');
    }
  }

  /// Perform comprehensive health screening based on user's tracking data
  Future<List<HealthDiagnosis>> performHealthScreening() async {
    if (currentUser == null) return [];

    _isAnalyzing = true;
    notifyListeners();

    try {
      // Get user's cycle and symptom data
      final cycles = await _getCycleHistory();
      final symptoms = await _getSymptomHistory();
      final insights = await _syncService.getRecentInsights(limit: 20);

      List<HealthDiagnosis> newDiagnoses = [];

      // Screen for various conditions
      for (final condition in MenstrualCondition.values) {
        final diagnosis = await _screenForCondition(
          condition,
          cycles,
          symptoms,
          insights,
        );
        
        if (diagnosis != null) {
          newDiagnoses.add(diagnosis);
        }
      }

      // Save diagnoses to Firestore
      for (final diagnosis in newDiagnoses) {
        await _saveDiagnosis(diagnosis);
      }

      _diagnoses.insertAll(0, newDiagnoses);
      notifyListeners();

      return newDiagnoses;
    } catch (e) {
      debugPrint('Error performing health screening: $e');
      return [];
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Screen for a specific condition
  Future<HealthDiagnosis?> _screenForCondition(
    MenstrualCondition condition,
    List<CycleData> cycles,
    Map<DateTime, List<String>> symptoms,
    List<AIInsights> insights,
  ) async {
    final riskScore = _calculateRiskScore(condition, cycles, symptoms);
    
    if (riskScore < 0.2) return null; // Skip low-risk conditions

    final matchedSymptoms = _getMatchedSymptoms(condition, symptoms);
    final riskFactors = _assessRiskFactors(condition, cycles);
    final severity = _determineSeverity(riskScore);
    
    return HealthDiagnosis(
      id: '', // Will be set when saved to Firestore
      userId: currentUser!.uid,
      type: DiagnosisType.screening,
      conditionName: condition.displayName,
      riskScore: riskScore,
      symptoms: matchedSymptoms,
      riskFactors: riskFactors,
      assessment: _generateAssessment(condition, riskScore, matchedSymptoms),
      recommendation: _generateRecommendation(condition, riskScore, severity),
      severity: severity,
      requiresProfessionalConsultation: riskScore >= 0.6 || severity.index >= 2,
      createdAt: DateTime.now(),
      followUpDate: _calculateFollowUpDate(severity),
      diagnosticData: {
        'condition_code': condition.toString().split('.').last,
        'analysis_date': DateTime.now().toIso8601String(),
        'data_points_analyzed': cycles.length + symptoms.length,
        'algorithm_version': '1.0',
      },
    );
  }

  /// Calculate risk score for a specific condition
  double _calculateRiskScore(
    MenstrualCondition condition,
    List<CycleData> cycles,
    Map<DateTime, List<String>> symptoms,
  ) {
    double score = 0.0;
    int factors = 0;

    switch (condition) {
      case MenstrualCondition.pcos:
        // Check for irregular cycles
        if (cycles.isNotEmpty) {
          final cycleLengths = cycles.map((c) => c.cycleLength).toList();
          final avgLength = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
          final variance = _calculateVariance(cycleLengths);
          
          if (variance > 5) score += 0.3; // High cycle irregularity
          if (avgLength > 35) score += 0.2; // Long cycles
          factors += 2;
        }

        // Check for PCOS-related symptoms
        final pcosSymptoms = ['acne', 'weight gain', 'hair loss', 'irregular periods'];
        final matchCount = _countSymptomMatches(symptoms, pcosSymptoms);
        score += (matchCount / pcosSymptoms.length) * 0.4;
        factors++;
        break;

      case MenstrualCondition.endometriosis:
        // Check for severe pain symptoms
        final endoSymptoms = ['severe pelvic pain', 'pain during intercourse', 'heavy periods'];
        final matchCount = _countSymptomMatches(symptoms, endoSymptoms);
        score += (matchCount / endoSymptoms.length) * 0.5;
        
        // Check for heavy periods in cycle data
        final heavyPeriods = cycles.where((c) => (c.averageFlow ?? 0) > 0.7).length;
        if (heavyPeriods > cycles.length * 0.5) score += 0.3;
        factors += 2;
        break;

      case MenstrualCondition.menorrhagia:
        // Check for heavy bleeding patterns
        final heavyPeriods = cycles.where((c) => 
          c.periodLength != null && c.periodLength! > 7 ||
          (c.averageFlow ?? 0) > 0.8
        ).length;
        
        if (cycles.isNotEmpty) {
          score += (heavyPeriods / cycles.length) * 0.6;
          factors++;
        }

        final heavySymptoms = ['heavy bleeding', 'fatigue', 'shortness of breath'];
        final matchCount = _countSymptomMatches(symptoms, heavySymptoms);
        score += (matchCount / heavySymptoms.length) * 0.4;
        factors++;
        break;

      case MenstrualCondition.amenorrhea:
        // Check for missing periods
        final now = DateTime.now();
        final recentCycles = cycles.where((c) => 
          now.difference(c.startDate).inDays < 90
        ).toList();
        
        if (recentCycles.isEmpty && cycles.isNotEmpty) {
          score += 0.8; // No periods in last 3 months
        }
        factors++;
        break;

      case MenstrualCondition.dysmenorrhea:
        // Check for pain-related symptoms
        final painSymptoms = ['severe menstrual cramps', 'lower back pain', 'nausea', 'vomiting'];
        final matchCount = _countSymptomMatches(symptoms, painSymptoms);
        score += (matchCount / painSymptoms.length) * 0.7;
        factors++;
        break;

      default:
        // Generic symptom matching for other conditions
        final conditionSymptoms = condition.commonSymptoms;
        final matchCount = _countSymptomMatches(symptoms, conditionSymptoms);
        score += (matchCount / conditionSymptoms.length) * 0.5;
        factors++;
        break;
    }

    return factors > 0 ? (score / factors).clamp(0.0, 1.0) : 0.0;
  }

  /// Count how many symptoms match the condition
  int _countSymptomMatches(Map<DateTime, List<String>> userSymptoms, List<String> conditionSymptoms) {
    int matches = 0;
    final allUserSymptoms = userSymptoms.values.expand((list) => list).toList();
    
    for (final symptom in conditionSymptoms) {
      final lowerSymptom = symptom.toLowerCase();
      final hasMatch = allUserSymptoms.any((userSymptom) => 
        userSymptom.toLowerCase().contains(lowerSymptom) ||
        lowerSymptom.contains(userSymptom.toLowerCase())
      );
      if (hasMatch) matches++;
    }
    
    return matches;
  }

  /// Calculate variance in cycle lengths
  double _calculateVariance(List<int> values) {
    if (values.isEmpty) return 0.0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean)).toList();
    return squaredDiffs.reduce((a, b) => a + b) / values.length;
  }

  /// Get matched symptoms for a condition
  List<String> _getMatchedSymptoms(
    MenstrualCondition condition,
    Map<DateTime, List<String>> symptoms,
  ) {
    final conditionSymptoms = condition.commonSymptoms;
    final allUserSymptoms = symptoms.values.expand((list) => list).toList();
    final matches = <String>[];

    for (final symptom in conditionSymptoms) {
      final lowerSymptom = symptom.toLowerCase();
      final matchingUserSymptom = allUserSymptoms.firstWhere(
        (userSymptom) => 
          userSymptom.toLowerCase().contains(lowerSymptom) ||
          lowerSymptom.contains(userSymptom.toLowerCase()),
        orElse: () => '',
      );
      
      if (matchingUserSymptom.isNotEmpty) {
        matches.add(matchingUserSymptom);
      }
    }

    return matches;
  }

  /// Assess risk factors for a condition
  List<String> _assessRiskFactors(MenstrualCondition condition, List<CycleData> cycles) {
    // This would ideally get risk factor data from user profile
    // For now, return generic risk factors based on cycle patterns
    final riskFactors = <String>[];
    
    if (cycles.isNotEmpty) {
      final avgCycleLength = cycles.map((c) => c.cycleLength).reduce((a, b) => a + b) / cycles.length;
      if (avgCycleLength > 35) riskFactors.add('Long menstrual cycles');
      if (avgCycleLength < 21) riskFactors.add('Short menstrual cycles');
      
      final variance = _calculateVariance(cycles.map((c) => c.cycleLength).toList());
      if (variance > 5) riskFactors.add('Irregular menstrual cycles');
    }
    
    return riskFactors;
  }

  /// Determine severity based on risk score
  DiagnosisSeverity _determineSeverity(double riskScore) {
    if (riskScore >= 0.8) return DiagnosisSeverity.critical;
    if (riskScore >= 0.6) return DiagnosisSeverity.high;
    if (riskScore >= 0.4) return DiagnosisSeverity.moderate;
    if (riskScore >= 0.2) return DiagnosisSeverity.mild;
    return DiagnosisSeverity.low;
  }

  /// Generate assessment text
  String _generateAssessment(
    MenstrualCondition condition,
    double riskScore,
    List<String> symptoms,
  ) {
    final riskLevel = riskScore >= 0.6 ? 'high' : riskScore >= 0.4 ? 'moderate' : 'low';
    
    return 'Based on your tracking data and reported symptoms, you have a $riskLevel '
           'risk indication for ${condition.displayName}. '
           '${symptoms.isNotEmpty ? "Key symptoms identified include: ${symptoms.take(3).join(", ")}." : ""} '
           'This assessment is based on ${condition.description}';
  }

  /// Generate recommendation text
  String _generateRecommendation(
    MenstrualCondition condition,
    double riskScore,
    DiagnosisSeverity severity,
  ) {
    if (riskScore >= 0.6) {
      return 'We strongly recommend consulting with a healthcare provider for proper '
             'evaluation and diagnosis. Early intervention can help manage symptoms '
             'and prevent complications.';
    } else if (riskScore >= 0.4) {
      return 'Consider monitoring your symptoms closely and discuss with your healthcare '
             'provider during your next appointment. Keep tracking your cycles and symptoms.';
    } else {
      return 'Continue monitoring your menstrual health. If symptoms worsen or new '
             'symptoms develop, consult with a healthcare provider.';
    }
  }

  /// Calculate follow-up date based on severity
  DateTime? _calculateFollowUpDate(DiagnosisSeverity severity) {
    final now = DateTime.now();
    switch (severity) {
      case DiagnosisSeverity.critical:
        return now.add(const Duration(days: 7));
      case DiagnosisSeverity.high:
        return now.add(const Duration(days: 14));
      case DiagnosisSeverity.moderate:
        return now.add(const Duration(days: 30));
      case DiagnosisSeverity.mild:
        return now.add(const Duration(days: 60));
      case DiagnosisSeverity.low:
        return now.add(const Duration(days: 90));
    }
  }

  /// Get cycle history from sync service
  Future<List<CycleData>> _getCycleHistory() async {
    // This would get historical cycle data
    return _syncService.cycles;
  }

  /// Get symptom history
  Future<Map<DateTime, List<String>>> _getSymptomHistory() async {
    // This would get historical symptom data from Firestore
    // For now, return empty map
    return {};
  }

  /// Save diagnosis to Firestore
  Future<void> _saveDiagnosis(HealthDiagnosis diagnosis) async {
    if (currentUser == null) return;

    final docRef = await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('health_diagnoses')
        .add(diagnosis.toFirestore());

    // Update local diagnosis with Firestore ID
    final index = _diagnoses.indexWhere((d) => d.createdAt == diagnosis.createdAt);
    if (index != -1) {
      _diagnoses[index] = diagnosis.copyWith(id: docRef.id);
    }
  }

  /// Get high-risk diagnoses that need attention
  List<HealthDiagnosis> getHighRiskDiagnoses() {
    return _diagnoses.where((d) => 
      d.isHighRisk && d.requiresProfessionalConsultation
    ).toList();
  }

  /// Get diagnoses requiring follow-up
  List<HealthDiagnosis> getDiagnosesDueForFollowUp() {
    final now = DateTime.now();
    return _diagnoses.where((d) => 
      d.followUpDate != null && 
      d.followUpDate!.isBefore(now.add(const Duration(days: 7)))
    ).toList();
  }

  /// Mark diagnosis as reviewed
  Future<void> markAsReviewed(String diagnosisId) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('health_diagnoses')
        .doc(diagnosisId)
        .update({'reviewed': true, 'reviewedAt': FieldValue.serverTimestamp()});
  }

  /// Delete diagnosis
  Future<void> deleteDiagnosis(String diagnosisId) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('health_diagnoses')
        .doc(diagnosisId)
        .delete();

    _diagnoses.removeWhere((d) => d.id == diagnosisId);
    notifyListeners();
  }
}
