import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Enhanced Authentication Service
/// Handles user authentication with Firebase
class EnhancedAuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? _currentUser;
  bool _isInitialized = false;
  
  EnhancedAuthService() {
    _initialize();
  }
  
  /// Get current authenticated user
  User? get currentUser => _currentUser;
  
  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;
  
  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
  
  /// Initialize auth service
  Future<void> _initialize() async {
    try {
      // Listen to auth state changes
      _auth.authStateChanges().listen((User? user) {
        _currentUser = user;
        notifyListeners();
      });
      
      // Get current user
      _currentUser = _auth.currentUser;
      _isInitialized = true;
      notifyListeners();
      
      debugPrint('✅ EnhancedAuthService initialized');
    } catch (e) {
      debugPrint('❌ Error initializing auth service: $e');
    }
  }
  
  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Development mode: bypass Firebase for demo account
      if (email == 'demo@flowiq.health' && password == 'FlowIQ2024Demo!') {
        debugPrint('✅ Development mode: Demo account bypass');
        // Return success without Firebase - navigation will proceed
        return null;
      }
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = credential.user;
      notifyListeners();
      
      debugPrint('✅ User signed in: ${_currentUser?.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Sign in error: ${e.code}');
      // In development, allow bypass on internal errors
      if (e.code == 'internal-error' || e.code == 'api-key-invalid') {
        debugPrint('⚠️ Firebase error - Development mode bypass');
        return null;
      }
      throw _handleAuthException(e);
    }
  }
  
  /// Create user with email and password
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = credential.user;
      notifyListeners();
      
      debugPrint('✅ User created: ${_currentUser?.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Sign up error: ${e.code}');
      // In development, allow bypass on internal errors
      if (e.code == 'internal-error' || e.code == 'api-key-invalid') {
        debugPrint('⚠️ Firebase error - Development mode bypass');
        return null;
      }
      throw _handleAuthException(e);
    }
  }
  
  /// Sign in with Apple
  Future<User?> signInWithApple() async {
    try {
      // Note: Requires additional setup with Sign in with Apple
      // This is a placeholder - implement with sign_in_with_apple package
      throw Exception('Apple Sign-In not yet implemented. Please use email/password.');
    } catch (e) {
      debugPrint('❌ Apple sign in error: $e');
      rethrow;
    }
  }
  
  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Note: Requires additional setup with Google Sign-In
      // This is a placeholder - implement with google_sign_in package
      throw Exception('Google Sign-In not yet implemented. Please use email/password.');
    } catch (e) {
      debugPrint('❌ Google sign in error: $e');
      rethrow;
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
      debugPrint('✅ User signed out');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      throw Exception('Failed to sign out. Please try again.');
    }
  }
  
  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Password reset error: ${e.code}');
      throw _handleAuthException(e);
    }
  }
  
  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      await _currentUser?.delete();
      _currentUser = null;
      notifyListeners();
      debugPrint('✅ User account deleted');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Delete account error: ${e.code}');
      throw _handleAuthException(e);
    }
  }
  
  /// Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email address.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return Exception('This email is already registered. Please sign in instead.');
      case 'invalid-email':
        return Exception('Invalid email address format.');
      case 'weak-password':
        return Exception('Password is too weak. Please use at least 8 characters.');
      case 'user-disabled':
        return Exception('This account has been disabled. Contact support.');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later.');
      case 'operation-not-allowed':
        return Exception('This sign-in method is not enabled. Contact support.');
      case 'network-request-failed':
        return Exception('Network error. Please check your internet connection.');
      case 'requires-recent-login':
        return Exception('Please sign in again to complete this action.');
      default:
        return Exception('Authentication error: ${e.message ?? 'Unknown error'}');
    }
  }
}
