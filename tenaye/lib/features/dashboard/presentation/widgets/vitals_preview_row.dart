import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_action_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Primary Scroll Surface Container
          RefreshIndicator(
            onRefresh: () async {},
            color: AppColors.primaryGreen,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GreetingHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood prompt callout banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.moodAccent.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: AppColors.moodAccent, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("How are you feeling today?", style: AppTextStyles.sectionHeader),
                                    SizedBox(height: 4),
                                    Text("Log your mood", style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.resolveOrange,
                                  side: const BorderSide(color: AppColors.resolveOrange),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                icon: const Icon(Icons.favorite_border, size: 18),
                                label: const Text("Check In", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text("QUICK ACTIONS", style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        const QuickActionGrid(),
                        const SizedBox(height: 80), // Creates bottom spacing safely
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Adjusted Floating AI Copilot position block (brought closer to content grid padding boundary)
          Positioned(
            bottom: 20,
            right: 20, 
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryGreen,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.smart_toy_outlined, color: AppColors.textLight, size: 28),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
