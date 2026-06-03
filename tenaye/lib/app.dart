import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/bottom_nav_bar.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

class TenayeAppWorkspace extends StatefulWidget {
  const TenayeAppWorkspace({super.key});

  @override
  State<TenayeAppWorkspace> createState() => _TenayeAppWorkspaceState();
}

class _TenayeAppWorkspaceState extends State<TenayeAppWorkspace> {
  int _currentIndex = 0;

  void _onNavigationTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> featureScreens = [
      const DashboardScreen(),
      const Scaffold(body: Center(child: Text("Health Vitals Tracking Module Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("Meds Scheduler Module Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("Mood & Wellness Tracker Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("AI Nutrition Planner Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("AI Fitness Planner Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("High-Stakes Emergency SOS Ready", style: TextStyle(color: AppColors.textPrimary)))),
      const Scaffold(body: Center(child: Text("User Health Profile Setup Ready", style: TextStyle(color: AppColors.textPrimary)))),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: featureScreens,
      ),
      bottomNavigationBar: TenayeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTabTapped,
      ),
    );
  }
}
