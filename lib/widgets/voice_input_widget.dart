import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_input_service.dart';

/// Voice input widget that provides speech-to-text functionality
/// with visual feedback and error handling
class VoiceInputWidget extends StatefulWidget {
  final VoiceInputType inputType;
  final Function(VoiceInputResult) onResult;
  final String? placeholder;
  final bool showHelp;
  final Duration? timeout;

  const VoiceInputWidget({
    super.key,
    required this.inputType,
    required this.onResult,
    this.placeholder,
    this.showHelp = true,
    this.timeout,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeVoiceService();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  void _initializeVoiceService() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final voiceService = Provider.of<VoiceInputService>(context, listen: false);
      await voiceService.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceInputService>(
      builder: (context, voiceService, child) {
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildVoiceButton(voiceService),
                const SizedBox(height: 16),
                _buildStatusText(voiceService),
                if (voiceService.recognizedText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildRecognizedText(voiceService),
                ],
                if (voiceService.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(voiceService),
                ],
                if (widget.showHelp && !voiceService.isListening) ...[
                  const SizedBox(height: 20),
                  _buildHelpSection(voiceService),
                ],
                const SizedBox(height: 16),
                _buildActionButtons(voiceService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          _getIconForInputType(),
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _getTitleForInputType(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceButton(VoiceInputService voiceService) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _waveAnimation]),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => _handleVoiceButtonTap(voiceService),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: voiceService.isListening
                    ? [
                        Colors.red.withValues(alpha: 0.3),
                        Colors.red.withValues(alpha: 0.1),
                        Colors.transparent,
                      ]
                    : [
                        Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
              ),
            ),
            child: Transform.scale(
              scale: voiceService.isListening ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: voiceService.isListening
                      ? Colors.red
                      : (voiceService.isAvailable
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: (voiceService.isListening
                              ? Colors.red
                              : Theme.of(context).primaryColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: voiceService.isListening ? 10 : 5,
                    ),
                  ],
                ),
                child: Icon(
                  voiceService.isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText(VoiceInputService voiceService) {
    String statusText;
    Color statusColor;

    if (!voiceService.isAvailable) {
      statusText = 'Voice input not available';
      statusColor = Colors.red;
    } else if (voiceService.isListening) {
      statusText = 'Listening... Speak now';
      statusColor = Colors.red;
    } else if (voiceService.recognizedText.isNotEmpty) {
      statusText = 'Tap the button to speak again';
      statusColor = Colors.green;
    } else {
      statusText = widget.placeholder ?? 'Tap to start voice input';
      statusColor = Colors.grey[600]!;
    }

    return Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontSize: 16,
        fontWeight: voiceService.isListening ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRecognizedText(VoiceInputService voiceService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recognized:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            voiceService.recognizedText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.verified,
                size: 16,
                color: _getConfidenceColor(voiceService.confidence),
              ),
              const SizedBox(width: 4),
              Text(
                'Confidence: ${(voiceService.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: _getConfidenceColor(voiceService.confidence),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(VoiceInputService voiceService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              voiceService.errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(VoiceInputService voiceService) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Voice Commands',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            voiceService.getVoiceCommandsHelp(widget.inputType),
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(VoiceInputService voiceService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (voiceService.recognizedText.isNotEmpty) ...[
          TextButton.icon(
            onPressed: () => voiceService.clearSession(),
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _processAndReturn(voiceService),
            icon: const Icon(Icons.check),
            label: const Text('Use Result'),
          ),
        ] else ...[
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  void _handleVoiceButtonTap(VoiceInputService voiceService) {
    if (voiceService.isListening) {
      voiceService.stopListening();
      _pulseController.stop();
      _waveController.stop();
    } else {
      voiceService.startListening(
        inputType: widget.inputType,
        timeout: widget.timeout,
      );
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  void _processAndReturn(VoiceInputService voiceService) {
    final result = voiceService.getCurrentResult(widget.inputType);
    if (result != null && result.hasResults) {
      widget.onResult(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No recognized symptoms or mood found. Please try again.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  IconData _getIconForInputType() {
    switch (widget.inputType) {
      case VoiceInputType.symptoms:
        return Icons.medical_services;
      case VoiceInputType.mood:
        return Icons.mood;
      case VoiceInputType.general:
        return Icons.record_voice_over;
      case VoiceInputType.notes:
        return Icons.note_alt;
    }
  }

  String _getTitleForInputType() {
    switch (widget.inputType) {
      case VoiceInputType.symptoms:
        return 'Voice Symptom Logging';
      case VoiceInputType.mood:
        return 'Voice Mood Tracking';
      case VoiceInputType.general:
        return 'Voice Check-in';
      case VoiceInputType.notes:
        return 'Voice Notes';
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }
}

/// Floating action button for quick voice input access
class VoiceInputFAB extends StatelessWidget {
  final VoiceInputType inputType;
  final Function(VoiceInputResult) onResult;
  final String? tooltip;

  const VoiceInputFAB({
    super.key,
    required this.inputType,
    required this.onResult,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showVoiceInputModal(context),
      tooltip: tooltip ?? 'Voice Input',
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.mic, color: Colors.white),
    );
  }

  void _showVoiceInputModal(BuildContext context) {
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
              inputType: inputType,
              onResult: (result) {
                Navigator.of(context).pop();
                onResult(result);
              },
            ),
          ),
        ),
      ),
    );
  }
}
