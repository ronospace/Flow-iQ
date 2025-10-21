import 'package:flutter/material.dart';
import '../widgets/flow_iq_components.dart';

class DashboardExample extends StatefulWidget {
  const DashboardExample({super.key});

  @override
  State<DashboardExample> createState() => _DashboardExampleState();
}

class _DashboardExampleState extends State<DashboardExample> {
  bool _showAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow iQ Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Alert Banner
            if (_showAlert)
              AlertBanner(
                message: 'Patient data sync completed successfully. 3 new entries processed.',
                type: 'success',
                actionText: 'View Details',
                onAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing sync details...')),
                  );
                },
                onClose: () {
                  setState(() {
                    _showAlert = false;
                  });
                },
              ),
            
            // Welcome Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, Dr. Smith',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Today you have 12 patients scheduled and 3 priority alerts',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            // Metrics Overview
            const SectionHeader(
              title: 'Clinical Overview',
              subtitle: 'Today\'s key metrics and status',
              icon: Icons.analytics,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  MetricCard(
                    title: 'Active Patients',
                    value: '247',
                    icon: Icons.people,
                    status: 'normal',
                    trend: 'up',
                    subtitle: '+12 this month',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening patient list...')),
                      );
                    },
                  ),
                  MetricCard(
                    title: 'Cycle Accuracy',
                    value: '94.2',
                    unit: '%',
                    icon: Icons.track_changes,
                    status: 'normal',
                    trend: 'stable',
                    subtitle: 'Last 30 days avg',
                  ),
                  MetricCard(
                    title: 'Critical Alerts',
                    value: '3',
                    icon: Icons.warning,
                    status: 'attention',
                    trend: 'down',
                    subtitle: 'Requires attention',
                  ),
                  MetricCard(
                    title: 'Data Quality',
                    value: '98.7',
                    unit: '%',
                    icon: Icons.verified,
                    status: 'normal',
                    trend: 'up',
                    subtitle: 'Sync reliability',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progress Section
            const SectionHeader(
              title: 'Treatment Progress',
              subtitle: 'Patient compliance and outcomes',
              icon: Icons.timeline,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClinicalCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overall Treatment Compliance',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '87% of patients are following their treatment plans effectively',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ProgressRing(
                          progress: 0.87,
                          size: 80,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '87%',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'compliance',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        StatusIndicator(
                          status: 'normal',
                          label: '180 Compliant',
                        ),
                        const SizedBox(width: 12),
                        StatusIndicator(
                          status: 'attention',
                          label: '35 At Risk',
                        ),
                        const SizedBox(width: 12),
                        StatusIndicator(
                          status: 'urgent',
                          label: '12 Non-compliant',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            const SectionHeader(
              title: 'Quick Actions',
              subtitle: 'Common clinical tasks',
              icon: Icons.flash_on,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'New Patient',
                          icon: Icons.person_add,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening new patient form...')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GradientButton(
                          text: 'Sync Data',
                          icon: Icons.sync,
                          gradientColors: [
                            Colors.teal.shade400,
                            Colors.cyan.shade400,
                          ],
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Syncing patient data...')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    text: 'Generate Report',
                    icon: Icons.assessment,
                    gradientColors: [
                      Colors.purple.shade400,
                      Colors.deepPurple.shade400,
                    ],
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating clinical report...')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity Section
            const SectionHeader(
              title: 'Recent Activity',
              subtitle: 'Latest patient interactions',
              icon: Icons.history,
              actionText: 'View All',
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ClinicalCard(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: const Text('Sarah Johnson updated cycle data'),
                      subtitle: const Text('2 minutes ago • Cycle day 14'),
                      trailing: StatusIndicator(
                        status: 'normal',
                        label: 'Synced',
                        showLabel: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClinicalCard(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.warning,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text('Emma Wilson - Irregular pattern detected'),
                      subtitle: const Text('15 minutes ago • Requires review'),
                      trailing: StatusIndicator(
                        status: 'attention',
                        label: 'Review',
                        showLabel: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClinicalCard(
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                      title: const Text('Lisa Chen completed treatment milestone'),
                      subtitle: const Text('1 hour ago • 90-day compliance achieved'),
                      trailing: StatusIndicator(
                        status: 'normal',
                        label: 'Complete',
                        showLabel: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
