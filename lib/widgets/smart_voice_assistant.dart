import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/voice_input_service.dart';
import '../services/enhanced_ai_service.dart';

/// Enhanced smart voice assistant with conversational AI capabilities
/// Provides natural language processing and context-aware responses
class SmartVoiceAssistant extends StatefulWidget {
  final VoidCallback? onClose;
  final bool isFloating;

  const SmartVoiceAssistant({
    super.key,
    this.onClose,
    this.isFloating = false,
  });

  @override
  State<SmartVoiceAssistant> createState() => _SmartVoiceAssistantState();
}

class _SmartVoiceAssistantState extends State<SmartVoiceAssistant>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  List<ConversationMessage> _conversationHistory = [];
  bool _isProcessingAI = false;
  String _currentContext = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeAssistant();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  void _initializeAssistant() {
    // Add welcome message
    _conversationHistory.add(
      ConversationMessage(
        text: "Hi! I'm your Flow Ai assistant. I can help you track symptoms, mood, analyze your cycle patterns, or answer questions about your health. How can I assist you today?",
        isAssistant: true,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFloating ? _buildFloatingAssistant() : _buildFullAssistant();
  }

  Widget _buildFloatingAssistant() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: _showFullAssistant,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: const Icon(Icons.assistant, size: 24),
              label: const Text(
                'AI Assistant',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullAssistant() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.95),
              Theme.of(context).primaryColor.withValues(alpha: 0.98),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAssistantHeader(),
              Expanded(child: _buildConversationView()),
              _buildVoiceInputSection(),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: const Icon(
              Icons.assistant,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flow Ai Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your personal health companion',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Conversation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                if (_isProcessingAI)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _conversationHistory.length,
              itemBuilder: (context, index) {
                final message = _conversationHistory[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ConversationMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isAssistant 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        children: [
          if (message.isAssistant) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.assistant, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isAssistant 
                    ? Colors.grey[100] 
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isAssistant ? Colors.black87 : Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  if (message.insights != null) ...[
                    const SizedBox(height: 8),
                    _buildInsightChips(message.insights!),
                  ],
                ],
              ),
            ),
          ),
          if (!message.isAssistant) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightChips(List<String> insights) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: insights.map((insight) => Chip(
        label: Text(
          insight,
          style: const TextStyle(fontSize: 12),
        ),
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      )).toList(),
    );
  }

  Widget _buildVoiceInputSection() {
    return Consumer<VoiceInputService>(
      builder: (context, voiceService, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.mic, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      voiceService.isListening 
                          ? 'Listening... speak now' 
                          : 'Tap to speak or type a message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: voiceService.isListening 
                            ? Colors.red 
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _handleVoiceInput(voiceService),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 60,
                        decoration: BoxDecoration(
                          color: voiceService.isListening 
                              ? Colors.red.withValues(alpha: 0.1)
                              : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: voiceService.isListening 
                                ? Colors.red 
                                : Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            voiceService.isListening ? Icons.stop : Icons.mic,
                            color: voiceService.isListening 
                                ? Colors.red 
                                : Theme.of(context).primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _showTextInput,
                    icon: Icon(
                      Icons.keyboard,
                      color: Theme.of(context).primaryColor,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
              if (voiceService.recognizedText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    voiceService.recognizedText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => voiceService.clearSession(),
                      child: const Text('Clear'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _processVoiceInput(voiceService.recognizedText),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickActionChip('Track symptoms', Icons.medical_services),
              _buildQuickActionChip('Log mood', Icons.mood),
              _buildQuickActionChip('Cycle insights', Icons.insights),
              _buildQuickActionChip('Health tips', Icons.health_and_safety),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _processVoiceInput(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVoiceInput(VoiceInputService voiceService) {
    if (voiceService.isListening) {
      voiceService.stopListening();
    } else {
      voiceService.startListening(inputType: VoiceInputType.general);
    }
  }

  void _showTextInput() {
    showDialog(
      context: context,
      builder: (context) => _TextInputDialog(
        onSend: (text) => _processVoiceInput(text),
      ),
    );
  }

  void _processVoiceInput(String input) async {
    if (input.trim().isEmpty) return;

    // Add user message to conversation
    setState(() {
      _conversationHistory.add(
        ConversationMessage(
          text: input,
          isAssistant: false,
          timestamp: DateTime.now(),
        ),
      );
      _isProcessingAI = true;
    });

    try {
      // Process with AI service
      final aiService = Provider.of<EnhancedAIService>(context, listen: false);
      final voiceService = Provider.of<VoiceInputService>(context, listen: false);
      
      // Parse voice input for structured data
      final voiceResult = voiceService.processVoiceInput(input, VoiceInputType.general);
      
      // Generate AI response with context
      final response = await _generateAIResponse(input, voiceResult, aiService);
      
      setState(() {
        _conversationHistory.add(response);
        _isProcessingAI = false;
      });

      // Clear voice session
      voiceService.clearSession();
      
    } catch (e) {
      setState(() {
        _conversationHistory.add(
          ConversationMessage(
            text: "I apologize, I encountered an error processing your request. Please try again.",
            isAssistant: true,
            timestamp: DateTime.now(),
          ),
        );
        _isProcessingAI = false;
      });
    }
  }

  Future<ConversationMessage> _generateAIResponse(
    String input,
    VoiceInputResult voiceResult,
    EnhancedAIService aiService,
  ) async {
    // Create context for AI response
    String contextPrompt = """
You are Flow Ai's personal health assistant. Respond naturally and helpfully to user queries about:
- Menstrual cycle tracking and predictions
- Symptom analysis and patterns
- Mood tracking and wellness
- Health insights and recommendations
- General period and reproductive health questions

User input: "$input"
""";

    if (voiceResult.symptoms?.isNotEmpty ?? false) {
      contextPrompt += "\nRecognized symptoms: ${voiceResult.symptoms!.join(', ')}";
    }
    
    if (voiceResult.mood != null) {
      contextPrompt += "\nRecognized mood: ${voiceResult.mood}";
    }

    try {
      // Generate AI response
      final aiResponse = await aiService.generateInsight(
        _currentContext.isNotEmpty ? _currentContext : contextPrompt,
        isConversational: true,
      );

      // Extract insights if the response contains structured data
      List<String>? insights;
      if (voiceResult.hasResults) {
        insights = [];
        if (voiceResult.symptoms?.isNotEmpty ?? false) {
          insights.addAll(voiceResult.symptoms!);
        }
        if (voiceResult.mood != null) {
          insights.add(voiceResult.mood!);
        }
      }

      return ConversationMessage(
        text: aiResponse.description,
        isAssistant: true,
        timestamp: DateTime.now(),
        insights: insights,
      );
    } catch (e) {
      // Fallback response
      return ConversationMessage(
        text: _generateFallbackResponse(input, voiceResult),
        isAssistant: true,
        timestamp: DateTime.now(),
      );
    }
  }

  String _generateFallbackResponse(String input, VoiceInputResult voiceResult) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('symptom')) {
      if (voiceResult.symptoms?.isNotEmpty ?? false) {
        return "I've logged your symptoms: ${voiceResult.symptoms!.join(', ')}. These can be helpful for tracking patterns in your cycle.";
      }
      return "I can help you track symptoms like cramps, headaches, bloating, and more. Just tell me what you're experiencing.";
    }
    
    if (lowerInput.contains('mood')) {
      if (voiceResult.mood != null) {
        return "Thanks for sharing that you're feeling ${voiceResult.mood}. Mood tracking helps identify patterns related to your cycle phases.";
      }
      return "I can help track your mood throughout your cycle. How are you feeling today?";
    }
    
    if (lowerInput.contains('cycle') || lowerInput.contains('period')) {
      return "I can provide insights about your menstrual cycle, predict upcoming periods, and help track symptoms and patterns. What would you like to know?";
    }
    
    return "I'm here to help with cycle tracking, symptom logging, mood monitoring, and health insights. Feel free to ask me anything about your reproductive health!";
  }

  void _showFullAssistant() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SmartVoiceAssistant(
          isFloating: false,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }
}

/// Text input dialog for manual message entry
class _TextInputDialog extends StatefulWidget {
  final Function(String) onSend;

  const _TextInputDialog({required this.onSend});

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Type your message'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Ask me anything about your health...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        textCapitalization: TextCapitalization.sentences,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSend(_controller.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Send'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Data model for conversation messages
class ConversationMessage {
  final String text;
  final bool isAssistant;
  final DateTime timestamp;
  final List<String>? insights;

  ConversationMessage({
    required this.text,
    required this.isAssistant,
    required this.timestamp,
    this.insights,
  });
}
