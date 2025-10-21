import 'package:flutter/material.dart';
import '../widgets/daily_feelings_widget.dart';

/// Demo Screen for Daily Feelings Intelligence System
/// 
/// This demonstrates the complete feelings tracking system with:
/// - Smart contextual questioning
/// - Intelligent insights and pattern detection
/// - Adaptive UI based on time of day and user patterns
/// - Cross-app compatibility (Flow iQ Clinical vs Flow AI Consumer)
/// - Real-time analytics and trend visualization
class DailyFeelingsDemoScreen extends StatefulWidget {
  final bool isFlowIQClinical;
  
  const DailyFeelingsDemoScreen({
    Key? key,
    this.isFlowIQClinical = false,
  }) : super(key: key);

  @override
  State<DailyFeelingsDemoScreen> createState() => _DailyFeelingsDemoScreenState();
}

class _DailyFeelingsDemoScreenState extends State<DailyFeelingsDemoScreen> {
  bool _showFullWidget = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFlowIQClinical ? 'Clinical Wellness Intelligence' : 'Daily Feelings AI',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: widget.isFlowIQClinical 
            ? const Color(0xFF667eea)
            : const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isFlowIQClinical
                ? [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    Colors.white,
                  ]
                : [
                    const Color(0xFF6B73FF),
                    const Color(0xFF9DD5FF),
                    Colors.white,
                  ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: _showFullWidget 
              ? _buildFullFeelingsWidget()
              : _buildDemoOverview(),
        ),
      ),
    );
  }
  
  Widget _buildDemoOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          _buildFeatureHighlights(),
          const SizedBox(height: 30),
          _buildDemoSummaryCard(),
          const SizedBox(height: 30),
          _buildActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildFullFeelingsWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DailyFeelingsWidget(
        isFlowIQClinical: widget.isFlowIQClinical,
        onCompleted: () {
          setState(() {
            _showFullWidget = false;
          });
        },
      ),
    );
  }
  
  Widget _buildHeader() {
    final now = DateTime.now();
    final isMorning = now.hour < 14;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.isFlowIQClinical 
                    ? Icons.medical_services
                    : (isMorning ? Icons.wb_sunny : Icons.nightlight_round),
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isFlowIQClinical 
                        ? 'Clinical Wellness Intelligence'
                        : 'Daily Feelings AI System',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revolutionizing emotional health tracking with intelligent insights',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildFeatureHighlights() {
    final features = widget.isFlowIQClinical 
        ? [
            _FeatureData(
              icon: Icons.psychology,
              title: 'Clinical-Grade Analysis',
              description: 'Medical-level mood correlation & predictive insights',
            ),
            _FeatureData(
              icon: Icons.show_chart,
              title: 'Cycle Integration',
              description: 'Correlates feelings with menstrual cycle phases',
            ),
            _FeatureData(
              icon: Icons.security,
              title: 'HIPAA Compliant',
              description: 'Secure, encrypted clinical-grade data storage',
            ),
            _FeatureData(
              icon: Icons.health_and_safety,
              title: 'Healthcare Provider Sharing',
              description: 'Seamless integration with medical professionals',
            ),
          ]
        : [
            _FeatureData(
              icon: Icons.smart_toy,
              title: 'AI-Powered Intelligence',
              description: 'Smart contextual questioning adapts to your patterns',
            ),
            _FeatureData(
              icon: Icons.auto_graph,
              title: 'Pattern Recognition',
              description: 'Detects mood patterns across days, weeks & cycles',
            ),
            _FeatureData(
              icon: Icons.notifications_active,
              title: 'Adaptive Notifications',
              description: 'Learns optimal times for check-ins',
            ),
            _FeatureData(
              icon: Icons.trending_up,
              title: 'Longitudinal Tracking',
              description: 'Long-term wellness trends & performance analytics',
            ),
          ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feature.icon,
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildDemoSummaryCard() {
    return DailyFeelingsSummaryWidget(
      isFlowIQClinical: widget.isFlowIQClinical,
      onTap: () {
        setState(() {
          _showFullWidget = true;
        });
      },
    );
  }
  
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showFullWidget = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: widget.isFlowIQClinical 
                  ? const Color(0xFF667eea)
                  : const Color(0xFF6B73FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              widget.isFlowIQClinical 
                  ? 'Start Clinical Assessment'
                  : 'Start Daily Check-in',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showInfoDialog('System Architecture'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Architecture'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showInfoDialog('Analytics Demo'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Analytics'),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _showInfoDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type),
        content: Text(_getInfoContent(type)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  String _getInfoContent(String type) {
    switch (type) {
      case 'System Architecture':
        return '''
🧠 INTELLIGENT DAILY FEELINGS SYSTEM

Core Components:
• DailyFeelingsIntelligenceService - Main service logic
• Smart contextual question generation
• ML-powered pattern detection
• Adaptive notification system
• Cross-app data synchronization

Data Models:
• DailyFeelingsEntry with metadata
• FeelingsPattern with confidence scores
• FeelingsInsight with actionable suggestions
• Performance analytics & trends

Key Features:
• Twice-daily adaptive questioning
• Menstrual cycle correlation (Flow iQ)
• Real-time insights generation
• Longitudinal trend analysis
• Intelligent intervention suggestions
        ''';
      case 'Analytics Demo':
        return '''
📊 ANALYTICS & INSIGHTS

Performance Metrics:
• Overall wellbeing trend analysis
• Morning vs Evening patterns
• Weekly/monthly consistency scores
• Streak tracking & gamification

Pattern Detection:
• Weekday mood correlations
• Seasonal affective patterns
• Cycle-based mood variations (Flow iQ)
• Stress response patterns

Intelligent Features:
• Predictive mood forecasting
• Intervention recommendations
• Personalized wellness tips
• Healthcare provider integration (Flow iQ)

Visualization:
• Interactive mood charts
• Pattern correlation graphs
• Trend prediction displays
• Progress milestone tracking
        ''';
      default:
        return 'Information not available.';
    }
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  
  _FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
