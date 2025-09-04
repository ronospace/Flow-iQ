import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthStateNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _testUser;
  bool _initialized = false;

  AuthStateNotifier() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Listen to Firebase auth changes
      _auth.authStateChanges().listen((user) {
        _user = user;
        notifyListeners();
      });

      // Check for existing test account
      await _loadTestAccount();
      
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ AuthStateNotifier initialization error: $e');
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> _loadTestAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('test_account_'));
      
      if (keys.isNotEmpty) {
        final testAccountData = prefs.getString(keys.first);
        if (testAccountData != null) {
          _testUser = jsonDecode(testAccountData);
          debugPrint('✅ Test account loaded: ${_testUser?['displayName']}');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error loading test account: $e');
    }
  }

  /// Set test account (called when test account is created)
  Future<void> setTestAccount(Map<String, dynamic> testUserData) async {
    try {
      _testUser = testUserData;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'test_account_${testUserData['email']}', 
        jsonEncode(testUserData),
      );
      debugPrint('✅ Test account set: ${testUserData['displayName']}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error setting test account: $e');
    }
  }

  /// Clear test account (for sign out)
  Future<void> clearTestAccount() async {
    try {
      _testUser = null;
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('test_account_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
      debugPrint('✅ Test account cleared');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error clearing test account: $e');
    }
  }

  /// Check if user is logged in (either Firebase or test account)
  bool get isLoggedIn => _user != null || _testUser != null;

  /// Get current user (Firebase or test)
  User? get user => _user;

  /// Get test user data
  Map<String, dynamic>? get testUser => _testUser;

  /// Check if current session is a test account
  bool get isTestAccount => _testUser != null && _user == null;

  /// Get display name from current user (Firebase or test)
  String? get displayName {
    if (_user != null) return _user!.displayName;
    if (_testUser != null) return _testUser!['displayName'];
    return null;
  }

  /// Get email from current user (Firebase or test)
  String? get email {
    if (_user != null) return _user!.email;
    if (_testUser != null) return _testUser!['email'];
    return null;
  }

  /// Get user ID (Firebase or test)
  String? get uid {
    if (_user != null) return _user!.uid;
    if (_testUser != null) return _testUser!['uid'];
    return null;
  }

  /// Sign out from current session (Firebase or test)
  Future<void> signOut() async {
    try {
      if (_user != null) {
        await _auth.signOut();
      }
      if (_testUser != null) {
        await clearTestAccount();
      }
      debugPrint('✅ Signed out successfully');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
    }
  }

  bool get initialized => _initialized;
}
