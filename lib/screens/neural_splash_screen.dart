import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../themes/flow_ai_futuristic_theme.dart';

class NeuralSplashScreen extends StatefulWidget {
  const NeuralSplashScreen({super.key});

  @override
  State<NeuralSplashScreen> createState() => _NeuralSplashScreenState();
}

class _NeuralSplashScreenState extends State<NeuralSplashScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _mainController;
  late AnimationController _neuralController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _matrixController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _neuralAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _matrixAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }
  
  void _setupAnimations() {
    // Main controller for overall sequence
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    // Neural network animation
    _neuralController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Particle system animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    
    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Matrix code animation
    _matrixController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );
    
    // Define animation curves
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: NeuralCurves.quantumTunnel),
      ),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.9, curve: NeuralCurves.synapticFire),
      ),
    );
    
    _neuralAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _neuralController,
        curve: NeuralCurves.plasmaFlow,
      ),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.linear,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: NeuralCurves.neuralPulse,
      ),
    );
    
    _matrixAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _matrixController,
        curve: Curves.linear,
      ),
    );
  }
  
  void _startSplashSequence() async {
    // Start animations in sequence
    _particleController.repeat();
    _matrixController.repeat();
    _pulseController.repeat(reverse: true);
    
    await Future.delayed(const Duration(milliseconds: 200));
    _neuralController.repeat();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _mainController.forward();
    
    // Wait for completion
    await Future.delayed(const Duration(milliseconds: 4000));
    
    // Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _neuralController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _matrixController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _neuralController,
          _particleController,
          _pulseController,
          _matrixController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _buildNeuralBackground(isDark),
            ),
            child: Stack(
              children: [
                // Background matrix effect
                Positioned.fill(
                  child: CustomPaint(
                    painter: MatrixCodePainter(
                      animationValue: _matrixAnimation.value,
                      isDark: isDark,
                    ),
                  ),
                ),
                
                // Neural network background
                Positioned.fill(
                  child: CustomPaint(
                    painter: NeuralNetworkPainter(
                      animationValue: _neuralAnimation.value,
                      particleValue: _particleAnimation.value,
                      isDark: isDark,
                    ),
                  ),
                ),
                
                // Particle system
                Positioned.fill(
                  child: CustomPaint(
                    painter: QuantumParticlePainter(
                      animationValue: _particleAnimation.value,
                      pulseValue: _pulseAnimation.value,
                      isDark: isDark,
                    ),
                  ),
                ),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Neural logo
                      _buildNeuralLogo(isDark),
                      
                      const SizedBox(height: 40),
                      
                      // App title with holographic effect
                      _buildHolographicTitle(isDark),
                      
                      const SizedBox(height: 16),
                      
                      // Subtitle
                      _buildSubtitle(isDark),
                      
                      const SizedBox(height: 80),
                      
                      // Quantum loading indicator
                      _buildQuantumLoader(isDark),
                    ],
                  ),
                ),
                
                // Bottom neural circuit
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: CustomPaint(
                    painter: NeuralCircuitPainter(
                      animationValue: _neuralAnimation.value,
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  LinearGradient _buildNeuralBackground(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          FlowAIFuturisticTheme.voidBlack,
          FlowAIFuturisticTheme.cosmicBlue,
          FlowAIFuturisticTheme.nebulaPurple,
          FlowAIFuturisticTheme.stellarGray,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey.shade50,
          Colors.blue.shade50,
          Colors.purple.shade50,
          Colors.cyan.shade50,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );
    }
  }
  
  Widget _buildNeuralLogo(bool isDark) {
    return Transform.scale(
      scale: _logoScale.value * _pulseAnimation.value,
      child: Opacity(
        opacity: _logoOpacity.value,
        child: Container(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer neural ring
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                        ? FlowAIFuturisticTheme.quantumField
                        : FlowAIFuturisticTheme.synapseGlow,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                          .withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // Inner core
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? FlowAIFuturisticTheme.stellarGray : Colors.white,
                  border: Border.all(
                    color: (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isDark
                          ? FlowAIFuturisticTheme.quantumField
                          : FlowAIFuturisticTheme.synapseGlow,
                    ).createShader(bounds),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Neural synapses (rotating)
              Transform.rotate(
                angle: _neuralAnimation.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(140, 140),
                  painter: SynapsePainter(
                    animationValue: _neuralAnimation.value,
                    isDark: isDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHolographicTitle(bool isDark) {
    return Opacity(
      opacity: _textOpacity.value,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return FlowAIFuturisticTheme.createAnimatedGradient(
            bounds,
            isDark
                ? FlowAIFuturisticTheme.quantumField
                : FlowAIFuturisticTheme.synapseGlow,
            _neuralAnimation.value,
          );
        },
        child: Text(
          'Flow AI',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1,
            shadows: [
              Shadow(
                color: (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                    .withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSubtitle(bool isDark) {
    return Opacity(
      opacity: _textOpacity.value * 0.8,
      child: Column(
        children: [
          Text(
            'Neural Period Intelligence',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? FlowAIFuturisticTheme.holoBlue
                  : FlowAIFuturisticTheme.neuralBlue,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by Quantum Analytics',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuantumLoader(bool isDark) {
    return Opacity(
      opacity: _textOpacity.value,
      child: Container(
        width: 200,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                  .withValues(alpha: 0.3),
              isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue,
              (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                  .withValues(alpha: 0.3),
              Colors.transparent,
            ],
            stops: [
              0.0,
              math.max(0.0, _mainController.value - 0.2),
              _mainController.value,
              math.min(1.0, _mainController.value + 0.2),
              1.0,
            ],
          ),
        ),
      ),
    );
  }
}

/// Neural Network Background Painter
class NeuralNetworkPainter extends CustomPainter {
  final double animationValue;
  final double particleValue;
  final bool isDark;
  
  NeuralNetworkPainter({
    required this.animationValue,
    required this.particleValue,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..blendMode = BlendMode.screen;
    
    final nodeCount = 8;
    final List<Offset> nodes = [];
    
    // Generate neural nodes
    for (int i = 0; i < nodeCount; i++) {
      final angle = (i / nodeCount) * 2 * math.pi + (animationValue * 0.5);
      final radius = size.width * 0.3;
      final x = size.width / 2 + math.cos(angle) * radius;
      final y = size.height / 2 + math.sin(angle) * radius;
      nodes.add(Offset(x, y));
    }
    
    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i] - nodes[j]).distance;
        if (distance < size.width * 0.4) {
          final opacity = (1 - distance / (size.width * 0.4)) * 
                         math.sin(animationValue * math.pi + i + j) * 0.5 + 0.5;
          
          paint.color = (isDark 
              ? FlowAIFuturisticTheme.quantumCyan 
              : FlowAIFuturisticTheme.neuralBlue)
              .withValues(alpha: opacity * 0.3);
          
          canvas.drawLine(nodes[i], nodes[j], paint);
        }
      }
    }
    
    // Draw nodes
    for (int i = 0; i < nodes.length; i++) {
      final pulse = math.sin(animationValue * 2 * math.pi + i) * 0.3 + 0.7;
      paint.style = PaintingStyle.fill;
      paint.color = (isDark 
          ? FlowAIFuturisticTheme.quantumCyan 
          : FlowAIFuturisticTheme.neuralBlue)
          .withValues(alpha: pulse);
      
      canvas.drawCircle(nodes[i], 4 * pulse, paint);
      
      paint.style = PaintingStyle.stroke;
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Quantum Particle System Painter
class QuantumParticlePainter extends CustomPainter {
  final double animationValue;
  final double pulseValue;
  final bool isDark;
  
  QuantumParticlePainter({
    required this.animationValue,
    required this.pulseValue,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    
    for (int i = 0; i < 50; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      
      // Particle movement
      final x = baseX + math.sin(animationValue * 2 * math.pi + i) * 20;
      final y = baseY + math.cos(animationValue * math.pi + i) * 10;
      
      // Quantum tunnel effect
      final tunnelEffect = math.sin(animationValue * 3 * math.pi + i) * 0.5 + 0.5;
      final size_particle = (1 + tunnelEffect * 2) * pulseValue;
      final opacity = tunnelEffect * 0.6;
      
      paint.color = FlowAIFuturisticTheme.quantumField[i % FlowAIFuturisticTheme.quantumField.length]
          .withValues(alpha: opacity);
      
      canvas.drawCircle(Offset(x, y), size_particle, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Matrix Code Background Painter
class MatrixCodePainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  
  MatrixCodePainter({
    required this.animationValue,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) return; // Only show matrix in dark mode
    
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    final chars = '01';
    final random = math.Random(42);
    
    for (int column = 0; column < size.width / 20; column++) {
      final x = column * 20.0;
      final streamHeight = random.nextDouble() * size.height;
      final streamSpeed = 0.5 + random.nextDouble();
      
      final offset = (animationValue * streamSpeed * size.height) % (size.height + streamHeight);
      
      for (int row = 0; row < streamHeight / 20; row++) {
        final y = offset + row * 20 - streamHeight;
        
        if (y > -20 && y < size.height + 20) {
          final char = chars[random.nextInt(chars.length)];
          final opacity = math.max(0.0, 1 - (row / (streamHeight / 20)));
          
          textPainter.text = TextSpan(
            text: char,
            style: TextStyle(
              color: FlowAIFuturisticTheme.matrixGreen.first.withValues(alpha: opacity * 0.3),
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          );
          
          textPainter.layout();
          textPainter.paint(canvas, Offset(x, y));
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Synapse Connection Painter
class SynapsePainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  
  SynapsePainter({
    required this.animationValue,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    
    // Draw synaptic connections
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * math.pi;
      final startX = center.dx + math.cos(angle) * radius * 0.7;
      final startY = center.dy + math.sin(angle) * radius * 0.7;
      final endX = center.dx + math.cos(angle) * radius;
      final endY = center.dy + math.sin(angle) * radius;
      
      final pulse = math.sin(animationValue * 4 * math.pi - i) * 0.5 + 0.5;
      
      paint.color = (isDark 
          ? FlowAIFuturisticTheme.quantumCyan 
          : FlowAIFuturisticTheme.neuralBlue)
          .withValues(alpha: pulse);
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      
      // Draw synapse nodes
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(endX, endY), 3 * pulse, paint);
      paint.style = PaintingStyle.stroke;
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Neural Circuit Bottom Painter
class NeuralCircuitPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  
  NeuralCircuitPainter({
    required this.animationValue,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw circuit lines
    final y = size.height * 0.6;
    final segments = 10;
    
    for (int i = 0; i < segments; i++) {
      final x1 = (i / segments) * size.width;
      final x2 = ((i + 1) / segments) * size.width;
      
      final pulse = math.sin(animationValue * 2 * math.pi - i * 0.5) * 0.5 + 0.5;
      
      paint.color = (isDark 
          ? FlowAIFuturisticTheme.holoBlue 
          : FlowAIFuturisticTheme.neuralBlue)
          .withValues(alpha: pulse * 0.4);
      
      canvas.drawLine(Offset(x1, y), Offset(x2, y + math.sin(i) * 10), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
