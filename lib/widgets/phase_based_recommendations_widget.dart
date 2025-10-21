import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/phase_based_recommendations_service.dart';
import '../models/cycle_data.dart';

/// Widget that displays personalized recommendations based on menstrual cycle phase
class PhaseBasedRecommendationsWidget extends StatefulWidget {
  final CyclePhase currentPhase;
  final DateTime? cycleDay;
  final bool showHeader;
  final int maxRecommendations;

  const PhaseBasedRecommendationsWidget({
    Key? key,
    required this.currentPhase,
    this.cycleDay,
    this.showHeader = true,
    this.maxRecommendations = 6,
  }) : super(key: key);

  @override
  State<PhaseBasedRecommendationsWidget> createState() => _PhaseBasedRecommendationsWidgetState();
}

class _PhaseBasedRecommendationsWidgetState extends State<PhaseBasedRecommendationsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  RecommendationCategory _selectedCategory = RecommendationCategory.wellness;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: RecommendationCategory.values.length, vsync: this);
    
    // Load recommendations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  @override
  void didUpdateWidget(PhaseBasedRecommendationsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPhase != widget.currentPhase ||
        oldWidget.cycleDay != widget.cycleDay) {
      _loadRecommendations();
    }
  }

  void _loadRecommendations() {
    final service = context.read<PhaseBasedRecommendationsService>();
    service.generateRecommendations(
      currentPhase: widget.currentPhase,
      cycleDay: widget.cycleDay,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhaseBasedRecommendationsService>(
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
                  _getPhaseColor(widget.currentPhase).withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                if (widget.showHeader) _buildHeader(context, service),
                
                // Content
                if (service.isLoading)
                  _buildLoadingState()
                else if (service.currentRecommendations.isEmpty)
                  _buildEmptyState()
                else
                  _buildRecommendationsContent(context, service),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PhaseBasedRecommendationsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: _getPhaseColor(widget.currentPhase).withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getPhaseColor(widget.currentPhase).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPhaseIcon(widget.currentPhase),
                  color: _getPhaseColor(widget.currentPhase),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalized for Your ${_getPhaseName(widget.currentPhase)} Phase',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getPhaseColor(widget.currentPhase),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-powered recommendations based on your cycle and health data',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (service.lastUpdateTime != null)
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
                        'Updated',
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
            valueColor: AlwaysStoppedAnimation(_getPhaseColor(widget.currentPhase)),
          ),
          const SizedBox(height: 16),
          Text(
            'Generating personalized recommendations...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Recommendations Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track more data to receive personalized recommendations',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsContent(
    BuildContext context,
    PhaseBasedRecommendationsService service,
  ) {
    return Column(
      children: [
        // Category tabs
        _buildCategoryTabs(context, service),
        
        // Recommendations list
        _buildRecommendationsList(context, service),
        
        // Action buttons
        _buildActionButtons(context, service),
      ],
    );
  }

  Widget _buildCategoryTabs(BuildContext context, PhaseBasedRecommendationsService service) {
    final categories = RecommendationCategory.values;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            final count = service.getRecommendationsByCategory(category).length;
            
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? _getPhaseColor(widget.currentPhase)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? _getPhaseColor(widget.currentPhase)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getCategoryName(category),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.3)
                              : _getPhaseColor(widget.currentPhase).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : _getPhaseColor(widget.currentPhase),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(
    BuildContext context,
    PhaseBasedRecommendationsService service,
  ) {
    final recommendations = service.getRecommendationsByCategory(_selectedCategory)
        .take(widget.maxRecommendations)
        .toList();
    
    if (recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              _getCategoryIcon(_selectedCategory),
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No ${_getCategoryName(_selectedCategory)} recommendations',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final recommendation = recommendations[index];
          return _buildRecommendationCard(context, recommendation, service);
        },
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    PersonalizedRecommendation recommendation,
    PhaseBasedRecommendationsService service,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showRecommendationDetails(context, recommendation, service),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(recommendation.priority).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconData(recommendation.icon),
                        color: _getPriorityColor(recommendation.priority),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (recommendation.dataInsight != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              recommendation.dataInsight!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Priority indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(recommendation.priority),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        recommendation.priority.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  recommendation.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Benefit and personalization score
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up, size: 16, color: Colors.green[600]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                recommendation.estimatedBenefit,
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPhaseColor(widget.currentPhase).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: _getPhaseColor(widget.currentPhase),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(recommendation.personalizedScore * 100).toInt()}%',
                            style: TextStyle(
                              color: _getPhaseColor(widget.currentPhase),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: recommendation.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 12),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleRecommendationFeedback(
                          context,
                          recommendation,
                          service,
                          false,
                        ),
                        icon: const Icon(Icons.thumb_down_outlined, size: 16),
                        label: const Text('Not Helpful'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleRecommendationFeedback(
                          context,
                          recommendation,
                          service,
                          true,
                        ),
                        icon: const Icon(Icons.thumb_up, size: 16),
                        label: const Text('Helpful'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getPhaseColor(widget.currentPhase),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PhaseBasedRecommendationsService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _loadRecommendations(),
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
              onPressed: () => _showAllRecommendations(context, service),
              icon: const Icon(Icons.list),
              label: const Text('View All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPhaseColor(widget.currentPhase),
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
    );
  }

  void _showRecommendationDetails(
    BuildContext context,
    PersonalizedRecommendation recommendation,
    PhaseBasedRecommendationsService service,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _RecommendationDetailsSheet(
        recommendation: recommendation,
        phaseColor: _getPhaseColor(widget.currentPhase),
        onFeedback: (isPositive, feedback) {
          service.recordUserResponse(recommendation.id, isPositive, feedback);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleRecommendationFeedback(
    BuildContext context,
    PersonalizedRecommendation recommendation,
    PhaseBasedRecommendationsService service,
    bool isPositive,
  ) {
    service.recordUserResponse(recommendation.id, isPositive, null);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPositive
              ? 'Thanks! We\'ll show more similar recommendations.'
              : 'Got it! We\'ll adjust future recommendations.',
        ),
        backgroundColor: isPositive ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAllRecommendations(BuildContext context, PhaseBasedRecommendationsService service) {
    // Navigate to full recommendations view or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Recommendations'),
        content: const Text('Full recommendations view coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper methods for UI styling
  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Colors.red;
      case CyclePhase.follicular:
        return Colors.green;
      case CyclePhase.ovulatory:
        return Colors.purple;
      case CyclePhase.luteal:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getPhaseIcon(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Icons.water_drop;
      case CyclePhase.follicular:
        return Icons.energy_savings_leaf;
      case CyclePhase.ovulatory:
        return Icons.favorite;
      case CyclePhase.luteal:
        return Icons.self_improvement;
      default:
        return Icons.calendar_month;
    }
  }

  String _getPhaseName(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulatory:
        return 'Ovulatory';
      case CyclePhase.luteal:
        return 'Luteal';
      default:
        return 'Unknown';
    }
  }

  Color _getPriorityColor(RecommendationPriority priority) {
    switch (priority) {
      case RecommendationPriority.high:
        return Colors.red[600]!;
      case RecommendationPriority.medium:
        return Colors.orange[600]!;
      case RecommendationPriority.low:
        return Colors.green[600]!;
    }
  }

  IconData _getCategoryIcon(RecommendationCategory category) {
    switch (category) {
      case RecommendationCategory.nutrition:
        return Icons.restaurant;
      case RecommendationCategory.exercise:
        return Icons.fitness_center;
      case RecommendationCategory.wellness:
        return Icons.spa;
      case RecommendationCategory.lifestyle:
        return Icons.home;
      case RecommendationCategory.tracking:
        return Icons.analytics;
    }
  }

  String _getCategoryName(RecommendationCategory category) {
    switch (category) {
      case RecommendationCategory.nutrition:
        return 'Nutrition';
      case RecommendationCategory.exercise:
        return 'Exercise';
      case RecommendationCategory.wellness:
        return 'Wellness';
      case RecommendationCategory.lifestyle:
        return 'Lifestyle';
      case RecommendationCategory.tracking:
        return 'Tracking';
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'bedtime':
        return Icons.bedtime;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_drink':
        return Icons.local_drink;
      case 'energy_savings_leaf':
        return Icons.energy_savings_leaf;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'group':
        return Icons.group;
      case 'record_voice_over':
        return Icons.record_voice_over;
      case 'palette':
        return Icons.palette;
      case 'folder_special':
        return Icons.folder_special;
      case 'spa':
        return Icons.spa;
      case 'medication':
        return Icons.medication;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'thermostat':
        return Icons.thermostat;
      case 'work_history':
        return Icons.work_history;
      case 'phone_android':
        return Icons.phone_android;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'edit_note':
        return Icons.edit_note;
      case 'hot_tub':
        return Icons.hot_tub;
      default:
        return Icons.lightbulb;
    }
  }
}

/// Bottom sheet for detailed recommendation view
class _RecommendationDetailsSheet extends StatefulWidget {
  final PersonalizedRecommendation recommendation;
  final Color phaseColor;
  final Function(bool, String?) onFeedback;

  const _RecommendationDetailsSheet({
    required this.recommendation,
    required this.phaseColor,
    required this.onFeedback,
  });

  @override
  State<_RecommendationDetailsSheet> createState() => __RecommendationDetailsSheetState();
}

class __RecommendationDetailsSheetState extends State<_RecommendationDetailsSheet> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Title and icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.phaseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(widget.recommendation.icon),
                  color: widget.phaseColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recommendation.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Personalized for ${widget.recommendation.phase.name} phase',
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
          
          const SizedBox(height: 20),
          
          // Description
          Text(
            widget.recommendation.description,
            style: const TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 16),
          
          // Estimated benefit
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.recommendation.estimatedBenefit,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (widget.recommendation.dataInsight != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.phaseColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.insights, color: widget.phaseColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.recommendation.dataInsight!,
                      style: TextStyle(
                        color: widget.phaseColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.recommendation.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Feedback section
          Text(
            'Was this helpful?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          TextField(
            controller: _feedbackController,
            decoration: const InputDecoration(
              hintText: 'Share your feedback (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.onFeedback(false, _feedbackController.text),
                  child: const Text('Not Helpful'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onFeedback(true, _feedbackController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.phaseColor,
                  ),
                  child: const Text('Helpful'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Same implementation as in the parent widget
    switch (iconName) {
      case 'bedtime':
        return Icons.bedtime;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_drink':
        return Icons.local_drink;
      case 'energy_savings_leaf':
        return Icons.energy_savings_leaf;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'group':
        return Icons.group;
      case 'record_voice_over':
        return Icons.record_voice_over;
      case 'palette':
        return Icons.palette;
      case 'folder_special':
        return Icons.folder_special;
      case 'spa':
        return Icons.spa;
      case 'medication':
        return Icons.medication;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'thermostat':
        return Icons.thermostat;
      case 'work_history':
        return Icons.work_history;
      case 'phone_android':
        return Icons.phone_android;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'edit_note':
        return Icons.edit_note;
      case 'hot_tub':
        return Icons.hot_tub;
      default:
        return Icons.lightbulb;
    }
  }
}
