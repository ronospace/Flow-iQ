import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FlowIQ Visual System
/// Revolutionary clinical design system for Flow iQ
class FlowIQVisualSystem {
  // Primary Clinical Colors
  static const Color primaryClinical = Color(0xFF2C5282); // Deep clinical blue
  static const Color primaryAccent = Color(0xFF4299E1); // Bright accent blue
  static const Color secondaryAccent = Color(0xFF9F7AEA); // Medical purple
  static const Color tertiaryAccent = Color(0xFF38B2AC); // Healthcare teal
  
  // Complementary Colors
  static const Color warmAccent = Color(0xFFED8936); // Professional orange
  static const Color successGreen = Color(0xFF38A169); // Health green
  static const Color cautionYellow = Color(0xFFF6E05E); // Warning yellow
  static const Color errorRed = Color(0xFFE53E3E); // Alert red
  
  // Neutral Palette
  static const Color neutralDark = Color(0xFF1A202C);
  static const Color neutralMedium = Color(0xFF4A5568);
  static const Color neutralLight = Color(0xFFA0AEC0);
  static const Color neutralExtraLight = Color(0xFFF7FAFC);
  
  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8FAFF);
  static const Color surfaceTertiary = Color(0xFFEDF2F7);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F36);
  static const Color darkSurfaceElevated = Color(0xFF252A42);
  static const Color darkAccent = Color(0xFF6B73FF);

  /// Light Theme Configuration
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: primaryClinical,
      onPrimary: Colors.white,
      secondary: secondaryAccent,
      onSecondary: Colors.white,
      tertiary: tertiaryAccent,
      onTertiary: Colors.white,
      surface: surfacePrimary,
      onSurface: neutralDark,
      surfaceVariant: surfaceSecondary,
      onSurfaceVariant: neutralMedium,
      error: errorRed,
      onError: Colors.white,
      outline: neutralLight,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.transparent,
      foregroundColor: primaryClinical,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        color: primaryClinical,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: primaryClinical.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryClinical,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryClinical.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfacePrimary,
      elevation: 3,
      shadowColor: primaryClinical.withValues(alpha: 0.1),
      surfaceTintColor: Colors.transparent,
      indicatorColor: primaryClinical.withValues(alpha: 0.1),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: primaryClinical,
            size: 24,
          );
        }
        return const IconThemeData(
          color: neutralLight,
          size: 24,
        );
      }),
    ),
  );

  /// Dark Theme Configuration
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: darkAccent,
      onPrimary: Colors.white,
      secondary: secondaryAccent,
      onSecondary: Colors.white,
      tertiary: tertiaryAccent,
      onTertiary: Colors.white,
      surface: darkSurface,
      onSurface: Colors.white,
      surfaceVariant: darkSurfaceElevated,
      onSurfaceVariant: neutralLight,
      error: errorRed,
      onError: Colors.white,
      outline: neutralMedium,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}
