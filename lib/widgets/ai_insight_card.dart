import 'package:flutter/material.dart';
import '../models/ai_insights.dart';

class AIInsightCard extends StatelessWidget {
  final AIInsights insight;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: insight.isPinned ? 4 : 2,
      color: insight.isPinned ? Colors.blue[50] : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Insight type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      insight.type.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                insight.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (insight.isPinned)
                              Icon(
                                Icons.push_pin,
                                size: 16,
                                color: Colors.blue[600],
                              ),
                            if (onDismiss != null)
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: onDismiss,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        
                        // Insight type badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTypeColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            insight.type.displayName,
                            style: TextStyle(
                              color: _getTypeColor(),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Description
                        Text(
                          insight.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Recommendation
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outlined,
                                size: 16,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  insight.recommendation,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Footer with confidence and timestamp
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Confidence indicator
                  Row(
                    children: [
                      _buildConfidenceIndicator(),
                      const SizedBox(width: 4),
                      Text(
                        _getConfidenceText(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
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

  Widget _buildConfidenceIndicator() {
    Color color;
    IconData icon;
    
    if (insight.isHighConfidence) {
      color = Colors.green;
      icon = Icons.circle;
    } else if (insight.isMediumConfidence) {
      color = Colors.orange;
      icon = Icons.circle;
    } else {
      color = Colors.red;
      icon = Icons.circle_outlined;
    }
    
    return Icon(
      icon,
      size: 12,
      color: color,
    );
  }

  String _getConfidenceText() {
    if (insight.isHighConfidence) {
      return 'High confidence';
    } else if (insight.isMediumConfidence) {
      return 'Medium confidence';
    } else {
      return 'Low confidence';
    }
  }

  Color _getTypeColor() {
    switch (insight.type) {
      case InsightType.cyclePattern:
        return Colors.blue;
      case InsightType.symptomCorrelation:
        return Colors.purple;
      case InsightType.moodTracking:
        return Colors.pink;
      case InsightType.fertilityWindow:
        return Colors.green;
      case InsightType.healthRecommendation:
        return Colors.red;
      case InsightType.nutritionAdvice:
        return Colors.orange;
      case InsightType.exerciseGuidance:
        return Colors.teal;
      case InsightType.sleepOptimization:
        return Colors.indigo;
      case InsightType.stressManagement:
        return Colors.deepPurple;
      case InsightType.general:
        return Colors.grey;
    }
  }

  String _formatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(insight.createdAt);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${insight.createdAt.day}/${insight.createdAt.month}';
    }
  }
}
