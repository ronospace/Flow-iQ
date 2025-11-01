import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../widgets/flow_ai_components.dart';
import '../themes/flow_ai_visual_system.dart';
import '../performance/animation_performance.dart';

/// Flow iQ Clinical Home Screen
/// 
/// Revolutionary medical-grade home experience showcasing:
/// - Clinical-precision menstrual cycle tracking
/// - Medical-grade hormonal state monitoring  
/// - Biorhythm-inspired particle visualizations
/// - Clinical data hierarchy with depth layers
/// - Medical visualization with custom painters
/// - Clinical surfaces with glassmorphism
/// - Hardware-accelerated medical interfaces
/// - Physiological rhythm animations
/// - Medical data shader visualizations
/// - Clinical-grade performance optimization

class FlowIQHomeScreen extends StatefulWidget {
  const FlowIQHomeScreen({super.key});

  @override
  State<FlowIQHomeScreen> createState() => _FlowIQHomeScreenState();
}

class _FlowIQHomeScreenState extends State<FlowIQHomeScreen>
    with TickerProviderStateMixin {
  
  // === ALL 10 CLINICAL VISUAL TECHNIQUES CONTROLLERS ===
  late AnimationController _flowLinesController;      // 1. Mathematical Gradient Animations
  late AnimationController _shadowSystemController;   // 2. Multi-Layer Shadow System
  late AnimationController _particleController;       // 3. Floating Particle System
  late AnimationController _radialController;         // 4. Radial Gradient Depth
  late AnimationController _breathingController;      // 8. Pulse/Breathing Animations
  late AnimationController _colorMorphController;     // 9. Shader Mask Gradients
  late AnimationController _backgroundController;     // Background flow
  
  // === CLINICAL SIGNATURE ELEMENTS ANIMATIONS ===
  late Animation<double> _flowLinesAnimation;
  late Animation<double> _shadowSystemAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _radialAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _colorMorphAnimation;
  late Animation<double> _backgroundAnimation;
  
  // === CLINICAL CYCLE DATA ===
  String _currentPhase = 'follicular';
  double _cycleProgress = 0.67;
  String _hormonalState = 'balanced'; // elevated, balanced, declining, peak, low
  
  @override
  void initState() {
    super.initState();
    _setupClinicalVisualTechniques();
    _startFlowIQAnimations();
  }
  
  void _setupClinicalVisualTechniques() {
    // === TECHNIQUE 1: MATHEMATICAL GRADIENT ANIMATIONS ===
    _flowLinesController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    
    // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===
    _shadowSystemController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    
    // === TECHNIQUE 3: FLOATING PARTICLE SYSTEM ===
    _particleController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    
    // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===
    _radialController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );
    
    // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===
    _breathingController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    // === TECHNIQUE 9: SHADER MASK GRADIENTS ===
    _colorMorphController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );
    
    // === BACKGROUND FLOW ===
    _backgroundController = FlowIQAnimationFactory.createOptimizedController(
      vsync: this,
      duration: const Duration(milliseconds: 15000),
    );
    
    // === SETUP CLINICAL ANIMATIONS ===
    _flowLinesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flowLinesController, curve: Curves.linear),
    );
    
    _shadowSystemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shadowSystemController, curve: FlowIQCurves.depthTransition),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    
    _radialAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _radialController, curve: Curves.linear),
    );
    
    _breathingAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathingController, curve: FlowIQCurves.breathingPulse),
    );
    
    _colorMorphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorMorphController, curve: FlowIQCurves.colorMorph),
    );
    
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
  }
  
  void _startFlowIQAnimations() {
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
              gradient: FlowIQVisualSystem.createFlowGradient(
                _backgroundAnimation.value,
                colors: _getHormonalGradient(),
              ),
            ),
            child: Stack(
              children: [
                // === TECHNIQUE 4: RADIAL GRADIENT DEPTH ===
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: FlowIQVisualSystem.createDepthRadial(
                        colors: FlowIQVisualSystem.petalGradient.map((c) => 
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
                      colors: FlowIQVisualSystem.flowLineGradient,
                      opacity: 0.3,
                    ),
                  ),
                ),
                
                // === TECHNIQUE 3: FLOATING PARTICLE SYSTEM ===
                Positioned.fill(
                  child: CustomPaint(
                    painter: FloatingParticlesPainter(
                      animationValue: _particleAnimation.value,
                      particles: FlowIQVisualSystem.generateOrbitalParticles(15),
                    ),
                  ),
                ),
                
                // === MAIN CLINICAL CONTENT WITH ALL TECHNIQUES ===
                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // === TECHNIQUE 6 & 9: GLASSMORPHISM + SHADER MASK ===
                      _buildFlowIQAppBar(isDark),
                      
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // === CLINICAL HORMONAL WELCOME ===
                            _buildClinicalWelcome(isDark),
                            const SizedBox(height: 24),
                            
                            // === ALL CLINICAL SIGNATURE ELEMENTS COMBINED ===
                            _buildClinicalCycleCenter(isDark),
                            const SizedBox(height: 32),
                            
                            // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM ===
                            _buildClinicalMetricsGrid(isDark),
                            const SizedBox(height: 32),
                            
                            // === SIGNATURE ELEMENT 2: PETAL SCATTER PATTERNS ===
                            _buildClinicalPredictions(isDark),
                            const SizedBox(height: 32),
                            
                            // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS ===
                            _buildClinicalActions(isDark),
                            const SizedBox(height: 32),
                            
                            // === ALL TECHNIQUES CLINICAL SHOWCASE ===
                            _buildFlowIQInsights(isDark),
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
      floatingActionButton: _buildFlowIQFAB(isDark),
    );
  }
  
  // === HORMONAL STATE BASED GRADIENTS ===
  List<Color> _getHormonalGradient() {
    switch (_hormonalState) {
      case 'elevated':
        return [FlowIQVisualSystem.emotionalMorph[0], ...FlowIQVisualSystem.petalGradient];
      case 'balanced':
        return [FlowIQVisualSystem.emotionalMorph[1], ...FlowIQVisualSystem.flowLineGradient];
      case 'declining':
        return [FlowIQVisualSystem.emotionalMorph[2], ...FlowIQVisualSystem.petalGradient];
      case 'peak':
        return [FlowIQVisualSystem.emotionalMorph[3], ...FlowIQVisualSystem.flowLineGradient];
      case 'low':
        return [FlowIQVisualSystem.emotionalMorph[4], ...FlowIQVisualSystem.petalGradient];
      default:
        return FlowIQVisualSystem.emotionalMorph;
    }
  }
  
  // === TECHNIQUE 6 & 9: GLASSMORPHISM + SHADER MASK APP BAR ===
  Widget _buildFlowIQAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: FlowIQVisualSystem.createFlowShaderMask(
          colors: FlowIQVisualSystem.emotionalMorph,
          time: _colorMorphAnimation.value,
          child: const Text(
            'Flow iQ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        background: Container(
          decoration: FlowIQVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowIQVisualSystem.flowPrimary,
            opacity: 0.1,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: FlowIQVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowIQVisualSystem.flowSecondary,
            opacity: 0.2,
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: FlowIQVisualSystem.parametricColorMorph(
                _colorMorphAnimation.value, 
                FlowIQVisualSystem.emotionalMorph,
              ),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: FlowIQVisualSystem.createGlassNeumorphism(
            backgroundColor: FlowIQVisualSystem.flowAccent,
            opacity: 0.2,
          ),
          child: IconButton(
            icon: Icon(
              Icons.medical_services,
              color: FlowIQVisualSystem.parametricColorMorph(
                _colorMorphAnimation.value, 
                FlowIQVisualSystem.emotionalMorph,
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
  
  // === CLINICAL HORMONAL WELCOME ===
  Widget _buildClinicalWelcome(bool isDark) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: FlowIQCard(
        enableBreathing: false,
        enableColorMorph: true,
        enableFlowLines: true,
        morphColors: _getHormonalGradient(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlowIQVisualSystem.createFlowShaderMask(
                        colors: FlowIQVisualSystem.emotionalMorph,
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
                        'Your clinical flow is in perfect harmony',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // === TECHNIQUE 8: PULSE/BREATHING + SIGNATURE ELEMENT 2: PETAL SCATTER ===
                FlowIQProgressRing(
                  progress: _cycleProgress,
                  size: 90,
                  colors: _getHormonalGradient(),
                  enablePetalScatter: true,
                  enableBreathing: true,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlowIQVisualSystem.createFlowShaderMask(
                        colors: _getHormonalGradient(),
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
            // === HORMONAL STATE SELECTOR ===
            _buildHormonalStateSelector(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHormonalStateSelector() {
    final hormonalStates = ['elevated', 'balanced', 'declining', 'peak', 'low'];
    final stateIcons = [Icons.trending_up, Icons.balance, Icons.trending_down, Icons.keyboard_double_arrow_up, Icons.keyboard_double_arrow_down];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: hormonalStates.asMap().entries.map((entry) {
        final index = entry.key;
        final state = entry.value;
        final isSelected = _hormonalState == state;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _hormonalState = state;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: isSelected 
                ? LinearGradient(colors: [
                    FlowIQVisualSystem.emotionalMorph[index],
                    FlowIQVisualSystem.emotionalMorph[index].withValues(alpha: 0.7),
                  ])
                : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlowIQVisualSystem.emotionalMorph[index].withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              stateIcons[index],
              color: isSelected ? Colors.white : FlowIQVisualSystem.emotionalMorph[index],
              size: 20,
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // === ALL CLINICAL SIGNATURE ELEMENTS COMBINED ===
  Widget _buildClinicalCycleCenter(bool isDark) {
    return FlowIQCard(
      enableBreathing: true,
      enableFlowLines: true,
      enablePetalScatter: true,
      enableColorMorph: true,
      morphColors: _getHormonalGradient(),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: 24,
                color: FlowIQVisualSystem.parametricColorMorph(
                  _colorMorphAnimation.value,
                  _getHormonalGradient(),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FlowIQVisualSystem.createFlowShaderMask(
                  colors: _getHormonalGradient(),
                  time: _colorMorphAnimation.value,
                  child: Text(
                    'Clinical Cycle Analysis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // === LARGE CLINICAL PROGRESS RING WITH ALL EFFECTS ===
          FlowIQProgressRing(
            progress: _cycleProgress,
            size: 180,
            colors: _getHormonalGradient(),
            enablePetalScatter: true,
            enableBreathing: true,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlowIQVisualSystem.createFlowShaderMask(
                  colors: _getHormonalGradient(),
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
                    gradient: LinearGradient(colors: _getHormonalGradient()),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: FlowIQVisualSystem.createDepthShadows(
                      color: _getHormonalGradient().first,
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
                  'Clinical fertile window',
                  style: TextStyle(
                    fontSize: 12,
                    color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // === CLINICAL INDICATORS WITH BREATHING ANIMATION ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildClinicalIndicator('Harmony', '96%', Icons.self_improvement, isDark),
              _buildClinicalIndicator('Balance', '89%', Icons.balance, isDark),
              _buildClinicalIndicator('Vitality', '92%', Icons.battery_charging_full, isDark),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildClinicalIndicator(String label, String value, IconData icon, bool isDark) {
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _getHormonalGradient()),
              borderRadius: BorderRadius.circular(12),
              boxShadow: FlowIQVisualSystem.createDepthShadows(
                color: _getHormonalGradient().first,
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
          FlowIQVisualSystem.createFlowShaderMask(
            colors: _getHormonalGradient(),
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
  
  // === TECHNIQUE 2: MULTI-LAYER SHADOW SYSTEM CLINICAL METRICS ===
  Widget _buildClinicalMetricsGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,  // Changed from 1.2 to 1.0 for more height
      children: [
        FlowIQMetricCard(
          title: 'Harmony',  // Shortened from 'Clinical Harmony'
          value: '94',
          unit: '%',
          icon: Icons.waves,
          trendDirection: 'up',
          trendValue: 8.5,
          enableColorMorph: true,
        ),
        FlowIQMetricCard(
          title: 'Balance',  // Shortened from 'Hormonal Balance'
          value: '96.8',
          unit: '%',
          icon: Icons.favorite_border,
          trendDirection: 'stable',
          subtitle: 'Hormonal',  // Shortened from 'Medical precision'
          enableColorMorph: true,
        ),
        FlowIQMetricCard(
          title: 'Clinical',  // Shortened from 'Clinical Prediction'
          value: '98',
          unit: '%',
          icon: Icons.auto_awesome,
          trendDirection: 'up',
          trendValue: 12.3,
          enableColorMorph: true,
        ),
        FlowIQMetricCard(
          title: 'Wellness',  // Shortened from 'Medical Wellness'
          value: '92.1',
          unit: '%',
          icon: Icons.medical_services,
          trendDirection: 'up',
          subtitle: 'Medical',  // Shortened from 'Thriving'
          enableColorMorph: true,
        ),
      ],
    );
  }
  
  // === SIGNATURE ELEMENT 2: PETAL SCATTER PATTERNS CLINICAL PREDICTIONS ===
  Widget _buildClinicalPredictions(bool isDark) {
    return Column(
      children: [
        FlowIQCard(
          enablePetalScatter: true,
          enableColorMorph: true,
          morphColors: _getHormonalGradient(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: FlowIQVisualSystem.parametricColorMorph(
                      _colorMorphAnimation.value,
                      _getHormonalGradient(),
                    ),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  FlowIQVisualSystem.createFlowShaderMask(
                    colors: _getHormonalGradient(),
                    time: _colorMorphAnimation.value,
                    child: Text(
                      'Clinical Flow Prediction',
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
                        FlowIQVisualSystem.createFlowShaderMask(
                          colors: _getHormonalGradient(),
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
                    decoration: FlowIQVisualSystem.createGlassNeumorphism(
                      backgroundColor: FlowIQVisualSystem.flowSecondary,
                      opacity: 0.2,
                    ),
                    child: Text(
                      '98% Clinical',
                      style: TextStyle(
                        color: FlowIQVisualSystem.flowSecondary,
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
              child: FlowIQCard(
                enablePetalScatter: true,
                child: Column(
                  children: [
                    Icon(
                      Icons.mood,
                      color: FlowIQVisualSystem.parametricColorMorph(
                        _colorMorphAnimation.value,
                        [FlowIQVisualSystem.flowPink],
                      ),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hormonal Flow',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    FlowIQVisualSystem.createFlowShaderMask(
                      colors: [FlowIQVisualSystem.flowPink],
                      time: _colorMorphAnimation.value,
                      child: Text(
                        'Balanced',
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
              child: FlowIQCard(
                enablePetalScatter: true,
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: FlowIQVisualSystem.parametricColorMorph(
                        _colorMorphAnimation.value,
                        [FlowIQVisualSystem.flowSecondary],
                      ),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Clinical Flow',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    FlowIQVisualSystem.createFlowShaderMask(
                      colors: [FlowIQVisualSystem.flowSecondary],
                      time: _colorMorphAnimation.value,
                      child: Text(
                        'Optimal',
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
  
  // === TECHNIQUE 8: PULSE/BREATHING ANIMATIONS CLINICAL ACTIONS ===
  Widget _buildClinicalActions(bool isDark) {
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
          child: FlowIQButton(
            text: 'Clinical Log',
            icon: Icons.medical_information,
            gradientColors: _getHormonalGradient(),
            onPressed: () {},
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 0.98,
          child: FlowIQButton(
            text: 'Medical Insights',
            icon: Icons.auto_awesome,
            gradientColors: FlowIQVisualSystem.petalGradient,
            onPressed: () {
              Navigator.pushNamed(context, '/insights');
            },
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 1.02,
          child: FlowIQButton(
            text: 'Clinical Sync',
            icon: Icons.sync,
            gradientColors: FlowIQVisualSystem.flowLineGradient,
            onPressed: () {},
          ),
        ),
        Transform.scale(
          scale: _breathingAnimation.value * 0.99,
          child: FlowIQButton(
            text: 'Health Monitor',
            icon: Icons.monitor_heart,
            gradientColors: FlowIQVisualSystem.emotionalMorph,
            onPressed: () {
              Navigator.pushNamed(context, '/health');
            },
          ),
        ),
      ],
    );
  }
  
  // === ALL CLINICAL TECHNIQUES SHOWCASE INSIGHTS ===
  Widget _buildFlowIQInsights(bool isDark) {
    return FlowIQCard(
      enableBreathing: true,
      enableFlowLines: true,
      enablePetalScatter: false,
      enableColorMorph: true,
      morphColors: _getHormonalGradient(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: FlowIQVisualSystem.parametricColorMorph(
                  _colorMorphAnimation.value,
                  _getHormonalGradient(),
                ),
                size: 24,
              ),
              const SizedBox(width: 8),
              FlowIQVisualSystem.createFlowShaderMask(
                colors: _getHormonalGradient(),
                time: _colorMorphAnimation.value,
                child: Text(
                  'Flow iQ Clinical Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildClinicalInsightItem(
            'Perfect clinical flow detected',
            'Your cycle rhythm shows medical-grade harmony with natural patterns',
            Icons.waves,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildClinicalInsightItem(
            'Optimal medical window',
            'Clinical analysis shows perfect timing for wellness activities',
            Icons.auto_awesome,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildClinicalInsightItem(
            'Clinical vitality optimization',
            'Medical data shows your body is naturally energized and balanced',
            Icons.battery_charging_full,
            isDark,
          ),
        ],
      ),
    );
  }
  
  Widget _buildClinicalInsightItem(String title, String subtitle, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _getHormonalGradient()),
            borderRadius: BorderRadius.circular(12),
            boxShadow: FlowIQVisualSystem.createDepthShadows(
              color: _getHormonalGradient().first,
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
              FlowIQVisualSystem.createFlowShaderMask(
                colors: _getHormonalGradient(),
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
  Widget _buildFlowIQFAB(bool isDark) {
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _getHormonalGradient()),
          shape: BoxShape.circle,
          boxShadow: FlowIQVisualSystem.createDepthShadows(
            color: _getHormonalGradient().first,
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
              decoration: FlowIQVisualSystem.createGlassNeumorphism(
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

// === CUSTOM PAINTERS FOR ADDITIONAL CLINICAL EFFECTS ===

/// Enhanced Floating Particles with Clinical Biorhythm Animations
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
      // Calculate clinical orbital position with biorhythmic harmonics
      final primaryAngle = particle.initialAngle + animationValue * particle.speed * 2 * math.pi;
      final biorhythmOffset = math.sin(animationValue * 4 * math.pi + particle.initialAngle) * 20;
      
      final x = center.dx + math.cos(primaryAngle) * (particle.radius + biorhythmOffset);
      final y = center.dy + math.sin(primaryAngle) * (particle.radius + biorhythmOffset) * 0.7;
      
      // Multi-layered clinical particle effect
      final pulseScale = 1.0 + 0.4 * math.sin(animationValue * 6 * math.pi + particle.initialAngle);
      final currentSize = particle.size * pulseScale;
      final opacity = particle.opacity * (0.5 + 0.5 * math.sin(animationValue * math.pi));
      
      // Outer clinical glow
      paint.color = particle.color.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, y), currentSize * 2, paint);
      
      // Inner clinical particle
      paint.color = particle.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), currentSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
