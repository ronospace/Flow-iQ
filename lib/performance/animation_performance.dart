import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/rendering.dart';

/// Performance optimization utilities for Flow AI animations
class AnimationPerformance {
  static const Duration _optimizedDuration = Duration(milliseconds: 300);
  static const Duration _complexAnimationDuration = Duration(milliseconds: 800);
  
  /// Optimized curves for smooth hardware acceleration
  static const Curve primaryCurve = Curves.easeOutCubic;
  static const Curve morphingCurve = Curves.elasticOut;
  static const Curve particleCurve = Curves.linear;
  
  /// Hardware-accelerated animation controller factory
  static AnimationController createOptimizedController({
    required TickerProvider vsync,
    Duration? duration,
    bool isComplex = false,
  }) {
    return AnimationController(
      duration: duration ?? (isComplex ? _complexAnimationDuration : _optimizedDuration),
      vsync: vsync,
    );
  }
  
  /// Performance-aware tween factory
  static Animation<T> createOptimizedTween<T>({
    required T begin,
    required T end,
    required AnimationController controller,
    Curve curve = primaryCurve,
  }) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
  
  /// Staggered animation builder for complex sequences
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int count,
    double staggerOffset = 0.1,
    Curve curve = primaryCurve,
  }) {
    return List.generate(count, (index) {
      final start = (index * staggerOffset).clamp(0.0, 1.0);
      final end = ((index * staggerOffset) + (1.0 - staggerOffset)).clamp(0.0, 1.0);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: curve),
        ),
      );
    });
  }
  
  /// Performance monitoring for animation frames
  static void enablePerformanceMonitoring() {
    if (SchedulerBinding.instance.hasScheduledFrame) {
      SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
        // Monitor frame timing for optimization
        final frameDuration = timeStamp - (SchedulerBinding.instance.currentFrameTimeStamp ?? timeStamp);
        if (frameDuration > const Duration(milliseconds: 16)) {
          debugPrint('Frame drop detected: ${frameDuration.inMilliseconds}ms');
        }
      });
    }
  }
  
  /// Optimized repaint boundaries for custom painters
  static Widget withRepaintBoundary(Widget child, {String? debugLabel}) {
    return RepaintBoundary(
      child: child,
    );
  }
  
  /// GPU-optimized shader compilation hints
  static void warmUpShaders(BuildContext context) {
    // Pre-compile shaders for better performance
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Trigger shader compilation
        renderObject.markNeedsPaint();
      });
    }
  }
  
  /// Memory-efficient color interpolation
  static Color lerpColorOptimized(Color a, Color b, double t) {
    // Use hardware-accelerated color interpolation
    return Color.lerp(a, b, t) ?? a;
  }
  
  /// Performance-aware animation disposal
  static void disposeAnimations(List<AnimationController> controllers) {
    for (final controller in controllers) {
      if (controller.isAnimating) {
        controller.stop();
      }
      controller.dispose();
    }
  }
}

/// Mixin for performance-optimized animations
mixin PerformanceOptimizedAnimations on TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  
  AnimationController createController({
    Duration? duration,
    bool isComplex = false,
  }) {
    final controller = AnimationPerformance.createOptimizedController(
      vsync: this,
      duration: duration,
      isComplex: isComplex,
    );
    _controllers.add(controller);
    return controller;
  }
  
  @override
  void dispose() {
    AnimationPerformance.disposeAnimations(_controllers);
    super.dispose();
  }
}

/// Performance-optimized custom painter base class
abstract class OptimizedCustomPainter extends CustomPainter {
  final Animation<double>? animation;
  
  OptimizedCustomPainter({this.animation}) : super(repaint: animation);
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Only repaint when animation values change
    return animation?.value != (oldDelegate as OptimizedCustomPainter?)?.animation?.value;
  }
  
  /// Hardware-accelerated paint setup
  Paint createOptimizedPaint({
    Color? color,
    double? strokeWidth,
    PaintingStyle style = PaintingStyle.fill,
    BlendMode blendMode = BlendMode.srcOver,
  }) {
    return Paint()
      ..color = color ?? Colors.white
      ..strokeWidth = strokeWidth ?? 1.0
      ..style = style
      ..blendMode = blendMode
      ..isAntiAlias = true;
  }
  
  /// Efficient gradient creation
  LinearGradient createOptimizedGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: colors,
      stops: stops,
      begin: begin,
      end: end,
    );
  }
}

/// Performance configuration constants
class PerformanceConfig {
  static const int maxParticles = 50;
  static const double particleUpdateThreshold = 0.016; // 60 FPS
  static const Duration debounceDelay = Duration(milliseconds: 100);
  static const int maxConcurrentAnimations = 10;
  
  /// Adaptive quality based on device performance
  static double getAdaptiveQuality() {
    // Simple device capability detection
    return 1.0; // Default to high quality, can be adjusted based on performance
  }
  
  /// Animation complexity reducer for low-end devices
  static bool shouldReduceComplexity() {
    return false; // Can be implemented with device performance detection
  }
}
