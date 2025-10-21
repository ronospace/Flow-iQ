import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/feelings_data.dart';
import '../services/daily_feelings_intelligence_service.dart';

/// Main Daily Feelings Tracking Widget
/// Adaptive interface that changes based on time of day and user patterns
class DailyFeelingsWidget extends StatefulWidget {
  final bool isFlowIQClinical;
  final VoidCallback? onCompleted;
  
  const DailyFeelingsWidget({
    Key? key,
    this.isFlowIQClinical = false,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<DailyFeelingsWidget> createState() => _DailyFeelingsWidgetState();
}

class _DailyFeelingsWidgetState extends State<DailyFeelingsWidget>
    with TickerProviderStateMixin {
  
  late DailyFeelingsIntelligenceService _feelingsService;
  late AnimationController _animationController;
  late AnimationController _slideController;
  
  List<FeelingsQuestion> _currentQuestions = [];
  Map<String, dynamic> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isSubmitting = false;
  bool _showResults = false;
  FeelingsSubmissionResult? _submissionResult;
  
  @override
  void initState() {
    super.initState();
    _feelingsService = DailyFeelingsIntelligenceService(
      isFlowIQClinical: widget.isFlowIQClinical
    );
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _initializeFeelings();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeFeelings() async {
    await _feelingsService.initialize();
    setState(() {
      _currentQuestions = _feelingsService.getContextualQuestions();
    });
    _animationController.forward();
  }
  
  void _nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _slideController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex++;
        });
        _slideController.forward();
      });
    } else {
      _submitFeelings();
    }
  }
  
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _slideController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex--;
        });
        _slideController.forward();
      });
    }
  }
  
  Future<void> _submitFeelings() async {
    setState(() {
      _isSubmitting = true;
    });
    
    final now = DateTime.now();
    final timeOfDay = now.hour < 14 ? FeelingsTimeOfDay.morning : FeelingsTimeOfDay.evening;
    
    // Extract main feeling score
    final overallFeeling = _answers['overall_feeling'] as int? ?? 5;
    
    // Extract detailed feelings
    final detailedFeelings = <String, int>{};
    for (final question in _currentQuestions) {
      if (question.type == FeelingsQuestionType.scale && _answers.containsKey(question.id)) {
        detailedFeelings[question.id] = _answers[question.id] as int;
      }
    }
    
    // Extract selected moods
    final selectedMoods = _answers['mood_tags'] as List<String>? ?? [];
    
    try {
      final result = await _feelingsService.submitDailyFeelings(
        overallFeeling: overallFeeling,
        timeOfDay: timeOfDay,
        detailedFeelings: detailedFeelings,
        selectedMoods: selectedMoods,
        additionalContext: _answers,
      );
      
      setState(() {
        _submissionResult = result;
        _showResults = true;
        _isSubmitting = false;
      });
      
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      }
      
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feelings: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _feelingsService,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _buildBackgroundGradient(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _showResults ? _buildResultsScreen() : _buildQuestionScreen(),
          );
        },
      ),
    );
  }
  
  Widget _buildQuestionScreen() {
    if (_currentQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildProgressIndicator(),
          const SizedBox(height: 32),
          Expanded(
            child: AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * (1 - _slideController.value) * 0.3,
                    0,
                  ),
                  child: Opacity(
                    opacity: _slideController.value,
                    child: _buildCurrentQuestion(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
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
            Icon(
              isMorning ? Icons.wb_sunny : Icons.nightlight_round,
              size: 32,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.isFlowIQClinical 
                    ? 'Clinical Wellness Check'
                    : isMorning ? 'Morning Check-in' : 'Evening Reflection',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isMorning 
              ? 'How are you feeling this morning?'
              : 'How has your day been?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_currentQuestions.length}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            Text(
              '${((_currentQuestionIndex + 1) / _currentQuestions.length * 100).round()}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _currentQuestions.length,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCurrentQuestion() {
    if (_currentQuestionIndex >= _currentQuestions.length) {
      return const SizedBox.shrink();
    }
    
    final question = _currentQuestions[_currentQuestionIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildQuestionInput(question)),
      ],
    );
  }
  
  Widget _buildQuestionInput(FeelingsQuestion question) {
    switch (question.type) {
      case FeelingsQuestionType.scale:
        return _buildScaleInput(question);
      case FeelingsQuestionType.multiSelect:
        return _buildMultiSelectInput(question);
      case FeelingsQuestionType.text:
        return _buildTextInput(question);
      case FeelingsQuestionType.boolean:
        return _buildBooleanInput(question);
    }
  }
  
  Widget _buildScaleInput(FeelingsQuestion question) {
    final currentValue = _answers[question.id] as int? ?? 5;
    final min = question.scaleMin ?? 1;
    final max = question.scaleMax ?? 10;
    
    return Column(
      children: [
        // Visual scale indicator
        Expanded(
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentValue.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (question.scaleLabels != null && question.scaleLabels!.isNotEmpty)
                      Text(
                        _getScaleLabel(question, currentValue),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white.withValues(alpha: 0.8),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: Colors.white.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: currentValue.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value.round();
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              min.toString(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            Text(
              max.toString(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMultiSelectInput(FeelingsQuestion question) {
    final selectedMoods = _answers[question.id] as List<String>? ?? [];
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: question.options?.length ?? 0,
      itemBuilder: (context, index) {
        final option = question.options![index];
        final isSelected = selectedMoods.contains(option);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              final currentMoods = List<String>.from(selectedMoods);
              if (isSelected) {
                currentMoods.remove(option);
              } else {
                currentMoods.add(option);
              }
              _answers[question.id] = currentMoods;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTextInput(FeelingsQuestion question) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Share your thoughts...',
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
        ),
      ),
      maxLines: 4,
      onChanged: (value) {
        _answers[question.id] = value;
      },
    );
  }
  
  Widget _buildBooleanInput(FeelingsQuestion question) {
    final value = _answers[question.id] as bool? ?? false;
    
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _answers[question.id] = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: value 
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: value 
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: value ? 1.0 : 0.7),
                    fontSize: 16,
                    fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _answers[question.id] = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: !value 
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !value 
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: !value ? 1.0 : 0.7),
                    fontSize: 16,
                    fontWeight: !value ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentQuestionIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousQuestion,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Previous',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        if (_currentQuestionIndex > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _currentQuestionIndex == _currentQuestions.length - 1
                          ? 'Submit'
                          : 'Next',
                      style: const TextStyle(
                        color: Color(0xFF6B73FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultsScreen() {
    if (_submissionResult == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final result = _submissionResult!;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Success animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Encouragement
          if (result.encouragement != null)
            Text(
              result.encouragement!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          
          // Streak info
          if (result.streak != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${result.streak} day streak!',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          
          // Insight
          if (result.insight != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getInsightIcon(result.insight!.type),
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Insight',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.insight!.content,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (result.insight!.actionSuggestion != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              result.insight!.actionSuggestion!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          
          const Spacer(),
          
          // Next prompt time
          if (result.nextPromptTime != null) ...[
            Text(
              'Next check-in: ${_formatNextPromptTime(result.nextPromptTime!)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Done button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xFF6B73FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  LinearGradient _buildBackgroundGradient() {
    final now = DateTime.now();
    final isMorning = now.hour < 14;
    
    if (widget.isFlowIQClinical) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
      );
    }
    
    if (isMorning) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFB75E),
          Color(0xFFED8F03),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
      );
    }
  }
  
  String _getScaleLabel(FeelingsQuestion question, int value) {
    if (question.scaleLabels == null || question.scaleLabels!.isEmpty) {
      return '';
    }
    
    final min = question.scaleMin ?? 1;
    final max = question.scaleMax ?? 10;
    final range = max - min;
    final labels = question.scaleLabels!;
    
    if (labels.length == 1) return labels[0];
    
    final index = ((value - min) / range * (labels.length - 1)).round();
    return labels[index.clamp(0, labels.length - 1)];
  }
  
  IconData _getInsightIcon(FeelingsInsightType type) {
    switch (type) {
      case FeelingsInsightType.celebration:
        return Icons.celebration;
      case FeelingsInsightType.positive:
        return Icons.sentiment_very_satisfied;
      case FeelingsInsightType.neutral:
        return Icons.sentiment_neutral;
      case FeelingsInsightType.awareness:
        return Icons.lightbulb_outline;
      case FeelingsInsightType.support:
        return Icons.favorite_border;
      case FeelingsInsightType.intervention:
        return Icons.health_and_safety;
    }
  }
  
  String _formatNextPromptTime(DateTime nextPrompt) {
    final now = DateTime.now();
    final difference = nextPrompt.difference(now);
    
    if (difference.inHours < 24) {
      if (difference.inHours < 1) {
        return 'in ${difference.inMinutes} minutes';
      }
      return 'in ${difference.inHours} hours';
    }
    
    return 'tomorrow';
  }
}

/// Compact Daily Feelings Summary Widget
/// Shows current streak and recent trends
class DailyFeelingsSummaryWidget extends StatelessWidget {
  final bool isFlowIQClinical;
  final VoidCallback? onTap;
  
  const DailyFeelingsSummaryWidget({
    Key? key,
    this.isFlowIQClinical = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isFlowIQClinical
                ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                : [const Color(0xFF6B73FF), const Color(0xFF9DD5FF)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isFlowIQClinical ? Icons.medical_services : Icons.mood,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isFlowIQClinical ? 'Clinical Wellness' : 'Daily Feelings',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.local_fire_department,
                    label: 'Streak',
                    value: '5 days',
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.trending_up,
                    label: 'Trend',
                    value: '↗ +0.5',
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.access_time,
                    label: 'Next',
                    value: '6:30 PM',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
