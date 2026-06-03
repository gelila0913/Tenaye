import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/bottom_nav_bar.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/health_tracking/presentation/screens/health_tracking_screen.dart';
import 'features/medications/presentation/screens/medications_screen.dart';

// Newly added feature imports
import 'features/mood_wellness/presentation/screens/mood_wellness_screen.dart';
import 'features/nutrition/presentation/screens/nutrition_screen.dart';
import 'features/fitness/presentation/screens/fitness_screen.dart';
import 'features/emergency_sos/presentation/screens/sos_active_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

// Medication service imports
import 'features/medications/data/models/medication_model.dart';
import 'features/medications/data/services/medication_service.dart';

// Navigation controller import
import 'core/utils/tab_navigation_controller.dart';

class TenayeAppWorkspace extends StatefulWidget {
  const TenayeAppWorkspace({super.key});

  @override
  State<TenayeAppWorkspace> createState() => _TenayeAppWorkspaceState();
}

class _TenayeAppWorkspaceState extends State<TenayeAppWorkspace> {
  @override
  void initState() {
    super.initState();
    
    // Initialize Medication Alarm Check Service
    final medService = MedicationService();
    medService.startAlarmCheckService();
    medService.onAlarmTriggered = (medication, scheduledTime) {
      _showAlarmDialog(medication, scheduledTime);
    };
  }

  @override
  void dispose() {
    MedicationService().stopAlarmCheckService();
    super.dispose();
  }

  void _showAlarmDialog(Medication medication, String scheduledTime) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(Icons.alarm_on_rounded, color: AppColors.primaryGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'ጤናዬ Reminder',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'It is time to take your medication:',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dosage: ${medication.dosage}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    if (medication.notes != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Note: ${medication.notes!}',
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Scheduled for: $scheduledTime',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Dismiss', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Mark as Taken', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Marked ${medication.name} as taken.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> featureScreens = [
      const DashboardScreen(),
      const HealthTrackingScreen(),
      const MedicationsScreen(), 
      const MoodScreen(),
      const NutritionScreen(),
      const FitnessScreen(),
      const SosScreen(),
      const ProfileScreen(),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: TabNavigationController.selectedIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: currentIndex,
            children: featureScreens,
          ),
          bottomNavigationBar: TenayeBottomNavBar(
            currentIndex: currentIndex,
            onTap: TabNavigationController.changeTab,
          ),
        );
      },
    );
  }
}