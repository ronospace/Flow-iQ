import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../services/multimodal_input_service.dart';

/// Widget for multimodal input (camera, photo analysis, and combined voice+photo)
class MultimodalInputWidget extends StatefulWidget {
  const MultimodalInputWidget({Key? key}) : super(key: key);

  @override
  State<MultimodalInputWidget> createState() => _MultimodalInputWidgetState();
}

class _MultimodalInputWidgetState extends State<MultimodalInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize pulse animation for camera capture
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Initialize the service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MultimodalInputService>().initialize();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MultimodalInputService>(
      builder: (context, service, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Multimodal Tracking',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Capture photos and voice input for comprehensive symptom tracking',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Camera preview for mood selfies
                if (service.isCameraInitialized)
                  _buildCameraPreview(context, service)
                else
                  _buildCameraInitializationStatus(context, service),

                const SizedBox(height: 20),

                // Action buttons
                _buildActionButtons(context, service),

                const SizedBox(height: 16),

                // Error message
                if (service.errorMessage != null)
                  _buildErrorMessage(context, service.errorMessage!),

                // Analysis history
                if (service.analysisHistory.isNotEmpty)
                  _buildAnalysisHistory(context, service),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCameraPreview(BuildContext context, MultimodalInputService service) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (service.cameraController != null)
            CameraPreview(service.cameraController!)
          else
            const Center(
              child: Text(
                'Camera not available',
                style: TextStyle(color: Colors.white),
              ),
            ),

          // Overlay for mood selfie capture
          Positioned(
            bottom: 16,
            right: 16,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: service.isAnalyzing ? _pulseAnimation.value : 1.0,
                  child: FloatingActionButton(
                    mini: true,
                    heroTag: "mood_capture",
                    onPressed: service.isAnalyzing ? null : () => _captureMoodSelfie(context, service),
                    child: service.isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.camera_alt),
                  ),
                );
              },
            ),
          ),

          // Camera switch button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              onPressed: () => _switchCamera(service),
              icon: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraInitializationStatus(BuildContext context, MultimodalInputService service) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Initializing camera...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MultimodalInputService service) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Mood Selfie Button
        _buildActionButton(
          context: context,
          icon: Icons.sentiment_satisfied,
          label: 'Mood Selfie',
          color: Colors.blue,
          isLoading: service.isAnalyzing,
          onPressed: () => _captureMoodSelfie(context, service),
        ),

        // Skin Analysis Button
        _buildActionButton(
          context: context,
          icon: Icons.face_retouching_natural,
          label: 'Skin Analysis',
          color: Colors.pink,
          isLoading: service.isAnalyzing,
          onPressed: () => _analyzeSkinPhoto(context, service),
        ),

        // Combined Analysis Button
        _buildActionButton(
          context: context,
          icon: Icons.multitrack_audio,
          label: 'Voice + Photo',
          color: Colors.purple,
          isLoading: service.isAnalyzing,
          onPressed: () => _showCombinedAnalysisDialog(context, service),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 56) / 2,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            : Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String error) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisHistory(BuildContext context, MultimodalInputService service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Analysis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => service.clearHistory(),
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            itemCount: service.analysisHistory.length,
            itemBuilder: (context, index) {
              final result = service.analysisHistory[index];
              return _buildAnalysisResultCard(context, result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisResultCard(BuildContext context, MultimodalAnalysisResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(result.type).withValues(alpha: 0.2),
          child: Icon(
            _getTypeIcon(result.type),
            color: _getTypeColor(result.type),
            size: 20,
          ),
        ),
        title: Text(
          _getTypeTitle(result.type),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.summary),
            Text(
              _formatTimestamp(result.timestamp),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: result.imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  File(result.imagePath!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : null,
        onTap: () => _showAnalysisDetails(context, result),
      ),
    );
  }

  // Action methods
  Future<void> _captureMoodSelfie(BuildContext context, MultimodalInputService service) async {
    if (service.isAnalyzing) return;

    _pulseController.repeat(reverse: true);
    
    final result = await service.captureMoodSelfie();
    
    _pulseController.stop();
    _pulseController.reset();
    
    if (result != null && mounted) {
      _showAnalysisSuccess(context, result);
    }
  }

  Future<void> _analyzeSkinPhoto(BuildContext context, MultimodalInputService service) async {
    if (service.isAnalyzing) return;

    final result = await service.analyzeSkinPhoto();
    if (result != null && mounted) {
      _showAnalysisSuccess(context, result);
    }
  }

  Future<void> _switchCamera(MultimodalInputService service) async {
    // In a full implementation, this would switch between front and back cameras
    // For now, we'll just reinitialize
    await service.initialize();
  }

  void _showCombinedAnalysisDialog(BuildContext context, MultimodalInputService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Combined Analysis'),
        content: const Text('This feature allows you to combine voice descriptions with supporting photos for comprehensive symptom tracking.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement combined analysis flow
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Combined analysis coming soon!')),
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showAnalysisSuccess(BuildContext context, MultimodalAnalysisResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analysis complete: ${result.summary}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAnalysisDetails(BuildContext context, MultimodalAnalysisResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTypeTitle(result.type)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Time: ${_formatTimestamp(result.timestamp)}'),
              const SizedBox(height: 8),
              Text('Summary: ${result.summary}'),
              if (result.moodAnalysis != null) ...[
                const SizedBox(height: 12),
                Text('Detected Mood: ${result.moodAnalysis!.detectedMood}'),
                Text('Confidence: ${(result.moodAnalysis!.confidence * 100).toInt()}%'),
              ],
              if (result.skinAnalysis != null) ...[
                const SizedBox(height: 12),
                Text('Skin Conditions: ${result.skinAnalysis!.detectedConditions.join(', ')}'),
                Text('Skin Tone: ${result.skinAnalysis!.skinTone}'),
                if (result.skinAnalysis!.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Recommendations:'),
                  ...result.skinAnalysis!.recommendations.map((rec) => Text('• $rec')),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getTypeColor(MultimodalInputType type) {
    switch (type) {
      case MultimodalInputType.moodSelfie:
        return Colors.blue;
      case MultimodalInputType.skinAnalysis:
        return Colors.pink;
      case MultimodalInputType.combined:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(MultimodalInputType type) {
    switch (type) {
      case MultimodalInputType.moodSelfie:
        return Icons.sentiment_satisfied;
      case MultimodalInputType.skinAnalysis:
        return Icons.face_retouching_natural;
      case MultimodalInputType.combined:
        return Icons.multitrack_audio;
    }
  }

  String _getTypeTitle(MultimodalInputType type) {
    switch (type) {
      case MultimodalInputType.moodSelfie:
        return 'Mood Selfie';
      case MultimodalInputType.skinAnalysis:
        return 'Skin Analysis';
      case MultimodalInputType.combined:
        return 'Combined Analysis';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
