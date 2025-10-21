import 'package:flutter/material.dart';
import '../services/enhanced_ai_service.dart';

/// Widget to display personalized insights from Enhanced AI Service
class PersonalizedInsightCard extends StatelessWidget {
  final PersonalizedInsight insight;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onFeedback;

  const PersonalizedInsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.onDismiss,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getTypeColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
              const SizedBox(height: 12),
              _buildRecommendation(),
              if (insight.actionable) ...[
                const SizedBox(height: 16),
                _buildActionButton(),
              ],
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getTypeIcon(),
            color: _getTypeColor(),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                insight.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getTypeDisplayName(),
                  style: TextStyle(
                    color: _getTypeColor(),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (onDismiss != null)
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      insight.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.4,
      ),
    );
  }

  Widget _buildRecommendation() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outlined,
            color: Colors.blue[600],
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              insight.recommendation,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(_getActionIcon(), size: 18),
        label: Text(_getActionText()),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getTypeColor(),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildRelevanceIndicator(),
            const SizedBox(width: 12),
            Text(
              _formatTimestamp(),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        if (onFeedback != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                onPressed: () => _handleFeedback(true),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.thumb_down_outlined, size: 16),
                onPressed: () => _handleFeedback(false),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRelevanceIndicator() {
    final relevance = insight.relevanceScore;
    Color color;
    IconData icon;

    if (relevance >= 0.8) {
      color = Colors.green;
      icon = Icons.circle;
    } else if (relevance >= 0.6) {
      color = Colors.orange;
      icon = Icons.circle;
    } else {
      color = Colors.red;
      icon = Icons.circle_outlined;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 4),
        Text(
          'Relevance: ${(relevance * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return Colors.green;
      case PersonalizedInsightType.nutrition:
        return Colors.orange;
      case PersonalizedInsightType.sleep:
        return Colors.indigo;
      case PersonalizedInsightType.mood:
        return Colors.pink;
      case PersonalizedInsightType.selfCare:
        return Colors.purple;
      case PersonalizedInsightType.health:
        return Colors.red;
      case PersonalizedInsightType.prediction:
        return Colors.blue;
      case PersonalizedInsightType.warning:
        return Colors.red;
    }
  }

  IconData _getTypeIcon() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return Icons.fitness_center;
      case PersonalizedInsightType.nutrition:
        return Icons.restaurant;
      case PersonalizedInsightType.sleep:
        return Icons.bedtime;
      case PersonalizedInsightType.mood:
        return Icons.mood;
      case PersonalizedInsightType.selfCare:
        return Icons.spa;
      case PersonalizedInsightType.health:
        return Icons.health_and_safety;
      case PersonalizedInsightType.prediction:
        return Icons.auto_awesome;
      case PersonalizedInsightType.warning:
        return Icons.warning_amber;
    }
  }

  String _getTypeDisplayName() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return 'Exercise';
      case PersonalizedInsightType.nutrition:
        return 'Nutrition';
      case PersonalizedInsightType.sleep:
        return 'Sleep';
      case PersonalizedInsightType.mood:
        return 'Mood';
      case PersonalizedInsightType.selfCare:
        return 'Self Care';
      case PersonalizedInsightType.health:
        return 'Health';
      case PersonalizedInsightType.prediction:
        return 'Prediction';
      case PersonalizedInsightType.warning:
        return 'Alert';
    }
  }

  IconData _getActionIcon() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return Icons.play_arrow;
      case PersonalizedInsightType.nutrition:
        return Icons.restaurant_menu;
      case PersonalizedInsightType.sleep:
        return Icons.schedule;
      case PersonalizedInsightType.mood:
        return Icons.emoji_emotions;
      case PersonalizedInsightType.selfCare:
        return Icons.self_improvement;
      case PersonalizedInsightType.health:
        return Icons.medical_services;
      case PersonalizedInsightType.prediction:
        return Icons.visibility;
      case PersonalizedInsightType.warning:
        return Icons.priority_high;
    }
  }

  String _getActionText() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return 'Start Workout';
      case PersonalizedInsightType.nutrition:
        return 'View Meal Plans';
      case PersonalizedInsightType.sleep:
        return 'Sleep Tips';
      case PersonalizedInsightType.mood:
        return 'Track Mood';
      case PersonalizedInsightType.selfCare:
        return 'Self Care Guide';
      case PersonalizedInsightType.health:
        return 'Learn More';
      case PersonalizedInsightType.prediction:
        return 'View Details';
      case PersonalizedInsightType.warning:
        return 'Take Action';
    }
  }

  String _formatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(insight.createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _handleFeedback(bool isPositive) {
    if (onFeedback != null) {
      onFeedback!();
      // In a real implementation, you would send feedback to the AI service
    }
  }
}

/// Compact version of personalized insight for summary views
class PersonalizedInsightSummary extends StatelessWidget {
  final PersonalizedInsight insight;
  final VoidCallback? onTap;

  const PersonalizedInsightSummary({
    super.key,
    required this.insight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(),
                color: _getTypeColor(),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    insight.recommendation,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return Colors.green;
      case PersonalizedInsightType.nutrition:
        return Colors.orange;
      case PersonalizedInsightType.sleep:
        return Colors.indigo;
      case PersonalizedInsightType.mood:
        return Colors.pink;
      case PersonalizedInsightType.selfCare:
        return Colors.purple;
      case PersonalizedInsightType.health:
        return Colors.red;
      case PersonalizedInsightType.prediction:
        return Colors.blue;
      case PersonalizedInsightType.warning:
        return Colors.red;
    }
  }

  IconData _getTypeIcon() {
    switch (insight.type) {
      case PersonalizedInsightType.exercise:
        return Icons.fitness_center;
      case PersonalizedInsightType.nutrition:
        return Icons.restaurant;
      case PersonalizedInsightType.sleep:
        return Icons.bedtime;
      case PersonalizedInsightType.mood:
        return Icons.mood;
      case PersonalizedInsightType.selfCare:
        return Icons.spa;
      case PersonalizedInsightType.health:
        return Icons.health_and_safety;
      case PersonalizedInsightType.prediction:
        return Icons.auto_awesome;
      case PersonalizedInsightType.warning:
        return Icons.warning_amber;
    }
  }
}
