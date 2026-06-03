import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController _foodController = TextEditingController();
  bool _isPlanGenerated = false;

  // Track state for each expandable meal card item
  final Map<String, bool> _expandedMeals = {
    'Breakfast': true, // Expanded by default to show local foods detail
    'Morning Snack': false,
    'Lunch': false,
    'Afternoon Snack': false,
    'Dinner': false,
  };

  @override
  void dispose() {
    _foodController.dispose();
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
            title: 'Nutrition Planner',
            subtitle: 'AI-powered personalized meal plans',
          ),

          // Main Scroll Content Engine
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  // Persistent Form Input Box Container
                  _buildInputFormCard(),
                  const SizedBox(height: 20),

                  // Conditionally swap view states based on generation trigger toggle
                  if (_isPlanGenerated) ...[
                    _buildCalorieTargetCard(),
                    const SizedBox(height: 16),
                    _buildMealScheduleTimeline(),
                    const SizedBox(height: 16),
                    _buildNutritionTipsCard(),
                    const SizedBox(height: 24),
                  ] else ...[
                    // Empty state placeholder indicator setup
                    const SizedBox(height: 60),
                    Icon(
                      Icons.restaurant_menu_rounded,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter ingredients to build your meal plan',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Available Ingredients Intake Form Component (image_d9d318.png / image_93e7e9.png)
  Widget _buildInputFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available foods (optional)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _foodController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'e.g., rice, lentils, spinach, eggs...',
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isPlanGenerated = true;
                });
              },
              icon: Icon(
                _isPlanGenerated ? Icons.refresh_rounded : Icons.restaurant_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                _isPlanGenerated ? 'Regenerate Plan' : 'Generate Meal Plan',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Calorie Metric Tracker Banner Component (image_93e7e9.png)
  Widget _buildCalorieTargetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        children: const [
          Text(
            'Daily Target',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '2200',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'calories',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Widget: Map Iteration over Schedule Options Loop (image_93e7c8.png / image_93e502.png)
  Widget _buildMealScheduleTimeline() {
    return Column(
      children: [
        _buildMealCard('Breakfast', '8:00 AM', '600 cal', isBreakfast: true),
        const SizedBox(height: 12),
        _buildMealCard('Morning Snack', '10:30 AM', '600 cal'),
        const SizedBox(height: 12),
        _buildMealCard('Lunch', '1:00 PM', '700 cal'),
        const SizedBox(height: 12),
        _buildMealCard('Afternoon Snack', '4:00 PM', '250 cal'),
        const SizedBox(height: 12),
        _buildMealCard('Dinner', '7:00 PM', '550 cal'),
      ],
    );
  }

  // Widget: Expandable Meal Item Row Component Builder (image_93e4c6.png)
  Widget _buildMealCard(String mealTitle, String time, String calories, {bool isBreakfast = false}) {
    bool isExpanded = _expandedMeals[mealTitle] ?? false;

    IconData getMealIcon() {
      if (mealTitle.contains('Breakfast')) return Icons.wb_twighlight;
      if (mealTitle.contains('Snack')) return Icons.apple_rounded;
      return Icons.wb_sunny_rounded;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expandedMeals[mealTitle] = !isExpanded;
              });
            },
            leading: Icon(getMealIcon(), color: Colors.orangeAccent, size: 24),
            title: Text(
              mealTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Text(
              '$time · $calories',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ),

          if (isExpanded && isBreakfast)
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  
                  _buildSubSectionHeader('FOODS'),
                  _buildBulletPointItem('2 Injera'),
                  _buildBulletPointItem('1 avocado (100g)'),
                  _buildBulletPointItem('100g grilled chicken breast'),
                  _buildBulletPointItem('1 small banana'),
                  _buildBulletPointItem('1 cup herbal tea'),
                  const SizedBox(height: 16),

                  _buildSubSectionHeader('NUTRIENTS'),
                  const Text(
                    'Protein: 38g, Carbohydrates: 67g, Fats: 25g',
                    style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),

                  _buildSubSectionHeader('PREPARATION'),
                  const Text(
                    'Serve grilled chicken sliced on top of the injera, add sliced avocado, and enjoy with a banana and herbal tea.',
                    style: TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
                  ),
                ],
              ),
            )
          else if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
              child: Text(
                'Balanced healthy choice instructions tailored to $mealTitle setup template rules.',
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Nutrition Tips',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipListItem('Ensure adequate hydration by drinking at least 2 liters of water per day.'),
          _buildTipListItem('Incorporate strength training exercises at least 3 times a week to aid muscle gain.'),
          _buildTipListItem('Practice relaxation techniques like deep breathing or meditation to help with stress reduction.'),
          _buildTipListItem('Aim for consistent sleep patterns by going to bed and waking up at regular times.'),
        ],
      ),
    );
  }

  Widget _buildSubSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildBulletPointItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildTipListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.3))),
        ],
      ),
    );
  }
}