import 'package:flutter/material.dart';
import '../models/health_diagnosis.dart';
import '../services/health_diagnosis_service.dart';
import '../services/flow_iq_sync_service.dart';

class HealthDiagnosisScreen extends StatefulWidget {
  const HealthDiagnosisScreen({super.key});

  @override
  State<HealthDiagnosisScreen> createState() => _HealthDiagnosisScreenState();
}

class _HealthDiagnosisScreenState extends State<HealthDiagnosisScreen>
    with TickerProviderStateMixin {
  late HealthDiagnosisService _diagnosisService;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _diagnosisService = HealthDiagnosisService(FlowIQSyncService());
    _loadDiagnoses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDiagnoses() async {
    await _diagnosisService.loadDiagnoses();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Assessment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Dashboard', icon: Icon(Icons.dashboard_outlined)),
            Tab(text: 'History', icon: Icon(Icons.history_outlined)),
            Tab(text: 'Screening', icon: Icon(Icons.health_and_safety_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildHistoryTab(),
          _buildScreeningTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startHealthScreening,
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.health_and_safety),
        label: const Text('Health Screening'),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildHighRiskAlerts(),
          const SizedBox(height: 20),
          _buildFollowUpReminders(),
          const SizedBox(height: 20),
          _buildRecentDiagnoses(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final diagnoses = _diagnosisService.diagnoses;

    if (diagnoses.isEmpty) {
      return _buildEmptyState(
        'No Health Assessments',
        'Complete a health screening to get personalized insights about your menstrual health.',
        Icons.health_and_safety_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diagnoses.length,
      itemBuilder: (context, index) {
        final diagnosis = diagnoses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDiagnosisCard(diagnosis),
        );
      },
    );
  }

  Widget _buildScreeningTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menstrual Health Conditions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Learn about common menstrual health conditions and their symptoms.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ...MenstrualCondition.values.map((condition) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildConditionCard(condition),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.health_and_safety,
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
                        'Health Assessment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AI-powered screening for menstrual health conditions',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Our AI analyzes your tracking data to identify potential health conditions '
              'and provide personalized recommendations. Early detection can help you '
              'get the right care at the right time.',
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startHealthScreening,
                    child: const Text('Start Screening'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _tabController.animateTo(2),
                    child: const Text('Learn More'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighRiskAlerts() {
    final highRiskDiagnoses = _diagnosisService.getHighRiskDiagnoses();

    if (highRiskDiagnoses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attention Required',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red[600],
          ),
        ),
        const SizedBox(height: 12),
        ...highRiskDiagnoses.map((diagnosis) => Card(
          color: Colors.red[50],
          child: ListTile(
            leading: Icon(Icons.warning, color: Colors.red[600]),
            title: Text(
              diagnosis.conditionName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('High risk - Professional consultation recommended'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDiagnosisDetails(diagnosis),
          ),
        )),
      ],
    );
  }

  Widget _buildFollowUpReminders() {
    final followUpDiagnoses = _diagnosisService.getDiagnosesDueForFollowUp();

    if (followUpDiagnoses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow-up Reminders',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...followUpDiagnoses.map((diagnosis) => Card(
          color: Colors.orange[50],
          child: ListTile(
            leading: Icon(Icons.schedule, color: Colors.orange[600]),
            title: Text(diagnosis.conditionName),
            subtitle: Text('Follow-up due: ${_formatDate(diagnosis.followUpDate!)}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDiagnosisDetails(diagnosis),
          ),
        )),
      ],
    );
  }

  Widget _buildRecentDiagnoses() {
    final recentDiagnoses = _diagnosisService.diagnoses.take(3).toList();

    if (recentDiagnoses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Assessments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _tabController.animateTo(1),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentDiagnoses.map((diagnosis) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildDiagnosisCard(diagnosis),
        )),
      ],
    );
  }

  Widget _buildDiagnosisCard(HealthDiagnosis diagnosis) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getSeverityColor(diagnosis.severity).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            diagnosis.type.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          diagnosis.conditionName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Risk Level: ${_getRiskText(diagnosis.riskScore)}'),
            Text('${_formatDate(diagnosis.createdAt)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getSeverityColor(diagnosis.severity),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                diagnosis.severity.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        isThreeLine: true,
        onTap: () => _showDiagnosisDetails(diagnosis),
      ),
    );
  }

  Widget _buildConditionCard(MenstrualCondition condition) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.health_and_safety,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          condition.displayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(condition.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Common Symptoms:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: condition.commonSymptoms
                      .take(6)
                      .map((symptom) => Chip(
                            label: Text(symptom),
                            backgroundColor: Colors.grey[100],
                            labelStyle: const TextStyle(fontSize: 12),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Risk Factors:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                ...condition.riskFactors.take(4).map((factor) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 6, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(child: Text(factor, style: TextStyle(color: Colors.grey[700]))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startHealthScreening,
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Start Health Screening'),
            ),
          ],
        ),
      ),
    );
  }

  void _startHealthScreening() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Analyzing your health data...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );

    _diagnosisService.performHealthScreening().then((newDiagnoses) {
      Navigator.pop(context); // Close loading dialog
      
      if (newDiagnoses.isNotEmpty) {
        _showScreeningResults(newDiagnoses);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health screening completed. No significant risks detected.'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      setState(() {}); // Refresh the UI
    }).catchError((error) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during screening: $error')),
      );
    });
  }

  void _showScreeningResults(List<HealthDiagnosis> diagnoses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _ScreeningResultsSheet(
          diagnoses: diagnoses,
          scrollController: scrollController,
          onViewDetails: _showDiagnosisDetails,
        ),
      ),
    );
  }

  void _showDiagnosisDetails(HealthDiagnosis diagnosis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _DiagnosisDetailsSheet(
          diagnosis: diagnosis,
          scrollController: scrollController,
          onMarkReviewed: () => _diagnosisService.markAsReviewed(diagnosis.id),
          onDelete: () => _diagnosisService.deleteDiagnosis(diagnosis.id),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Assessment Help'),
        content: const SingleChildScrollView(
          child: Text(
            'Health Assessment Features:\n\n'
            '• AI-powered screening for menstrual health conditions\n'
            '• Risk assessment based on your tracking data\n'
            '• Personalized recommendations\n'
            '• Professional consultation guidance\n\n'
            'Important Disclaimer:\n'
            'This tool is for informational purposes only and should not replace professional medical advice. Always consult with a healthcare provider for proper diagnosis and treatment.\n\n'
            'Privacy:\n'
            'All health assessments are encrypted and stored securely. You control what data is shared.',
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

  Color _getSeverityColor(DiagnosisSeverity severity) {
    switch (severity) {
      case DiagnosisSeverity.low:
        return Colors.green;
      case DiagnosisSeverity.mild:
        return Colors.lightGreen;
      case DiagnosisSeverity.moderate:
        return Colors.orange;
      case DiagnosisSeverity.high:
        return Colors.red;
      case DiagnosisSeverity.critical:
        return Colors.red[800]!;
    }
  }

  String _getRiskText(double riskScore) {
    if (riskScore >= 0.7) return 'High Risk';
    if (riskScore >= 0.4) return 'Moderate Risk';
    return 'Low Risk';
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
}

// Screening Results Sheet
class _ScreeningResultsSheet extends StatelessWidget {
  final List<HealthDiagnosis> diagnoses;
  final ScrollController scrollController;
  final Function(HealthDiagnosis) onViewDetails;

  const _ScreeningResultsSheet({
    required this.diagnoses,
    required this.scrollController,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Health Screening Results',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: diagnoses.map((diagnosis) => Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(diagnosis.severity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.health_and_safety,
                        color: _getSeverityColor(diagnosis.severity),
                      ),
                    ),
                    title: Text(diagnosis.conditionName),
                    subtitle: Text('Risk Score: ${(diagnosis.riskScore * 100).toInt()}%'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onViewDetails(diagnosis);
                      },
                      child: const Text('View Details'),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(DiagnosisSeverity severity) {
    switch (severity) {
      case DiagnosisSeverity.low:
        return Colors.green;
      case DiagnosisSeverity.mild:
        return Colors.lightGreen;
      case DiagnosisSeverity.moderate:
        return Colors.orange;
      case DiagnosisSeverity.high:
        return Colors.red;
      case DiagnosisSeverity.critical:
        return Colors.red[800]!;
    }
  }
}

// Diagnosis Details Sheet
class _DiagnosisDetailsSheet extends StatelessWidget {
  final HealthDiagnosis diagnosis;
  final ScrollController scrollController;
  final VoidCallback onMarkReviewed;
  final VoidCallback onDelete;

  const _DiagnosisDetailsSheet({
    required this.diagnosis,
    required this.scrollController,
    required this.onMarkReviewed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  diagnosis.conditionName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Share functionality
                },
                icon: const Icon(Icons.share_outlined),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Assessment
                  Text(
                    'Assessment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(diagnosis.assessment),
                  
                  const SizedBox(height: 20),
                  
                  // Recommendation
                  Text(
                    'Recommendation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(diagnosis.recommendation),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Risk Factors
                  if (diagnosis.riskFactors.isNotEmpty) ...[
                    Text(
                      'Risk Factors Identified',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...diagnosis.riskFactors.map((factor) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(child: Text(factor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Symptoms
                  if (diagnosis.symptoms.isNotEmpty) ...[
                    Text(
                      'Symptoms Matched',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: diagnosis.symptoms.map((symptom) => 
                        Chip(
                          label: Text(symptom),
                          backgroundColor: Colors.orange[100],
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  // Actions
                  if (diagnosis.requiresProfessionalConsultation)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning, color: Colors.red[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Professional Consultation Recommended',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to find healthcare providers
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                            ),
                            child: const Text('Find Healthcare Providers'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
