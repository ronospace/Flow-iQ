import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../services/smart_notification_service.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import '../widgets/common/banner_ad_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _recentCycles = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _cycleStatus;
  Map<String, dynamic>? _predictions;
  static DateTime?
  _lastSmartAnalysis; // Make static to persist across instances

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    // Trigger smart analysis after data loads
    _runSmartAnalysis();
  }

  Future<void> _runSmartAnalysis() async {
    // Throttle smart analysis - only run every 30 minutes
    final now = DateTime.now();
    if (_lastSmartAnalysis != null) {
      final timeSinceLastAnalysis = now
          .difference(_lastSmartAnalysis!)
          .inMinutes;
      if (timeSinceLastAnalysis < 30) {
        debugPrint(
          '🧠 Smart analysis skipped - throttled (${timeSinceLastAnalysis}min ago)',
        );
        return;
      }
    }

    // Run smart notification analysis in background
    try {
      await SmartNotificationService.runSmartAnalysis();
      _lastSmartAnalysis = now;
      debugPrint('🧠 Smart analysis completed on home screen');
    } catch (e) {
      debugPrint('❌ Smart analysis error: $e');
    }
  }

  // Helper method to parse DateTime from various formats
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        debugPrint(
          '⚠️ Failed to parse DateTime from string: $value, error: $e',
        );
        return null;
      }
    }

    // Handle Firestore Timestamp objects if needed
    if (value.runtimeType.toString().contains('Timestamp')) {
      try {
        return (value as dynamic).toDate();
      } catch (e) {
        debugPrint(
          '⚠️ Failed to parse DateTime from Timestamp: $value, error: $e',
        );
        return null;
      }
    }

    debugPrint('⚠️ Unknown DateTime format: ${value.runtimeType} - $value');
    return null;
  }

  Future<void> _loadDashboardData() async {
    try {
      final cycles = await FirebaseService.getCycles(limit: 5);
      final status = _calculateCycleStatus(cycles);
      final predictions = _calculatePredictions(cycles);

      setState(() {
        _recentCycles = cycles;
        _cycleStatus = status;
        _predictions = predictions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? _calculateCycleStatus(
    List<Map<String, dynamic>> cycles,
  ) {
    if (cycles.isEmpty) return null;

    final now = DateTime.now();
    final lastCycle = cycles.first;

    // Safe date parsing
    DateTime? startDate;
    DateTime? endDate;

    try {
      // Parse start date
      if (lastCycle['start'] != null) {
        if (lastCycle['start'] is DateTime) {
          startDate = lastCycle['start'];
        } else if (lastCycle['start_date'] != null) {
          startDate = _parseDateTime(lastCycle['start_date']);
        } else {
          startDate = _parseDateTime(lastCycle['start']);
        }
      }

      // Parse end date
      if (lastCycle['end'] != null) {
        if (lastCycle['end'] is DateTime) {
          endDate = lastCycle['end'];
        } else if (lastCycle['end_date'] != null) {
          endDate = _parseDateTime(lastCycle['end_date']);
        } else {
          endDate = _parseDateTime(lastCycle['end']);
        }
      }
    } catch (e) {
      debugPrint('Error parsing cycle dates in status calculation: $e');
      return null;
    }

    if (startDate == null) return null;

    // Calculate days since last period
    final daysSinceStart = now.difference(startDate).inDays;

    String phase;
    String description;
    Color color;
    IconData icon;

    if (endDate != null) {
      // Last cycle ended
      final daysSinceEnd = now.difference(endDate).inDays;

      if (daysSinceEnd < 0) {
        // Currently on period
        phase = 'Menstrual';
        description = 'Day ${daysSinceStart + 1} of your cycle';
        color = AppTheme.healthColors['menstruation']!;
        icon = Icons.water_drop;
      } else if (daysSinceEnd <= 7) {
        // Follicular phase
        phase = 'Follicular';
        description = 'Post-period recovery phase';
        color = AppTheme.healthColors['fertile']!;
        icon = Icons.eco;
      } else if (daysSinceEnd >= 10 && daysSinceEnd <= 16) {
        // Ovulation window (assuming 28-day cycle)
        phase = 'Ovulation';
        description = 'Fertile window - ovulation likely';
        color = AppTheme.healthColors['ovulation']!;
        icon = Icons.favorite;
      } else {
        // Luteal phase
        phase = 'Luteal';
        description = 'Pre-period phase';
        color = AppTheme.healthColors['luteal']!;
        icon = Icons.nightlight_round;
      }
    } else {
      // Current cycle ongoing
      phase = 'Menstrual';
      description = 'Day ${daysSinceStart + 1} of current cycle';
      color = Colors.red;
      icon = Icons.water_drop;
    }

    return {
      'phase': phase,
      'description': description,
      'color': color,
      'icon': icon,
      'daysSinceStart': daysSinceStart,
    };
  }

  Map<String, dynamic>? _calculatePredictions(
    List<Map<String, dynamic>> cycles,
  ) {
    if (cycles.isEmpty) return null;

    // Enhanced prediction algorithm with weighted averages and confidence scoring
    final predictions = _calculateEnhancedPredictions(cycles);
    return predictions;
  }

  /// Enhanced cycle prediction algorithm with improved accuracy
  Map<String, dynamic>? _calculateEnhancedPredictions(
    List<Map<String, dynamic>> cycles,
  ) {
    if (cycles.isEmpty) return null;

    // Separate period cycles from inter-cycle intervals
    List<int> cycleLengths = [];
    List<int> periodLengths = [];
    List<DateTime> cycleStartDates = [];
    
    // Parse and validate cycle data
    for (int i = 0; i < cycles.length; i++) {
      final cycle = cycles[i];
      final start = _parseDateTime(cycle['start']) ?? _parseDateTime(cycle['start_date']);
      final end = _parseDateTime(cycle['end']) ?? _parseDateTime(cycle['end_date']);
      
      if (start != null) {
        cycleStartDates.add(start);
        
        if (end != null) {
          // Calculate period length (menstrual phase duration)
          final periodLength = end.difference(start).inDays + 1;
          if (periodLength > 0 && periodLength <= 10) {
            periodLengths.add(periodLength);
          }
          
          // Calculate cycle length (start of one cycle to start of next)
          if (i < cycles.length - 1) {
            final nextCycle = cycles[i + 1];
            final nextStart = _parseDateTime(nextCycle['start']) ?? 
                              _parseDateTime(nextCycle['start_date']);
            if (nextStart != null) {
              final cycleLength = start.difference(nextStart).inDays.abs();
              if (cycleLength >= 21 && cycleLength <= 45) { // Normal cycle range
                cycleLengths.add(cycleLength);
              }
            }
          }
        }
      }
    }

    if (cycleStartDates.isEmpty) return null;

    // Calculate weighted averages (more recent cycles have higher weight)
    double avgCycleLength = _calculateWeightedAverage(cycleLengths);
    double avgPeriodLength = _calculateWeightedAverage(periodLengths);
    
    // Fallback to typical values if no data
    if (avgCycleLength == 0) avgCycleLength = 28.0; // Typical cycle
    if (avgPeriodLength == 0) avgPeriodLength = 5.0; // Typical period
    
    // Get last cycle data
    final lastCycle = cycles.first;
    final lastStart = _parseDateTime(lastCycle['start']) ?? 
                      _parseDateTime(lastCycle['start_date']);
    final lastEnd = _parseDateTime(lastCycle['end']) ?? 
                    _parseDateTime(lastCycle['end_date']);
    
    if (lastStart == null) return null;
    
    // Calculate predictions with confidence intervals
    DateTime nextPeriodDate;
    double confidence = _calculateConfidence(cycleLengths.length, _calculateVariance(cycleLengths));
    
    if (lastEnd != null) {
      // Last period ended - predict next cycle start
      nextPeriodDate = lastStart.add(Duration(days: avgCycleLength.round()));
    } else {
      // Current period ongoing - estimate when it will end and next will start
      final estimatedEndDate = lastStart.add(Duration(days: avgPeriodLength.round()));
      nextPeriodDate = lastStart.add(Duration(days: avgCycleLength.round()));
    }
    
    // Enhanced ovulation prediction (luteal phase is typically 12-16 days)
    final lutealPhaseLength = 14; // Most common
    final ovulationDate = nextPeriodDate.subtract(Duration(days: lutealPhaseLength));
    
    // Fertile window (sperm can live up to 5 days, egg lives ~24 hours)
    final fertileWindowStart = ovulationDate.subtract(const Duration(days: 5));
    final fertileWindowEnd = ovulationDate.add(const Duration(days: 2));
    
    // Calculate cycle regularity score
    double regularity = _calculateRegularity(cycleLengths);
    
    return {
      'nextPeriod': nextPeriodDate,
      'ovulation': ovulationDate,
      'fertileStart': fertileWindowStart,
      'fertileEnd': fertileWindowEnd,
      'avgCycleLength': avgCycleLength.round(),
      'avgPeriodLength': avgPeriodLength.round(),
      'confidence': confidence,
      'regularity': regularity,
      'cycleCount': cycleLengths.length,
      'lastUpdated': DateTime.now(),
    };
  }
  
  /// Calculate weighted average with more recent data having higher weight
  double _calculateWeightedAverage(List<int> values) {
    if (values.isEmpty) return 0.0;
    
    double weightedSum = 0.0;
    double totalWeight = 0.0;
    
    for (int i = 0; i < values.length; i++) {
      // More recent entries get higher weight (exponential decay)
      double weight = 1.0 + (i * 0.2); // Recent cycles weighted more heavily
      weightedSum += values[i] * weight;
      totalWeight += weight;
    }
    
    return weightedSum / totalWeight;
  }
  
  /// Calculate prediction confidence based on data quantity and consistency
  double _calculateConfidence(int dataPoints, double variance) {
    if (dataPoints == 0) return 0.0;
    
    // Base confidence on number of cycles (more data = higher confidence)
    double dataConfidence = (dataPoints / 6.0).clamp(0.0, 1.0);
    
    // Reduce confidence based on variance (higher variance = lower confidence)
    double consistencyConfidence = 1.0 - (variance / 100.0).clamp(0.0, 1.0);
    
    // Combined confidence score
    return (dataConfidence * 0.6 + consistencyConfidence * 0.4).clamp(0.0, 1.0);
  }
  
  /// Calculate variance in cycle lengths
  double _calculateVariance(List<int> values) {
    if (values.length < 2) return 0.0;
    
    double mean = values.reduce((a, b) => a + b) / values.length;
    double sumSquaredDifferences = values
        .map((value) => (value - mean) * (value - mean))
        .reduce((a, b) => a + b);
    
    return sumSquaredDifferences / values.length;
  }
  
  /// Calculate cycle regularity score (0.0 = irregular, 1.0 = very regular)
  double _calculateRegularity(List<int> cycleLengths) {
    if (cycleLengths.length < 3) return 0.5; // Neutral for insufficient data
    
    double variance = _calculateVariance(cycleLengths);
    
    // Lower variance = higher regularity
    if (variance <= 4) return 1.0; // Very regular (±2 days)
    if (variance <= 9) return 0.8; // Regular (±3 days)
    if (variance <= 16) return 0.6; // Somewhat regular (±4 days)
    if (variance <= 25) return 0.4; // Irregular (±5 days)
    return 0.2; // Very irregular
  }

  Widget _buildWelcomeCard() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final l10n = AppLocalizations.of(context);

        // Get display name from persistent user service with fallback
        String getDisplayName() {
          // First try from UserProvider (persistent storage)
          if (userProvider.displayName?.isNotEmpty == true) {
            return userProvider.displayName!;
          }

          // Fallback to preferred name from profile
          if (userProvider.preferredName?.isNotEmpty == true) {
            return userProvider.preferredName!;
          }

          // Last resort - use greeting name method
          final greetingName = userProvider.getGreetingName();
          if (greetingName != 'User') {
            return greetingName;
          }

          // Final fallback to Firebase Auth or email
          final user = FirebaseAuth.instance.currentUser;
          return user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
        }

        final displayName = getDisplayName();
        final isLoggedIn = userProvider.isLoggedIn;

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isLoggedIn
                          ? Colors.pink.shade100
                          : Colors.grey.shade200,
                      child: Icon(
                        isLoggedIn ? Icons.favorite : Icons.person,
                        color: isLoggedIn
                            ? Colors.pink.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoggedIn
                                ? (l10n.homeWelcomeMessage(displayName) ??
                                      'Hello, $displayName!')
                                : 'Welcome to Flow iQ!',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isLoggedIn
                                ? (l10n.homeWelcomeSubtitle ??
                                      'Track your cycle with confidence')
                                : 'Sign in to start tracking your cycle',
                            style: TextStyle(
                              color: AppTheme.getSubtitleColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLoggedIn)
                      ElevatedButton(
                        onPressed: () => context.go('/auth'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                  ],
                ),

                // Show user profile info if available
                if (isLoggedIn && userProvider.userProfile != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.pink.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: Colors.pink.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Profile synced • ${userProvider.userProfile!.stats.totalLogins} logins',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.pink.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (userProvider.userProfile!.isProfileComplete)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCycleStatusCard() {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_cycleStatus == null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.homeStartTracking ?? 'Start Tracking Your Cycle',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeStartTrackingDescription ??
                    'Log your first cycle to see personalized insights and predictions.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.go('/log-cycle'),
                icon: const Icon(Icons.add),
                label: Text(l10n.homeLogFirstCycle ?? 'Log First Cycle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final status = _cycleStatus!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              (status['color'] as Color).withValues(alpha: 0.1),
              (status['color'] as Color).withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                      color: (status['color'] as Color).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      status['icon'] as IconData,
                      color: status['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${status['phase']} Phase',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: status['color'] as Color,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionsCard() {
    if (_isLoading || _predictions == null) {
      return const SizedBox.shrink();
    }

    final predictions = _predictions!;
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeUpcomingEvents ?? 'Upcoming Events',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                _buildConfidenceBadge(predictions['confidence'] ?? 0.0),
              ],
            ),
            const SizedBox(height: 4),
            _buildCycleStatsRow(predictions),
            const SizedBox(height: 12),

            // Next Period
            _buildPredictionItem(
              icon: Icons.water_drop,
              color: Colors.red,
              title: l10n.homeNextPeriod ?? 'Next Period',
              date: predictions['nextPeriod'] as DateTime,
              now: now,
            ),

            const SizedBox(height: 8),

            // Ovulation
            _buildPredictionItem(
              icon: Icons.favorite,
              color: Colors.orange,
              title: l10n.homeOvulation ?? 'Ovulation',
              date: predictions['ovulation'] as DateTime,
              now: now,
            ),

            const SizedBox(height: 8),

            // Fertile Window
            Row(
              children: [
                Icon(Icons.eco, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeFertileWindow ?? 'Fertile Window',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${_formatPredictionDate(predictions['fertileStart'] as DateTime, now)} - ${_formatPredictionDate(predictions['fertileEnd'] as DateTime, now)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfidenceBadge(double confidence) {
    Color badgeColor;
    String confidenceText;
    
    if (confidence >= 0.8) {
      badgeColor = Colors.green;
      confidenceText = 'High';
    } else if (confidence >= 0.6) {
      badgeColor = Colors.amber;
      confidenceText = 'Medium';
    } else {
      badgeColor = Colors.orange;
      confidenceText = 'Low';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.analytics,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            confidenceText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCycleStatsRow(Map<String, dynamic> predictions) {
    final avgCycleLength = predictions['avgCycleLength'] ?? 28;
    final avgPeriodLength = predictions['avgPeriodLength'] ?? 5;
    final regularity = predictions['regularity'] ?? 0.5;
    final cycleCount = predictions['cycleCount'] ?? 0;
    
    String regularityText;
    Color regularityColor;
    
    if (regularity >= 0.8) {
      regularityText = 'Very Regular';
      regularityColor = Colors.green;
    } else if (regularity >= 0.6) {
      regularityText = 'Regular';
      regularityColor = Colors.lightGreen;
    } else if (regularity >= 0.4) {
      regularityText = 'Somewhat Regular';
      regularityColor = Colors.amber;
    } else {
      regularityText = 'Irregular';
      regularityColor = Colors.orange;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cycle: ${avgCycleLength}d',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Period: ${avgPeriodLength}d',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timeline,
                    size: 12,
                    color: regularityColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    regularityText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: regularityColor,
                    ),
                  ),
                ],
              ),
              Text(
                'Based on $cycleCount cycles',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionItem({
    required IconData icon,
    required Color color,
    required String title,
    required DateTime date,
    required DateTime now,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          _formatPredictionDate(date, now),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatPredictionDate(DateTime date, DateTime now) {
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      final pastDays = -difference;
      if (pastDays == 1) {
        return 'Yesterday';
      } else {
        return '$pastDays days ago';
      }
    }
  }

  Widget _buildQuickActions() {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeQuickActions ?? 'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add_circle,
                    label: l10n.homeLogCycle ?? 'Log Cycle',
                    color: Colors.pink,
                    onTap: () => context.go('/log-cycle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.history,
                    label: l10n.homeViewHistory ?? 'View History',
                    color: Colors.blue,
                    onTap: () => context.go('/cycle-history'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.calendar_month,
                    label: l10n.homeCalendar ?? 'Calendar',
                    color: Colors.green,
                    onTap: () => context.go('/calendar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.analytics,
                    label: l10n.homeAnalytics ?? 'Analytics',
                    color: Colors.purple,
                    onTap: () => context.go('/analytics'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.psychology,
                    label: l10n.homeAIInsights ?? 'AI Insights',
                    color: Colors.deepPurple,
                    onTap: () => context.go('/ai-insights'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_note,
                    label: l10n.homeDailyLog ?? 'Daily Log',
                    color: Colors.teal,
                    onTap: () => context.go('/daily-log'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.health_and_safety,
                    label: l10n.healthTitle ?? 'Health Insights',
                    color: Colors.red,
                    onTap: () => context.go('/health-insights'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.trending_up,
                    label: 'Symptom Trends',
                    color: Colors.amber,
                    onTap: () => context.go('/symptom-trends'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.smart_toy,
                    label: 'AI Health Coach',
                    color: Colors.indigo,
                    onTap: () => context.go('/ai-health-coach'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.settings,
                    label: l10n.settingsTitle ?? 'Settings',
                    color: Colors.grey,
                    onTap: () => context.go('/settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCycles() {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeRecentCycles ?? 'Recent Cycles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/cycle-history'),
                  child: Text(l10n.homeViewAll ?? 'View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.orange,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeUnableToLoad ??
                                'Unable to load recent cycles',
                          ),
                          TextButton(
                            onPressed: _loadDashboardData,
                            child: Text(l10n.homeTryAgain ?? 'Try Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _recentCycles.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      l10n.homeNoCycles ??
                          'No cycles logged yet. Start tracking!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.getSubtitleColor(context),
                      ),
                    ),
                  )
                : Column(
                    children: _recentCycles.take(3).map((cycle) {
                      return _buildRecentCycleItem(cycle);
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCycleItem(Map<String, dynamic> cycle) {
    // Parse dates safely
    DateTime? startDate;
    DateTime? endDate;

    try {
      if (cycle['start'] != null) {
        if (cycle['start'] is DateTime) {
          startDate = cycle['start'];
        } else if (cycle['start'].toString().contains('Timestamp')) {
          // Handle Firestore Timestamp
          startDate = (cycle['start'] as dynamic).toDate();
        } else {
          startDate = DateTime.parse(cycle['start'].toString());
        }
      }
      if (cycle['end'] != null) {
        if (cycle['end'] is DateTime) {
          endDate = cycle['end'];
        } else if (cycle['end'].toString().contains('Timestamp')) {
          // Handle Firestore Timestamp
          endDate = (cycle['end'] as dynamic).toDate();
        } else {
          endDate = DateTime.parse(cycle['end'].toString());
        }
      }
    } catch (e) {
      debugPrint('Error parsing cycle dates: $e');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              startDate != null && endDate != null
                  ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                  : 'Invalid dates',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (startDate != null && endDate != null)
            Text(
              '${endDate.difference(startDate).inDays + 1} days',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('🌸 ${l10n.homeTitle ?? "CycleSync"}'),
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.pink.shade700, // Make icons darker and more visible
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.pink.shade700),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              _buildCycleStatusCard(),
              _buildPredictionsCard(),
              _buildQuickActions(),
              _buildRecentCycles(),
              const SizedBox(height: 12),
              Center(child: BannerAdContainer()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
