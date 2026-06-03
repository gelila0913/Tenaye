import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({Key? key}) : super(key: key);

  @override
  State<ChatAssistantScreen> createState() => _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  final TextEditingController _chatController = TextEditingController();

  // Suggestion prompt strings from image_945582.png
  final List<String> _suggestions = [
    'What should I eat for diabetes?',
    'Create a morning workout for me',
    'How do I lower my blood pressure?',
  ];

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
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

          // 2. Main Conversational Context Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Centered Assistant Identity Hub Badge
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
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

                  // 3. Quick Tap Suggestion Action Array
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
                            color: AppColors.border.withOpacity(0.4),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            _chatController.text = _suggestions[index];
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
            ),
          ),

          // 4. Floating Input Message Command Bar Deck
          Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 28.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Ask your health assistant...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      filled: true,
                      fillColor: AppColors.background.withOpacity(0.5),
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
                    if (_chatController.text.trim().isNotEmpty) {
                      _chatController.clear();
                    }
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
}