import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../themes/flow_ai_futuristic_theme.dart';
import '../widgets/futuristic_components.dart';

class NeuralHomeScreen extends StatefulWidget {
  const NeuralHomeScreen({super.key});

  @override
  State<NeuralHomeScreen> createState() => _NeuralHomeScreenState();
}

class _NeuralHomeScreenState extends State<NeuralHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _dataUpdateController;
  
  late Animation<double> _backgroundAnimation;
  late Animation<double> _dataUpdateAnimation;
  
  String _currentPhase = 'follicular';
  double _cycleProgress = 0.67;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _simulateRealTimeUpdates();
  }
  
  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _dataUpdateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
    
    _dataUpdateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dataUpdateController, curve: NeuralCurves.synapticFire),
    );
    
    _backgroundController.repeat();
  }
  
  void _simulateRealTimeUpdates() {
    // Simulate real-time data updates
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _dataUpdateController.forward().then((_) {
          _dataUpdateController.reset();
        });
      }
    });
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _dataUpdateController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_backgroundAnimation, _dataUpdateAnimation]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _buildNeuralBackground(isDark),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildNeuralAppBar(isDark),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildQuantumWelcome(isDark),
                        const SizedBox(height: 24),
                        
                        _buildCycleNeuralCenter(isDark),
                        const SizedBox(height: 32),
                        
                        NeuralSectionHeader(
                          title: 'Neural Analytics',
                          subtitle: 'AI-powered insights updating in real-time',
                          icon: Icons.psychology,
                          actionText: 'View All',
                          onActionPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          gradientColors: FlowAIFuturisticTheme.getTimeBasedGradient(),
                        ),
                        
                        _buildNeuralMetricsGrid(isDark),
                        const SizedBox(height: 32),
                        
                        NeuralSectionHeader(
                          title: 'Quantum Predictions',
                          subtitle: 'Advanced ML forecasting',
                          icon: Icons.auto_awesome,
                          gradientColors: FlowAIFuturisticTheme.quantumField,
                        ),
                        
                        _buildPredictionCards(isDark),
                        const SizedBox(height: 32),
                        
                        NeuralSectionHeader(
                          title: 'Holographic Actions',
                          subtitle: 'Quick access to AI features',
                          icon: Icons.flash_on,
                          gradientColors: FlowAIFuturisticTheme.synapseGlow,
                        ),
                        
                        _buildQuantumActions(isDark),
                        const SizedBox(height: 32),
                        
                        _buildNeuralInsights(isDark),
                        const SizedBox(height: 100), // Space for floating elements
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildQuantumFAB(isDark),
    );
  }
  
  LinearGradient _buildNeuralBackground(bool isDark) {
    final baseColors = FlowAIFuturisticTheme.getTimeBasedGradient();
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        if (isDark) ...[
          FlowAIFuturisticTheme.voidBlack,
          baseColors.first.withValues(alpha: 0.1),
          baseColors.last.withValues(alpha: 0.05),
          FlowAIFuturisticTheme.stellarGray,
        ] else ...[
          Colors.grey.shade50,
          baseColors.first.withValues(alpha: 0.05),
          baseColors.last.withValues(alpha: 0.03),
          Colors.white,
        ],
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
      transform: GradientRotation(_backgroundAnimation.value * 0.5),
    );
  }
  
  Widget _buildNeuralAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: FlowAIFuturisticTheme.getTimeBasedGradient(),
          ).createShader(bounds),
          child: const Text(
            'Flow AI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                (isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue)
                    .withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.settings,
            color: isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }
  
  Widget _buildQuantumWelcome(bool isDark) {
    final hour = DateTime.now().hour;
    String greeting = '';
    if (hour < 12) greeting = 'Good morning';
    else if (hour < 17) greeting = 'Good afternoon';
    else greeting = 'Good evening';
    
    return NeuralCard(
      gradientColors: FlowAIFuturisticTheme.getTimeBasedGradient(),
      enableHolography: true,
      glowIntensity: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: FlowAIFuturisticTheme.getTimeBasedGradient(),
                      ).createShader(bounds),
                      child: Text(
                        '$greeting, User',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your neural patterns are being analyzed',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: HolographicProgressRing(
                  progress: _cycleProgress,
                  colors: FlowAIFuturisticTheme.getCyclePhaseGradient(_currentPhase),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(_cycleProgress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Cycle',
                        style: TextStyle(
                          fontSize: 10,
                          color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCycleNeuralCenter(bool isDark) {
    return NeuralCard(
      gradientColors: FlowAIFuturisticTheme.getCyclePhaseGradient(_currentPhase),
      enableHolography: true,
      enablePulse: true,
      glowIntensity: 1.2,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                size: 24,
                color: isDark ? FlowAIFuturisticTheme.quantumCyan : FlowAIFuturisticTheme.neuralBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Neural Cycle Analysis',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Large holographic progress ring
          HolographicProgressRing(
            progress: _cycleProgress,
            size: 160,
            colors: FlowAIFuturisticTheme.getCyclePhaseGradient(_currentPhase),
            enableParticles: true,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day 18',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: FlowAIFuturisticTheme.getCyclePhaseGradient(_currentPhase),
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                  'High fertility phase detected',
                  style: TextStyle(
                    fontSize: 12,
                    color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Neural pattern indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNeuralIndicator('Hormone Sync', '94%', Icons.sync, isDark),
              _buildNeuralIndicator('Pattern Match', '87%', Icons.psychology, isDark),
              _buildNeuralIndicator('Prediction', '96%', Icons.auto_awesome, isDark),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildNeuralIndicator(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: FlowAIFuturisticTheme.getTimeBasedGradient(),
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: FlowAIFuturisticTheme.getTimeBasedGradient().first.withValues(alpha: 0.3),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
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
    );
  }
  
  Widget _buildNeuralMetricsGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        NeuralMetricCard(
          title: 'Neural Activity',
          value: '87',
          unit: '%',
          icon: Icons.psychology,
          trendDirection: 'up',
          trendValue: 12.5,
          enableRealTimeUpdate: true,
          gradientColors: FlowAIFuturisticTheme.synapseGlow,
        ),
        NeuralMetricCard(
          title: 'Cycle Harmony',
          value: '94.2',
          unit: '%',
          icon: Icons.waves,
          trendDirection: 'stable',
          subtitle: 'Optimal sync detected',
          gradientColors: FlowAIFuturisticTheme.quantumField,
        ),
        NeuralMetricCard(
          title: 'Prediction Accuracy',
          value: '96',
          unit: '%',
          icon: Icons.auto_awesome,
          trendDirection: 'up',
          trendValue: 8.1,
          gradientColors: FlowAIFuturisticTheme.matrixCode,
        ),
        NeuralMetricCard(
          title: 'Data Quality',
          value: '99.1',
          unit: '%',
          icon: Icons.verified,
          trendDirection: 'up',
          subtitle: 'All sensors active',
          gradientColors: FlowAIFuturisticTheme.cosmicDust,
        ),
      ],
    );
  }
  
  Widget _buildPredictionCards(bool isDark) {
    return Column(
      children: [
        NeuralCard(
          gradientColors: FlowAIFuturisticTheme.quantumField,
          enableHolography: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: FlowAIFuturisticTheme.quantumField.first,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Next Period Prediction',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
                        Text(
                          'In 12 days',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: FlowAIFuturisticTheme.quantumField.first,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'March 15, 2024',
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black87).withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: FlowAIFuturisticTheme.matrixGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: FlowAIFuturisticTheme.matrixGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '96% Confidence',
                      style: TextStyle(
                        color: FlowAIFuturisticTheme.matrixGreen,
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
              child: NeuralCard(
                gradientColors: [FlowAIFuturisticTheme.plasmaPink, FlowAIFuturisticTheme.holoGold],
                child: Column(
                  children: [
                    Icon(
                      Icons.mood,
                      color: FlowAIFuturisticTheme.plasmaPink,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mood Forecast',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Positive',
                      style: TextStyle(
                        color: FlowAIFuturisticTheme.plasmaPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NeuralCard(
                gradientColors: FlowAIFuturisticTheme.matrixCode,
                child: Column(
                  children: [
                    Icon(
                      Icons.energy_savings_leaf,
                      color: FlowAIFuturisticTheme.matrixGreen,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Energy Levels',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'High',
                      style: TextStyle(
                        color: FlowAIFuturisticTheme.matrixGreen,
                        fontWeight: FontWeight.w600,
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
  
  Widget _buildQuantumActions(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        QuantumButton(
          text: 'Neural Log',
          icon: Icons.psychology,
          gradientColors: FlowAIFuturisticTheme.synapseGlow,
          onPressed: () {},
        ),
        QuantumButton(
          text: 'AI Insights',
          icon: Icons.auto_awesome,
          gradientColors: FlowAIFuturisticTheme.quantumField,
          onPressed: () {
            Navigator.pushNamed(context, '/insights');
          },
        ),
        QuantumButton(
          text: 'Sync Data',
          icon: Icons.sync,
          gradientColors: FlowAIFuturisticTheme.matrixCode,
          onPressed: () {},
        ),
        QuantumButton(
          text: 'Health Scan',
          icon: Icons.health_and_safety,
          gradientColors: FlowAIFuturisticTheme.cosmicDust,
          onPressed: () {
            Navigator.pushNamed(context, '/health');
          },
        ),
      ],
    );
  }
  
  Widget _buildNeuralInsights(bool isDark) {
    return NeuralCard(
      gradientColors: FlowAIFuturisticTheme.neuralFlow,
      enableHolography: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuralSectionHeader(
            title: 'Latest Neural Insights',
            subtitle: 'AI-generated recommendations',
            icon: Icons.lightbulb,
            gradientColors: FlowAIFuturisticTheme.neuralFlow,
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Optimal sleep detected',
            'Your sleep patterns are perfectly aligned with your cycle phase',
            Icons.bedtime,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'Nutrition optimization',
            'Consider increasing iron intake during next phase',
            Icons.restaurant,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'Exercise recommendation',
            'High-intensity workouts are ideal for your current phase',
            Icons.fitness_center,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: FlowAIFuturisticTheme.getTimeBasedGradient(),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
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
  
  Widget _buildQuantumFAB(bool isDark) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: FlowAIFuturisticTheme.getTimeBasedGradient(),
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: FlowAIFuturisticTheme.getTimeBasedGradient().first.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
