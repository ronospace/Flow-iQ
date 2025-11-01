import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Service for managing app theme state
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeService() {
    _loadTheme();
  }
  
  /// Load saved theme preference
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeName = prefs.getString(_themeKey) ?? 'system';
      
      switch (themeName) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      
      notifyListeners();
      debugPrint('✅ Theme loaded: $themeName');
    } catch (e) {
      debugPrint('⚠️ Error loading theme: $e');
    }
  }
  
  /// Set theme mode and save preference
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeName;
      
      switch (mode) {
        case ThemeMode.light:
          themeName = 'light';
          break;
        case ThemeMode.dark:
          themeName = 'dark';
          break;
        case ThemeMode.system:
          themeName = 'system';
          break;
      }
      
      await prefs.setString(_themeKey, themeName);
      debugPrint('✅ Theme saved: $themeName');
    } catch (e) {
      debugPrint('⚠️ Error saving theme: $e');
    }
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
}
