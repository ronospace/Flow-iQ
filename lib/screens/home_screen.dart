import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/flow_iq_sync_service.dart';
import '../services/health_diagnosis_service.dart';
import '../models/cycle_data.dart';
import '../models/ai_insights.dart';
import '../widgets/cycle_progress_card.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/personalized_insight_card.dart';
import '../widgets/ml_predictions_widget.dart';
import '../services/enhanced_ai_service.dart';
import '../services/wearables_data_service.dart';
import '../services/voice_input_service.dart';
import '../widgets/wearables_dashboard_widget.dart';
import '../widgets/smart_voice_assistant.dart';
import '../screens/wearables_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlowIQSyncService _syncService = FlowIQSyncService();
  CycleData? _currentCycle;
  List<AIInsights> _recentInsights = [];
  List<PersonalizedInsight> _personalizedInsights = [];
  bool _isLoading = true;
  bool _isLoadingPersonalizedInsights = false;
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _updateGreeting();
    _loadPersonalizedInsights();
    _initializeWearables();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Good morning';
    } else if (hour < 17) {
      _greeting = 'Good afternoon';
    } else {
      _greeting = 'Good evening';
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load current cycle data
      _currentCycle = await _syncService.getCurrentCycle();
      
      // Load recent AI insights
      _recentInsights = await _syncService.getRecentInsights(limit: 3);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildGreetingSection(),
                        const SizedBox(height: 24),
                        _buildCycleOverview(),
                        const SizedBox(height: 24),
                        _buildMLPredictions(),
                        const SizedBox(height: 24),
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        _buildPersonalizedInsights(),
                        const SizedBox(height: 24),
                        _buildWearablesData(),
                        const SizedBox(height: 24),
                        _buildHealthAlerts(),
                        const SizedBox(height: 24),
                        _buildAIInsights(),
                        const SizedBox(height: 24),
                        _buildSyncStatus(),
                        const SizedBox(height: 100), // Extra space for FAB
                      ]),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _buildVoiceAssistantFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Flow iQ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Navigate to notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s how you\'re doing today',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCycleOverview() {
    if (_currentCycle == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.calendar_month,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Active Cycle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Start tracking your cycle to get personalized insights',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tracking');
                },
                child: const Text('Start Tracking'),
              ),
            ],
          ),
        ),
      );
    }

    return CycleProgressCard(cycle: _currentCycle!);
  }

  /// Build ML Predictions section
  Widget _buildMLPredictions() {
    // Only show ML predictions if we have an active cycle
    if (_currentCycle == null) {
      return const SizedBox.shrink(); // Don't show if no cycle data
    }

    final dayInCycle = DateTime.now().difference(_currentCycle!.startDate).inDays + 1;

    return MLPredictionsWidget(
      currentPhase: _currentCycle!.currentPhase,
      dayInCycle: dayInCycle,
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const QuickActionButtons(),
      ],
    );
  }

  Widget _buildHealthAlerts() {
    return Consumer<HealthDiagnosisService>(
      builder: (context, diagnosisService, child) {
        final highRiskDiagnoses = diagnosisService.getHighRiskDiagnoses();
        final followUpDiagnoses = diagnosisService.getDiagnosesDueForFollowUp();
        
        // If no health alerts, show health screening promotion
        if (highRiskDiagnoses.isEmpty && followUpDiagnoses.isEmpty) {
          return Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.health_and_safety,
                      color: Colors.blue[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Assessment Available',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          'Get AI-powered health screening for menstrual conditions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to health tab
                      // This would need proper navigation implementation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      'Screen Now',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show health alerts
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Alerts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 12),
            
            // High risk diagnoses
            ...highRiskDiagnoses.map((diagnosis) => Card(
              color: Colors.red[50],
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.red[600]),
                title: Text(
                  diagnosis.conditionName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Requires professional consultation'),
                trailing: TextButton(
                  onPressed: () {
                    // Navigate to health diagnosis details
                  },
                  child: const Text('View Details'),
                ),
              ),
            )),
            
            // Follow-up reminders
            ...followUpDiagnoses.map((diagnosis) => Card(
              color: Colors.orange[50],
              child: ListTile(
                leading: Icon(Icons.schedule, color: Colors.orange[600]),
                title: Text(diagnosis.conditionName),
                subtitle: Text('Follow-up due: ${_formatDate(diagnosis.followUpDate!)}'),
                trailing: TextButton(
                  onPressed: () {
                    // Navigate to health diagnosis details
                  },
                  child: const Text('View Details'),
                ),
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AI Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_recentInsights.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/insights');
                },
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recentInsights.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Insights Yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track more data to receive personalized AI insights',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: _recentInsights
                .map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AIInsightCard(insight: insight),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildSyncStatus() {
    return FutureBuilder<bool>(
      future: _syncService.isConnectedToFlowIQ(),
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        
        return Card(
          color: isConnected ? Colors.green[50] : Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.sync : Icons.sync_problem,
                  color: isConnected ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isConnected 
                            ? 'Synced with Flow-iQ' 
                            : 'Flow-iQ Sync Disabled',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        isConnected 
                            ? 'Your data is automatically synchronized'
                            : 'Tap to connect with Flow-iQ for enhanced insights',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isConnected)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: const Text('Connect'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Load personalized insights from Enhanced AI service
  Future<void> _loadPersonalizedInsights() async {
    if (!mounted) return;
    
    setState(() => _isLoadingPersonalizedInsights = true);
    
    try {
      final enhancedAI = Provider.of<EnhancedAIService>(context, listen: false);
      final currentPhase = _currentCycle?.currentPhase ?? CyclePhase.unknown;
      
      final insights = await enhancedAI.generatePersonalizedInsights(
        currentPhase: currentPhase,
        limit: 3,
      );
      
      if (mounted) {
        setState(() {
          _personalizedInsights = insights;
        });
      }
    } catch (e) {
      debugPrint('Error loading personalized insights: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingPersonalizedInsights = false);
      }
    }
  }

  /// Initialize wearables data service
  Future<void> _initializeWearables() async {
    if (!mounted) return;
    
    try {
      final wearablesService = Provider.of<WearablesDataService>(context, listen: false);
      await wearablesService.initialize();
    } catch (e) {
      debugPrint('Error initializing wearables: $e');
    }
  }

  /// Build personalized insights section
  Widget _buildPersonalizedInsights() {
    return Consumer<EnhancedAIService>(
      builder: (context, enhancedAI, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Personalized for You',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_personalizedInsights.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      // Navigate to personalized insights screen
                    },
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoadingPersonalizedInsights)
              const Center(child: CircularProgressIndicator())
            else if (_personalizedInsights.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Getting to Know You',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track more data to receive personalized recommendations',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: _personalizedInsights
                    .map((insight) => PersonalizedInsightCard(
                          insight: insight,
                          onTap: () => _handleInsightTap(insight),
                          onFeedback: () => _handleInsightFeedback(insight),
                        ))
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  /// Build wearables data section
  Widget _buildWearablesData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.watch,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Health & Wearables',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WearablesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              label: const Text('View All'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Use the enhanced WearablesDashboardWidget
        const WearablesDashboardWidget(),
      ],
    );
  }


  /// Handle insight tap
  void _handleInsightTap(PersonalizedInsight insight) {
    // Navigate to detailed view or take action based on insight type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${insight.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle insight feedback
  void _handleInsightFeedback(PersonalizedInsight insight) {
    // Send feedback to Enhanced AI service
    final enhancedAI = Provider.of<EnhancedAIService>(context, listen: false);
    final feedback = UserFeedback(
      insightId: insight.id,
      type: FeedbackType.helpful,
      rating: 1.0,
      timestamp: DateTime.now(),
    );
    
    enhancedAI.updatePersonalizationWithFeedback(feedback);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Build voice assistant floating action button
  Widget _buildVoiceAssistantFAB() {
    return Consumer<VoiceInputService>(
      builder: (context, voiceService, child) {
        return const SmartVoiceAssistant(isFloating: true);
      },
    );
  }
}
