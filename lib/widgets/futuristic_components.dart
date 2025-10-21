import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../themes/flow_ai_futuristic_theme.dart';

/// Futuristic Neural Card with holographic effects
class NeuralCard extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final bool enableHolography;
  final bool enablePulse;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double glowIntensity;
  final String? neuralPattern;

  const NeuralCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.enableHolography = true,
    this.enablePulse = false,
    this.onTap,
    this.padding,
    this.margin,
    this.glowIntensity = 1.0,
    this.neuralPattern,
  });

  @override
  State<NeuralCard> createState() => _NeuralCardState();
}

class _NeuralCardState extends State<NeuralCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _holoController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _holoAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _holoController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: NeuralCurves.neuralPulse),
    );
    
    _holoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _holoController, curve: NeuralCurves.plasmaFlow),
    );
    
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
    
    if (widget.enableHolography) {
      _holoController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _holoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = widget.gradientColors ?? 
        (isDark ? FlowAIFuturisticTheme.synapseGlow : FlowAIFuturisticTheme.neuralFlow);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _holoAnimation]),
      builder: (context, child) {
        return Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(24),
              child: Transform.scale(
                scale: widget.enablePulse ? _pulseAnimation.value : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.enableHolography 
                        ? colors.map((c) => c.quantumShift(_holoAnimation.value)).toList()
                        : colors.map((c) => c.withValues(alpha: 0.1)).toList(),
                    ),
                    border: Border.all(
                      color: colors.first.withValues(alpha: 0.3 + (widget.glowIntensity * 0.4)),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.first.withValues(alpha: 0.3 * widget.glowIntensity),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      if (widget.enableHolography)
                        BoxShadow(
                          color: colors.last.withValues(alpha: 0.2 * widget.glowIntensity),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: widget.padding ?? const EdgeInsets.all(20),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Quantum Button with neural glow effects
class QuantumButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color>? gradientColors;
  final double width;
  final double height;
  final bool enableParticles;

  const QuantumButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.gradientColors,
    this.width = double.infinity,
    this.height = 56,
    this.enableParticles = true,
  });

  @override
  State<QuantumButton> createState() => _QuantumButtonState();
}

class _QuantumButtonState extends State<QuantumButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: NeuralCurves.synapticFire),
    );
    
    if (widget.enableParticles) {
      _particleController.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = widget.gradientColors ?? 
        (isDark ? FlowAIFuturisticTheme.quantumField : FlowAIFuturisticTheme.synapseGlow);

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: FlowAIFuturisticTheme.createNeuralGlow(
              colors: colors,
              glowRadius: 15 + (_glowAnimation.value * 10),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
                child: Stack(
                  children: [
                    // Particle effect background
                    if (widget.enableParticles)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _particleController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: ParticlePainter(
                                animationValue: _particleController.value,
                                colors: colors,
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // Button content
                    Center(
                      child: widget.isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlowAIFuturisticTheme.getContrastingTextColor(colors.first),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: FlowAIFuturisticTheme.getContrastingTextColor(colors.first),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: FlowAIFuturisticTheme.getContrastingTextColor(colors.first),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Holographic Progress Ring with neural patterns
class HolographicProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color>? colors;
  final Widget? center;
  final bool enableAnimation;
  final bool enableParticles;

  const HolographicProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.colors,
    this.center,
    this.enableAnimation = true,
    this.enableParticles = false,
  });

  @override
  State<HolographicProgressRing> createState() => _HolographicProgressRingState();
}

class _HolographicProgressRingState extends State<HolographicProgressRing>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _glowController;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _progressController, curve: NeuralCurves.plasmaFlow),
    );
    
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowController, curve: NeuralCurves.synapticFire),
    );
    
    if (widget.enableAnimation) {
      _progressController.forward();
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HolographicProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _progressController, curve: NeuralCurves.plasmaFlow),
      );
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = widget.colors ?? 
        (isDark ? FlowAIFuturisticTheme.quantumField : FlowAIFuturisticTheme.synapseGlow);

    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _glowAnimation]),
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow effect
              Container(
                width: widget.size + 20,
                height: widget.size + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.3 + (_glowAnimation.value * 0.4)),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // Background ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: HolographicRingPainter(
                  progress: 1.0,
                  strokeWidth: widget.strokeWidth,
                  colors: colors.map((c) => c.withValues(alpha: 0.2)).toList(),
                  isBackground: true,
                ),
              ),
              
              // Progress ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: HolographicRingPainter(
                  progress: _progressAnimation.value,
                  strokeWidth: widget.strokeWidth,
                  colors: colors,
                  glowIntensity: 0.5 + (_glowAnimation.value * 0.5),
                  enableParticles: widget.enableParticles,
                ),
              ),
              
              // Center content
              if (widget.center != null)
                widget.center!,
            ],
          ),
        );
      },
    );
  }
}

/// Neural Metric Card with advanced visualizations
class NeuralMetricCard extends StatefulWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final IconData icon;
  final String? trendDirection;
  final double? trendValue;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final bool enableRealTimeUpdate;

  const NeuralMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    required this.icon,
    this.trendDirection,
    this.trendValue,
    this.gradientColors,
    this.onTap,
    this.enableRealTimeUpdate = false,
  });

  @override
  State<NeuralMetricCard> createState() => _NeuralMetricCardState();
}

class _NeuralMetricCardState extends State<NeuralMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _updateController;
  late Animation<double> _updateAnimation;

  @override
  void initState() {
    super.initState();
    
    _updateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _updateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _updateController, curve: NeuralCurves.synapticFire),
    );
    
    if (widget.enableRealTimeUpdate) {
      _updateController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _updateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = widget.gradientColors ?? 
        FlowAIFuturisticTheme.getTimeBasedGradient();

    return NeuralCard(
      onTap: widget.onTap,
      gradientColors: colors,
      enableHolography: true,
      glowIntensity: widget.enableRealTimeUpdate ? 0.8 : 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and trend
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.trendDirection != null)
                _buildTrendIndicator(),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Value display
          AnimatedBuilder(
            animation: _updateAnimation,
            builder: (context, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: colors,
                    ).createShader(bounds),
                    child: Text(
                      widget.value,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 28 + (_updateAnimation.value * 4),
                      ),
                    ),
                  ),
                  if (widget.unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      widget.unit!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.first,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    Color trendColor;
    IconData trendIcon;
    
    switch (widget.trendDirection?.toLowerCase()) {
      case 'up':
        trendColor = FlowAIFuturisticTheme.matrixGreen.first;
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = FlowAIFuturisticTheme.plasmaBurst.first;
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor = FlowAIFuturisticTheme.holoBlue;
        trendIcon = Icons.trending_flat;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: trendColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trendIcon, color: trendColor, size: 16),
          if (widget.trendValue != null) ...[
            const SizedBox(width: 4),
            Text(
              '${widget.trendValue!.toStringAsFixed(1)}%',
              style: TextStyle(
                color: trendColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Advanced Section Header with neural styling
class NeuralSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final List<Color>? gradientColors;
  final bool enableGlow;

  const NeuralSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.gradientColors,
    this.enableGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? FlowAIFuturisticTheme.getTimeBasedGradient();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(12),
                boxShadow: enableGlow ? [
                  BoxShadow(
                    color: colors.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: colors,
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.first.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (actionText != null && onActionPressed != null)
            QuantumButton(
              text: actionText!,
              onPressed: onActionPressed,
              gradientColors: colors,
              width: 100,
              height: 36,
              enableParticles: false,
            ),
        ],
      ),
    );
  }
}

/// Custom painter for particle effects
class ParticlePainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;
  
  ParticlePainter({
    required this.animationValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    final random = math.Random(42); // Fixed seed for consistent pattern
    
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 1 + random.nextDouble() * 3;
      
      final phase = (animationValue + random.nextDouble()) % 1.0;
      final opacity = math.sin(phase * math.pi * 2) * 0.5 + 0.5;
      
      paint.color = colors[i % colors.length].withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for holographic rings
class HolographicRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;
  final double glowIntensity;
  final bool isBackground;
  final bool enableParticles;

  HolographicRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
    this.glowIntensity = 1.0,
    this.isBackground = false,
    this.enableParticles = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (isBackground) {
      // Background ring
      paint.color = colors.first.withValues(alpha: 0.1);
      canvas.drawCircle(center, radius, paint);
    } else {
      // Progress ring with gradient
      final rect = Rect.fromCircle(center: center, radius: radius);
      paint.shader = SweepGradient(
        colors: colors,
        stops: List.generate(colors.length, (i) => i / (colors.length - 1)),
      ).createShader(rect);
      
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        paint,
      );
      
      // Add glow effect
      if (glowIntensity > 0) {
        paint.color = colors.first.withValues(alpha: glowIntensity * 0.3);
        paint.strokeWidth = strokeWidth * 2;
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawArc(
          rect,
          -math.pi / 2,
          sweepAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
