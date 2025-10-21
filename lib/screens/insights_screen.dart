import 'package:flutter/material.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.lightbulb_outlined)),
            Tab(text: 'Pinned', icon: Icon(Icons.push_pin_outlined)),
            Tab(text: 'Recent', icon: Icon(Icons.schedule_outlined)),
            Tab(text: 'ML Predictions', icon: Icon(Icons.psychology)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAllInsightsTab(),
                _buildPinnedInsightsTab(),
                _buildRecentInsightsTab(),
                _buildMLPredictionsTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateNewInsight,
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate Insight'),
      ),
    );
  }

  Widget _buildAllInsightsTab() {
    return _buildEmptyState('AI Insights Coming Soon', 'Advanced AI insights will appear here as you continue tracking your cycle.');
  }

  Widget _buildPinnedInsightsTab() {
    return _buildEmptyState('No pinned insights', 'Pin important insights to access them quickly.');
  }

  Widget _buildRecentInsightsTab() {
    return _buildEmptyState('No recent insights', 'New insights will appear here as they\'re generated.');
  }

  Widget _buildMLPredictionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ML Predictions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.purple),
                      const SizedBox(width: 8),
                      const Text(
                        'Cycle Predictions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ML-powered predictions will be available here once you have enough cycle data.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generateNewInsight,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate New Insight'),
          ),
        ],
      ),
    );
  }

  void _generateNewInsight() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI insight generation coming soon!')),
    );
  }
}
