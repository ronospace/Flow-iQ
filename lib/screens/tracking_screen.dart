import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/flow_iq_sync_service.dart';
import '../widgets/multimodal_input_widget.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final FlowIQSyncService _syncService = FlowIQSyncService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  // Tracking data
  final Set<DateTime> _periodDays = {};
  final Set<DateTime> _symptomDays = {};
  final Map<DateTime, List<String>> _dailySymptoms = {};
  final Map<DateTime, String> _dailyMoods = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Cycle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar
            _buildCalendar(),
            
            // Selected day info
            if (_selectedDay != null) _buildSelectedDayInfo(),
            
            // Quick actions
            _buildQuickActionsCompact(),
            
            // Multimodal input section
            const MultimodalInputWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTrackingDialog(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TableCalendar<String>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
            CalendarFormat.week: 'Week',
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final markers = <Widget>[];
              
              if (_periodDays.contains(day)) {
                markers.add(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    width: 6,
                    height: 6,
                  ),
                );
              }
              
              if (_symptomDays.contains(day)) {
                markers.add(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    width: 6,
                    height: 6,
                  ),
                );
              }
              
              return markers.isNotEmpty 
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: markers,
                    )
                  : null;
            },
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonTextStyle: TextStyle(color: Colors.white),
            formatButtonDecoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayInfo() {
    final selectedDay = _selectedDay!;
    final isToday = isSameDay(selectedDay, DateTime.now());
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isToday ? 'Today' : _formatDate(selectedDay),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_periodDays.contains(selectedDay))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.water_drop, size: 16, color: Colors.red[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Period',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            if (_dailySymptoms.containsKey(selectedDay)) ...[
              const SizedBox(height: 12),
              Text(
                'Symptoms:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: _dailySymptoms[selectedDay]!
                    .map((symptom) => Chip(
                          label: Text(symptom),
                          backgroundColor: Colors.orange[100],
                          labelStyle: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 12,
                          ),
                        ))
                    .toList(),
              ),
            ],
            
            if (_dailyMoods.containsKey(selectedDay)) ...[
              const SizedBox(height: 12),
              Text(
                'Mood: ${_dailyMoods[selectedDay]}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
            
            if (!_periodDays.contains(selectedDay) && 
                !_dailySymptoms.containsKey(selectedDay) &&
                !_dailyMoods.containsKey(selectedDay))
              Text(
                'No tracking data for this day',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCompact() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    'Period',
                    Icons.water_drop,
                    Colors.red,
                    () => _logPeriodDay(),
                  ),
                  _buildActionButton(
                    'Symptoms',
                    Icons.medication,
                    Colors.orange,
                    () => _showSymptomsDialog(),
                  ),
                  _buildActionButton(
                    'Mood',
                    Icons.mood,
                    Colors.purple,
                    () => _showMoodDialog(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  'Period',
                  Icons.water_drop,
                  Colors.red,
                  () => _logPeriodDay(),
                ),
                _buildActionButton(
                  'Symptoms',
                  Icons.medication,
                  Colors.orange,
                  () => _showSymptomsDialog(),
                ),
                _buildActionButton(
                  'Mood',
                  Icons.mood,
                  Colors.purple,
                  () => _showMoodDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => _TrackingDialog(
          selectedDay: _selectedDay ?? DateTime.now(),
          onSave: (data) => _saveTrackingData(data),
        ),
      ),
    );
  }

  void _logPeriodDay() {
    final selectedDay = _selectedDay ?? DateTime.now();
    setState(() {
      if (_periodDays.contains(selectedDay)) {
        _periodDays.remove(selectedDay);
      } else {
        _periodDays.add(selectedDay);
      }
    });
    
    _syncService.addPeriodDay(
      date: selectedDay,
      flowIntensity: 'Medium',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _periodDays.contains(selectedDay) 
              ? 'Period day logged' 
              : 'Period day removed'
        ),
      ),
    );
  }

  void _showSymptomsDialog() {
    // Implementation similar to QuickActionButtons
    showDialog(
      context: context,
      builder: (context) => _SymptomsDialog(
        onSave: (symptoms) {
          final selectedDay = _selectedDay ?? DateTime.now();
          setState(() {
            _dailySymptoms[selectedDay] = symptoms;
            if (symptoms.isNotEmpty) {
              _symptomDays.add(selectedDay);
            } else {
              _symptomDays.remove(selectedDay);
            }
          });
        },
      ),
    );
  }

  void _showMoodDialog() {
    showDialog(
      context: context,
      builder: (context) => _MoodDialog(
        onSave: (mood) {
          final selectedDay = _selectedDay ?? DateTime.now();
          setState(() {
            _dailyMoods[selectedDay] = mood;
          });
        },
      ),
    );
  }

  void _saveTrackingData(Map<String, dynamic> data) {
    final selectedDay = _selectedDay ?? DateTime.now();
    
    setState(() {
      if (data['symptoms'] != null && (data['symptoms'] as List).isNotEmpty) {
        _dailySymptoms[selectedDay] = List<String>.from(data['symptoms']);
        _symptomDays.add(selectedDay);
      }
      
      if (data['mood'] != null) {
        _dailyMoods[selectedDay] = data['mood'];
      }
      
      if (data['period'] == true) {
        _periodDays.add(selectedDay);
      }
    });
    
    // Sync to Flow-iQ
    if (data['symptoms'] != null) {
      _syncService.addSymptomTracking(
        symptoms: List<String>.from(data['symptoms'] ?? []),
        mood: data['mood'] ?? 'Neutral',
        energyLevel: data['energyLevel'] ?? 3,
        painLevel: data['painLevel'] ?? 0,
        notes: data['notes'],
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

// Placeholder dialogs - would need full implementation
class _TrackingDialog extends StatelessWidget {
  final DateTime selectedDay;
  final Function(Map<String, dynamic>) onSave;

  const _TrackingDialog({
    required this.selectedDay,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Track for ${_formatDate(selectedDay)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                'Comprehensive tracking dialog would go here',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onSave({});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _SymptomsDialog extends StatelessWidget {
  final Function(List<String>) onSave;

  const _SymptomsDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Symptoms'),
      content: const Text('Symptoms dialog implementation'),
      actions: [
        TextButton(
          onPressed: () {
            onSave([]);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _MoodDialog extends StatelessWidget {
  final Function(String) onSave;

  const _MoodDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Mood'),
      content: const Text('Mood dialog implementation'),
      actions: [
        TextButton(
          onPressed: () {
            onSave('Neutral');
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
