import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'log_measurement_sheet.dart';

// Simple lightweight local model to represent logged vital entries
class HealthRecord {
  final String type;
  final String displayValue;
  final String timestamp;

  HealthRecord({
    required this.type,
    required this.displayValue,
    required this.timestamp,
  });
}

class HealthTrackingScreen extends StatefulWidget {
  const HealthTrackingScreen({super.key});

  @override
  State<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Blood Pressure',
    'Blood Glucose',
    'Weight',
    'Heart Rate',
    'Water Intake',  
    'Oxygen Level',  
    'Temperature'
  ];

  // In-memory mock list simulating database records matching image_e7f97b.png
  final List<HealthRecord> _loggedRecords = [
    HealthRecord(
      type: 'Blood Pressure',
      displayValue: '120/80 mmHg',
      timestamp: 'Jun 3, 1:18 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentCategory = _categories[_selectedCategoryIndex];

    // Filter down records belonging strictly to the currently selected horizontal category pill
    // (If 'Vitals' is picked, we show everything as an aggregate view)
    final filteredRecords = currentCategory == 'Vitals'
        ? _loggedRecords
        : _loggedRecords.where((record) => record.type == currentCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row Block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Tracking',
                        style: AppTextStyles.mainTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Monitor your vitals',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                  
                  // "+ Log" Action Button Action Router
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => LogMeasurementModal(
                          initialType: currentCategory == 'Vitals'
                              ? 'Blood Pressure'
                              : currentCategory,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: AppColors.textLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Log',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Horizontal Category Filter Pills Navigation Bar
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.border.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.textLight
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Content Swapper: Flips between dynamic ListView Cards and Empty Placeholder Illustration
              Expanded(
                child: filteredRecords.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredRecords.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final record = filteredRecords[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: AppColors.surface, // Clean crisp white card layout block
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: AppColors.border.withValues(alpha: 0.4),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Metric measurement readout text string value label
                                  Text(
                                    record.displayValue,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  // Timestamp context info block formatted on right edge boundary
                                  Text(
                                    record.timestamp,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.show_chart_rounded,
                              size: 72,
                              color: AppColors.textSecondary.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No measurements yet',
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
