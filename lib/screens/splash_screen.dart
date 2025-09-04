import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'package:flutter/foundation.dart' as foundation;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _backgroundAnimationController;
  late AnimationController _particleAnimationController;
  late AnimationController _pulseAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoGlowAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isInitialized = false;
  final List<FloatingParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animations
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoGlowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animations
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Background animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Particle system animation
    _particleAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _particleAnimationController,
    );

    // Pulse animation for glow effect
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize particles
    _initializeParticles();

    // Start animations sequence
    _startAnimationSequence();
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 15; i++) {
      _particles.add(FloatingParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.0005 + random.nextDouble() * 0.002,
        size: 2.0 + random.nextDouble() * 4.0,
        opacity: 0.3 + random.nextDouble() * 0.4,
        color: [Colors.white, Colors.pink.shade100, Colors.purple.shade100][random.nextInt(3)],
      ));
    }
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    if (mounted) {
      _backgroundAnimationController.forward();
    }

    // Wait a bit, then start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _logoAnimationController.forward();
    }

    // Wait for logo to finish, then start text
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      _textAnimationController.forward();
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Minimum splash screen time for smooth UX
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 3000)),
        _performInitialization(),
      ]);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Small delay to show loading completed state
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to appropriate screen
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (error) {
      foundation.debugPrint('Splash screen initialization error: $error');
      // Still navigate even if there's an error
      if (mounted) {
        await _navigateToNextScreen();
      }
    }
  }

  Future<void> _performInitialization() async {
    // Add any actual app initialization logic here
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    foundation.debugPrint('🚀 Starting navigation from splash screen...');

    try {
      // Auto-initialize test user for demo purposes
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      foundation.debugPrint('✅ UserProvider obtained, isLoggedIn: ${userProvider.isLoggedIn}');
      
      if (!userProvider.isLoggedIn) {
        foundation.debugPrint('🔑 Initializing test user...');
        await userProvider.initializeTestUser('Ronos');
        foundation.debugPrint('✅ Test user auto-initialized');
      }

      // Navigate to home screen
      foundation.debugPrint('🏠 Navigating to home screen...');
      if (mounted) {
        context.go('/home');
        foundation.debugPrint('✅ Navigation to home completed');
      }
    } catch (e) {
      foundation.debugPrint('❌ Error during navigation: $e');
      // Fallback navigation
      if (mounted) {
        try {
          context.go('/home');
          foundation.debugPrint('✅ Fallback navigation to home completed');
        } catch (navError) {
          foundation.debugPrint('❌ Fallback navigation failed: $navError');
          // Last resort - try login
          try {
            context.go('/login');
            foundation.debugPrint('✅ Final fallback to login completed');
          } catch (loginError) {
            foundation.debugPrint('💥 All navigation attempts failed: $loginError');
          }
        }
      }
    }
  }

  void _checkAuthState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _particleAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Emergency navigation - tap to skip
          foundation.debugPrint('👆 Emergency tap navigation triggered');
          if (mounted) {
            context.go('/home');
          }
        },
        child: Stack(
        children: [
          // Animated Background Gradient
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        AppTheme.primaryPink.withOpacity(0.8),
                        AppTheme.primaryPurple.withOpacity(0.9),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        AppTheme.primaryPink,
                        Colors.deepPurple.shade600,
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        AppTheme.primaryPurple,
                        Colors.indigo.shade700,
                        _backgroundAnimation.value,
                      )!,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          // Floating Particles Background
          AnimatedBuilder(
            animation: _particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: ParticlesPainter(_particles, _particleAnimation.value),
              );
            },
          ),

          // Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // Enhanced Animated Logo with Glow Effect
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoAnimationController,
                    _pulseAnimationController,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotationAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.pink.shade100,
                                AppTheme.primaryPink.withOpacity(0.3),
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPink.withOpacity(0.3 * _logoGlowAnimation.value),
                                blurRadius: 30 * _pulseAnimation.value,
                                spreadRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '🌸',
                                  style: TextStyle(
                                    fontSize: 54,
                                    shadows: [
                                      Shadow(
                                        color: Colors.pink.shade200.withOpacity(_logoGlowAnimation.value),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'iQ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryPink,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Enhanced App Name with Flow iQ Branding
                AnimatedBuilder(
                  animation: _textAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Column(
                          children: [
                            // Main Title with enhanced styling
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.pink.shade100,
                                  Colors.white,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ).createShader(bounds),
                              child: Text(
                                'Flow iQ',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 3.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 3),
                                      blurRadius: 8,
                                    ),
                                    Shadow(
                                      color: AppTheme.primaryPink.withOpacity(0.5),
                                      offset: const Offset(0, 0),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Subtitle with enhanced design
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Your Intelligent Cycle Companion',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Feature highlights
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFeaturePill('📊 Smart'),
                                const SizedBox(width: 6),
                                _buildFeaturePill('🤖 AI'),
                                const SizedBox(width: 6),
                                _buildFeaturePill('🔮 Predict'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // Enhanced Loading Indicator
                if (!_isInitialized) ...[
                  AnimatedBuilder(
                    animation: _pulseAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * _pulseAnimation.value),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 3,
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Preparing your personalized experience...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Enhanced Bottom Branding
                AnimatedBuilder(
                  animation: _textAnimationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '✨ ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Empowering Women with Intelligence',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  ' ✨',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Text(
                            'v1.0.0 • Flow iQ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFeaturePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Floating Particle Class
class FloatingParticle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;
  final Color color;

  FloatingParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.color,
  });

  void update() {
    y -= speed;
    if (y < -0.1) {
      y = 1.1;
      x = math.Random().nextDouble();
    }
  }
}

// Custom Painter for Floating Particles
class ParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;

  ParticlesPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (final particle in particles) {
      particle.update();
      
      paint
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
