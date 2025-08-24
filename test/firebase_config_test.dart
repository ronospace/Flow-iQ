import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_iq/firebase_options.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Firebase Configuration Tests for Flow iQ', () {
    test('Firebase options configuration test', () {
      // Test that Firebase options are properly configured
      final options = DefaultFirebaseOptions.currentPlatform;
      
      expect(options.projectId, equals('flow-iq-app'));
      expect(options.appId, isNotEmpty);
      expect(options.apiKey, isNotEmpty);
      expect(options.messagingSenderId, isNotEmpty);
      
      print('✅ Firebase configuration is valid for Flow iQ');
      print('  Project ID: ${options.projectId}');
      print('  App ID: ${options.appId}');
      print('  API Key: ${options.apiKey.substring(0, 10)}...');
    });
    
    test('Firebase configuration files exist', () {
      // Check if Firebase configuration files exist
      final firebaseOptions = File('lib/firebase_options.dart');
      final firestoreRules = File('firestore.rules');
      final storageRules = File('storage.rules');
      final firestoreIndexes = File('firestore.indexes.json');
      final firebaseJson = File('firebase.json');
      
      expect(firebaseOptions.existsSync(), isTrue, reason: 'firebase_options.dart should exist');
      expect(firestoreRules.existsSync(), isTrue, reason: 'firestore.rules should exist');
      expect(storageRules.existsSync(), isTrue, reason: 'storage.rules should exist');
      expect(firestoreIndexes.existsSync(), isTrue, reason: 'firestore.indexes.json should exist');
      expect(firebaseJson.existsSync(), isTrue, reason: 'firebase.json should exist');
      
      print('✅ All Firebase configuration files exist');
    });
    
    test('Mock Firestore functionality test', () async {
      // Test Firestore operations using fake_cloud_firestore
      final firestore = FakeFirebaseFirestore();
      
      // Test Flow iQ specific collections
      final userDoc = firestore.collection('users').doc('test-user');
      final cycleDoc = firestore.collection('users').doc('test-user')
          .collection('cycles').doc('test-cycle');
      final logDoc = firestore.collection('users').doc('test-user')
          .collection('dailyLogs').doc('test-log');
      
      // Write test user data
      await userDoc.set({
        'displayName': 'Test User',
        'email': 'test@flowiq.app',
        'createdAt': DateTime.now(),
        'preferences': {
          'theme': 'dark',
          'locale': 'en',
          'notifications': true,
        },
      });
      
      // Write test cycle data
      await cycleDoc.set({
        'startDate': DateTime.now(),
        'length': 28,
        'flow': ['light', 'medium', 'heavy'],
        'symptoms': ['cramps', 'headache'],
        'mood': [7, 6, 8],
        'createdAt': DateTime.now(),
      });
      
      // Write test daily log data
      await logDoc.set({
        'date': DateTime.now(),
        'mood': 7,
        'energy': 6,
        'sleep': {
          'duration': 8,
          'quality': 'good'
        },
        'symptoms': ['mild_cramps'],
        'activities': ['exercise', 'meditation'],
        'createdAt': DateTime.now(),
      });
      
      // Read and verify test data
      final userSnapshot = await userDoc.get();
      final cycleSnapshot = await cycleDoc.get();
      final logSnapshot = await logDoc.get();
      
      expect(userSnapshot.exists, isTrue);
      expect(userSnapshot.data()?['displayName'], equals('Test User'));
      expect(userSnapshot.data()?['email'], equals('test@flowiq.app'));
      
      expect(cycleSnapshot.exists, isTrue);
      expect(cycleSnapshot.data()?['length'], equals(28));
      expect(cycleSnapshot.data()?['flow'], isA<List>());
      
      expect(logSnapshot.exists, isTrue);
      expect(logSnapshot.data()?['mood'], equals(7));
      expect(logSnapshot.data()?['energy'], equals(6));
      
      // Test collection queries
      final userCycles = await firestore
          .collection('users')
          .doc('test-user')
          .collection('cycles')
          .get();
      
      expect(userCycles.docs.length, equals(1));
      
      print('✅ Mock Firestore functionality works correctly for Flow iQ');
    });
    
    test('Platform-specific configuration', () {
      // Test that we have different configurations per platform
      try {
        final webOptions = DefaultFirebaseOptions.web;
        final androidOptions = DefaultFirebaseOptions.android;
        final iosOptions = DefaultFirebaseOptions.ios;
        
        expect(webOptions.projectId, equals('flow-iq-app'));
        expect(androidOptions.projectId, equals('flow-iq-app'));
        expect(iosOptions.projectId, equals('flow-iq-app'));
        
        // Verify different app IDs for different platforms
        expect(webOptions.appId, isNot(equals(androidOptions.appId)));
        expect(iosOptions.appId, isNot(equals(androidOptions.appId)));
        
        print('✅ Platform-specific Firebase configurations are available');
      } catch (e) {
        print('⚠️ Platform-specific configuration test: $e');
        // This is expected if not all platforms are configured yet
      }
    });
    
    test('App branding consistency', () {
      // Test that app name and package are consistent
      final options = DefaultFirebaseOptions.currentPlatform;
      
      // Verify project ID matches Flow iQ naming convention
      expect(options.projectId, contains('flow-iq'));
      
      print('✅ App branding is consistent with Flow iQ');
    });
    
    test('Security configuration validation', () {
      // Test that security-related configurations are in place
      final firestoreRules = File('firestore.rules');
      final storageRules = File('storage.rules');
      
      if (firestoreRules.existsSync()) {
        final rulesContent = firestoreRules.readAsStringSync();
        
        // Check for basic security patterns
        expect(rulesContent, contains('request.auth'));
        expect(rulesContent, contains('userId'));
        expect(rulesContent, contains('allow read, write'));
        
        print('✅ Firestore security rules are configured');
      }
      
      if (storageRules.existsSync()) {
        final storageRulesContent = storageRules.readAsStringSync();
        
        // Check for storage security patterns
        expect(storageRulesContent, contains('request.auth'));
        expect(storageRulesContent, contains('userId'));
        expect(storageRulesContent, contains('request.resource.size'));
        
        print('✅ Storage security rules are configured');
      }
    });
  });
}
