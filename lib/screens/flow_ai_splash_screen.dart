import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../themes/flow_ai_visual_system.dart';
import '../widgets/flow_ai_components.dart';

class FlowAISplashScreen extends StatefulWidget {
  const FlowAISplashScreen({super.key});

  @override
  State<FlowAISplashScreen> createState() => _FlowAISplashScreenState();
}

class _FlowAISplashScreenState extends State<FlowAISplashScreen>
    with TickerProviderStateMixin {
  
  // === ANIMATION CONTROLLERS FOR ALL 10 TECHNIQUES ===
  late AnimationController _mainController;           // Main sequence
  late AnimationController _flowLinesController;      // Gradient Flow Lines
  late AnimationController _petalScatterController;   // Petal Scatter Patterns
  late AnimationController _breathingController;      // Pulse/Breathing Animations
  late AnimationController _colorMorphController;     // Color Morphing
  late AnimationController _depthLayersController;    // Depth Layers
  late AnimationController _particleController;       // Floating Particle System
  late AnimationController _radialController;         // Radial Gradient Depth
  
  // === ANIMATIONS FOR ALL SIGNATURE ELEMENTS ===
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _flowLinesAnimation;
  late Animation<double> _petalScatterAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _colorMorphAnimation;
  late Animation<double> _depthLayersAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _radialAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAllAnimations();
    _startFlowAISplashSequence();
  }
  
  void _setupAllAnimations() {
    // === MAIN SEQUENCE CONTROLLER ===
    _mainController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    // === SIGNATURE ELEMENT CONTROLLERS ===
    _flowLinesController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    
    _petalScatterController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    
    _breathingController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _colorMorphController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    
    _depthLayersController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    _particleController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );
    
    _radialController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    );
    
    // === MAIN SEQUENCE ANIMATIONS ===
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: FlowAICurves.petalFloat),
      ),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: FlowAICurves.flowEase),
      ),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.9, curve: FlowAICurves.colorMorph),
      ),
    );
    
    // === SIGNATURE ELEMENT ANIMATIONS ===
    _flowLinesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flowLinesController, curve: Curves.linear),
    );
    
    _petalScatterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _petalScatterController, curve: FlowAICurves.petalFloat),\n    );\n    \n    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(\n      CurvedAnimation(parent: _breathingController, curve: FlowAICurves.breathingPulse),\n    );\n    \n    _colorMorphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(\n      CurvedAnimation(parent: _colorMorphController, curve: FlowAICurves.colorMorph),\n    );\n    \n    _depthLayersAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(\n      CurvedAnimation(parent: _depthLayersController, curve: FlowAICurves.depthTransition),\n    );\n    \n    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(\n      CurvedAnimation(parent: _particleController, curve: Curves.linear),\n    );\n    \n    _radialAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(\n      CurvedAnimation(parent: _radialController, curve: Curves.linear),\n    );\n  }\n  \n  void _startFlowAISplashSequence() async {\n    // Start all continuous animations\n    _flowLinesController.repeat();\n    _petalScatterController.repeat();\n    _breathingController.repeat(reverse: true);\n    _colorMorphController.repeat();\n    _particleController.repeat();\n    _radialController.repeat();\n    \n    // Start depth layers with delay\n    await Future.delayed(const Duration(milliseconds: 300));\n    _depthLayersController.forward();\n    \n    // Start main sequence\n    await Future.delayed(const Duration(milliseconds: 500));\n    _mainController.forward();\n    \n    // Wait for splash completion\n    await Future.delayed(const Duration(milliseconds: 4000));\n    \n    // Navigate to main app\n    if (mounted) {\n      Navigator.of(context).pushReplacementNamed('/main');\n    }\n  }\n  \n  @override\n  void dispose() {\n    _mainController.dispose();\n    _flowLinesController.dispose();\n    _petalScatterController.dispose();\n    _breathingController.dispose();\n    _colorMorphController.dispose();\n    _depthLayersController.dispose();\n    _particleController.dispose();\n    _radialController.dispose();\n    super.dispose();\n  }\n  \n  @override\n  Widget build(BuildContext context) {\n    final isDark = Theme.of(context).brightness == Brightness.dark;\n    \n    return Scaffold(\n      body: AnimatedBuilder(\n        animation: Listenable.merge([\n          _mainController,\n          _flowLinesController,\n          _petalScatterController,\n          _breathingController,\n          _colorMorphController,\n          _depthLayersController,\n          _particleController,\n          _radialController,\n        ]),\n        builder: (context, child) {\n          return Container(\n            decoration: BoxDecoration(\n              gradient: _buildFlowAIBackground(isDark),\n            ),\n            child: Stack(\n              children: [\n                // === TECHNIQUE 1: MATHEMATICAL GRADIENT ANIMATIONS ===\n                Positioned.fill(\n                  child: Container(\n                    decoration: BoxDecoration(\n                      gradient: FlowAIVisualSystem.createFlowGradient(\n                        _flowLinesAnimation.value,\n                        colors: FlowAIVisualSystem.flowLineGradient,\n                      ),\n                    ),\n                  ),\n                ),\n                \n                // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===\n                Positioned.fill(\n                  child: CustomPaint(\n                    painter: DepthLayersPainter(\n                      animationValue: _depthLayersAnimation.value,\n                      isDark: isDark,\n                    ),\n                  ),\n                ),\n                \n                // === TECHNIQUE 3: FLOATING PARTICLE SYSTEM ===\n                Positioned.fill(\n                  child: CustomPaint(\n                    painter: FloatingParticlesPainter(\n                      animationValue: _particleAnimation.value,\n                      particles: FlowAIVisualSystem.generateOrbitalParticles(20),\n                    ),\n                  ),\n                ),\n                \n                // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===\n                Positioned.fill(\n                  child: Container(\n                    decoration: BoxDecoration(\n                      gradient: FlowAIVisualSystem.createDepthRadial(\n                        colors: FlowAIVisualSystem.petalGradient.map((c) => \n                          c.withValues(alpha: 0.3 * math.sin(_radialAnimation.value * math.pi))\n                        ).toList(),\n                      ),\n                    ),\n                  ),\n                ),\n                \n                // === SIGNATURE ELEMENT 1: GRADIENT FLOW LINES ===\n                Positioned.fill(\n                  child: CustomPaint(\n                    painter: FlowLinesPainter(\n                      animationValue: _flowLinesAnimation.value,\n                      colors: FlowAIVisualSystem.flowLineGradient,\n                      opacity: 0.4,\n                    ),\n                  ),\n                ),\n                \n                // === SIGNATURE ELEMENT 2: PETAL SCATTER PATTERNS ===\n                Positioned.fill(\n                  child: CustomPaint(\n                    painter: PetalScatterPainter(\n                      animationValue: _petalScatterAnimation.value,\n                      size: MediaQuery.of(context).size.width * 0.8,\n                    ),\n                  ),\n                ),\n                \n                // === MAIN CONTENT WITH ALL TECHNIQUES ===\n                Center(\n                  child: Column(\n                    mainAxisAlignment: MainAxisAlignment.center,\n                    children: [\n                      // === TECHNIQUE 5: CUSTOM PAINT RENDERING + SIGNATURE ELEMENT 3: PULSE ANIMATIONS ===\n                      _buildFlowAILogo(isDark),\n                      \n                      const SizedBox(height: 40),\n                      \n                      // === TECHNIQUE 9: SHADER MASK GRADIENTS + SIGNATURE ELEMENT 4: COLOR MORPHING ===\n                      _buildMorphingTitle(isDark),\n                      \n                      const SizedBox(height: 16),\n                      \n                      // === SIGNATURE ELEMENT 5: DEPTH LAYERS ===\n                      _buildDepthSubtitle(isDark),\n                      \n                      const SizedBox(height: 80),\n                      \n                      // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===\n                      _buildBreathingLoader(isDark),\n                    ],\n                  ),\n                ),\n                \n                // === TECHNIQUE 6: GLASSMORPHISM + NEUMORPHISM ===\n                _buildGlassNeumorphicOverlay(),\n              ],\n            ),\n          );\n        },\n      ),\n    );\n  }\n  \n  // === TECHNIQUE 1 & 4: MATHEMATICAL GRADIENT + RADIAL DEPTH ===\n  LinearGradient _buildFlowAIBackground(bool isDark) {\n    final baseColors = isDark \n        ? [Colors.black, const Color(0xFF1A1A2E), const Color(0xFF16213E)]\n        : [Colors.white, const Color(0xFFF8F9FA), const Color(0xFFE8F0FE)];\n    \n    final morphedColors = FlowAIVisualSystem.emotionalMorph.map((color) {\n      return FlowAIVisualSystem.parametricColorMorph(_colorMorphAnimation.value, [color]);\n    }).toList();\n    \n    return LinearGradient(\n      begin: Alignment.topLeft,\n      end: Alignment.bottomRight,\n      colors: [\n        ...baseColors,\n        ...morphedColors.map((c) => c.withValues(alpha: 0.1)),\n      ],\n      stops: const [0.0, 0.3, 0.6, 0.7, 0.8, 0.9, 1.0],\n    );\n  }\n  \n  // === TECHNIQUE 5: CUSTOM PAINT RENDERING + SIGNATURE ELEMENT 3: PULSE ANIMATIONS ===\n  Widget _buildFlowAILogo(bool isDark) {\n    return Transform.scale(\n      scale: _logoScale.value * _breathingAnimation.value,\n      child: Opacity(\n        opacity: _logoOpacity.value,\n        child: Container(\n          width: 160,\n          height: 160,\n          child: Stack(\n            alignment: Alignment.center,\n            children: [\n              // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===\n              Container(\n                width: 160,\n                height: 160,\n                decoration: BoxDecoration(\n                  shape: BoxShape.circle,\n                  boxShadow: FlowAIVisualSystem.createDepthShadows(\n                    color: FlowAIVisualSystem.flowPrimary,\n                    elevation: 20,\n                    layers: 6,\n                  ),\n                ),\n              ),\n              \n              // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===\n              Container(\n                width: 160,\n                height: 160,\n                decoration: BoxDecoration(\n                  shape: BoxShape.circle,\n                  gradient: FlowAIVisualSystem.createDepthRadial(\n                    colors: FlowAIVisualSystem.petalGradient,\n                  ),\n                ),\n              ),\n              \n              // === TECHNIQUE 6: GLASSMORPHISM + NEUMORPHISM ===\n              Container(\n                width: 120,\n                height: 120,\n                decoration: FlowAIVisualSystem.createGlassNeumorphism(\n                  backgroundColor: FlowAIVisualSystem.flowPrimary,\n                  opacity: 0.2,\n                ),\n                child: Center(\n                  child: Column(\n                    mainAxisAlignment: MainAxisAlignment.center,\n                    children: [\n                      // === TECHNIQUE 9: SHADER MASK GRADIENTS ===\n                      FlowAIVisualSystem.createFlowShaderMask(\n                        colors: FlowAIVisualSystem.emotionalMorph,\n                        time: _colorMorphAnimation.value,\n                        child: const Icon(\n                          Icons.favorite,\n                          size: 48,\n                          color: Colors.white,\n                        ),\n                      ),\n                      const SizedBox(height: 8),\n                      FlowAIVisualSystem.createFlowShaderMask(\n                        colors: FlowAIVisualSystem.flowLineGradient,\n                        time: _colorMorphAnimation.value,\n                        child: const Text(\n                          'AI',\n                          style: TextStyle(\n                            fontSize: 20,\n                            fontWeight: FontWeight.w800,\n                            color: Colors.white,\n                            letterSpacing: 2,\n                          ),\n                        ),\n                      ),\n                    ],\n                  ),\n                ),\n              ),\n              \n              // === TECHNIQUE 5: CUSTOM PAINT RENDERING ===\n              SizedBox(\n                width: 160,\n                height: 160,\n                child: CustomPaint(\n                  painter: FlowAILogoPainter(\n                    animationValue: _petalScatterAnimation.value,\n                    morphValue: _colorMorphAnimation.value,\n                  ),\n                ),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );\n  }\n  \n  // === TECHNIQUE 9: SHADER MASK GRADIENTS + SIGNATURE ELEMENT 4: COLOR MORPHING ===\n  Widget _buildMorphingTitle(bool isDark) {\n    return Opacity(\n      opacity: _textOpacity.value,\n      child: FlowAIVisualSystem.createFlowShaderMask(\n        colors: FlowAIVisualSystem.emotionalMorph,\n        time: _colorMorphAnimation.value,\n        child: Text(\n          'Flow AI',\n          style: TextStyle(\n            fontSize: 42,\n            fontWeight: FontWeight.w900,\n            color: Colors.white,\n            letterSpacing: -1,\n            shadows: [\n              Shadow(\n                color: FlowAIVisualSystem.flowPrimary.withValues(alpha: 0.5),\n                blurRadius: 20,\n              ),\n            ],\n          ),\n        ),\n      ),\n    );\n  }\n  \n  // === SIGNATURE ELEMENT 5: DEPTH LAYERS ===\n  Widget _buildDepthSubtitle(bool isDark) {\n    return Opacity(\n      opacity: _textOpacity.value * 0.8,\n      child: Container(\n        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),\n        decoration: FlowAIVisualSystem.createGlassNeumorphism(\n          backgroundColor: FlowAIVisualSystem.flowSecondary,\n          opacity: 0.1,\n        ),\n        child: Column(\n          children: [\n            Text(\n              'Intelligent Period Tracking',\n              style: TextStyle(\n                fontSize: 18,\n                fontWeight: FontWeight.w600,\n                color: FlowAIVisualSystem.parametricColorMorph(\n                  _colorMorphAnimation.value,\n                  FlowAIVisualSystem.emotionalMorph,\n                ),\n                letterSpacing: 1,\n              ),\n            ),\n            const SizedBox(height: 8),\n            Text(\n              'Powered by Mathematical Beauty',\n              style: TextStyle(\n                fontSize: 14,\n                fontWeight: FontWeight.w400,\n                color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.6),\n                letterSpacing: 0.5,\n              ),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n  \n  // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===\n  Widget _buildBreathingLoader(bool isDark) {\n    return Opacity(\n      opacity: _textOpacity.value,\n      child: Transform.scale(\n        scale: _breathingAnimation.value,\n        child: Container(\n          width: 200,\n          height: 6,\n          decoration: BoxDecoration(\n            borderRadius: BorderRadius.circular(3),\n            gradient: FlowAIVisualSystem.createFlowGradient(\n              _flowLinesAnimation.value,\n              colors: FlowAIVisualSystem.flowLineGradient,\n            ),\n            boxShadow: FlowAIVisualSystem.createDepthShadows(\n              color: FlowAIVisualSystem.flowPrimary,\n              elevation: 4,\n            ),\n          ),\n        ),\n      ),\n    );\n  }\n  \n  // === TECHNIQUE 6: GLASSMORPHISM + NEUMORPHISM ===\n  Widget _buildGlassNeumorphicOverlay() {\n    return Positioned(\n      top: 60,\n      right: 20,\n      child: Opacity(\n        opacity: _textOpacity.value * 0.7,\n        child: Container(\n          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),\n          decoration: FlowAIVisualSystem.createGlassNeumorphism(\n            backgroundColor: FlowAIVisualSystem.flowSecondary,\n            opacity: 0.15,\n          ),\n          child: Row(\n            mainAxisSize: MainAxisSize.min,\n            children: [\n              Icon(\n                Icons.security,\n                size: 16,\n                color: FlowAIVisualSystem.flowPrimary,\n              ),\n              const SizedBox(width: 6),\n              Text(\n                'HIPAA Compliant',\n                style: TextStyle(\n                  fontSize: 12,\n                  fontWeight: FontWeight.w500,\n                  color: FlowAIVisualSystem.flowPrimary,\n                ),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );\n  }\n}\n\n// === CUSTOM PAINTERS FOR ADVANCED TECHNIQUES ===\n\n/// Technique 2: Multi-Layer Shadow System through Depth Layers\nclass DepthLayersPainter extends CustomPainter {\n  final double animationValue;\n  final bool isDark;\n  \n  DepthLayersPainter({\n    required this.animationValue,\n    required this.isDark,\n  });\n  \n  @override\n  void paint(Canvas canvas, Size size) {\n    final paint = Paint()..style = PaintingStyle.fill;\n    \n    // Create multiple depth layers with different opacities\n    for (int i = 0; i < 5; i++) {\n      final layerOpacity = (0.1 - i * 0.02) * animationValue;\n      final layerOffset = i * 20.0;\n      \n      paint.color = (isDark \n          ? FlowAIVisualSystem.flowBlue \n          : FlowAIVisualSystem.flowPrimary).withValues(alpha: layerOpacity);\n      \n      canvas.drawCircle(\n        Offset(size.width / 2 + layerOffset, size.height / 2 + layerOffset),\n        size.width * 0.3,\n        paint,\n      );\n    }\n  }\n  \n  @override\n  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;\n}\n\n/// Technique 3: Floating Particle System with Orbital Animations\nclass FloatingParticlesPainter extends CustomPainter {\n  final double animationValue;\n  final List<ParticleConfig> particles;\n  \n  FloatingParticlesPainter({\n    required this.animationValue,\n    required this.particles,\n  });\n  \n  @override\n  void paint(Canvas canvas, Size size) {\n    final paint = Paint()..style = PaintingStyle.fill;\n    final center = Offset(size.width / 2, size.height / 2);\n    \n    for (final particle in particles) {\n      // Calculate orbital position\n      final angle = particle.initialAngle + animationValue * particle.speed * 2 * math.pi;\n      final x = center.dx + math.cos(angle) * particle.radius;\n      final y = center.dy + math.sin(angle) * particle.radius;\n      \n      // Apply pulsing effect\n      final pulseScale = 1.0 + 0.3 * math.sin(animationValue * 4 * math.pi + particle.initialAngle);\n      final currentSize = particle.size * pulseScale;\n      \n      paint.color = particle.color.withValues(alpha: particle.opacity);\n      canvas.drawCircle(Offset(x, y), currentSize, paint);\n    }\n  }\n  \n  @override\n  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;\n}\n\n/// Technique 5: Custom Paint Rendering for Logo\nclass FlowAILogoPainter extends CustomPainter {\n  final double animationValue;\n  final double morphValue;\n  \n  FlowAILogoPainter({\n    required this.animationValue,\n    required this.morphValue,\n  });\n  \n  @override\n  void paint(Canvas canvas, Size size) {\n    final paint = Paint()\n      ..style = PaintingStyle.stroke\n      ..strokeWidth = 3;\n    \n    final center = Offset(size.width / 2, size.height / 2);\n    final radius = size.width * 0.35;\n    \n    // Draw flowing orbital rings\n    for (int i = 0; i < 3; i++) {\n      final ringRadius = radius - i * 15;\n      final startAngle = animationValue * 2 * math.pi + i * math.pi / 3;\n      final sweepAngle = math.pi + math.sin(morphValue * 2 * math.pi) * 0.5;\n      \n      paint.color = FlowAIVisualSystem.petalGradient[i % FlowAIVisualSystem.petalGradient.length]\n          .withValues(alpha: 0.6);\n      \n      canvas.drawArc(\n        Rect.fromCircle(center: center, radius: ringRadius),\n        startAngle,\n        sweepAngle,\n        false,\n        paint,\n      );\n    }\n  }\n  \n  @override\n  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;\n}"}}]
