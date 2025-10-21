import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cycle_data.dart';
import '../models/ai_insights.dart';

/// Service to sync data with Flow-iQ professional app
/// Handles real-time synchronization, AI insights, and data sharing
class FlowIQSyncService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Sync state
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String? _sharedUserId;
  StreamSubscription? _dataStreamSubscription;
  
  // Data
  List<CycleData> _cycles = [];
  List<AIInsights> _insights = [];
  Map<String, dynamic>? _predictions;
  
  FlowIQSyncService() {
    _initializeService();
  }
  
  // Getters
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  List<CycleData> get cycles => _cycles;
  List<AIInsights> get insights => _insights;
  Map<String, dynamic>? get predictions => _predictions;
  User? get currentUser => _auth.currentUser;
  
  /// Initialize the sync service
  Future<void> _initializeService() async {
    await _loadSyncSettings();
    if (_sharedUserId != null) {
      await _setupRealtimeSync();
    }
  }
  
  /// Load sync settings from shared preferences or secure storage
  Future<void> _loadSyncSettings() async {
    // Load shared user ID and other settings
    // This would typically come from Flow-iQ integration setup
    _sharedUserId = currentUser?.uid;
  }
  
  /// Setup real-time synchronization with Flow-iQ
  Future<void> _setupRealtimeSync() async {
    if (_sharedUserId == null) return;
    
    try {
      // Listen to changes in the shared Firebase collection
      _dataStreamSubscription = _firestore
          .collection('users')
          .doc(_sharedUserId)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists) {
          await _processIncomingData(snapshot.data()!);
        }
      });
      
      debugPrint('Real-time sync with Flow-iQ established');
    } catch (e) {
      debugPrint('Error setting up real-time sync: $e');
    }
  }
  
  /// Process incoming data from Flow-iQ
  Future<void> _processIncomingData(Map<String, dynamic> data) async {
    _isSyncing = true;
    notifyListeners();
    
    try {
      // Process cycle data
      if (data.containsKey('cycles')) {
        // Note: This would need proper implementation based on Firestore structure
        // For now, keeping the local _cycles list
      }
      
      // Process AI insights
      if (data.containsKey('ai_insights')) {
        // Note: This would need proper implementation based on Firestore structure
        // For now, keeping the local _insights list
      }
      
      // Process predictions
      if (data.containsKey('predictions')) {
        _predictions = Map<String, dynamic>.from(data['predictions']);
      }
      
      _lastSyncTime = DateTime.now();
      debugPrint('Data synchronized from Flow-iQ');
    } catch (e) {
      debugPrint('Error processing incoming data: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
  
  /// Sync data to Flow-iQ
  Future<void> syncToFlowIQ(CycleData cycleData) async {
    if (_sharedUserId == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('consumer_updates')
          .add({
        'type': 'cycle_update',
        'data': cycleData.toFirestore(),
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'flow-ai',
      });
      
      debugPrint('Cycle data synced to Flow-iQ');
    } catch (e) {
      debugPrint('Error syncing to Flow-iQ: $e');
    }
  }
  
  /// Get current cycle information
  CycleData? get currentCycle {
    if (_cycles.isEmpty) return null;
    
    final now = DateTime.now();
    _cycles.sort((a, b) => b.startDate.compareTo(a.startDate));
    
    for (final cycle in _cycles) {
      if (cycle.startDate.isBefore(now) && 
          (cycle.endDate == null || cycle.endDate!.isAfter(now))) {
        return cycle;
      }
    }
    
    return _cycles.first; // Return most recent cycle
  }
  
  /// Get next predicted period date
  DateTime? get nextPeriodDate {
    final current = currentCycle;
    if (current == null) return null;
    
    if (_predictions != null && _predictions!.containsKey('next_period')) {
      final predictionData = _predictions!['next_period'];
      if (predictionData['date'] != null) {
        return DateTime.parse(predictionData['date']);
      }
    }
    
    // Fallback to simple calculation
    return current.startDate.add(Duration(days: current.cycleLength));
  }
  
  /// Get current cycle phase
  String get currentPhase {
    final current = currentCycle;
    if (current == null) return 'Unknown';
    
    final daysSinceStart = DateTime.now().difference(current.startDate).inDays + 1;
    
    if (daysSinceStart <= (current.periodLength ?? 5)) {
      return 'Menstrual';
    } else if (daysSinceStart <= 13) {
      return 'Follicular';
    } else if (daysSinceStart <= 16) {
      return 'Ovulatory';
    } else {
      return 'Luteal';
    }
  }
  
  /// Get fertile window
  Map<String, dynamic>? get fertileWindow {
    if (_predictions != null && _predictions!.containsKey('ovulation')) {
      final ovulationData = _predictions!['ovulation'];
      if (ovulationData['fertile_window'] != null) {
        return Map<String, dynamic>.from(ovulationData['fertile_window']);
      }
    }
    
    return null;
  }
  
  /// Get recent insights
  List<AIInsights> get recentInsights {
    final now = DateTime.now();
    return _insights
        .where((insight) => 
          now.difference(insight.createdAt).inDays <= 7)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
  
  /// Add symptom tracking
  Future<void> addSymptomTracking({
    required List<String> symptoms,
    required String mood,
    required int energyLevel,
    required int painLevel,
    String? notes,
  }) async {
    if (_sharedUserId == null) return;
    
    try {
      final trackingData = {
        'date': DateTime.now().toIso8601String(),
        'symptoms': symptoms,
        'mood': mood,
        'energy_level': energyLevel,
        'pain_level': painLevel,
        'notes': notes,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'flow-ai',
      };
      
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('daily_tracking')
          .add(trackingData);
      
      // Also add to consumer updates for Flow-iQ
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('consumer_updates')
          .add({
        'type': 'symptom_tracking',
        'data': trackingData,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'flow-ai',
      });
      
      debugPrint('Symptom tracking added');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding symptom tracking: $e');
    }
  }
  
  /// Add period tracking
  Future<void> addPeriodDay({
    required DateTime date,
    required String flowIntensity,
  }) async {
    if (_sharedUserId == null) return;
    
    try {
      final periodData = {
        'date': date.toIso8601String(),
        'flow_intensity': flowIntensity,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'flow-ai',
      };
      
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('period_days')
          .add(periodData);
      
      // Sync to Flow-iQ
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('consumer_updates')
          .add({
        'type': 'period_tracking',
        'data': periodData,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'flow-ai',
      });
      
      debugPrint('Period day added');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding period day: $e');
    }
  }
  
  /// Get AI prediction confidence
  double get predictionConfidence {
    if (_predictions != null && _predictions!.containsKey('confidence')) {
      return (_predictions!['confidence'] as num).toDouble();
    }
    return 0.0;
  }
  
  /// Get cycle regularity score
  double get cycleRegularityScore {
    if (_cycles.length < 3) return 0.0;
    
    final lengths = _cycles
        .take(6) // Last 6 cycles
        .map((cycle) => cycle.cycleLength)
        .toList();
    
    if (lengths.length < 3) return 0.0;
    
    final average = lengths.reduce((a, b) => a + b) / lengths.length;
    final variance = lengths
        .map((length) => (length - average) * (length - average))
        .reduce((a, b) => a + b) / lengths.length;
    
    // Convert variance to regularity score (lower variance = higher regularity)
    return (1.0 / (1.0 + variance)).clamp(0.0, 1.0);
  }
  
  /// Request manual sync
  Future<void> requestSync() async {
    if (_isSyncing || _sharedUserId == null) return;
    
    try {
      _isSyncing = true;
      notifyListeners();
      
      // Trigger sync by updating sync request
      await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('sync_requests')
          .add({
        'requested_by': 'flow-ai',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      debugPrint('Manual sync requested');
    } catch (e) {
      debugPrint('Error requesting sync: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
  
  /// Get integration status
  Map<String, dynamic> getIntegrationStatus() {
    return {
      'connected': _sharedUserId != null,
      'last_sync': _lastSyncTime?.toIso8601String(),
      'cycles_count': _cycles.length,
      'insights_count': _insights.length,
      'has_predictions': _predictions != null,
    };
  }
  
  /// Get current cycle (async method for HomeScreen)
  Future<CycleData?> getCurrentCycle() async {
    try {
      if (_sharedUserId == null) return null;
      
      // Try to get current cycle from Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('cycles')
          .orderBy('startDate', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return CycleData.fromFirestore(snapshot.docs.first);
      }
      
      return currentCycle; // Fallback to cached data
    } catch (e) {
      debugPrint('Error getting current cycle: $e');
      return currentCycle;
    }
  }
  
  /// Get recent insights (async method for HomeScreen)
  Future<List<AIInsights>> getRecentInsights({int limit = 10}) async {
    try {
      if (_sharedUserId == null) return [];
      
      final snapshot = await _firestore
          .collection('users')
          .doc(_sharedUserId)
          .collection('ai_insights')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs
          .map((doc) => AIInsights.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error getting recent insights: $e');
      return recentInsights.take(limit).toList();
    }
  }
  
  /// Check if connected to Flow-iQ
  Future<bool> isConnectedToFlowIQ() async {
    try {
      if (_sharedUserId == null) return false;
      
      // Check if Flow-iQ integration document exists
      final doc = await _firestore
          .collection('integrations')
          .doc(_sharedUserId)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return data['flow_iq_connected'] == true && 
               data['consumer_app_connected'] == true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error checking Flow-iQ connection: $e');
      return _sharedUserId != null;
    }
  }

  @override
  void dispose() {
    _dataStreamSubscription?.cancel();
    super.dispose();
  }
}
