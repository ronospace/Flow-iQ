import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Futuristic Flow AI Theme System
/// 
/// Advanced theme system inspired by cutting-edge AI interfaces with:
/// - Holographic gradients and neural network patterns
/// - Dynamic color transitions based on time and context
/// - Advanced glassmorphism effects
/// - Quantum-inspired color harmonics
class FlowAIFuturisticTheme {
  // === CORE NEURAL COLORS ===
  
  // Primary Neural Network Palette
  static const Color neuralBlue = Color(0xFF0A84FF);
  static const Color synapsePurple = Color(0xFF5E72E4);
  static const Color quantumCyan = Color(0xFF00D9FF);
  static const Color matrixGreen = Color(0xFF00FF88);
  static const Color plasmaPink = Color(0xFFFF0080);
  
  // Deep Space Background Palette
  static const Color voidBlack = Color(0xFF0A0A0F);
  static const Color cosmicBlue = Color(0xFF0F1419);
  static const Color nebulaPurple = Color(0xFF1A0D2E);
  static const Color stellarGray = Color(0xFF1C1C1E);
  
  // Holographic Accents
  static const Color holoBlue = Color(0xFF4DD0E1);
  static const Color holoGreen = Color(0xFF4CAF50);
  static const Color holoPink = Color(0xFFE91E63);
  static const Color holoGold = Color(0xFFFFD700);
  static const Color holoSilver = Color(0xFFC0C0C0);
  
  // === GRADIENT COLLECTIONS ===
  
  // Neural Network Gradients
  static const List<Color> neuralFlow = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF89CFF0),
  ];
  
  static const List<Color> synapseGlow = [
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
    Color(0xFF43e97b),
  ];
  
  static const List<Color> quantumField = [
    Color(0xFFfa709a),
    Color(0xFFfee140),
    Color(0xFF667eea),
  ];
  
  static const List<Color> matrixCode = [
    Color(0xFF00c851),
    Color(0xFF007E33),
    Color(0xFF00ff00),
  ];
  
  static const List<Color> cosmicDust = [
    Color(0xFF2E3192),
    Color(0xFF1BFFFF),
    Color(0xFF667eea),
  ];
  
  static const List<Color> plasmaBurst = [
    Color(0xFFff0080),
    Color(0xFFff8a00),
    Color(0xFFe91e63),
  ];
  
  // Context-Aware Gradients
  static const List<Color> periodFlow = [
    Color(0xFFff6b95),
    Color(0xFFc44569),
    Color(0xFF8e44ad),
  ];
  
  static const List<Color> ovulationGlow = [
    Color(0xFF00b894),
    Color(0xFF00cec9),
    Color(0xFF74b9ff),
  ];
  
  static const List<Color> menstrualPhase = [
    Color(0xFFd63031),
    Color(0xFFfd79a8),
    Color(0xFFe84393),
  ];
  
  static const List<Color> follicularPhase = [
    Color(0xFF00b894),
    Color(0xFF55a3ff),
    Color(0xFF74b9ff),
  ];
  
  // === ANIMATED COLOR SYSTEMS ===
  
  /// Get time-based gradient that changes throughout the day
  static List<Color> getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      // Morning - Sunrise palette
      return [
        const Color(0xFFffeaa7),
        const Color(0xFFfab1a0),
        const Color(0xFFfd79a8),
      ];
    } else if (hour >= 12 && hour < 17) {
      // Afternoon - Vibrant palette
      return [
        const Color(0xFF74b9ff),
        const Color(0xFF0984e3),
        const Color(0xFF6c5ce7),
      ];
    } else if (hour >= 17 && hour < 21) {
      // Evening - Sunset palette
      return [
        const Color(0xFFfd79a8),
        const Color(0xFFe84393),
        const Color(0xFF6c5ce7),
      ];
    } else {
      // Night - Deep space palette
      return [
        const Color(0xFF2d3436),
        const Color(0xFF636e72),
        const Color(0xFF74b9ff),
      ];
    }
  }
  
  /// Get cycle phase specific gradient
  static List<Color> getCyclePhaseGradient(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return menstrualPhase;
      case 'follicular':
        return follicularPhase;
      case 'ovulation':
        return ovulationGlow;
      case 'luteal':
        return plasmaBurst;
      default:
        return neuralFlow;
    }
  }
  
  /// Get health status gradient
  static List<Color> getHealthStatusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return matrixCode;
      case 'good':
        return synapseGlow;
      case 'moderate':
        return quantumField;
      case 'attention':
        return [const Color(0xFFffb142), const Color(0xFFff793f)];
      case 'critical':
        return plasmaBurst;
      default:
        return neuralFlow;
    }
  }
  
  // === GLASSMORPHISM EFFECTS ===
  
  /// Create glassmorphism container decoration
  static BoxDecoration createGlassmorphism({
    double opacity = 0.1,
    double blur = 10,
    List<Color>? gradientColors,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors?.map((c) => c.withValues(alpha: opacity)).toList() ??
            [
              Colors.white.withValues(alpha: opacity),
              Colors.white.withValues(alpha: opacity * 0.5),
            ],
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1,
      ),
    );
  }
  
  /// Create neural glow effect
  static BoxDecoration createNeuralGlow({
    required List<Color> colors,
    double glowRadius = 20,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: colors.first.withValues(alpha: 0.3),
          blurRadius: glowRadius,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: colors.last.withValues(alpha: 0.2),
          blurRadius: glowRadius * 1.5,
          spreadRadius: 4,
        ),
      ],
    );
  }
  
  // === THEME DATA GENERATION ===
  
  /// Generate light theme with futuristic design
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: neuralBlue,
        primaryContainer: neuralBlue.withValues(alpha: 0.1),
        secondary: synapsePurple,
        secondaryContainer: synapsePurple.withValues(alpha: 0.1),
        tertiary: quantumCyan,
        surface: Colors.white,
        surfaceContainer: const Color(0xFFF8F9FA),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A1A),
        error: plasmaPink,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white.withValues(alpha: 0.8),
      ),
      
      // Text Theme
      textTheme: _buildFuturisticTextTheme(Brightness.light),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.black87,
        size: 24,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: neuralBlue, width: 2),
        ),
      ),
    );
  }
  
  /// Generate dark theme with futuristic design
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: quantumCyan,
        primaryContainer: quantumCyan.withValues(alpha: 0.2),
        secondary: synapsePurple,
        secondaryContainer: synapsePurple.withValues(alpha: 0.2),
        tertiary: matrixGreen,
        surface: voidBlack,
        surfaceContainer: stellarGray,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        error: plasmaPink,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: stellarGray.withValues(alpha: 0.8),
      ),
      
      // Text Theme
      textTheme: _buildFuturisticTextTheme(Brightness.dark),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: stellarGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: quantumCyan, width: 2),
        ),
      ),
    );
  }
  
  /// Build futuristic text theme
  static TextTheme _buildFuturisticTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light 
        ? Colors.black87 
        : Colors.white;
    
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor.withValues(alpha: 0.8),
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor.withValues(alpha: 0.6),
        height: 1.4,
      ),
    );
  }
  
  // === UTILITY FUNCTIONS ===
  
  /// Generate color palette from base color
  static Map<String, Color> generatePaletteFromColor(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    
    return {
      'primary': baseColor,
      'light': hsl.withLightness(math.min(hsl.lightness + 0.2, 1.0)).toColor(),
      'dark': hsl.withLightness(math.max(hsl.lightness - 0.2, 0.0)).toColor(),
      'accent': hsl.withHue((hsl.hue + 30) % 360).toColor(),
      'complement': hsl.withHue((hsl.hue + 180) % 360).toColor(),
    };
  }
  
  /// Get contrasting text color
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
  
  /// Create animated gradient shader
  static Shader createAnimatedGradient(
    Rect bounds,
    List<Color> colors,
    double animationValue,
  ) {
    final adjustedColors = colors.map((color) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withHue((hsl.hue + animationValue * 360) % 360).toColor();
    }).toList();
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: adjustedColors,
    ).createShader(bounds);
  }
  
  /// Get cycle-aware color
  static Color getCycleAwareColor({
    required String phase,
    required double intensity, // 0.0 to 1.0
    Brightness brightness = Brightness.light,
  }) {
    final baseColors = getCyclePhaseGradient(phase);
    final color = Color.lerp(baseColors.first, baseColors.last, intensity) ?? baseColors.first;
    
    if (brightness == Brightness.dark) {
      return color.withValues(alpha: 0.8);
    }
    
    return color;
  }
}

/// Extension methods for enhanced color manipulation
extension ColorExtensions on Color {
  /// Create a holographic effect variant of the color
  Color get holographic {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(1.0).withLightness(0.7).toColor();
  }
  
  /// Create a neural glow variant
  Color get neuralGlow {
    return Color.lerp(this, Colors.cyan, 0.3) ?? this;
  }
  
  /// Create quantum interference pattern
  Color quantumShift(double phase) {
    final hsl = HSLColor.fromColor(this);
    final newHue = (hsl.hue + phase * 60) % 360;
    return hsl.withHue(newHue).toColor();
  }
}

/// Neural animation curves for smooth transitions
class NeuralCurves {
  static const Curve synapticFire = Curves.easeOutExpo;
  static const Curve quantumTunnel = Curves.elasticOut;
  static const Curve plasmaFlow = Curves.easeInOutCubic;
  static const Curve neuralPulse = Curves.bounceOut;
  static const Curve matrixGlitch = Curves.fastOutSlowIn;
}
