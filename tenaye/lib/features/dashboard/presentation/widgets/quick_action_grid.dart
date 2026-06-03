import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/tab_navigation_controller.dart';
import '../../../medications/data/models/medication_model.dart';
import '../../../medications/data/services/medication_service.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildActionCard(
          Icons.analytics_outlined,
          "Health",
          "Measurements",
          const Color(0xFFE8F6F3),
          AppColors.primaryGreen,
          onTap: () => TabNavigationController.changeTab(1),
        ),
        ValueListenableBuilder<List<Medication>>(
          valueListenable: MedicationService().medicationsNotifier,
          builder: (context, meds, child) {
            return _buildActionCard(
              Icons.medication_outlined,
              "Meds",
              "${meds.length} active",
              const Color(0xFFEBF5FB),
              Colors.blue,
              onTap: () => TabNavigationController.changeTab(2),
            );
          },
        ),
        _buildActionCard(
          Icons.restaurant_menu_outlined,
          "Nutrition",
          "Meal plan",
          const Color(0xFFFEF5E7),
          AppColors.resolveOrange,
          onTap: () => TabNavigationController.changeTab(4),
        ),
        _buildActionCard(
          Icons.fitness_center_outlined,
          "Fitness",
          "Exercise plan",
          const Color(0xFFF5EEF8),
          Colors.purple,
          onTap: () => TabNavigationController.changeTab(5),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    Color bgIconColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: bgIconColor, borderRadius: BorderRadius.circular(12.0)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.quickActionTitle, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySecondary, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
