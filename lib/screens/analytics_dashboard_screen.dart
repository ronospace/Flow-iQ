import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../services/ml_prediction_service.dart';
import '../services/wearables_data_service.dart';
import '../services/enhanced_ai_service.dart';

/// Advanced Analytics Dashboard Screen
/// 
/// Provides comprehensive visualization of cycle data, predictions, and health patterns
class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 90)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    final mlService = Provider.of<MLPredictionService>(context, listen: false);
    final wearablesService = Provider.of<WearablesDataService>(context, listen: false);
    
    if (!mlService.modelsInitialized) {
      await mlService.initialize();
    }
    
    if (!wearablesService.isConnected) {
      await wearablesService.initialize();
    }

    // Sync historical data for analytics
    await wearablesService.syncHistoricalData(
      startDate: _selectedDateRange.start,
      endDate: _selectedDateRange.end,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Overview'),
            Tab(icon: Icon(Icons.timeline), text: 'Predictions'),
            Tab(icon: Icon(Icons.favorite), text: 'Health'),
            Tab(icon: Icon(Icons.insights), text: 'Patterns'),
          ],
          indicatorColor: const Color(0xFFE91E63),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPredictionsTab(),
          _buildHealthTab(),
          _buildPatternsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer3<MLPredictionService, WearablesDataService, EnhancedAIService>(
      builder: (context, mlService, wearablesService, aiService, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics Cards
              _buildKeyMetricsGrid(mlService, wearablesService),
              
              const SizedBox(height: 24),
              
              // Cycle Length Trend Chart
              _buildCycleTrendChart(),
              
              const SizedBox(height: 24),
              
              // Current Phase Info
              _buildCurrentPhaseCard(),
              
              const SizedBox(height: 24),
              
              // Recent Insights
              _buildRecentInsights(aiService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPredictionsTab() {
    return Consumer<MLPredictionService>(
      builder: (context, mlService, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Next Period Prediction
              _buildNextPeriodPrediction(mlService),
              
              const SizedBox(height: 24),
              
              // Symptom Predictions
              _buildSymptomPredictions(mlService),
              
              const SizedBox(height: 24),
              
              // Mood Predictions
              _buildMoodPredictions(mlService),
              
              const SizedBox(height: 24),
              
              // Confidence Metrics
              _buildConfidenceMetrics(mlService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthTab() {
    return Consumer<WearablesDataService>(
      builder: (context, wearablesService, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health Score Card
              _buildHealthScoreCard(wearablesService),
              
              const SizedBox(height: 24),
              
              // Sleep Analysis
              _buildSleepAnalysisChart(wearablesService),
              
              const SizedBox(height: 24),
              
              // Heart Rate Variability
              _buildHRVChart(wearablesService),
              
              const SizedBox(height: 24),
              
              // Activity Levels
              _buildActivityChart(wearablesService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPatternsTab() {
    return Consumer<MLPredictionService>(
      builder: (context, mlService, child) {
        return FutureBuilder<List<HealthPattern>>(
          future: mlService.detectHealthPatterns(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final patterns = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pattern Summary
                  _buildPatternSummary(patterns),
                  
                  const SizedBox(height: 24),
                  
                  // Pattern Details
                  ...patterns.map((pattern) => _buildPatternCard(pattern)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKeyMetricsGrid(MLPredictionService mlService, WearablesDataService wearablesService) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          'Cycle Regularity',
          _getCycleRegularityScore().toStringAsFixed(1) + '%',
          Icons.refresh,
          const Color(0xFF4CAF50),
        ),
        _buildMetricCard(
          'Prediction Accuracy',
          _getPredictionAccuracy(mlService).toStringAsFixed(1) + '%',
          Icons.track_changes,
          const Color(0xFF2196F3),
        ),
        _buildMetricCard(
          'Wellness Score',
          (wearablesService.todaysSummary?.wellnessScore?.toStringAsFixed(1) ?? 'N/A'),
          Icons.favorite,
          const Color(0xFFE91E63),
        ),
        _buildMetricCard(
          'Data Points',
          _getDataPointsCount().toString(),
          Icons.data_usage,
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleTrendChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cycle Length Trends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.now().subtract(Duration(days: (30 - value).toInt()));
                        return Text(
                          DateFormat('M/d').format(date),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateCycleTrendData(),
                    isCurved: true,
                    color: const Color(0xFFE91E63),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhaseCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF06292)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Current Phase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Follicular Phase',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Day 8 of 28 • Energy building phase',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 8 / 28,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPeriodPrediction(MLPredictionService mlService) {
    final prediction = mlService.currentCyclePrediction;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Next Period Prediction',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (prediction != null) ...[
            Text(
              DateFormat('EEEE, MMM d').format(prediction.nextPeriodDate),
              style: const TextStyle(
                color: Color(0xFFE91E63),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: ${(prediction.confidence * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPredictionMetric('Cycle Length', '${prediction.predictedCycleLength} days'),
                ),
                Expanded(
                  child: _buildPredictionMetric('Based on', '${prediction.basedOnCycles} cycles'),
                ),
              ],
            ),
          ] else ...[
            Text(
              'No prediction available',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictionMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomPredictions(MLPredictionService mlService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Symptoms (7 days)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...mlService.symptomPredictions.take(5).map((prediction) => 
            _buildSymptomPredictionRow(prediction)
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomPredictionRow(SymptomPrediction prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Text(
              DateFormat('M/d').format(prediction.date),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: prediction.predictedSymptoms.entries.map((entry) => 
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${(entry.value * 100).toInt()}%',
                      style: TextStyle(
                        color: _getSymptomProbabilityColor(entry.value),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternCard(HealthPattern pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            width: 4,
            color: _getPatternColor(pattern.type),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getPatternIcon(pattern.type),
                color: _getPatternColor(pattern.type),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pattern.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPatternColor(pattern.type).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(pattern.confidence * 100).toInt()}%',
                  style: TextStyle(
                    color: _getPatternColor(pattern.type),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pattern.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for data and UI
  double _getCycleRegularityScore() {
    // Calculate based on cycle length variance
    return 87.5; // Placeholder
  }

  double _getPredictionAccuracy(MLPredictionService mlService) {
    final prediction = mlService.currentCyclePrediction;
    return (prediction?.confidence ?? 0.0) * 100;
  }

  int _getDataPointsCount() {
    return 127; // Placeholder
  }

  List<FlSpot> _generateCycleTrendData() {
    final random = Random();
    return List.generate(10, (index) {
      return FlSpot(index.toDouble(), 26 + random.nextDouble() * 6);
    });
  }

  Color _getSymptomProbabilityColor(double probability) {
    if (probability >= 0.7) return const Color(0xFFE91E63);
    if (probability >= 0.4) return const Color(0xFFFF9800);
    return const Color(0xFF4CAF50);
  }

  Color _getPatternColor(PatternType type) {
    switch (type) {
      case PatternType.positive:
        return const Color(0xFF4CAF50);
      case PatternType.neutral:
        return const Color(0xFF2196F3);
      case PatternType.concerning:
        return const Color(0xFFE91E63);
    }
  }

  IconData _getPatternIcon(PatternType type) {
    switch (type) {
      case PatternType.positive:
        return Icons.trending_up;
      case PatternType.neutral:
        return Icons.info_outline;
      case PatternType.concerning:
        return Icons.warning_outlined;
    }
  }

  // Additional widget builders
  Widget _buildRecentInsights(EnhancedAIService aiService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Insights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Your cycle patterns show excellent regularity. Consider maintaining your current sleep schedule.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(WearablesDataService wearablesService) {
    final wellnessScore = wearablesService.todaysSummary?.wellnessScore ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getHealthScoreColor(wellnessScore),
            _getHealthScoreColor(wellnessScore).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Score',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            wellnessScore.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getHealthScoreDescription(wellnessScore),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepAnalysisChart(WearablesDataService wearablesService) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Add sleep chart here
          Center(
            child: Text(
              'Sleep Chart Placeholder',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHRVChart(WearablesDataService wearablesService) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heart Rate Variability',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Add HRV chart here
          Center(
            child: Text(
              'HRV Chart Placeholder',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(WearablesDataService wearablesService) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Levels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Add activity chart here
          Center(
            child: Text(
              'Activity Chart Placeholder',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodPredictions(MLPredictionService mlService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Predictions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Mood prediction placeholder',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceMetrics(MLPredictionService mlService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confidence Metrics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Confidence metrics placeholder',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternSummary(List<HealthPattern> patterns) {
    final positiveCount = patterns.where((p) => p.type == PatternType.positive).length;
    final concerningCount = patterns.where((p) => p.type == PatternType.concerning).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pattern Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPatternSummaryCard(
                  'Positive', 
                  positiveCount.toString(), 
                  const Color(0xFF4CAF50)
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPatternSummaryCard(
                  'Concerning', 
                  concerningCount.toString(), 
                  const Color(0xFFE91E63)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatternSummaryCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFF2196F3);
    if (score >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFE91E63);
  }

  String _getHealthScoreDescription(double score) {
    if (score >= 80) return 'Excellent health metrics';
    if (score >= 60) return 'Good overall health';
    if (score >= 40) return 'Average health metrics';
    return 'Needs attention';
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      await _loadAnalyticsData();
    }
  }

  Future<void> _refreshAnalytics() async {
    await _loadAnalyticsData();
    setState(() {});
  }
}
