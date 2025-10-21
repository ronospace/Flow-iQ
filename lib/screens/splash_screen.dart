import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../themes/flow_ai_futuristic_theme.dart';
import '../widgets/futuristic_components.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _backgroundGradient;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  
  bool _isDark = false;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
    
    // Determine theme
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDark = brightness == Brightness.dark;
  }
  
  void _setupAnimations() {
    // Main animation controller (3.5 seconds)
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    
    // Pulse animation (continuous)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Rotation animation (continuous)
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));
    
    // Text animation
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));
    
    // Background gradient animation
    _backgroundGradient = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));
    
    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // Particle animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
  }
  
  void _startSplashSequence() async {
    // Start all animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _particleController.forward();
    
    // Wait for splash completion
    await Future.delayed(const Duration(milliseconds: 3500));
    
    // Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _rotationController,
          _particleController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _isDark ? _buildDarkGradient() : _buildLightGradient(),
            ),
            child: Stack(
              children: [
                // Background particles
                ..._buildParticles(),
                
                // Central logo area
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animations
                      _buildAnimatedLogo(),
                      
                      const SizedBox(height: 32),
                      
                      // App name with animation
                      _buildAnimatedText(),
                      
                      const SizedBox(height: 16),
                      
                      // Tagline
                      _buildTagline(),
                      
                      const SizedBox(height: 64),
                      
                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),
                
                // Bottom branding
                _buildBottomBranding(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  LinearGradient _buildLightGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(
          FlowiQTheme.neutralExtraLight,
          FlowiQTheme.primaryClinical.withValues(alpha: 0.1),
          _backgroundGradient.value,
        )!,
        Color.lerp(
          FlowiQTheme.surfaceSecondary,
          FlowiQTheme.primaryAccent.withValues(alpha: 0.1),
          _backgroundGradient.value,
        )!,
        Color.lerp(
          FlowiQTheme.surfacePrimary,
          FlowiQTheme.tertiaryAccent.withValues(alpha: 0.05),
          _backgroundGradient.value,
        )!,
      ],
    );
  }
  
  LinearGradient _buildDarkGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(
          FlowiQTheme.darkBackground,
          FlowiQTheme.darkAccent.withValues(alpha: 0.2),
          _backgroundGradient.value,
        )!,
        Color.lerp(
          FlowiQTheme.darkSurface,
          FlowiQTheme.secondaryAccent.withValues(alpha: 0.1),
          _backgroundGradient.value,
        )!,
        Color.lerp(
          FlowiQTheme.darkSurfaceElevated,
          FlowiQTheme.tertiaryAccent.withValues(alpha: 0.1),
          _backgroundGradient.value,
        )!,
      ],
    );
  }
  
  Widget _buildAnimatedLogo() {
    return Transform.scale(
      scale: _logoScale.value * _pulseAnimation.value,
      child: Opacity(
        opacity: _logoOpacity.value,
        child: Transform.rotate(
          angle: _rotationAnimation.value * 0.1, // Subtle rotation
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isDark
                    ? [
                        FlowiQTheme.darkAccent,
                        FlowiQTheme.secondaryAccent,
                        FlowiQTheme.tertiaryAccent,
                      ]
                    : [
                        FlowiQTheme.primaryClinical,
                        FlowiQTheme.primaryAccent,
                        FlowiQTheme.tertiaryAccent,
                      ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isDark ? FlowiQTheme.darkAccent : FlowiQTheme.primaryClinical)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Outer ring
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
                
                // Inner content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Flow iQ icon
                      Icon(
                        Icons.health_and_safety,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'iQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rotating accent ring
                Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: CustomPaint(
                    size: Size(120, 120),
                    painter: AccentRingPainter(
                      color: Colors.white.withValues(alpha: 0.4),
                      progress: _particleAnimation.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnimatedText() {
    return Opacity(
      opacity: _textOpacity.value,
      child: Column(
        children: [
          // Main app name
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: _isDark
                    ? [FlowiQTheme.darkAccent, FlowiQTheme.secondaryAccent]
                    : [FlowiQTheme.primaryClinical, FlowiQTheme.primaryAccent],
              ).createShader(bounds);
            },
            child: Text(
              'Flow iQ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Subtitle
          Text(
            'Clinical Period Tracker',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              color: (_isDark ? Colors.white : FlowiQTheme.neutralDark)
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTagline() {
    return Opacity(
      opacity: _textOpacity.value * 0.8,
      child: Text(
        'Advanced Clinical Insights',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
          color: (_isDark ? Colors.white : FlowiQTheme.neutralMedium)
              .withValues(alpha: 0.7),
        ),
      ),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return Opacity(
      opacity: _textOpacity.value,
      child: SizedBox(
        width: 120,
        child: Transform.scale(
          scale: _pulseAnimation.value * 0.3 + 0.7,
          child: LinearProgressIndicator(
            backgroundColor: (_isDark ? Colors.white : FlowiQTheme.primaryClinical)
                .withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _isDark ? FlowiQTheme.darkAccent : FlowiQTheme.primaryClinical,
            ),
            minHeight: 3,
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomBranding() {
    return Positioned(
      bottom: 48,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: _textOpacity.value * 0.6,
        child: Column(
          children: [
            Text(
              'Powered by Advanced AI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: (_isDark ? Colors.white : FlowiQTheme.neutralMedium)
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 12,
                  color: (_isDark ? Colors.white : FlowiQTheme.neutralMedium)
                      .withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'HIPAA Compliant',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: (_isDark ? Colors.white : FlowiQTheme.neutralMedium)
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildParticles() {
    List<Widget> particles = [];
    
    for (int i = 0; i < 15; i++) {
      particles.add(
        Positioned(
          left: (i * 50 + 30) % MediaQuery.of(context).size.width,
          top: (i * 80 + 100) % MediaQuery.of(context).size.height,
          child: Transform.rotate(
            angle: _rotationAnimation.value + (i * 0.5),
            child: Transform.scale(
              scale: (math.sin(_particleAnimation.value * 2 * math.pi + i) * 0.3 + 0.7),
              child: Opacity(
                opacity: (math.sin(_particleAnimation.value * math.pi + i) * 0.3 + 0.4),
                child: Container(
                  width: 4 + (i % 3) * 2,
                  height: 4 + (i % 3) * 2,
                  decoration: BoxDecoration(
                    color: (_isDark ? FlowiQTheme.darkAccent : FlowiQTheme.primaryAccent)
                        .withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isDark ? FlowiQTheme.darkAccent : FlowiQTheme.primaryAccent)
                            .withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return particles;
  }
}

/// Custom painter for the accent ring around the logo
class AccentRingPainter extends CustomPainter {
  final Color color;
  final double progress;
  
  AccentRingPainter({
    required this.color,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Draw accent arcs
    for (int i = 0; i < 3; i++) {
      final startAngle = (i * 2 * math.pi / 3) + (progress * 2 * math.pi);
      const sweepAngle = math.pi / 3;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
