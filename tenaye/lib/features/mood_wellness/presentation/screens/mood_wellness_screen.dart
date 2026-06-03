import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String _selectedMood = 'Okay';
  double _energyLevel = 3.0;
  double _stressLevel = 2.0;
  int _sleepHours = 7;
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _moodEmojis = [
    {'emoji': '😁', 'label': 'Great'},
    {'emoji': '😊', 'label': 'Good'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '😔', 'label': 'Bad'},
    {'emoji': '😢', 'label': 'Terrible'},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified Brand Header Bar
          const TenayeBrandHeader(
            title: 'Mood & Wellness',
            subtitle: 'Track how you feel each day',
          ),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Questionnaire Wrapper Block
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.border.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'How are you feeling today?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Emojis Horizontal Builder Grid Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _moodEmojis.map((item) {
                            final isSelected = _selectedMood == item['label'];
                            return GestureDetector(
                              onTap: () => setState(() => _selectedMood = item['label']!),
                              child: Column(
                                children: [
                                  Text(item['emoji']!, style: TextStyle(fontSize: isSelected ? 38 : 30)),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['label']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Energy Metrics Slider Group
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Energy Level: ${_energyLevel.toInt()}/5', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ],
                        ),
                        Slider(
                          value: _energyLevel,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: AppColors.primaryGreen,
                          inactiveColor: AppColors.primaryGreen.withOpacity(0.15),
                          onChanged: (val) => setState(() => _energyLevel = val),
                        ),
                        const SizedBox(height: 16),

                        // Stress Metrics Slider Group
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Stress Level: ${_stressLevel.toInt()}/5', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ],
                        ),
                        Slider(
                          value: _stressLevel,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          activeColor: AppColors.primaryGreen,
                          inactiveColor: AppColors.primaryGreen.withOpacity(0.15),
                          onChanged: (val) => setState(() => _stressLevel = val),
                        ),
                        const SizedBox(height: 16),

                        // Sleep Numeric Selector Counter
                        const Text('Sleep Hours', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$_sleepHours', style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _sleepHours++),
                                    child: const Icon(Icons.keyboard_arrow_up, size: 18, color: AppColors.textSecondary),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _sleepHours > 0 ? _sleepHours-- : null),
                                    child: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Optional Notes Field Group
                        const Text('Notes (optional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notesController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Anything on your mind...',
                            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            contentPadding: const EdgeInsets.all(14.0),
                            filled: true,
                            fillColor: AppColors.background.withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: AppColors.primaryGreen),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Primary Form Submission Trigger button block
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: AppColors.textLight,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                            child: const Text('Log Mood', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Recent Entries Title Separator Segment Block
                  const Text(
                    'RECENT ENTRIES',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 24),

                  // Center Heart Empty Container matching layout frame placeholder
                  Center(
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}