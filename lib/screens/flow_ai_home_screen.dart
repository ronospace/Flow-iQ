import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../widgets/flow_ai_components.dart';
import '../themes/flow_ai_visual_system.dart';
import '../performance/animation_performance.dart';

class FlowAIHomeScreen extends StatefulWidget {
  const FlowAIHomeScreen({super.key});

  @override
  State<FlowAIHomeScreen> createState() => _FlowAIHomeScreenState();
}

class _FlowAIHomeScreenState extends State<FlowAIHomeScreen>
    with TickerProviderStateMixin {
  
  // === ALL 10 VISUAL TECHNIQUES CONTROLLERS ===
  late AnimationController _flowLinesController;      // 1. Mathematical Gradient Animations
  late AnimationController _shadowSystemController;   // 2. Multi-Layer Shadow System
  late AnimationController _particleController;       // 3. Floating Particle System
  late AnimationController _radialController;         // 4. Radial Gradient Depth
  late AnimationController _breathingController;      // 8. Pulse/Breathing Animations
  late AnimationController _colorMorphController;     // 9. Shader Mask Gradients
  late AnimationController _backgroundController;     // Background flow
  
  // === SIGNATURE ELEMENTS ANIMATIONS ===
  late Animation<double> _flowLinesAnimation;
  late Animation<double> _shadowSystemAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _radialAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _colorMorphAnimation;
  late Animation<double> _backgroundAnimation;
  
  // === CYCLE DATA ===
  String _currentPhase = 'follicular';
  double _cycleProgress = 0.67;
  String _emotionalState = 'calm'; // joy, calm, focus, peace, love
  
  @override
  void initState() {
    super.initState();
    _setupAllVisualTechniques();
    _startFlowAIAnimations();
  }
  
  void _setupAllVisualTechniques() {
    // === TECHNIQUE 1: MATHEMATICAL GRADIENT ANIMATIONS ===
    _flowLinesController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    
    // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===
    _shadowSystemController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    
    // === TECHNIQUE 3: FLOATING PARTICLE SYSTEM ===
    _particleController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    
    // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===
    _radialController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );
    
    // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===
    _breathingController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    // === TECHNIQUE 9: SHADER MASK GRADIENTS ===
    _colorMorphController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );
    
    // === BACKGROUND FLOW ===
    _backgroundController = FlowAIAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 15000),
    );
    
    // === SETUP ANIMATIONS ===
    _flowLinesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flowLinesController, curve: Curves.linear),
    );
    
    _shadowSystemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shadowSystemController, curve: FlowAICurves.depthTransition),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    
    _radialAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _radialController, curve: Curves.linear),
    );
    
    _breathingAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathingController, curve: FlowAICurves.breathingPulse),
    );
    
    _colorMorphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorMorphController, curve: FlowAICurves.colorMorph),
    );
    
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
  }
  
  void _startFlowAIAnimations() {
    _flowLinesController.repeat();
    _shadowSystemController.repeat(reverse: true);
    _particleController.repeat();
    _radialController.repeat();
    _breathingController.repeat(reverse: true);
    _colorMorphController.repeat();
    _backgroundController.repeat();
  }
  
  @override
  void dispose() {
    _flowLinesController.dispose();
    _shadowSystemController.dispose();
    _particleController.dispose();
    _radialController.dispose();
    _breathingController.dispose();
    _colorMorphController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _flowLinesAnimation,
          _shadowSystemAnimation,
          _particleAnimation,
          _radialAnimation,
          _breathingAnimation,
          _colorMorphAnimation,
          _backgroundAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              // === TECHNIQUE 1: MATHEMATICAL GRADIENT ANIMATIONS ===
              gradient: FlowAIVisualSystem.createFlowGradient(
                _backgroundAnimation.value,
                colors: _getEmotionalGradient(),
              ),
            ),
            child: Stack(
              children: [
                // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: FlowAIVisualSystem.createDepthRadial(
                        colors: FlowAIVisualSystem.petalGradient.map((c) => 
                          c.withValues(alpha: 0.2 * math.sin(_radialAnimation.value * math.pi))
                        ).toList(),
                      ),
                    ),
                  ),
                ),
                
                // === SIGNATURE ELEMENT 1: GRADIENT FLOW LINES ===
                Positioned.fill(
                  child: CustomPaint(
                    painter: FlowLinesPainter(
                      animationValue: _flowLinesAnimation.value,
                      colors: FlowAIVisualSystem.flowLineGradient,
                      opacity: 0.3,
                    ),
                  ),
                ),
                
                // === TECHNIQUE 3: FLOATING PARTICLE SYSTEM ===
                Positioned.fill(
                  child: CustomPaint(
                    painter: FloatingParticlesPainter(
                      animationValue: _particleAnimation.value,
                      particles: FlowAIVisualSystem.generateOrbitalParticles(15),
                    ),
                  ),
                ),
                
                // === MAIN CONTENT WITH ALL TECHNIQUES ===
                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // === TECHNIQUE 6 & 9: GLASSMORPHISM + SHADER MASK ===
                      _buildFlowAIAppBar(isDark),
                      
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // === SIGNATURE ELEMENT 4: COLOR MORPHING ===
                            _buildEmotionalWelcome(isDark),
                            const SizedBox(height: 24),
                            
                            // === ALL SIGNATURE ELEMENTS COMBINED ===
                            _buildCycleFlowCenter(isDark),
                            const SizedBox(height: 32),
                            
                            // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===
                            _buildDepthMetricsGrid(isDark),
                            const SizedBox(height: 32),
                            
                            // === SIGNATURE ELEMENT 2: PETAL SCATTER PATTERNS ===
                            _buildPetalPredictions(isDark),
                            const SizedBox(height: 32),
                            
                            // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===
                            _buildBreathingActions(isDark),
                            const SizedBox(height: 32),
                            
                            // === ALL TECHNIQUES SHOWCASE ===
                            _buildFlowAIInsights(isDark),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // === TECHNIQUE 5 & 6: CUSTOM PAINT + GLASSMORPHISM FAB ===
      floatingActionButton: _buildFlowAIFAB(isDark),
    );
  }
  
  // === EMOTIONAL STATE BASED GRADIENTS ===
  List<Color> _getEmotionalGradient() {
    switch (_emotionalState) {
      case 'joy':
        return [FlowAIVisualSystem.emotionalMorph[0], ...FlowAIVisualSystem.petalGradient];
      case 'calm':
        return [FlowAIVisualSystem.emotionalMorph[1], ...FlowAIVisualSystem.flowLineGradient];
      case 'focus':
        return [FlowAIVisualSystem.emotionalMorph[2], ...FlowAIVisualSystem.petalGradient];
      case 'peace':
        return [FlowAIVisualSystem.emotionalMorph[3], ...FlowAIVisualSystem.flowLineGradient];
      case 'love':
        return [FlowAIVisualSystem.emotionalMorph[4], ...FlowAIVisualSystem.petalGradient];
      default:
        return FlowAIVisualSystem.emotionalMorph;
    }
  }
  
  // === TECHNIQUE 6 & 9: GLASSMORPHISM + SHADER MASK APP BAR ===
  Widget _buildFlowAIAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: FlowAIVisualSystem.createFlowShaderMask(
          colors: FlowAIVisualSystem.emotionalMorph,
          time: _colorMorphAnimation.value,
          child: const Text(
            'Flow AI',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        background: Container(
          decoration: FlowAIVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowAIVisualSystem.flowPrimary,
            opacity: 0.1,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: FlowAIVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowAIVisualSystem.flowSecondary,
            opacity: 0.2,
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications,
              color: FlowAIVisualSystem.parametricColorMorph(
                _colorMorphAnimation.value, 
                FlowAIVisualSystem.emotionalMorph,
              ),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: FlowAIVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowAIVisualSystem.flowAccent,
            opacity: 0.2,
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: FlowAIVisualSystem.parametricColorMorph(
                _colorMorphAnimation.value, 
                FlowAIVisualSystem.emotionalMorph,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ),
      ],
    );
  }
  
  // === SIGNATURE ELEMENT 4: COLOR MORPHING WELCOME ===
  Widget _buildEmotionalWelcome(bool isDark) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: FlowAICard(
        enableBreathing: false,
        enableColorMorph: true,
        enableFlowLines: true,
        morphColors: _getEmotionalGradient(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlowAIVisualSystem.createFlowShaderMask(
                        colors: FlowAIVisualSystem.emotionalMorph,
                        time: _colorMorphAnimation.value,
                        child: Text(
                          '$greeting, Beautiful',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your flow is perfectly in harmony',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // === TECHNIQUE 8: PULSE/BREATHING + SIGNATURE ELEMENT 2: PETAL SCATTER ===
                FlowAIProgressRing(
                  progress: _cycleProgress,
                  size: 90,
                  colors: _getEmotionalGradient(),
                  enablePetalScatter: true,
                  enableBreathing: true,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlowAIVisualSystem.createFlowShaderMask(
                        colors: _getEmotionalGradient(),
                        time: _colorMorphAnimation.value,
                        child: Text(
                          '${(_cycleProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Flow',
                        style: TextStyle(
                          fontSize: 10,
                          color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // === EMOTIONAL STATE SELECTOR ===
            _buildEmotionalStateSelector(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmotionalStateSelector() {
    final emotions = ['joy', 'calm', 'focus', 'peace', 'love'];
    final emotionIcons = [Icons.sentiment_very_satisfied, Icons.self_improvement, Icons.psychology, Icons.spa, Icons.favorite];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: emotions.asMap().entries.map((entry) {
        final index = entry.key;
        final emotion = entry.value;
        final isSelected = _emotionalState == emotion;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _emotionalState = emotion;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: isSelected 
                ? LinearGradient(colors: [FlowAIVisualSystem.emotionalMorph[index]])
                : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlowAIVisualSystem.emotionalMorph[index].withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              emotionIcons[index],
              color: isSelected ? Colors.white : FlowAIVisualSystem.emotionalMorph[index],
              size: 20,
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // === ALL SIGNATURE ELEMENTS COMBINED ===
  Widget _buildCycleFlowCenter(bool isDark) {
    return FlowAICard(
      enableBreathing: true,
      enableFlowLines: true,
      enablePetalScatter: true,
      enableColorMorph: true,
      morphColors: _getEmotionalGradient(),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: 24,
                color: FlowAIVisualSystem.parametricColorMorph(
                  _colorMorphAnimation.value,
                  _getEmotionalGradient(),
                ),
              ),
              const SizedBox(width: 8),
              FlowAIVisualSystem.createFlowShaderMask(
                colors: _getEmotionalGradient(),
                time: _colorMorphAnimation.value,
                child: Text(
                  'Cycle Flow Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // === LARGE FLOW AI PROGRESS RING WITH ALL EFFECTS ===
          FlowAIProgressRing(
            progress: _cycleProgress,
            size: 180,
            colors: _getEmotionalGradient(),
            enablePetalScatter: true,
            enableBreathing: true,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlowAIVisualSystem.createFlowShaderMask(
                  colors: _getEmotionalGradient(),
                  time: _colorMorphAnimation.value,
                  child: Text(
                    'Day 18',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _getEmotionalGradient()),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: FlowAIVisualSystem.createDepthShadows(
                      color: _getEmotionalGradient().first,
                      elevation: 4,
                    ),
                  ),
                  child: Text(
                    _currentPhase.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Optimal fertile window',
                  style: TextStyle(
                    fontSize: 12,
                    color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // === FLOW INDICATORS WITH BREATHING ANIMATION ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFlowIndicator('Harmony', '96%', Icons.self_improvement, isDark),
              _buildFlowIndicator('Balance', '89%', Icons.balance, isDark),
              _buildFlowIndicator('Energy', '92%', Icons.battery_charging_full, isDark),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFlowIndicator(String label, String value, IconData icon, bool isDark) {
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _getEmotionalGradient()),
              borderRadius: BorderRadius.circular(12),
              boxShadow: FlowAIVisualSystem.createDepthShadows(
                color: _getEmotionalGradient().first,
                elevation: 6,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          FlowAIVisualSystem.createFlowShaderMask(
            colors: _getEmotionalGradient(),
            time: _colorMorphAnimation.value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
  
  // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM METRICS ===
  Widget _buildDepthMetricsGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        FlowAIMetricCard(
          title: 'Flow Harmony',
          value: '94',
          unit: '%',
          icon: Icons.waves,
          trendDirection: 'up',
          trendValue: 8.5,
          enableColorMorph: true,
        ),
        FlowAIMetricCard(
          title: 'Cycle Rhythm',
          value: '96.8',
          unit: '%',
          icon: Icons.favorite_border,
          trendDirection: 'stable',
          subtitle: 'Perfect sync',
          enableColorMorph: true,
        ),
        FlowAIMetricCard(
          title: 'Prediction',
          value: '98',
          unit: '%',
          icon: Icons.auto_awesome,
          trendDirection: 'up',
          trendValue: 12.3,
          enableColorMorph: true,
        ),
        FlowAIMetricCard(
          title: 'Wellness',
          value: '92.1',
          unit: '%',
          icon: Icons.spa,
          trendDirection: 'up',
          subtitle: 'Flourishing',
          enableColorMorph: true,
        ),
      ],
    );
  }
  
  // === SIGNATURE ELEMENT 2: PETAL SCATTER PATTERNS PREDICTIONS ===
  Widget _buildPetalPredictions(bool isDark) {
    return Column(
      children: [
        FlowAICard(
          enablePetalScatter: true,
          enableColorMorph: true,
          morphColors: _getEmotionalGradient(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: FlowAIVisualSystem.parametricColorMorph(
                      _colorMorphAnimation.value,
                      _getEmotionalGradient(),
                    ),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  FlowAIVisualSystem.createFlowShaderMask(
                    colors: _getEmotionalGradient(),
                    time: _colorMorphAnimation.value,
                    child: Text(
                      'Next Flow Prediction',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlowAIVisualSystem.createFlowShaderMask(
                          colors: _getEmotionalGradient(),
                          time: _colorMorphAnimation.value,
                          child: Text(
                            'In 10 days',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'March 18, 2024 • Tuesday',
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: FlowAIVisualSystem.createGlassNeumorphism(
                      backgroundColor: FlowAIVisualSystem.flowSecondary,
                      opacity: 0.2,
                    ),
                    child: Text(
                      '98% Harmony',
                      style: TextStyle(
                        color: FlowAIVisualSystem.flowSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FlowAICard(
                enablePetalScatter: true,
                child: Column(
                  children: [
                    Icon(
                      Icons.mood,
                      color: FlowAIVisualSystem.parametricColorMorph(
                        _colorMorphAnimation.value,
                        [FlowAIVisualSystem.flowPink],
                      ),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mood Flow',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    FlowAIVisualSystem.createFlowShaderMask(
                      colors: [FlowAIVisualSystem.flowPink],
                      time: _colorMorphAnimation.value,
                      child: Text(
                        'Joyful',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FlowAICard(
                enablePetalScatter: true,
                child: Column(
                  children: [
                    Icon(
                      Icons.energy_savings_leaf,
                      color: FlowAIVisualSystem.parametricColorMorph(
                        _colorMorphAnimation.value,
                        [FlowAIVisualSystem.flowSecondary],
                      ),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Energy Flow',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    FlowAIVisualSystem.createFlowShaderMask(
                      colors: [FlowAIVisualSystem.flowSecondary],
                      time: _colorMorphAnimation.value,
                      child: Text(
                        'Vibrant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ACTIONS ===
  Widget _buildBreathingActions(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        Transform.scale(
          scale: _breathingAnimation.value,
          child: FlowAIButton(
            text: 'Flow Log',
            icon: Icons.favorite,
            gradientColors: _getEmotionalGradient(),
            onPressed: () {},
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 0.98, // Slightly different rhythm
          child: FlowAIButton(
            text: 'AI Insights',
            icon: Icons.auto_awesome,
            gradientColors: FlowAIVisualSystem.petalGradient,
            onPressed: () {
              Navigator.pushNamed(context, '/insights');
            },
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 1.02, // Slightly different rhythm
          child: FlowAIButton(
            text: 'Sync Flow',
            icon: Icons.sync,
            gradientColors: FlowAIVisualSystem.flowLineGradient,
            onPressed: () {},
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 0.99, // Slightly different rhythm
          child: FlowAIButton(
            text: 'Wellness',
            icon: Icons.spa,
            gradientColors: FlowAIVisualSystem.emotionalMorph,
            onPressed: () {
              Navigator.pushNamed(context, '/health');
            },
          ),
        ),
      ],
    );
  }
  
  // === ALL TECHNIQUES SHOWCASE INSIGHTS ===
  Widget _buildFlowAIInsights(bool isDark) {
    return FlowAICard(
      enableBreathing: true,
      enableFlowLines: true,
      enablePetalScatter: false,
      enableColorMorph: true,
      morphColors: _getEmotionalGradient(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: FlowAIVisualSystem.parametricColorMorph(
                  _colorMorphAnimation.value,
                  _getEmotionalGradient(),
                ),
                size: 24,
              ),
              const SizedBox(width: 8),
              FlowAIVisualSystem.createFlowShaderMask(
                colors: _getEmotionalGradient(),
                time: _colorMorphAnimation.value,
                child: Text(
                  'Flow AI Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightItem(
            'Perfect flow detected',
            'Your cycle rhythm is in beautiful harmony with your natural patterns',
            Icons.waves,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Optimal wellness window',
            'This is the perfect time for creative pursuits and social connections',
            Icons.auto_awesome,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Energy optimization',
            'Your body is naturally energized - perfect for physical activities',
            Icons.battery_charging_full,
            isDark,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInsightItem(String title, String subtitle, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _getEmotionalGradient()),
            borderRadius: BorderRadius.circular(12),
            boxShadow: FlowAIVisualSystem.createDepthShadows(
              color: _getEmotionalGradient().first,
              elevation: 4,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowAIVisualSystem.createFlowShaderMask(
                colors: _getEmotionalGradient(),
                time: _colorMorphAnimation.value,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // === TECHNIQUE 5 & 6: CUSTOM PAINT + GLASSMORPHISM FAB ===
  Widget _buildFlowAIFAB(bool isDark) {
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _getEmotionalGradient()),
          shape: BoxShape.circle,
          boxShadow: FlowAIVisualSystem.createDepthShadows(
            color: _getEmotionalGradient().first,
            elevation: 12,
            layers: 4,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(35),
            child: Container(
              decoration: FlowAIVisualSystem.createGlassNeumorphism(
                backgroundColor: Colors.white,
                opacity: 0.1,
              ),
              child: const Center(
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === CUSTOM PAINTERS FOR ADDITIONAL EFFECTS ===

/// Enhanced Floating Particles with Orbital Animations
class FloatingParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<ParticleConfig> particles;
  
  FloatingParticlesPainter({
    required this.animationValue,
    required this.particles,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    
    for (final particle in particles) {
      // Calculate orbital position with multiple harmonics
      final primaryAngle = particle.initialAngle + animationValue * particle.speed * 2 * math.pi;
      final secondaryOffset = math.sin(animationValue * 4 * math.pi + particle.initialAngle) * 20;
      
      final x = center.dx + math.cos(primaryAngle) * (particle.radius + secondaryOffset);
      final y = center.dy + math.sin(primaryAngle) * (particle.radius + secondaryOffset) * 0.7;
      
      // Multi-layered particle effect
      final pulseScale = 1.0 + 0.4 * math.sin(animationValue * 6 * math.pi + particle.initialAngle);
      final currentSize = particle.size * pulseScale;
      final opacity = particle.opacity * (0.5 + 0.5 * math.sin(animationValue * math.pi));
      
      // Outer glow
      paint.color = particle.color.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, y), currentSize * 2, paint);
      
      // Inner particle
      paint.color = particle.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), currentSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
