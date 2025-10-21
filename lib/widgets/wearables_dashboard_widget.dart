import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/wearables_data_service.dart';
import '../services/enhanced_ai_service.dart';

/// Advanced wearables dashboard showing comprehensive biometric data
class WearablesDashboardWidget extends StatefulWidget {
  const WearablesDashboardWidget({Key? key}) : super(key: key);

  @override
  State<WearablesDashboardWidget> createState() => _WearablesDashboardWidgetState();
}

class _WearablesDashboardWidgetState extends State<WearablesDashboardWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showDetailedView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize wearables service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WearablesDataService>().initialize();
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
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context, wearablesService),
                
                // Connection status
                if (!wearablesService.isConnected)
                  _buildConnectionPrompt(context, wearablesService)
                else if (wearablesService.isLoading)
                  _buildLoadingIndicator()
                else if (wearablesService.todaysSummary == null)
                  _buildNoDataMessage()
                else
                  _buildDashboardContent(context, wearablesService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WearablesDataService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.watch,
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
                  'Wearables Health Data',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service.isConnected 
                      ? 'Connected • Last sync: ${_formatLastSync(service.lastSyncTime)}'
                      : 'Not connected to health data',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showDetailedView = !_showDetailedView),
            icon: Icon(
              _showDetailedView ? Icons.compress : Icons.expand,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionPrompt(BuildContext context, WearablesDataService service) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Connect Your Wearable',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get insights from your Apple Watch, Fitbit, or other health devices to enhance your menstrual health tracking.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => service.initialize(),
            icon: const Icon(Icons.link),
            label: const Text('Connect Health App'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Syncing health data...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.data_usage_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No health data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your wearable device is synced and has collected data for today.',
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

  Widget _buildDashboardContent(BuildContext context, WearablesDataService service) {
    final summary = service.todaysSummary!;
    
    return Column(
      children: [
        // Quick metrics overview
        _buildQuickMetrics(context, summary),
        
        // Tabs for detailed data
        if (_showDetailedView) ...[
          const SizedBox(height: 16),
          _buildTabBar(context),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityTab(context, summary),
                _buildSleepTab(context, summary),
                _buildVitalsTab(context, summary),
                _buildWellnessTab(context, summary),
              ],
            ),
          ),
        ],
        
        // Action buttons
        _buildActionButtons(context, service),
      ],
    );
  }

  Widget _buildQuickMetrics(BuildContext context, WearablesSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Wellness score
          if (summary.wellnessScore != null)
            _buildWellnessScoreCard(context, summary.wellnessScore!),
          
          const SizedBox(height: 16),
          
          // Key metrics grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _buildMetricCard(
                context,
                'Steps',
                summary.steps?.toString() ?? '--',
                Icons.directions_walk,
                Colors.blue,
                subtitle: summary.steps != null ? '${(summary.steps! / 10000 * 100).toInt()}% of goal' : null,
              ),
              _buildMetricCard(
                context,
                'Sleep',
                summary.sleepHours != null ? '${summary.sleepHours!.toStringAsFixed(1)}h' : '--',
                Icons.bedtime,
                Colors.purple,
                subtitle: summary.sleepQualityScore != null ? '${summary.sleepQualityScore!.toInt()}% quality' : null,
              ),
              _buildMetricCard(
                context,
                'Heart Rate',
                summary.restingHeartRate?.toInt().toString() ?? '--',
                Icons.favorite,
                Colors.red,
                subtitle: summary.restingHeartRate != null ? 'Resting BPM' : null,
              ),
              _buildMetricCard(
                context,
                'HRV',
                summary.heartRateVariability?.toInt().toString() ?? '--',
                Icons.show_chart,
                Colors.green,
                subtitle: summary.heartRateVariability != null ? 'ms' : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessScoreCard(BuildContext context, double score) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 6,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(
              score >= 80 ? Colors.green : 
              score >= 60 ? Colors.orange : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${score.toInt()}/100',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: score >= 80 ? Colors.green : 
                           score >= 60 ? Colors.orange : Colors.red,
                  ),
                ),
                Text(
                  _getWellnessScoreDescription(score),
                  style: TextStyle(
                    color: Colors.grey[600],
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

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
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
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(text: 'Activity'),
          Tab(text: 'Sleep'),
          Tab(text: 'Vitals'),
          Tab(text: 'Wellness'),
        ],
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context, WearablesSummary summary) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Metrics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildDetailedMetricTile(
                  'Steps',
                  summary.steps?.toString() ?? 'No data',
                  Icons.directions_walk,
                  Colors.blue,
                  description: summary.steps != null 
                      ? 'Target: 10,000 steps (${(summary.steps! / 10000 * 100).toInt()}% complete)'
                      : null,
                ),
                _buildDetailedMetricTile(
                  'Distance',
                  summary.distanceWalkingRunning != null 
                      ? '${(summary.distanceWalkingRunning! / 1000).toStringAsFixed(2)} km'
                      : 'No data',
                  Icons.straighten,
                  Colors.green,
                  description: 'Walking and running distance',
                ),
                _buildDetailedMetricTile(
                  'Flights Climbed',
                  summary.flightsClimbed?.toString() ?? 'No data',
                  Icons.stairs,
                  Colors.orange,
                  description: 'Equivalent to climbing stairs',
                ),
                _buildDetailedMetricTile(
                  'Active Calories',
                  summary.activeEnergyBurned?.toInt().toString() ?? 'No data',
                  Icons.local_fire_department,
                  Colors.red,
                  description: 'Energy burned through activity',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTab(BuildContext context, WearablesSummary summary) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Sleep quality pie chart
          if (summary.sleepHours != null)
            SizedBox(
              height: 200,
              child: _buildSleepQualityChart(context, summary),
            ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView(
              children: [
                _buildDetailedMetricTile(
                  'Total Sleep',
                  summary.sleepHours != null ? '${summary.sleepHours!.toStringAsFixed(1)} hours' : 'No data',
                  Icons.bedtime,
                  Colors.purple,
                  description: summary.sleepQualityScore != null 
                      ? 'Quality: ${summary.sleepQualityScore!.toInt()}/100'
                      : null,
                ),
                _buildDetailedMetricTile(
                  'Deep Sleep',
                  summary.deepSleepHours != null 
                      ? '${summary.deepSleepHours!.toStringAsFixed(1)} hours'
                      : 'No data',
                  Icons.bedtime_outlined,
                  Colors.indigo,
                  description: summary.deepSleepHours != null && summary.sleepHours != null
                      ? '${((summary.deepSleepHours! / summary.sleepHours!) * 100).toInt()}% of total sleep'
                      : null,
                ),
                _buildDetailedMetricTile(
                  'REM Sleep',
                  summary.remSleepHours != null 
                      ? '${summary.remSleepHours!.toStringAsFixed(1)} hours'
                      : 'No data',
                  Icons.psychology,
                  Colors.pink,
                  description: summary.remSleepHours != null && summary.sleepHours != null
                      ? '${((summary.remSleepHours! / summary.sleepHours!) * 100).toInt()}% of total sleep'
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsTab(BuildContext context, WearablesSummary summary) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vital Signs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildDetailedMetricTile(
                  'Resting Heart Rate',
                  summary.restingHeartRate != null 
                      ? '${summary.restingHeartRate!.toInt()} BPM'
                      : 'No data',
                  Icons.favorite,
                  Colors.red,
                  description: _getHeartRateDescription(summary.restingHeartRate),
                ),
                _buildDetailedMetricTile(
                  'Heart Rate Variability',
                  summary.heartRateVariability != null 
                      ? '${summary.heartRateVariability!.toInt()} ms'
                      : 'No data',
                  Icons.show_chart,
                  Colors.green,
                  description: 'Measure of autonomic nervous system balance',
                ),
                _buildDetailedMetricTile(
                  'Blood Oxygen',
                  summary.bloodOxygen != null 
                      ? '${summary.bloodOxygen!.toInt()}%'
                      : 'No data',
                  Icons.air,
                  Colors.blue,
                  description: summary.bloodOxygen != null 
                      ? _getBloodOxygenDescription(summary.bloodOxygen!)
                      : null,
                ),
                _buildDetailedMetricTile(
                  'Body Temperature',
                  summary.bodyTemperature != null 
                      ? '${summary.bodyTemperature!.toStringAsFixed(1)}°C'
                      : 'No data',
                  Icons.thermostat,
                  Colors.orange,
                  description: 'Basal body temperature',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessTab(BuildContext context, WearablesSummary summary) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Insights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildWellnessInsightCard(
                  context,
                  'Menstrual Health Correlation',
                  _getMenstrualHealthInsights(summary),
                  Icons.health_and_safety,
                  Colors.pink,
                ),
                _buildWellnessInsightCard(
                  context,
                  'Sleep Quality Impact',
                  _getSleepQualityInsights(summary),
                  Icons.bedtime,
                  Colors.purple,
                ),
                _buildWellnessInsightCard(
                  context,
                  'Activity Recommendations',
                  _getActivityRecommendations(summary),
                  Icons.fitness_center,
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetricTile(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
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
                if (description != null)
                  Text(
                    description,
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

  Widget _buildWellnessInsightCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualityChart(BuildContext context, WearablesSummary summary) {
    if (summary.sleepHours == null) return Container();

    final data = <PieChartSectionData>[];
    
    if (summary.deepSleepHours != null) {
      data.add(PieChartSectionData(
        color: Colors.indigo,
        value: summary.deepSleepHours!,
        title: 'Deep',
        radius: 50,
      ));
    }
    
    if (summary.remSleepHours != null) {
      data.add(PieChartSectionData(
        color: Colors.pink,
        value: summary.remSleepHours!,
        title: 'REM',
        radius: 50,
      ));
    }
    
    final lightSleep = summary.sleepHours! - 
                     (summary.deepSleepHours ?? 0) - 
                     (summary.remSleepHours ?? 0);
    
    if (lightSleep > 0) {
      data.add(PieChartSectionData(
        color: Colors.lightBlue,
        value: lightSleep,
        title: 'Light',
        radius: 50,
      ));
    }

    return PieChart(
      PieChartData(
        sections: data,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WearablesDataService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => service.syncTodaysData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Sync Now'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showHistoricalData(context, service),
              icon: const Icon(Icons.history),
              label: const Text('View History'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoricalData(BuildContext context, WearablesDataService service) {
    // Show historical data dialog or navigate to detailed view
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Historical Data'),
        content: const Text('Historical wearables data view coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatLastSync(DateTime? lastSync) {
    if (lastSync == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getWellnessScoreDescription(double score) {
    if (score >= 80) return 'Excellent wellness metrics';
    if (score >= 60) return 'Good overall health';
    if (score >= 40) return 'Fair, room for improvement';
    return 'Consider lifestyle adjustments';
  }

  String? _getHeartRateDescription(double? hr) {
    if (hr == null) return null;
    
    if (hr < 60) return 'Below normal range';
    if (hr <= 80) return 'Normal range';
    if (hr <= 100) return 'Elevated';
    return 'High - consult healthcare provider';
  }

  String _getBloodOxygenDescription(double oxygen) {
    if (oxygen >= 95) return 'Normal oxygen saturation';
    if (oxygen >= 90) return 'Slightly low oxygen levels';
    return 'Low oxygen - seek medical attention';
  }

  String _getMenstrualHealthInsights(WearablesSummary summary) {
    final metrics = summary.menstrualHealthMetrics;
    final insights = <String>[];
    
    if (metrics['sleep_quality'] != null && metrics['sleep_quality']! < 60) {
      insights.add('Poor sleep quality may affect hormonal balance');
    }
    
    if (metrics['hrv'] != null && metrics['hrv']! < 30) {
      insights.add('Low HRV suggests increased stress levels');
    }
    
    if (metrics['body_temp'] != null) {
      insights.add('Body temperature tracking can help predict ovulation');
    }
    
    if (insights.isEmpty) {
      return 'Your current metrics support healthy menstrual cycle patterns.';
    }
    
    return insights.join('. ') + '.';
  }

  String _getSleepQualityInsights(WearablesSummary summary) {
    if (summary.sleepQualityScore == null) {
      return 'No sleep data available for analysis.';
    }
    
    final score = summary.sleepQualityScore!;
    if (score >= 80) {
      return 'Excellent sleep quality supports hormonal regulation and menstrual health.';
    } else if (score >= 60) {
      return 'Good sleep patterns. Consider optimizing sleep environment for better recovery.';
    } else {
      return 'Poor sleep quality may impact menstrual regularity and PMS symptoms. Focus on sleep hygiene.';
    }
  }

  String _getActivityRecommendations(WearablesSummary summary) {
    if (summary.steps == null) {
      return 'Enable activity tracking to receive personalized recommendations.';
    }
    
    if (summary.steps! >= 10000) {
      return 'Great activity level! Regular exercise supports menstrual health and reduces PMS symptoms.';
    } else if (summary.steps! >= 7500) {
      return 'Good activity level. Try adding 15-20 minutes of walking to reach optimal daily movement.';
    } else {
      return 'Low activity detected. Gentle exercise like yoga or walking can help regulate menstrual cycles.';
    }
  }
}
