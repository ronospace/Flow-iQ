import 'package:flutter/material.dart';
import '../services/voice_input_service.dart';
import '../widgets/voice_input_widget.dart';

class QuickActionButtons extends StatelessWidget {
  const QuickActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          icon: Icons.water_drop,
          label: 'Log Flow',
          color: Colors.red[400]!,
          onTap: () => _showLogFlowDialog(context),
        ),
        _buildActionButton(
          context,
          icon: Icons.mood,
          label: 'Mood',
          color: Colors.purple[400]!,
          onTap: () => _showMoodDialog(context),
        ),
        _buildActionButton(
          context,
          icon: Icons.medication,
          label: 'Symptoms',
          color: Colors.orange[400]!,
          onTap: () => _showSymptomsDialog(context),
        ),
                _buildActionButton(
                  context,
                  icon: Icons.insights,
                  label: 'Insights',
                  color: Colors.blue[400]!,
                  onTap: () => Navigator.pushNamed(context, '/insights'),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.mic,
                  label: 'Voice',
                  color: Colors.purple[400]!,
                  onTap: () => _showVoiceInput(context),
                ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
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

  void _showLogFlowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _FlowLogDialog();
      },
    );
  }

  void _showMoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MoodLogDialog();
      },
    );
  }

  void _showSymptomsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _SymptomsLogDialog();
      },
    );
  }

  void _showVoiceInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: VoiceInputWidget(
              inputType: VoiceInputType.general,
              onResult: (result) {
                Navigator.of(context).pop();
                _processVoiceResult(context, result);
              },
              placeholder: 'Tell me how you\'re feeling today',
            ),
          ),
        ),
      ),
    );
  }

  void _processVoiceResult(BuildContext context, VoiceInputResult result) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Voice input processed successfully!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(result.formattedResults),
          ],
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Save the voice input results to the database
    print('Processing voice result: ${result.toMap()}');
  }
}

class _FlowLogDialog extends StatefulWidget {
  @override
  State<_FlowLogDialog> createState() => _FlowLogDialogState();
}

class _FlowLogDialogState extends State<_FlowLogDialog> {
  String _selectedFlow = 'Light';
  final List<String> _flowOptions = ['Spotting', 'Light', 'Medium', 'Heavy'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Flow'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How would you describe your flow today?'),
          const SizedBox(height: 16),
          ..._flowOptions.map((option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedFlow,
                onChanged: (value) => setState(() => _selectedFlow = value!),
              )).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Log the flow data
            _logFlowData();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Flow logged: $_selectedFlow')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _logFlowData() {
    // TODO: Implement flow logging logic
    print('Logging flow: $_selectedFlow');
  }
}

class _MoodLogDialog extends StatefulWidget {
  @override
  State<_MoodLogDialog> createState() => _MoodLogDialogState();
}

class _MoodLogDialogState extends State<_MoodLogDialog> {
  double _moodValue = 3.0;
  String _selectedMood = 'Neutral';
  
  final Map<String, double> _moodMap = {
    'Terrible': 1.0,
    'Bad': 2.0,
    'Neutral': 3.0,
    'Good': 4.0,
    'Excellent': 5.0,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Mood'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How are you feeling today?'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moodMap.entries.map((entry) => GestureDetector(
              onTap: () => setState(() {
                _moodValue = entry.value;
                _selectedMood = entry.key;
              }),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedMood == entry.key 
                      ? Colors.purple[100] 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _getMoodEmoji(entry.value),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: _selectedMood == entry.key 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _logMoodData();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mood logged: $_selectedMood')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _getMoodEmoji(double value) {
    switch (value.toInt()) {
      case 1:
        return '😞';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😁';
      default:
        return '😐';
    }
  }

  void _logMoodData() {
    // TODO: Implement mood logging logic
    print('Logging mood: $_selectedMood ($_moodValue)');
  }
}

class _SymptomsLogDialog extends StatefulWidget {
  @override
  State<_SymptomsLogDialog> createState() => _SymptomsLogDialogState();
}

class _SymptomsLogDialogState extends State<_SymptomsLogDialog> {
  final Set<String> _selectedSymptoms = <String>{};
  
  final List<String> _symptomOptions = [
    'Cramps',
    'Headache',
    'Bloating',
    'Breast Tenderness',
    'Fatigue',
    'Nausea',
    'Back Pain',
    'Acne',
    'Food Cravings',
    'Mood Swings',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Symptoms'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('What symptoms are you experiencing?'),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.maxFinite,
            child: ListView(
              children: _symptomOptions.map((symptom) => CheckboxListTile(
                title: Text(symptom),
                value: _selectedSymptoms.contains(symptom),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
              )).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _logSymptomsData();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _selectedSymptoms.isEmpty 
                      ? 'No symptoms logged'
                      : 'Symptoms logged: ${_selectedSymptoms.join(', ')}'
                ),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _logSymptomsData() {
    // TODO: Implement symptoms logging logic
    print('Logging symptoms: $_selectedSymptoms');
  }
}
