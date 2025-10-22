import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/flow_iq_visual_system.dart';
import '../services/enhanced_auth_service.dart';

/// Flow iQ Clinical Splash Screen
class FlowIQSplashScreen extends StatefulWidget {
  const FlowIQSplashScreen({super.key});

  @override
  State<FlowIQSplashScreen> createState() => _FlowIQSplashScreenState();
}

class _FlowIQSplashScreenState extends State<FlowIQSplashScreen>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _startAnimation();
  }

  void _startAnimation() async {
    _controller.forward();
    
    // Wait for animation
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Check if user is already authenticated
      final authService = Provider.of<EnhancedAuthService>(context, listen: false);
      final isAuthenticated = authService.currentUser != null;
      
      // Navigate based on auth state
      if (isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlowIQVisualSystem.darkBackground,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  FlowIQVisualSystem.primaryClinical,
                  FlowIQVisualSystem.darkBackground,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: FlowIQVisualSystem.primaryClinical.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 60,
                          color: FlowIQVisualSystem.primaryClinical,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // App name
                      const Text(
                        'Flow iQ',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'Clinical Intelligence',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Loading indicator
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                          strokeWidth: 2,
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
    );
  }
}
