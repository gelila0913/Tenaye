import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'features/health_tracking/presentation/screens/health_tracking_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.background,
      ),
      // Set the home property directly to your upgraded Health Tracking Screen to test it instantly!
      home: const HealthTrackingScreen(),
    );
  }
}