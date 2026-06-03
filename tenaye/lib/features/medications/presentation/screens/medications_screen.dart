import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../data/models/medication_model.dart';
import '../../data/services/medication_service.dart';
import '../widgets/add_medication_modal.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<List<Medication>>(
        valueListenable: MedicationService().medicationsNotifier,
        builder: (context, medications, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unified Brand Header Bar
              TenayeBrandHeader(
                title: 'Medications',
                subtitle: '${medications.length} active medication${medications.length == 1 ? "" : "s"}',
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AddMedicationModal(),
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
                    'Add',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Content Section: Grid of Cards vs Empty State
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: medications.isNotEmpty
                      ? ListView.builder(
                          itemCount: medications.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildMedicationCard(context, medications[index]);
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Elegant tilted pill outline icon
                              Transform.rotate(
                                angle: -0.7,
                                child: Icon(
                                  Icons.local_pharmacy,
                                  size: 68,
                                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                                ),
                               ),
                              const SizedBox(height: 20),
                              const Text(
                                'No active medications',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medication med) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${med.dosage} · ${med.frequency}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      med.isAlarmSet ? Icons.alarm_on_rounded : Icons.alarm_off_rounded,
                      color: med.isAlarmSet ? AppColors.primaryGreen : AppColors.textSecondary,
                    ),
                    tooltip: med.isAlarmSet ? 'Alarm Enabled' : 'Alarm Disabled',
                    onPressed: () => MedicationService().toggleAlarm(med.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.emergencyRed),
                    tooltip: 'Delete Medication',
                    onPressed: () {
                      MedicationService().removeMedication(med.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Times Wrap
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: med.times.map((time) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          // Optional Notes
          if (med.notes != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                med.notes!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}