import 'package:flutter/material.dart';
import '../models/cycle_data.dart';

class CycleProgressCard extends StatelessWidget {
  final CycleData cycle;

  const CycleProgressCard({
    super.key,
    required this.cycle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Cycle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPhaseColor(cycle.currentPhase).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cycle.currentPhase.displayName,
                    style: TextStyle(
                      color: _getPhaseColor(cycle.currentPhase),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Cycle progress circle
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: cycle.completionPercentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPhaseColor(cycle.currentPhase),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Day ${DateTime.now().difference(cycle.startDate).inDays + 1}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of ${cycle.cycleLength}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Phase description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getPhaseColor(cycle.currentPhase).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cycle.currentPhase.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cycle stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Next Period',
                  '${cycle.daysUntilNextPeriod} days',
                  Icons.calendar_today,
                ),
                _buildStatItem(
                  context,
                  'Cycle Length',
                  '${cycle.cycleLength} days',
                  Icons.timeline,
                ),
                if (cycle.periodLength != null)
                  _buildStatItem(
                    context,
                    'Period Length',
                    '${cycle.periodLength} days',
                    Icons.water_drop,
                  ),
              ],
            ),
            
            // Sync status indicator
            if (cycle.isSyncedWithFlowIQ)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sync,
                      size: 14,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Synced with Flow-iQ',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Colors.red[400]!;
      case CyclePhase.follicular:
        return Colors.green[400]!;
      case CyclePhase.ovulatory:
        return Colors.purple[400]!;
      case CyclePhase.luteal:
        return Colors.orange[400]!;
      case CyclePhase.unknown:
        return Colors.grey[400]!;
    }
  }
}
