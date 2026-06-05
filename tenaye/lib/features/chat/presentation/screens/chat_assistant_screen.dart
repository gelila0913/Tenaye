import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../services/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({super.key});

  @override
  State<ChatAssistantScreen> createState() => _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiClient _apiClient = ApiClient();

  bool _isTyping = false;
  final String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';

  // Chat message list: maps with role ('user' | 'ai') and content
  final List<Map<String, String>> _messages = [];

  // Suggestion prompt strings
  final List<String> _suggestions = [
    'What should I eat for diabetes?',
    'Create a morning workout for me',
    'How do I lower my blood pressure?',
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Automatically animate to the bottom of the list when new messages are added
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Send user message to the Gemini API layer and append AI response
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isTyping = true;
    });
    _chatController.clear();
    _scrollToBottom();

    try {
      final payload = {
        'userId': _userId,
        'message': text,
      };

      // POST /api/chat
      final response = await _apiClient.post(ApiConstants.chat, payload);

      if (response != null && response['success'] == true) {
        final reply = response['data']['reply']?.toString() ?? 'No reply received.';
        setState(() {
          _messages.add({'role': 'ai', 'content': reply});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'ai',
            'content': 'Sorry, I had trouble processing that request. Please try again.',
          });
        });
      }
    } on ApiException catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'content': 'Connection error: ${e.message}',
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'content': 'An unexpected error occurred. Please check your connection and try again.',
        });
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Solid Top Brand Header Panel
          TenayeBrandHeader(
            title: 'AI Assistant',
            subtitle: 'Your personal health companion',
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.android_rounded, color: Colors.white, size: 22),
            ),
          ),

          // 2. Main Chat Container
          Expanded(
            child: _messages.isEmpty ? _buildWelcomeView() : _buildChatListView(),
          ),

          // 3. Floating Input Message Command Bar Deck
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 28.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                    onSubmitted: (val) => _sendMessage(val),
                    decoration: InputDecoration(
                      hintText: 'Ask your health assistant...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      filled: true,
                      fillColor: AppColors.background.withValues(alpha: 0.5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: AppColors.primaryGreen),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Circular Send Trigger Button Block
                GestureDetector(
                  onTap: () {
                    final text = _chatController.text.trim();
                    _sendMessage(text);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Welcome View displayed when there is no chat history
  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Centered Assistant Identity Hub Badge
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
            child: const Icon(Icons.android_rounded, color: AppColors.primaryGreen, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            "Hello! I'm your health assistant.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ask me about nutrition, fitness, medications, or any health concerns.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 36),

          // Quick Tap Suggestion Action Array
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.4),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    _sendMessage(_suggestions[index]);
                  },
                  leading: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  title: Text(
                    _suggestions[index],
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textSecondary,
                    size: 14,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Message List View displaying the chat history and typing indicator
  Widget _buildChatListView() {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  /// Chat bubble widget separating user and AI roles visually
  Widget _buildMessageBubble(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: Radius.circular(isUser ? 16.0 : 4.0),
            bottomRight: Radius.circular(isUser ? 4.0 : 16.0),
          ),
          border: Border.all(
            color: isUser ? Colors.transparent : AppColors.border.withValues(alpha: 0.4),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          msg['content'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  /// Visual indicator widget representing active AI generating states
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(16.0),
          ),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Tenaye is typing...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}