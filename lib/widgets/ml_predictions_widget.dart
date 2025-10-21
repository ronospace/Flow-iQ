import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/ml_prediction_service.dart';
import '../models/cycle_data.dart';

/// Widget displaying ML-powered predictions and insights
class MLPredictionsWidget extends StatefulWidget {
  final CyclePhase? currentPhase;
  final int? dayInCycle;

  const MLPredictionsWidget({
    Key? key,
    this.currentPhase,
    this.dayInCycle,
  }) : super(key: key);

  @override
  State<MLPredictionsWidget> createState() => _MLPredictionsWidgetState();
}

class _MLPredictionsWidgetState extends State<MLPredictionsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize ML service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = context.read<MLPredictionService>();
      if (!service.modelsInitialized) {
        service.initialize();
      }
      _loadPredictions();
    });
  }

  void _loadPredictions() {
    final service = context.read<MLPredictionService>();
    if (service.modelsInitialized && widget.currentPhase != null) {
      final currentCycle = CycleDataPoint(
        timestamp: DateTime.now(),
        dayInCycle: widget.dayInCycle ?? 1,
        cycleLength: 28,
        phase: widget.currentPhase!,
        periodStartDate: DateTime.now().subtract(Duration(days: widget.dayInCycle ?? 1)),
        flowIntensity: 2,
        painLevel: 1,
        energyLevel: 4,
        mood: 'calm',
        symptoms: [],
      );
      
      service.predictNextCycle(currentCycle);
      service.predictUpcomingSymptoms(currentCycle);
      service.predictMoodPatterns(currentCycle);
      service.detectHealthPatterns();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MLPredictionService>(
      builder: (context, service, child) {
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
                  Colors.indigo.withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context, service),
                
                // Content
                if (service.isLoading)
                  _buildLoadingState()
                else if (!service.modelsInitialized)
                  _buildInitializationState(service)
                else if (service.errorMessage != null)
                  _buildErrorState(service.errorMessage!)
                else
                  _buildPredictionsContent(context, service),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, MLPredictionService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.indigo.withValues(alpha: 0.05),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.indigo,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Predictions & Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ML-powered cycle predictions and health pattern analysis',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (service.modelsInitialized)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    'ML Active',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.indigo),
          ),
          const SizedBox(height: 16),
          Text(
            'Training ML models...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInitializationState(MLPredictionService service) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Initialize ML Models',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Train AI models with your data for personalized predictions',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => service.initialize(),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Initialize ML'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
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

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ML Initialization Error',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsContent(BuildContext context, MLPredictionService service) {
    return Column(
      children: [
        // Quick predictions overview
        _buildQuickPredictions(context, service),
        
        // Expandable detailed view
        if (_isExpanded) ...[
          _buildTabBar(context),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCyclePredictionTab(context, service),
                _buildSymptomPredictionTab(context, service),
                _buildMoodPredictionTab(context, service),
                _buildPatternsTab(context, service),
              ],
            ),
          ),
        ],
        
        // Action buttons
        _buildActionButtons(context, service),
      ],
    );
  }

  Widget _buildQuickPredictions(BuildContext context, MLPredictionService service) {
    final cyclePrediction = service.currentCyclePrediction;
    final symptomPredictions = service.symptomPredictions;
    final moodPrediction = service.moodPrediction;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Predictions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Prediction cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildPredictionCard(
                'Next Period',
                cyclePrediction != null 
                    ? '${_formatDate(cyclePrediction.nextPeriodDate)}'
                    : '--',
                Icons.calendar_month,
                Colors.red,
                subtitle: cyclePrediction != null 
                    ? '${cyclePrediction.confidence * 100}% confidence'
                    : null,
              ),
              _buildPredictionCard(
                'Ovulation',
                cyclePrediction != null 
                    ? '${_formatDate(cyclePrediction.ovulationDate)}'
                    : '--',
                Icons.favorite,
                Colors.pink,
                subtitle: cyclePrediction != null 
                    ? 'Cycle length: ${cyclePrediction.predictedCycleLength}d'
                    : null,
              ),
              _buildPredictionCard(
                'Mood Trend',
                moodPrediction?.overallTrend ?? '--',
                Icons.mood,
                Colors.purple,
                subtitle: moodPrediction != null
                    ? '7-day outlook'
                    : null,
              ),
              _buildPredictionCard(
                'Symptoms',
                symptomPredictions.isNotEmpty
                    ? '${symptomPredictions.length} days predicted'
                    : '--',
                Icons.warning,
                Colors.orange,
                subtitle: symptomPredictions.isNotEmpty
                    ? 'Next 7 days'
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
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
        labelColor: Colors.indigo,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.indigo,
        tabs: const [
          Tab(text: 'Cycle'),
          Tab(text: 'Symptoms'),
          Tab(text: 'Mood'),
          Tab(text: 'Patterns'),
        ],
      ),
    );
  }

  Widget _buildCyclePredictionTab(BuildContext context, MLPredictionService service) {
    final prediction = service.currentCyclePrediction;
    
    if (prediction == null) {
      return Center(
        child: Text('No cycle prediction available', 
          style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cycle Predictions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Prediction details
          _buildDetailedMetricTile(
            'Next Period Date',
            _formatDate(prediction.nextPeriodDate),
            Icons.calendar_month,
            Colors.red,
            description: 'Predicted with ${(prediction.confidence * 100).toInt()}% confidence',
          ),
          _buildDetailedMetricTile(
            'Cycle Length',
            '${prediction.predictedCycleLength} days',
            Icons.timeline,
            Colors.blue,
            description: 'Based on ${prediction.basedOnCycles} previous cycles',
          ),
          _buildDetailedMetricTile(
            'Ovulation Date',
            _formatDate(prediction.ovulationDate),
            Icons.favorite,
            Colors.pink,
            description: 'Estimated 14 days before period',
          ),
          _buildDetailedMetricTile(
            'Fertility Window',
            '${_formatDateShort(prediction.fertilityWindowStart)} - ${_formatDateShort(prediction.fertilityWindowEnd)}',
            Icons.child_care,
            Colors.green,
            description: '6-day fertile window',
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomPredictionTab(BuildContext context, MLPredictionService service) {
    final predictions = service.symptomPredictions;
    
    if (predictions.isEmpty) {
      return Center(
        child: Text('No symptom predictions available', 
          style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Symptoms',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final prediction = predictions[index];
                return _buildSymptomPredictionCard(prediction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomPredictionCard(SymptomPrediction prediction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatDate(prediction.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Day ${prediction.dayInCycle}',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: prediction.predictedSymptoms.entries.map((entry) {
                final symptom = entry.key;
                final probability = entry.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSymptomColor(symptom).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$symptom (${(probability * 100).toInt()}%)',
                    style: TextStyle(
                      color: _getSymptomColor(symptom),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodPredictionTab(BuildContext context, MLPredictionService service) {
    final prediction = service.moodPrediction;
    
    if (prediction == null) {
      return Center(
        child: Text('No mood predictions available', 
          style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Predictions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Overall trend
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getMoodTrendColor(prediction.overallTrend).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _getMoodTrendIcon(prediction.overallTrend),
                  color: _getMoodTrendColor(prediction.overallTrend),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7-Day Mood Trend',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      prediction.overallTrend,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getMoodTrendColor(prediction.overallTrend),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Risk factors
          if (prediction.riskFactors.isNotEmpty) ...[
            Text(
              'Risk Factors',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...prediction.riskFactors.map((factor) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.orange[600]),
                  const SizedBox(width: 8),
                  Expanded(child: Text(factor)),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPatternsTab(BuildContext context, MLPredictionService service) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Patterns',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          FutureBuilder<List<HealthPattern>>(
            future: service.detectHealthPatterns(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No patterns detected yet',
                    style: TextStyle(color: Colors.grey[600])),
                );
              }
              
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final pattern = snapshot.data![index];
                    return _buildPatternCard(pattern);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatternCard(HealthPattern pattern) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getPatternColor(pattern.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getPatternIcon(pattern.type),
                color: _getPatternColor(pattern.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pattern.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Confidence: ${(pattern.confidence * 100).toInt()}%',
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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

  Widget _buildActionButtons(BuildContext context, MLPredictionService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Expand/Collapse button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              label: Text(_isExpanded ? 'Show Less' : 'Show Detailed Predictions'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Action buttons row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _loadPredictions(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
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
                  onPressed: () => _exportPredictions(service),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _exportPredictions(MLPredictionService service) {
    // In a real implementation, export predictions to file or share
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Predictions'),
        content: const Text('Prediction export feature coming soon!'),
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
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference > 0) return 'In $difference days';
    return '${-difference} days ago';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Color _getSymptomColor(String symptom) {
    switch (symptom.toLowerCase()) {
      case 'cramps':
        return Colors.red;
      case 'bloating':
        return Colors.orange;
      case 'acne':
        return Colors.purple;
      case 'mood swings':
        return Colors.pink;
      case 'fatigue':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Color _getMoodTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'challenging':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getMoodTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'positive':
        return Icons.trending_up;
      case 'challenging':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getPatternColor(PatternType type) {
    switch (type) {
      case PatternType.positive:
        return Colors.green;
      case PatternType.concerning:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getPatternIcon(PatternType type) {
    switch (type) {
      case PatternType.positive:
        return Icons.check_circle;
      case PatternType.concerning:
        return Icons.warning;
      default:
        return Icons.info;
    }
  }
}
