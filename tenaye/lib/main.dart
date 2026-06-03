import 'package:flutter/material.dart';
import 'app.dart';
import 'core/theme/app_colors.dart';

void main() {
  // Ensure native bindings are cleanly mapped before building context
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TenayeCoreRoot());
}

class TenayeCoreRoot extends StatelessWidget {
  const TenayeCoreRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenaye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          surface: AppColors.surface,
          brightness: Brightness.light, // Set to Brightness.dark if implementing a complete dark-mode theme override
        ),
      ),
      home: const TenayeAppWorkspace(),
    );
  }
}