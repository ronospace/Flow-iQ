import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wearables_data_service.dart';

/// Detailed wearables screen with comprehensive health data visualization
class WearablesScreen extends StatefulWidget {
  const WearablesScreen({super.key});

  @override
  State<WearablesScreen> createState() => _WearablesScreenState();
}

class _WearablesScreenState extends State<WearablesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool _showTrends = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Initialize wearables service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = context.read<WearablesDataService>();
      if (!service.isConnected) {
        service.initialize();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WearablesDataService>(
      builder: (context, wearablesService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Health & Wearables'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                icon: Icon(_showTrends ? Icons.today : Icons.trending_up),
                onPressed: () => setState(() => _showTrends = !_showTrends),
                tooltip: _showTrends ? 'Show Daily View' : 'Show Trends',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => wearablesService.syncTodaysData(),
                tooltip: 'Sync Data',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 16)),
                Tab(text: 'Activity', icon: Icon(Icons.directions_walk, size: 16)),
                Tab(text: 'Sleep', icon: Icon(Icons.bedtime, size: 16)),
                Tab(text: 'Vitals', icon: Icon(Icons.favorite, size: 16)),
                Tab(text: 'Wellness', icon: Icon(Icons.psychology, size: 16)),
              ],
            ),
          ),
          body: !wearablesService.isConnected
              ? _buildConnectionScreen(wearablesService)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(context, wearablesService),
                    _buildActivityTab(context, wearablesService),
                    _buildSleepTab(context, wearablesService),
                    _buildVitalsTab(context, wearablesService),
                    _buildWellnessTab(context, wearablesService),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildConnectionScreen(WearablesDataService service) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.watch,
              size: 80,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Connect Your Health Data',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sync your Apple Watch, Fitbit, or other wearables to get personalized insights about your menstrual health patterns.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          
          // Benefits list
          _buildBenefitItem(
            Icons.insights,
            'Smart Insights',
            'Discover correlations between your cycle and health metrics',
          ),
          _buildBenefitItem(
            Icons.track_changes,
            'Pattern Recognition',
            'Track how sleep, activity, and stress affect your cycle',
          ),
          _buildBenefitItem(
            Icons.notifications_active,
            'Personalized Alerts',
            'Get notified about important health changes',
          ),
          
          const SizedBox(height: 40),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: service.isLoading ? null : () => service.initialize(),
              icon: service.isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.health_and_safety),
              label: Text(service.isLoading ? 'Connecting...' : 'Connect Health App'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          TextButton(
            onPressed: () => _showPrivacyInfo(),
            child: Text(
              'Privacy & Data Security',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, WearablesDataService service) {
    return RefreshIndicator(
      onRefresh: () => service.syncTodaysData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date selector
            _buildDateSelector(),
            const SizedBox(height: 16),
            
            // Summary cards
            if (service.todaysSummary != null) ...[
              _buildWellnessOverview(service.todaysSummary!),
              const SizedBox(height: 16),
              _buildQuickStatsGrid(service.todaysSummary!),
              const SizedBox(height: 16),
              
              // Charts section
              if (_showTrends) ...[
                _buildTrendsSection(service),
              ] else ...[
                _buildDailyBreakdown(service.todaysSummary!),
              ],
            ] else ...[
              _buildNoDataCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDate(_selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _selectDate(),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessOverview(WearablesSummary summary) {
    final score = summary.wellnessScore ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Wellness Score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${score.toInt()}/100',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score),
                      ),
                    ),
                    Text(
                      _getWellnessDescription(score),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(_getScoreColor(score)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildScoreBreakdown(summary),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid(WearablesSummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          'Steps',
          summary.steps?.toString() ?? '--',
          Icons.directions_walk,
          Colors.blue,
          progress: summary.steps != null ? (summary.steps! / 10000).clamp(0.0, 1.0) : null,
        ),
        _buildStatCard(
          'Sleep',
          summary.sleepHours != null ? '${summary.sleepHours!.toStringAsFixed(1)}h' : '--',
          Icons.bedtime,
          Colors.purple,
          progress: summary.sleepHours != null ? (summary.sleepHours! / 8).clamp(0.0, 1.0) : null,
        ),
        _buildStatCard(
          'Heart Rate',
          summary.restingHeartRate?.toInt().toString() ?? '--',
          Icons.favorite,
          Colors.red,
          subtitle: 'Resting BPM',
        ),
        _buildStatCard(
          'HRV',
          summary.heartRateVariability?.toInt().toString() ?? '--',
          Icons.show_chart,
          Colors.green,
          subtitle: 'ms',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              if (progress != null)
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context, WearablesDataService service) {
    final summary = service.todaysSummary;
    
    return RefreshIndicator(
      onRefresh: () => service.syncTodaysData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (summary != null) ...[
              // Activity rings
              _buildActivityRings(summary),
              const SizedBox(height: 24),
              
              // Detailed metrics
              _buildActivityMetrics(summary),
              const SizedBox(height: 24),
              
              // Activity chart
              if (_showTrends)
                _buildActivityChart(),
            ] else
              _buildNoDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRings(WearablesSummary summary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Today\'s Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Steps ring
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: summary.steps != null ? (summary.steps! / 10000).clamp(0.0, 1.0) : 0.0,
                    strokeWidth: 12,
                    backgroundColor: Colors.blue.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                
                // Active calories ring
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: summary.activeEnergyBurned != null 
                        ? (summary.activeEnergyBurned! / 600).clamp(0.0, 1.0) 
                        : 0.0,
                    strokeWidth: 10,
                    backgroundColor: Colors.red.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.red),
                  ),
                ),
                
                // Center content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      summary.steps?.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'STEPS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRingLegend(
                'Steps',
                summary.steps?.toString() ?? '0',
                '/ 10,000',
                Colors.blue,
              ),
              _buildRingLegend(
                'Active Cal',
                summary.activeEnergyBurned?.toInt().toString() ?? '0',
                '/ 600',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRingLegend(String title, String value, String target, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '$value$target',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityMetrics(WearablesSummary summary) {
    return Column(
      children: [
        _buildMetricRow(
          'Steps',
          summary.steps?.toString() ?? 'No data',
          Icons.directions_walk,
          Colors.blue,
          subtitle: summary.steps != null 
              ? '${((summary.steps! / 10000) * 100).toInt()}% of daily goal'
              : null,
        ),
        _buildMetricRow(
          'Distance',
          summary.distanceWalkingRunning != null 
              ? '${(summary.distanceWalkingRunning! / 1000).toStringAsFixed(2)} km'
              : 'No data',
          Icons.straighten,
          Colors.green,
          subtitle: 'Walking and running',
        ),
        _buildMetricRow(
          'Flights Climbed',
          summary.flightsClimbed?.toString() ?? 'No data',
          Icons.stairs,
          Colors.orange,
          subtitle: 'Floors climbed equivalent',
        ),
        _buildMetricRow(
          'Active Calories',
          summary.activeEnergyBurned?.toInt().toString() ?? 'No data',
          Icons.local_fire_department,
          Colors.red,
          subtitle: 'Calories burned through activity',
        ),
      ],
    );
  }

  Widget _buildSleepTab(BuildContext context, WearablesDataService service) {
    final summary = service.todaysSummary;
    
    return RefreshIndicator(
      onRefresh: () => service.syncTodaysData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep Analysis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (summary != null) ...[
              // Sleep quality overview
              _buildSleepQualityCard(summary),
              const SizedBox(height: 16),
              
              // Sleep breakdown chart
              if (summary.sleepHours != null)
                _buildSleepBreakdownChart(summary),
              const SizedBox(height: 16),
              
              // Sleep metrics
              _buildSleepMetrics(summary),
            ] else
              _buildNoDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepQualityCard(WearablesSummary summary) {
    final quality = summary.sleepQualityScore ?? 0.0;
    final hours = summary.sleepHours ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withValues(alpha: 0.1),
            Colors.indigo.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep Quality',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${quality.toInt()}/100',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getSleepQualityColor(quality),
                      ),
                    ),
                    Text(
                      _getSleepQualityDescription(quality),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${hours.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const Text(
                    'HOURS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepBreakdownChart(WearablesSummary summary) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Stages',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildSleepStageBar(
                    'Deep',
                    summary.deepSleepHours ?? 0.0,
                    summary.sleepHours ?? 1.0,
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSleepStageBar(
                    'REM',
                    summary.remSleepHours ?? 0.0,
                    summary.sleepHours ?? 1.0,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSleepStageBar(
                    'Light',
                    (summary.sleepHours ?? 0.0) - 
                    (summary.deepSleepHours ?? 0.0) - 
                    (summary.remSleepHours ?? 0.0),
                    summary.sleepHours ?? 1.0,
                    Colors.lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStageBar(String stage, double hours, double total, Color color) {
    final percentage = total > 0 ? (hours / total) : 0.0;
    
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stage,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${hours.toStringAsFixed(1)}h',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${(percentage * 100).toInt()}%',
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepMetrics(WearablesSummary summary) {
    return Column(
      children: [
        _buildMetricRow(
          'Total Sleep',
          summary.sleepHours != null ? '${summary.sleepHours!.toStringAsFixed(1)} hours' : 'No data',
          Icons.bedtime,
          Colors.purple,
          subtitle: _getSleepDurationFeedback(summary.sleepHours),
        ),
        _buildMetricRow(
          'Deep Sleep',
          summary.deepSleepHours != null 
              ? '${summary.deepSleepHours!.toStringAsFixed(1)} hours'
              : 'No data',
          Icons.bedtime_outlined,
          Colors.indigo,
          subtitle: summary.deepSleepHours != null && summary.sleepHours != null
              ? '${((summary.deepSleepHours! / summary.sleepHours!) * 100).toInt()}% of total sleep'
              : null,
        ),
        _buildMetricRow(
          'REM Sleep',
          summary.remSleepHours != null 
              ? '${summary.remSleepHours!.toStringAsFixed(1)} hours'
              : 'No data',
          Icons.psychology,
          Colors.pink,
          subtitle: summary.remSleepHours != null && summary.sleepHours != null
              ? '${((summary.remSleepHours! / summary.sleepHours!) * 100).toInt()}% of total sleep'
              : null,
        ),
      ],
    );
  }

  Widget _buildVitalsTab(BuildContext context, WearablesDataService service) {
    final summary = service.todaysSummary;
    
    return RefreshIndicator(
      onRefresh: () => service.syncTodaysData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vital Signs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (summary != null) ...[
              // Vital signs overview
              _buildVitalsOverview(summary),
              const SizedBox(height: 16),
              
              // Detailed metrics
              _buildVitalsMetrics(summary),
            ] else
              _buildNoDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsOverview(WearablesSummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildVitalCard(
          'Heart Rate',
          summary.restingHeartRate?.toInt().toString() ?? '--',
          'BPM',
          Icons.favorite,
          Colors.red,
          isGood: _isHeartRateHealthy(summary.restingHeartRate),
        ),
        _buildVitalCard(
          'HRV',
          summary.heartRateVariability?.toInt().toString() ?? '--',
          'ms',
          Icons.show_chart,
          Colors.green,
          isGood: _isHRVHealthy(summary.heartRateVariability),
        ),
        _buildVitalCard(
          'Blood O₂',
          summary.bloodOxygen?.toInt().toString() ?? '--',
          '%',
          Icons.air,
          Colors.blue,
          isGood: _isBloodOxygenHealthy(summary.bloodOxygen),
        ),
        _buildVitalCard(
          'Temperature',
          summary.bodyTemperature != null 
              ? '${summary.bodyTemperature!.toStringAsFixed(1)}' 
              : '--',
          '°C',
          Icons.thermostat,
          Colors.orange,
          isGood: _isTemperatureHealthy(summary.bodyTemperature),
        ),
      ],
    );
  }

  Widget _buildVitalCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color, {
    bool? isGood,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isGood != null
            ? Border.all(
                color: isGood ? Colors.green : Colors.orange,
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              if (isGood != null)
                Icon(
                  isGood ? Icons.check_circle : Icons.warning,
                  color: isGood ? Colors.green : Colors.orange,
                  size: 20,
                ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsMetrics(WearablesSummary summary) {
    return Column(
      children: [
        _buildMetricRow(
          'Resting Heart Rate',
          summary.restingHeartRate != null 
              ? '${summary.restingHeartRate!.toInt()} BPM'
              : 'No data',
          Icons.favorite,
          Colors.red,
          subtitle: _getHeartRateDescription(summary.restingHeartRate),
        ),
        _buildMetricRow(
          'Heart Rate Variability',
          summary.heartRateVariability != null 
              ? '${summary.heartRateVariability!.toInt()} ms'
              : 'No data',
          Icons.show_chart,
          Colors.green,
          subtitle: 'Measure of autonomic nervous system balance',
        ),
        _buildMetricRow(
          'Blood Oxygen',
          summary.bloodOxygen != null 
              ? '${summary.bloodOxygen!.toInt()}%'
              : 'No data',
          Icons.air,
          Colors.blue,
          subtitle: summary.bloodOxygen != null 
              ? _getBloodOxygenDescription(summary.bloodOxygen!)
              : null,
        ),
        _buildMetricRow(
          'Body Temperature',
          summary.bodyTemperature != null 
              ? '${summary.bodyTemperature!.toStringAsFixed(1)}°C'
              : 'No data',
          Icons.thermostat,
          Colors.orange,
          subtitle: 'Basal body temperature',
        ),
      ],
    );
  }

  Widget _buildWellnessTab(BuildContext context, WearablesDataService service) {
    final summary = service.todaysSummary;
    
    return RefreshIndicator(
      onRefresh: () => service.syncTodaysData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wellness Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (summary != null) ...[
              // Menstrual health correlation
              _buildMenstrualHealthCard(summary),
              const SizedBox(height: 16),
              
              // Wellness insights
              _buildWellnessInsights(summary),
            ] else
              _buildNoDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenstrualHealthCard(WearablesSummary summary) {
    final metrics = summary.menstrualHealthMetrics;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: 0.1),
            Colors.purple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: Colors.pink,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Menstrual Health Correlation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getMenstrualHealthInsights(summary),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          
          // Key metrics
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (metrics['sleep_quality'] != null)
                _buildMetricChip('Sleep Quality', '${metrics['sleep_quality']!.toInt()}%', Colors.purple),
              if (metrics['stress_indicator'] != null)
                _buildMetricChip('Stress Level', _getStressLevel(metrics['stress_indicator']!), Colors.orange),
              if (metrics['activity_level'] != null)
                _buildMetricChip('Activity', '${metrics['activity_level']!.toInt()} steps', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessInsights(WearablesSummary summary) {
    return Column(
      children: [
        _buildInsightCard(
          'Sleep Quality Impact',
          _getSleepQualityInsights(summary),
          Icons.bedtime,
          Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Activity Recommendations',
          _getActivityRecommendations(summary),
          Icons.fitness_center,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Recovery Status',
          _getRecoveryInsights(summary),
          Icons.healing,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInsightCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods...

  Widget _buildMetricRow(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.data_usage_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Data Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your wearable device is connected and syncing data.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder methods for charts and additional features
  Widget _buildTrendsSection(WearablesDataService service) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Trends Chart\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyBreakdown(WearablesSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Wellness Score: ${summary.wellnessScore?.toInt() ?? 0}/100\n'
            'Sleep Quality: ${summary.sleepQualityScore?.toInt() ?? 0}/100\n'
            'Activity Level: ${_getActivityLevel(summary.steps)}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Activity Trends Chart\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown(WearablesSummary summary) {
    return Column(
      children: [
        _buildScoreComponent('Sleep', summary.sleepQualityScore ?? 0, Colors.purple),
        _buildScoreComponent('Activity', _calculateActivityScore(summary), Colors.blue),
        _buildScoreComponent('Recovery', _calculateRecoveryScore(summary), Colors.green),
      ],
    );
  }

  Widget _buildScoreComponent(String label, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${score.toInt()}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getSleepQualityColor(double quality) {
    if (quality >= 80) return Colors.green;
    if (quality >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getWellnessDescription(double score) {
    if (score >= 80) return 'Excellent wellness today!';
    if (score >= 60) return 'Good health metrics';
    return 'Consider focusing on recovery';
  }

  String _getSleepQualityDescription(double quality) {
    if (quality >= 80) return 'Excellent sleep quality';
    if (quality >= 60) return 'Good sleep quality';
    return 'Consider improving sleep habits';
  }

  String _getSleepDurationFeedback(double? hours) {
    if (hours == null) return '';
    if (hours >= 7 && hours <= 9) return 'Optimal sleep duration';
    if (hours < 7) return 'Consider getting more sleep';
    return 'You may be getting too much sleep';
  }

  String _getActivityLevel(int? steps) {
    if (steps == null) return 'No data';
    if (steps >= 10000) return 'Very Active';
    if (steps >= 7500) return 'Active';
    if (steps >= 5000) return 'Moderately Active';
    return 'Low Activity';
  }

  String _getStressLevel(double indicator) {
    if (indicator < 2) return 'Low';
    if (indicator < 4) return 'Moderate';
    return 'High';
  }

  String _getHeartRateDescription(double? hr) {
    if (hr == null) return '';
    if (hr >= 60 && hr <= 80) return 'Normal range';
    if (hr < 60) return 'Below normal (bradycardia)';
    return 'Above normal (tachycardia)';
  }

  String _getBloodOxygenDescription(double oxygen) {
    if (oxygen >= 95) return 'Normal';
    if (oxygen >= 90) return 'Slightly low';
    return 'Concerning - consult doctor';
  }

  String _getMenstrualHealthInsights(WearablesSummary summary) {
    return 'Your health metrics show patterns that may correlate with your menstrual cycle. '
           'Sleep quality and heart rate variability often fluctuate throughout different cycle phases. '
           'Continue tracking to build a comprehensive picture of your health patterns.';
  }

  String _getSleepQualityInsights(WearablesSummary summary) {
    final quality = summary.sleepQualityScore ?? 0;
    if (quality >= 80) {
      return 'Your sleep quality is excellent, which supports hormonal balance and overall wellbeing.';
    } else if (quality >= 60) {
      return 'Good sleep quality. Consider establishing a consistent bedtime routine for optimal hormonal health.';
    } else {
      return 'Sleep quality could be improved. Poor sleep can affect menstrual cycle regularity and mood.';
    }
  }

  String _getActivityRecommendations(WearablesSummary summary) {
    final steps = summary.steps ?? 0;
    if (steps >= 10000) {
      return 'Great activity level! Regular exercise supports menstrual health and reduces PMS symptoms.';
    } else if (steps >= 7500) {
      return 'Good activity level. Try to reach 10,000 steps daily for optimal menstrual health benefits.';
    } else {
      return 'Consider increasing daily activity. Light exercise can help regulate cycles and reduce cramping.';
    }
  }

  String _getRecoveryInsights(WearablesSummary summary) {
    final hrv = summary.heartRateVariability ?? 0;
    if (hrv >= 40) {
      return 'Excellent recovery status. Your body is adapting well to stress and maintaining good balance.';
    } else if (hrv >= 20) {
      return 'Moderate recovery. Consider stress management techniques and adequate rest.';
    } else {
      return 'Low recovery status. Focus on rest, stress reduction, and consistent sleep schedule.';
    }
  }

  bool _isHeartRateHealthy(double? hr) => hr != null && hr >= 60 && hr <= 80;
  bool _isHRVHealthy(double? hrv) => hrv != null && hrv >= 30;
  bool _isBloodOxygenHealthy(double? oxygen) => oxygen != null && oxygen >= 95;
  bool _isTemperatureHealthy(double? temp) => temp != null && temp >= 36.1 && temp <= 37.2;

  double _calculateActivityScore(WearablesSummary summary) {
    final steps = summary.steps ?? 0;
    return ((steps / 10000) * 100).clamp(0, 100);
  }

  double _calculateRecoveryScore(WearablesSummary summary) {
    final hrv = summary.heartRateVariability ?? 0;
    return ((hrv / 50) * 100).clamp(0, 100);
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data Security'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your health data is encrypted and stored securely on your device. '
                'We only access data with your explicit permission and never share '
                'personal health information with third parties.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Data Collection:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Sleep patterns and quality'),
              Text('• Activity and exercise data'),
              Text('• Heart rate and variability'),
              Text('• Body temperature readings'),
              SizedBox(height: 16),
              Text(
                'Data Usage:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Personalized health insights'),
              Text('• Menstrual cycle correlations'),
              Text('• Wellness recommendations'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
