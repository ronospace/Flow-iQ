import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/cycle_data.dart';
import '../services/wearables_data_service.dart';
import '../services/enhanced_ai_service.dart';

/// Service that provides personalized recommendations based on menstrual cycle phase,
/// health data, and user preferences
class PhaseBasedRecommendationsService extends ChangeNotifier {
  final WearablesDataService _wearablesService;
  final EnhancedAIService _enhancedAIService;
  
  // Recommendation state
  List<PersonalizedRecommendation> _currentRecommendations = [];
  DateTime? _lastUpdateTime;
  bool _isLoading = false;
  String? _errorMessage;
  
  // User preferences and history
  Map<String, double> _userPreferences = {};
  Map<String, List<UserResponse>> _userResponseHistory = {};
  
  PhaseBasedRecommendationsService(
    this._wearablesService,
    this._enhancedAIService,
  );

  // Getters
  List<PersonalizedRecommendation> get currentRecommendations => _currentRecommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdateTime => _lastUpdateTime;

  /// Generate personalized recommendations based on current cycle phase and health data
  Future<List<PersonalizedRecommendation>> generateRecommendations({
    required CyclePhase currentPhase,
    DateTime? cycleDay,
    Map<String, dynamic>? additionalContext,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get current wearables data
      final wearablesSummary = _wearablesService.todaysSummary;
      
      // Get user insights from Enhanced AI
      final userInsights = await _enhancedAIService.generatePersonalizedInsights(
        currentPhase: currentPhase,
        limit: 5,
      );

      // Generate recommendations based on phase and data
      final recommendations = <PersonalizedRecommendation>[];
      
      // Phase-specific recommendations
      recommendations.addAll(_generatePhaseSpecificRecommendations(
        currentPhase, 
        cycleDay,
        wearablesSummary,
      ));
      
      // Health data-driven recommendations
      if (wearablesSummary != null) {
        recommendations.addAll(_generateHealthDataRecommendations(
          wearablesSummary,
          currentPhase,
        ));
      }
      
      // Personalized lifestyle recommendations
      recommendations.addAll(_generateLifestyleRecommendations(
        currentPhase,
        wearablesSummary,
        userInsights,
      ));

      // Nutrition recommendations
      recommendations.addAll(_generateNutritionRecommendations(
        currentPhase,
        wearablesSummary,
      ));

      // Exercise recommendations
      recommendations.addAll(_generateExerciseRecommendations(
        currentPhase,
        wearablesSummary,
      ));

      // Wellness and self-care recommendations
      recommendations.addAll(_generateWellnessRecommendations(
        currentPhase,
        wearablesSummary,
      ));

      // Sort recommendations by priority and personalization score
      recommendations.sort((a, b) => b.personalizedScore.compareTo(a.personalizedScore));
      
      // Apply user preference filtering
      final filteredRecommendations = _applyUserPreferences(recommendations);
      
      // Limit to top recommendations
      _currentRecommendations = filteredRecommendations.take(8).toList();
      _lastUpdateTime = DateTime.now();
      
      debugPrint('Generated ${_currentRecommendations.length} personalized recommendations');
      return _currentRecommendations;
      
    } catch (e) {
      _errorMessage = 'Error generating recommendations: $e';
      debugPrint(_errorMessage);
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate phase-specific recommendations
  List<PersonalizedRecommendation> _generatePhaseSpecificRecommendations(
    CyclePhase phase,
    DateTime? cycleDay,
    WearablesSummary? wearablesSummary,
  ) {
    final recommendations = <PersonalizedRecommendation>[];
    final dayInCycle = cycleDay != null 
        ? DateTime.now().difference(cycleDay).inDays + 1 
        : 1;

    switch (phase) {
      case CyclePhase.menstrual:
        recommendations.addAll([
          PersonalizedRecommendation(
            id: 'menstrual_rest',
            title: 'Prioritize Rest and Recovery',
            description: 'Your body is working hard during menstruation. Focus on gentle activities and adequate sleep.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.lifestyle,
            personalizedScore: 0.9,
            icon: 'bedtime',
            tags: ['rest', 'recovery', 'sleep'],
            estimatedBenefit: 'Reduces fatigue and supports natural recovery',
          ),
          PersonalizedRecommendation(
            id: 'menstrual_iron',
            title: 'Boost Iron Intake',
            description: 'Include iron-rich foods like spinach, lean meats, and legumes to replenish lost minerals.',
            category: RecommendationCategory.nutrition,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.nutrition,
            personalizedScore: 0.85,
            icon: 'restaurant',
            tags: ['iron', 'nutrition', 'recovery'],
            estimatedBenefit: 'Prevents iron deficiency and maintains energy levels',
          ),
          PersonalizedRecommendation(
            id: 'menstrual_hydration',
            title: 'Stay Extra Hydrated',
            description: 'Drink 8-10 glasses of water daily to help reduce bloating and support circulation.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.hydration,
            personalizedScore: 0.8,
            icon: 'local_drink',
            tags: ['hydration', 'bloating', 'circulation'],
            estimatedBenefit: 'Reduces bloating and supports overall comfort',
          ),
        ]);
        break;

      case CyclePhase.follicular:
        recommendations.addAll([
          PersonalizedRecommendation(
            id: 'follicular_energy',
            title: 'Harness Your Rising Energy',
            description: 'You\'re entering a high-energy phase. Perfect time to start new projects and challenges.',
            category: RecommendationCategory.lifestyle,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.lifestyle,
            personalizedScore: 0.9,
            icon: 'energy_savings_leaf',
            tags: ['energy', 'productivity', 'new projects'],
            estimatedBenefit: 'Maximizes productivity during peak energy phase',
          ),
          PersonalizedRecommendation(
            id: 'follicular_cardio',
            title: 'Focus on Cardio Workouts',
            description: 'Your estrogen levels are rising - perfect for high-intensity cardio and endurance training.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.88,
            icon: 'fitness_center',
            tags: ['cardio', 'endurance', 'high-intensity'],
            estimatedBenefit: 'Optimizes workout effectiveness during estrogen rise',
          ),
          PersonalizedRecommendation(
            id: 'follicular_social',
            title: 'Plan Social Activities',
            description: 'You\'re likely feeling more social and confident. Great time for social gatherings and networking.',
            category: RecommendationCategory.lifestyle,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.social,
            personalizedScore: 0.75,
            icon: 'group',
            tags: ['social', 'confidence', 'networking'],
            estimatedBenefit: 'Leverages natural social confidence peak',
          ),
        ]);
        break;

      case CyclePhase.ovulatory:
        recommendations.addAll([
          PersonalizedRecommendation(
            id: 'ovulatory_communication',
            title: 'Tackle Important Conversations',
            description: 'Your communication skills are at their peak. Perfect time for presentations and difficult discussions.',
            category: RecommendationCategory.lifestyle,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.communication,
            personalizedScore: 0.92,
            icon: 'record_voice_over',
            tags: ['communication', 'presentations', 'confidence'],
            estimatedBenefit: 'Maximizes communication effectiveness',
          ),
          PersonalizedRecommendation(
            id: 'ovulatory_strength',
            title: 'Maximize Strength Training',
            description: 'Peak testosterone levels make this ideal for strength training and muscle building.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.9,
            icon: 'fitness_center',
            tags: ['strength training', 'muscle building', 'testosterone'],
            estimatedBenefit: 'Optimizes muscle building potential',
          ),
          PersonalizedRecommendation(
            id: 'ovulatory_creativity',
            title: 'Channel Creative Energy',
            description: 'High estrogen enhances creativity and problem-solving. Perfect for creative projects.',
            category: RecommendationCategory.lifestyle,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.creativity,
            personalizedScore: 0.82,
            icon: 'palette',
            tags: ['creativity', 'problem-solving', 'projects'],
            estimatedBenefit: 'Harnesses peak creative potential',
          ),
        ]);
        break;

      case CyclePhase.luteal:
        final isEarlyLuteal = dayInCycle <= 21;
        
        if (isEarlyLuteal) {
          recommendations.addAll([
            PersonalizedRecommendation(
              id: 'luteal_organization',
              title: 'Focus on Organization',
              description: 'Rising progesterone enhances attention to detail. Great time for organizing and planning.',
              category: RecommendationCategory.lifestyle,
              priority: RecommendationPriority.high,
              phase: phase,
              actionType: ActionType.organization,
              personalizedScore: 0.87,
              icon: 'folder_special',
              tags: ['organization', 'planning', 'attention to detail'],
              estimatedBenefit: 'Leverages natural organizational tendencies',
            ),
          ]);
        } else {
          recommendations.addAll([
            PersonalizedRecommendation(
              id: 'luteal_selfcare',
              title: 'Increase Self-Care',
              description: 'PMS symptoms may be emerging. Prioritize stress management and gentle self-care.',
              category: RecommendationCategory.wellness,
              priority: RecommendationPriority.high,
              phase: phase,
              actionType: ActionType.selfCare,
              personalizedScore: 0.9,
              icon: 'spa',
              tags: ['self-care', 'stress management', 'PMS'],
              estimatedBenefit: 'Reduces PMS symptoms and improves mood',
            ),
            PersonalizedRecommendation(
              id: 'luteal_magnesium',
              title: 'Consider Magnesium Support',
              description: 'Magnesium can help with mood stability and reduce PMS symptoms during late luteal phase.',
              category: RecommendationCategory.nutrition,
              priority: RecommendationPriority.medium,
              phase: phase,
              actionType: ActionType.nutrition,
              personalizedScore: 0.8,
              icon: 'medication',
              tags: ['magnesium', 'mood', 'PMS', 'supplements'],
              estimatedBenefit: 'Supports mood stability and reduces cramping',
            ),
          ]);
        }
        break;

      default:
        // General recommendations when phase is unknown
        recommendations.add(
          PersonalizedRecommendation(
            id: 'general_tracking',
            title: 'Start Cycle Tracking',
            description: 'Track your symptoms and cycle to receive more personalized recommendations.',
            category: RecommendationCategory.lifestyle,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.tracking,
            personalizedScore: 0.95,
            icon: 'calendar_month',
            tags: ['tracking', 'personalization', 'insights'],
            estimatedBenefit: 'Enables personalized health insights',
          ),
        );
    }

    return recommendations;
  }

  /// Generate health data-driven recommendations
  List<PersonalizedRecommendation> _generateHealthDataRecommendations(
    WearablesSummary wearablesSummary,
    CyclePhase phase,
  ) {
    final recommendations = <PersonalizedRecommendation>[];

    // Sleep-based recommendations
    if (wearablesSummary.sleepHours != null) {
      if (wearablesSummary.sleepHours! < 7) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'sleep_improvement',
            title: 'Improve Sleep Duration',
            description: 'You got ${wearablesSummary.sleepHours!.toStringAsFixed(1)} hours of sleep. Aim for 7-9 hours for optimal hormonal balance.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.sleep,
            personalizedScore: 0.9,
            icon: 'bedtime',
            tags: ['sleep', 'hormones', 'recovery'],
            estimatedBenefit: 'Improves hormonal regulation and energy',
            dataInsight: 'Based on your ${wearablesSummary.sleepHours!.toStringAsFixed(1)}h sleep',
          ),
        );
      }

      if (wearablesSummary.sleepQualityScore != null && 
          wearablesSummary.sleepQualityScore! < 70) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'sleep_quality',
            title: 'Enhance Sleep Quality',
            description: 'Your sleep quality is ${wearablesSummary.sleepQualityScore!.toInt()}%. Try a consistent bedtime routine and cooler room temperature.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.sleep,
            personalizedScore: 0.8,
            icon: 'bedtime',
            tags: ['sleep quality', 'bedtime routine', 'environment'],
            estimatedBenefit: 'Better sleep supports cycle regularity',
            dataInsight: 'Sleep quality: ${wearablesSummary.sleepQualityScore!.toInt()}%',
          ),
        );
      }
    }

    // Activity-based recommendations
    if (wearablesSummary.steps != null) {
      if (wearablesSummary.steps! < 7500) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'increase_activity',
            title: 'Boost Daily Movement',
            description: 'You\'ve taken ${wearablesSummary.steps} steps. Aim for 8,000-10,000 for better menstrual health.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.75,
            icon: 'directions_walk',
            tags: ['steps', 'activity', 'movement'],
            estimatedBenefit: 'Regular movement reduces PMS symptoms',
            dataInsight: 'Current steps: ${wearablesSummary.steps}',
          ),
        );
      } else if (wearablesSummary.steps! > 15000) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'activity_balance',
            title: 'Balance High Activity',
            description: 'Great activity level (${wearablesSummary.steps} steps)! Ensure adequate recovery time.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.low,
            phase: phase,
            actionType: ActionType.recovery,
            personalizedScore: 0.65,
            icon: 'self_improvement',
            tags: ['recovery', 'balance', 'high activity'],
            estimatedBenefit: 'Prevents overtraining and hormone imbalance',
            dataInsight: 'High activity: ${wearablesSummary.steps} steps',
          ),
        );
      }
    }

    // Heart rate variability recommendations
    if (wearablesSummary.heartRateVariability != null) {
      if (wearablesSummary.heartRateVariability! < 30) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'stress_management',
            title: 'Focus on Stress Management',
            description: 'Low HRV (${wearablesSummary.heartRateVariability!.toInt()}ms) suggests high stress. Try meditation or breathing exercises.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.stressManagement,
            personalizedScore: 0.88,
            icon: 'self_improvement',
            tags: ['stress', 'HRV', 'meditation', 'breathing'],
            estimatedBenefit: 'Reduces stress impact on menstrual cycle',
            dataInsight: 'HRV: ${wearablesSummary.heartRateVariability!.toInt()}ms',
          ),
        );
      }
    }

    // Body temperature insights
    if (wearablesSummary.bodyTemperature != null) {
      final temp = wearablesSummary.bodyTemperature!;
      if (phase == CyclePhase.follicular && temp > 36.7) {
        recommendations.add(
          PersonalizedRecommendation(
            id: 'ovulation_tracking',
            title: 'Track Ovulation Signs',
            description: 'Elevated temperature (${temp.toStringAsFixed(1)}°C) may indicate approaching ovulation.',
            category: RecommendationCategory.tracking,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.tracking,
            personalizedScore: 0.85,
            icon: 'thermostat',
            tags: ['ovulation', 'temperature', 'fertility'],
            estimatedBenefit: 'Better understanding of fertile window',
            dataInsight: 'Body temp: ${temp.toStringAsFixed(1)}°C',
          ),
        );
      }
    }

    return recommendations;
  }

  /// Generate lifestyle recommendations
  List<PersonalizedRecommendation> _generateLifestyleRecommendations(
    CyclePhase phase,
    WearablesSummary? wearablesSummary,
    List<PersonalizedInsight> userInsights,
  ) {
    final recommendations = <PersonalizedRecommendation>[];

    // Work-life balance recommendations based on phase
    if (phase == CyclePhase.luteal) {
      recommendations.add(
        PersonalizedRecommendation(
          id: 'work_life_balance',
          title: 'Adjust Work-Life Balance',
          description: 'During luteal phase, consider lighter schedules and more downtime to support well-being.',
          category: RecommendationCategory.lifestyle,
          priority: RecommendationPriority.medium,
          phase: phase,
          actionType: ActionType.lifestyle,
          personalizedScore: 0.7,
          icon: 'work_history',
          tags: ['work-life balance', 'downtime', 'luteal phase'],
          estimatedBenefit: 'Reduces stress and supports hormonal balance',
        ),
      );
    }

    // Screen time and digital wellness
    recommendations.add(
      PersonalizedRecommendation(
        id: 'digital_wellness',
        title: 'Practice Digital Wellness',
        description: 'Reduce screen time before bed to improve sleep quality and hormonal regulation.',
        category: RecommendationCategory.wellness,
        priority: RecommendationPriority.low,
        phase: phase,
        actionType: ActionType.lifestyle,
        personalizedScore: 0.6,
        icon: 'phone_android',
        tags: ['digital wellness', 'screen time', 'sleep'],
        estimatedBenefit: 'Improves sleep quality and reduces stress',
      ),
    );

    return recommendations;
  }

  /// Generate nutrition recommendations
  List<PersonalizedRecommendation> _generateNutritionRecommendations(
    CyclePhase phase,
    WearablesSummary? wearablesSummary,
  ) {
    final recommendations = <PersonalizedRecommendation>[];

    switch (phase) {
      case CyclePhase.menstrual:
        recommendations.addAll([
          PersonalizedRecommendation(
            id: 'anti_inflammatory_foods',
            title: 'Choose Anti-Inflammatory Foods',
            description: 'Include turmeric, ginger, and fatty fish to reduce menstrual inflammation.',
            category: RecommendationCategory.nutrition,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.nutrition,
            personalizedScore: 0.78,
            icon: 'restaurant',
            tags: ['anti-inflammatory', 'turmeric', 'ginger', 'omega-3'],
            estimatedBenefit: 'Reduces menstrual pain and inflammation',
          ),
        ]);
        break;

      case CyclePhase.follicular:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'protein_boost',
            title: 'Increase Quality Protein',
            description: 'Support rising energy levels with lean proteins like chicken, fish, and plant-based options.',
            category: RecommendationCategory.nutrition,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.nutrition,
            personalizedScore: 0.72,
            icon: 'restaurant',
            tags: ['protein', 'lean meats', 'plant-based', 'energy'],
            estimatedBenefit: 'Supports energy and muscle recovery',
          ),
        );
        break;

      case CyclePhase.luteal:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'complex_carbs',
            title: 'Focus on Complex Carbohydrates',
            description: 'Support serotonin production with quinoa, sweet potatoes, and whole grains to stabilize mood.',
            category: RecommendationCategory.nutrition,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.nutrition,
            personalizedScore: 0.85,
            icon: 'restaurant',
            tags: ['complex carbs', 'serotonin', 'mood stability'],
            estimatedBenefit: 'Improves mood and reduces PMS symptoms',
          ),
        );
        break;

      default:
        break;
    }

    // General nutrition based on health data
    if (wearablesSummary?.waterIntake != null && wearablesSummary!.waterIntake! < 2000) {
      recommendations.add(
        PersonalizedRecommendation(
          id: 'hydration_reminder',
          title: 'Increase Water Intake',
          description: 'Aim for 2.5-3 liters daily to support circulation and reduce bloating.',
          category: RecommendationCategory.nutrition,
          priority: RecommendationPriority.medium,
          phase: phase,
          actionType: ActionType.hydration,
          personalizedScore: 0.7,
          icon: 'local_drink',
          tags: ['hydration', 'water', 'circulation', 'bloating'],
          estimatedBenefit: 'Improves circulation and reduces water retention',
        ),
      );
    }

    return recommendations;
  }

  /// Generate exercise recommendations
  List<PersonalizedRecommendation> _generateExerciseRecommendations(
    CyclePhase phase,
    WearablesSummary? wearablesSummary,
  ) {
    final recommendations = <PersonalizedRecommendation>[];

    switch (phase) {
      case CyclePhase.menstrual:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'gentle_exercise',
            title: 'Try Gentle Movement',
            description: 'Light yoga, walking, or stretching can help reduce cramps and improve mood.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.88,
            icon: 'self_improvement',
            tags: ['yoga', 'walking', 'stretching', 'gentle movement'],
            estimatedBenefit: 'Reduces menstrual discomfort and improves circulation',
          ),
        );
        break;

      case CyclePhase.follicular:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'high_intensity_workouts',
            title: 'Embrace High-Intensity Workouts',
            description: 'Rising estrogen levels make this perfect for HIIT, running, or challenging strength training.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.9,
            icon: 'fitness_center',
            tags: ['HIIT', 'running', 'strength training', 'high intensity'],
            estimatedBenefit: 'Maximizes workout effectiveness and energy',
          ),
        );
        break;

      case CyclePhase.ovulatory:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'strength_and_power',
            title: 'Focus on Strength and Power',
            description: 'Peak hormone levels support maximum strength gains. Perfect for heavy lifting and power training.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.92,
            icon: 'fitness_center',
            tags: ['strength training', 'power', 'heavy lifting', 'maximum gains'],
            estimatedBenefit: 'Optimizes strength and power development',
          ),
        );
        break;

      case CyclePhase.luteal:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'moderate_exercise',
            title: 'Moderate-Intensity Exercise',
            description: 'Focus on steady-state cardio, yoga, and moderate strength training to support mood.',
            category: RecommendationCategory.exercise,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.exercise,
            personalizedScore: 0.8,
            icon: 'directions_bike',
            tags: ['steady-state cardio', 'yoga', 'moderate intensity', 'mood support'],
            estimatedBenefit: 'Supports mood stability and reduces PMS symptoms',
          ),
        );
        break;

      default:
        break;
    }

    return recommendations;
  }

  /// Generate wellness and self-care recommendations
  List<PersonalizedRecommendation> _generateWellnessRecommendations(
    CyclePhase phase,
    WearablesSummary? wearablesSummary,
  ) {
    final recommendations = <PersonalizedRecommendation>[];

    // Stress management recommendations
    if (wearablesSummary?.heartRateVariability != null && 
        wearablesSummary!.heartRateVariability! < 40) {
      recommendations.add(
        PersonalizedRecommendation(
          id: 'meditation_practice',
          title: 'Start Daily Meditation',
          description: 'Just 10 minutes of daily meditation can significantly improve stress management and cycle regularity.',
          category: RecommendationCategory.wellness,
          priority: RecommendationPriority.high,
          phase: phase,
          actionType: ActionType.meditation,
          personalizedScore: 0.9,
          icon: 'self_improvement',
          tags: ['meditation', 'stress management', 'mindfulness'],
          estimatedBenefit: 'Improves stress resilience and hormonal balance',
          dataInsight: 'Based on elevated stress indicators',
        ),
      );
    }

    // Phase-specific wellness recommendations
    switch (phase) {
      case CyclePhase.luteal:
        recommendations.addAll([
          PersonalizedRecommendation(
            id: 'essential_oils',
            title: 'Try Aromatherapy',
            description: 'Lavender or chamomile essential oils can help reduce anxiety and improve sleep quality.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.low,
            phase: phase,
            actionType: ActionType.aromatherapy,
            personalizedScore: 0.6,
            icon: 'spa',
            tags: ['aromatherapy', 'essential oils', 'relaxation', 'sleep'],
            estimatedBenefit: 'Promotes relaxation and better sleep',
          ),
          PersonalizedRecommendation(
            id: 'journaling',
            title: 'Practice Emotional Journaling',
            description: 'Write down your thoughts and emotions to process PMS-related mood changes.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.medium,
            phase: phase,
            actionType: ActionType.journaling,
            personalizedScore: 0.7,
            icon: 'edit_note',
            tags: ['journaling', 'emotional processing', 'mood', 'PMS'],
            estimatedBenefit: 'Improves emotional processing and self-awareness',
          ),
        ]);
        break;

      case CyclePhase.menstrual:
        recommendations.add(
          PersonalizedRecommendation(
            id: 'heat_therapy',
            title: 'Use Heat Therapy',
            description: 'A warm bath or heating pad can provide natural pain relief for menstrual cramps.',
            category: RecommendationCategory.wellness,
            priority: RecommendationPriority.high,
            phase: phase,
            actionType: ActionType.heatTherapy,
            personalizedScore: 0.85,
            icon: 'hot_tub',
            tags: ['heat therapy', 'pain relief', 'cramps', 'natural remedies'],
            estimatedBenefit: 'Provides natural pain relief and muscle relaxation',
          ),
        );
        break;

      default:
        break;
    }

    return recommendations;
  }

  /// Apply user preferences to filter and score recommendations
  List<PersonalizedRecommendation> _applyUserPreferences(
    List<PersonalizedRecommendation> recommendations,
  ) {
    return recommendations.map((rec) {
      // Adjust score based on user response history
      final categoryHistory = _userResponseHistory[rec.category.toString()] ?? [];
      final positiveResponses = categoryHistory
          .where((response) => response.isPositive)
          .length;
      final totalResponses = categoryHistory.length;
      
      if (totalResponses > 0) {
        final categoryPreference = positiveResponses / totalResponses;
        rec.personalizedScore = (rec.personalizedScore * 0.7) + (categoryPreference * 0.3);
      }
      
      // Apply user preference multipliers
      final categoryPreference = _userPreferences[rec.category.toString()] ?? 1.0;
      rec.personalizedScore *= categoryPreference;
      
      return rec;
    }).toList();
  }

  /// Record user response to a recommendation
  void recordUserResponse(String recommendationId, bool isPositive, String? feedback) {
    final recommendation = _currentRecommendations
        .where((rec) => rec.id == recommendationId)
        .firstOrNull;
    
    if (recommendation != null) {
      final categoryKey = recommendation.category.toString();
      if (!_userResponseHistory.containsKey(categoryKey)) {
        _userResponseHistory[categoryKey] = [];
      }
      
      _userResponseHistory[categoryKey]!.add(
        UserResponse(
          recommendationId: recommendationId,
          isPositive: isPositive,
          feedback: feedback,
          timestamp: DateTime.now(),
        ),
      );
      
      // Update user preferences based on response
      _updateUserPreferences(recommendation.category, isPositive);
    }
  }

  /// Update user preferences based on feedback
  void _updateUserPreferences(RecommendationCategory category, bool isPositive) {
    final categoryKey = category.toString();
    final currentPreference = _userPreferences[categoryKey] ?? 1.0;
    
    // Adjust preference based on feedback (learning rate: 0.1)
    if (isPositive) {
      _userPreferences[categoryKey] = (currentPreference + 0.1).clamp(0.5, 1.5);
    } else {
      _userPreferences[categoryKey] = (currentPreference - 0.1).clamp(0.5, 1.5);
    }
  }

  /// Get recommendations by category
  List<PersonalizedRecommendation> getRecommendationsByCategory(
    RecommendationCategory category,
  ) {
    return _currentRecommendations
        .where((rec) => rec.category == category)
        .toList();
  }

  /// Get high priority recommendations
  List<PersonalizedRecommendation> getHighPriorityRecommendations() {
    return _currentRecommendations
        .where((rec) => rec.priority == RecommendationPriority.high)
        .toList();
  }

  /// Clear current recommendations
  void clearRecommendations() {
    _currentRecommendations.clear();
    notifyListeners();
  }
}

/// Represents a personalized recommendation
class PersonalizedRecommendation {
  final String id;
  final String title;
  final String description;
  final RecommendationCategory category;
  final RecommendationPriority priority;
  final CyclePhase phase;
  final ActionType actionType;
  final String icon;
  final List<String> tags;
  final String estimatedBenefit;
  final String? dataInsight;
  final String? actionUrl;
  double personalizedScore;

  PersonalizedRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.phase,
    required this.actionType,
    required this.personalizedScore,
    required this.icon,
    required this.tags,
    required this.estimatedBenefit,
    this.dataInsight,
    this.actionUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString(),
      'priority': priority.toString(),
      'phase': phase.toString(),
      'actionType': actionType.toString(),
      'personalizedScore': personalizedScore,
      'icon': icon,
      'tags': tags,
      'estimatedBenefit': estimatedBenefit,
      'dataInsight': dataInsight,
      'actionUrl': actionUrl,
    };
  }
}

/// Categories of recommendations
enum RecommendationCategory {
  nutrition,
  exercise,
  wellness,
  lifestyle,
  tracking,
}

/// Priority levels for recommendations
enum RecommendationPriority {
  high,
  medium,
  low,
}

/// Types of actions recommendations can suggest
enum ActionType {
  nutrition,
  exercise,
  sleep,
  hydration,
  meditation,
  tracking,
  lifestyle,
  social,
  communication,
  creativity,
  organization,
  selfCare,
  stressManagement,
  aromatherapy,
  journaling,
  heatTherapy,
  recovery,
}

/// User response to a recommendation
class UserResponse {
  final String recommendationId;
  final bool isPositive;
  final String? feedback;
  final DateTime timestamp;

  UserResponse({
    required this.recommendationId,
    required this.isPositive,
    this.feedback,
    required this.timestamp,
  });
}
