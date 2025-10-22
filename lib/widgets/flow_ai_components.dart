import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../themes/flow_ai_visual_system.dart';
import '../performance/animation_performance.dart';

/// Flow iQ Clinical Component Library
/// 
/// Revolutionary medical-grade components implementing all Flow iQ Clinical Signature Elements:
/// 1. Gradient Flow Lines - Menstrual flow pattern visualization
/// 2. Petal Scatter Patterns - Ovarian follicle arrangements  
/// 3. Pulse Animations - Physiological breathing effects
/// 4. Color Morphing - Hormonal state transitions
/// 5. Depth Layers - Clinical data hierarchy visualization

// === FLOW iQ CLINICAL CARD WITH ALL SIGNATURE ELEMENTS ===

class FlowIQCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool enableBreathing;
  final bool enableFlowLines;
  final bool enablePetalScatter;
  final bool enableColorMorph;
  final List<Color>? morphColors;

  const FlowIQCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.enableBreathing = true,
    this.enableFlowLines = true,
    this.enablePetalScatter = false,
    this.enableColorMorph = true,
    this.morphColors,
  });

  @override
  State<FlowIQCard> createState() => _FlowIQCardState();
}

class _FlowIQCardState extends State<FlowIQCard>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _flowController;
  late AnimationController _morphController;
  
  late Animation<double> _breathingAnimation;
  late Animation<double> _flowAnimation;
  late Animation<double> _morphAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _breathingController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _flowController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    
    _morphController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    
    _breathingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _breathingController, curve: FlowIQCurves.breathingPulse),
    );
    
    _flowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flowController, curve: Curves.linear),
    );
    
    _morphAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _morphController, curve: FlowIQCurves.colorMorph),
    );
    
    if (widget.enableBreathing) _breathingController.repeat(reverse: true);
    if (widget.enableFlowLines) _flowController.repeat();
    if (widget.enableColorMorph) _morphController.repeat();
  }
  
  @override
  void dispose() {
    _breathingController.dispose();
    _flowController.dispose();
    _morphController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingAnimation,
        _flowAnimation,
        _morphAnimation,
      ]),
      builder: (context, child) {
        final breathingScale = widget.enableBreathing 
            ? FlowIQVisualSystem.breathingCurve(_breathingAnimation.value)
            : 1.0;
            
        return Transform.scale(
          scale: breathingScale,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: _buildCardDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Stack(
                        children: [
                          // Background flow lines
                          if (widget.enableFlowLines)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: FlowLinesPainter(
                                  animationValue: _flowAnimation.value,
                                colors: widget.morphColors ?? FlowIQVisualSystem.flowLineGradient,
                                ),
                              ),
                            ),
                          
                          // Petal scatter pattern
                          if (widget.enablePetalScatter)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PetalScatterPainter(
                                  animationValue: _flowAnimation.value,
                                ),
                              ),
                            ),
                          
                          // Main content
                          Padding(
                            padding: widget.padding ?? const EdgeInsets.all(20),
                            child: widget.child,
                          ),
                        ],
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
  
  BoxDecoration _buildCardDecoration() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = widget.morphColors ?? FlowIQVisualSystem.emotionalMorph;
    
    Color morphedColor = widget.enableColorMorph
        ? FlowIQVisualSystem.parametricColorMorph(_morphAnimation.value, colors)
        : colors.first;
    
    return FlowIQVisualSystem.createGlassNeumorphism(
      backgroundColor: morphedColor,
      opacity: 0.1,
      blurRadius: 20,
    );
  }
}

// === FLOW AI COMPONENT ALIASES ===
// FlowAI components that alias to FlowIQ components

/// FlowAI Card - alias to FlowIQ Card
class FlowAICard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool enableBreathing;
  final bool enableFlowLines;
  final bool enablePetalScatter;
  final bool enableColorMorph;
  final List<Color>? morphColors;

  const FlowAICard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.enableBreathing = true,
    this.enableFlowLines = true,
    this.enablePetalScatter = false,
    this.enableColorMorph = true,
    this.morphColors,
  });

  @override
  Widget build(BuildContext context) {
    return FlowIQCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      enableBreathing: enableBreathing,
      enableFlowLines: enableFlowLines,
      enablePetalScatter: enablePetalScatter,
      enableColorMorph: enableColorMorph,
      morphColors: morphColors,
      child: child,
    );
  }
}

// === FLOW AI BUTTON WITH SIGNATURE ELEMENTS ===

class FlowAIButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color>? gradientColors;
  final double width;
  final double height;
  final bool enableFlowLines;
  final bool enablePulse;

  const FlowAIButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.gradientColors,
    this.width = double.infinity,
    this.height = 56,
    this.enableFlowLines = true,
    this.enablePulse = true,
  });

  @override
  State<FlowAIButton> createState() => _FlowAIButtonState();
}

class _FlowAIButtonState extends State<FlowAIButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _flowController;
  late AnimationController _tapController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _flowAnimation;
  late Animation<double> _tapAnimation;
  
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _flowController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    
    _tapController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: FlowAICurves.breathingPulse),
    );
    
    _flowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flowController, curve: Curves.linear),
    );
    
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapController, curve: FlowAICurves.depthTransition),
    );
    
    if (widget.enablePulse) _pulseController.repeat(reverse: true);
    if (widget.enableFlowLines) _flowController.repeat();
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _flowController.dispose();
    _tapController.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _tapController.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _tapController.reverse();
    widget.onPressed?.call();
  }
  
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _tapController.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ?? FlowAIVisualSystem.flowLineGradient;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _flowAnimation, _tapAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _tapAnimation.value * (widget.enablePulse ? _pulseAnimation.value : 1.0),
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: FlowAIVisualSystem.createFlowGradient(_flowAnimation.value, colors: colors),
                borderRadius: BorderRadius.circular(16),
                boxShadow: FlowAIVisualSystem.createDepthShadows(
                  color: colors.first,
                  elevation: _isPressed ? 4.0 : 8.0,
                ),
              ),
              child: Stack(
                children: [
                  // Flow lines background
                  if (widget.enableFlowLines)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomPaint(
                          painter: FlowLinesPainter(
                            animationValue: _flowAnimation.value,
                            colors: colors,
                            opacity: 0.3,
                          ),
                        ),
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
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
        );
      },
    );
  }
}

// === FLOW AI PROGRESS RING WITH PETAL SCATTER ===

class FlowAIProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color>? colors;
  final Widget? center;
  final bool enablePetalScatter;
  final bool enableBreathing;

  const FlowAIProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.colors,
    this.center,
    this.enablePetalScatter = true,
    this.enableBreathing = true,
  });

  @override
  State<FlowAIProgressRing> createState() => _FlowAIProgressRingState();
}

class _FlowAIProgressRingState extends State<FlowAIProgressRing>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _breathingController;
  late AnimationController _scatterController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _scatterAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _progressController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _breathingController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _scatterController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    
    _progressAnimation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _progressController, curve: FlowAICurves.flowEase),
    );
    
    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: FlowAICurves.breathingPulse),
    );
    
    _scatterAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scatterController, curve: Curves.linear),
    );
    
    _progressController.forward();
    if (widget.enableBreathing) _breathingController.repeat(reverse: true);
    if (widget.enablePetalScatter) _scatterController.repeat();
  }
  
  @override
  void didUpdateWidget(FlowAIProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _progressController, curve: FlowAICurves.flowEase),
      );
      _progressController.forward(from: 0);
    }
  }
  
  @override
  void dispose() {
    _progressController.dispose();
    _breathingController.dispose();
    _scatterController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? FlowAIVisualSystem.petalGradient;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_progressAnimation, _breathingAnimation, _scatterAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableBreathing ? _breathingAnimation.value : 1.0,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background depth shadows
                Container(
                  width: widget.size + 20,
                  height: widget.size + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: FlowAIVisualSystem.createDepthShadows(
                      color: colors.first,
                      elevation: 12,
                    ),
                  ),
                ),
                
                // Petal scatter background
                if (widget.enablePetalScatter)
                  SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CustomPaint(
                      painter: PetalScatterPainter(
                        animationValue: _scatterAnimation.value,
                        size: widget.size,
                      ),
                    ),
                  ),
                
                // Background ring
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: FlowAIRingPainter(
                    progress: 1.0,
                    strokeWidth: widget.strokeWidth,
                    colors: colors.map((c) => c.withValues(alpha: 0.2)).toList(),
                    isBackground: true,
                  ),
                ),
                
                // Progress ring with flow effect
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: FlowAIRingPainter(
                    progress: _progressAnimation.value,
                    strokeWidth: widget.strokeWidth,
                    colors: colors,
                    animationValue: _scatterAnimation.value,
                  ),
                ),
                
                // Center content
                if (widget.center != null)
                  widget.center!,
              ],
            ),
          ),
        );
      },
    );
  }
}

// === FLOW AI METRIC CARD ===

class FlowAIMetricCard extends StatefulWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final IconData icon;
  final String? trendDirection;
  final double? trendValue;
  final VoidCallback? onTap;
  final bool enableColorMorph;

  const FlowAIMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    required this.icon,
    this.trendDirection,
    this.trendValue,
    this.onTap,
    this.enableColorMorph = true,
  });

  @override
  State<FlowAIMetricCard> createState() => _FlowAIMetricCardState();
}

class _FlowAIMetricCardState extends State<FlowAIMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _morphController;
  late Animation<double> _morphAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _morphController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    _morphAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _morphController, curve: FlowAICurves.colorMorph),
    );
    
    if (widget.enableColorMorph) _morphController.repeat();
  }
  
  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FlowAICard(
      onTap: widget.onTap,
      enableColorMorph: widget.enableColorMorph,
      morphColors: FlowAIVisualSystem.emotionalMorph,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with icon and trend
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: FlowAIVisualSystem.createFlowGradient(
                    widget.enableColorMorph ? _morphAnimation.value : 0,
                    colors: FlowAIVisualSystem.petalGradient,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: FlowAIVisualSystem.createDepthShadows(
                    color: FlowAIVisualSystem.petalGradient.first,
                    elevation: 4,
                  ),
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
          
          // Value display with shader mask
          AnimatedBuilder(
            animation: _morphAnimation,
            builder: (context, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  FlowAIVisualSystem.createFlowShaderMask(
                    colors: FlowAIVisualSystem.emotionalMorph,
                    time: widget.enableColorMorph ? _morphAnimation.value : 0,
                    child: Text(
                      widget.value,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (widget.unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      widget.unit!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: FlowAIVisualSystem.flowPrimary,
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
        trendColor = FlowAIVisualSystem.flowSecondary;
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = FlowAIVisualSystem.flowAccent;
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor = FlowAIVisualSystem.flowBlue;
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

// === CUSTOM PAINTERS FOR SIGNATURE ELEMENTS ===

/// Gradient Flow Lines Painter
class FlowLinesPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;
  final double opacity;
  
  FlowLinesPainter({
    required this.animationValue,
    required this.colors,
    this.opacity = 1.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(colors: colors).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    
    // Create curved flow lines using mathematical functions
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final yOffset = size.height * (i / 4);
      final phase = animationValue * 2 * math.pi + i;
      
      path.moveTo(0, yOffset);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = yOffset + 
                  math.sin((x / size.width) * 2 * math.pi + phase) * 20 +
                  math.cos((x / size.width) * 4 * math.pi + phase * 0.5) * 10;
        path.lineTo(x, y);
      }
      
      paint.color = colors[i % colors.length].withValues(alpha: opacity * (0.3 + i * 0.1));
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// === FLOW IQ COMPONENT ALIASES ===
// FlowIQ components that alias to existing components

/// FlowIQ Button - alias to FlowAI Button
class FlowIQButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color>? gradientColors;
  final double width;
  final double height;
  final bool enableFlowLines;
  final bool enablePulse;

  const FlowIQButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.gradientColors,
    this.width = double.infinity,
    this.height = 56,
    this.enableFlowLines = true,
    this.enablePulse = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlowAIButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      gradientColors: gradientColors,
      width: width,
      height: height,
      enableFlowLines: enableFlowLines,
      enablePulse: enablePulse,
    );
  }
}

/// FlowIQ Metric Card - alias to FlowAI Metric Card
class FlowIQMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final IconData icon;
  final String? trendDirection;
  final double? trendValue;
  final VoidCallback? onTap;
  final bool enableColorMorph;

  const FlowIQMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    required this.icon,
    this.trendDirection,
    this.trendValue,
    this.onTap,
    this.enableColorMorph = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlowAIMetricCard(
      title: title,
      value: value,
      unit: unit,
      subtitle: subtitle,
      icon: icon,
      trendDirection: trendDirection,
      trendValue: trendValue,
      onTap: onTap,
      enableColorMorph: enableColorMorph,
    );
  }
}

/// FlowIQ Progress Ring - alias to FlowAI Progress Ring
class FlowIQProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color>? colors;
  final Widget? center;
  final bool enablePetalScatter;
  final bool enableBreathing;

  const FlowIQProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.colors,
    this.center,
    this.enablePetalScatter = true,
    this.enableBreathing = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlowAIProgressRing(
      progress: progress,
      size: size,
      strokeWidth: strokeWidth,
      colors: colors,
      center: center,
      enablePetalScatter: enablePetalScatter,
      enableBreathing: enableBreathing,
    );
  }
}

/// Petal Scatter Pattern Painter
class PetalScatterPainter extends CustomPainter {
  final double animationValue;
  final double size;
  
  PetalScatterPainter({
    required this.animationValue,
    this.size = 120,
  });
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    
    // Generate organic petal arrangements
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi + animationValue;
      final radius = size * 0.3 + math.sin(animationValue * 3 + i) * 20;
      
      final x = canvasSize.width / 2 + math.cos(angle) * radius;
      final y = canvasSize.height / 2 + math.sin(angle) * radius;
      
      final petalSize = 3 + math.sin(animationValue * 2 + i) * 2;
      final opacity = 0.3 + math.sin(animationValue + i) * 0.2;
      
      paint.color = FlowAIVisualSystem.petalGradient[i % FlowAIVisualSystem.petalGradient.length]
          .withValues(alpha: opacity);
      
      // Draw petal shapes
      final path = Path();
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: petalSize));
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Flow AI Ring Painter with Mathematical Progression
class FlowAIRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;
  final double animationValue;
  final bool isBackground;
  
  FlowAIRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
    this.animationValue = 0.0,
    this.isBackground = false,
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
      paint.color = colors.first.withValues(alpha: 0.1);
      canvas.drawCircle(center, radius, paint);
    } else {
      // Progress ring with flow gradient
      final rect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = 2 * math.pi * progress;
      
      // Create flowing gradient shader
      paint.shader = SweepGradient(
        colors: colors,
        stops: List.generate(colors.length, (i) => 
          (i / (colors.length - 1) + animationValue) % 1.0,
        ),
      ).createShader(rect);
      
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
