import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../data/services/health_tracking_service.dart';
import 'log_measurement_sheet.dart';

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

  @override
  void initState() {
    super.initState();
    // Load measurements dynamically from API on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HealthTrackingService().loadRecords();
    });
  }

  Future<void> _confirmDelete(BuildContext context, HealthRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Measurement', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this ${record.type} log of ${record.displayValue}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await HealthTrackingService().deleteRecord(record.id, record.type);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Measurement deleted successfully.' : 'Failed to delete measurement.'),
            backgroundColor: success ? AppColors.primaryGreen : Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = _categories[_selectedCategoryIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified Brand Header Bar
          TenayeBrandHeader(
            title: 'Health Tracking',
            subtitle: 'Monitor your vitals',
            trailing: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => LogMeasurementModal(
                    initialType: currentCategory,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGreen,
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
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 20),

                  // Content List
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: HealthTrackingService().isLoading,
                      builder: (context, loading, child) {
                        if (loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          );
                        }

                        return ValueListenableBuilder<List<HealthRecord>>(
                          valueListenable: HealthTrackingService().recordsNotifier,
                          builder: (context, records, child) {
                            final filteredRecords = records
                                .where((record) => record.type == currentCategory)
                                .toList();

                            if (filteredRecords.isNotEmpty) {
                              return ListView.builder(
                                itemCount: filteredRecords.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final record = filteredRecords[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
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
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  record.displayValue,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                    letterSpacing: -0.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  record.timestamp,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                                                  ),
                                                ),
                                                if (record.notes != null && record.notes!.isNotEmpty) ...[
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Notes: ${record.notes}",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontStyle: FontStyle.italic,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 20),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) => LogMeasurementModal(
                                                      initialType: currentCategory,
                                                      record: record,
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                                onPressed: () => _confirmDelete(context, record),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.show_chart_rounded,
                                      size: 72,
                                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No records found. Tap + Log to add one.',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
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
