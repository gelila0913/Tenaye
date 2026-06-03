import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../emergency_sos/presentation/screens/sos_active_screen.dart';
import '../../../health_tracking/data/services/health_tracking_service.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row containing greeting details and action targets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Good afternoon,", style: AppTextStyles.greetingSub),
                    const SizedBox(height: 4),
                    const Text("Gelila 👋", style: AppTextStyles.greetingName),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo_white.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        const Text("ጤናዬ — Your Health Companion", style: AppTextStyles.amharicSubtitle),
                      ],
                    ),
                  ],
                ),
              ),
              // Enlarged Sudden danger instant SOS trigger badge
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emergencyRed.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: IconButton(
                  icon: const Icon(Icons.warning_amber_rounded, color: AppColors.textLight, size: 30),
                  tooltip: 'Emergency SOS',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SosScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Horizontal inline vitals tracker panel segment row
          ValueListenableBuilder<List<HealthRecord>>(
            valueListenable: HealthTrackingService().recordsNotifier,
            builder: (context, records, child) {
              String getLatestValue(String type, String unit) {
                final match = records.lastWhere(
                  (r) => r.type == type,
                  orElse: () => HealthRecord(type: type, displayValue: "—", timestamp: ""),
                );
                if (match.displayValue == "—") return "—";
                // Strip the unit suffix to display only the raw values on the dashboard vital chips
                return match.displayValue.replaceAll(" $unit", "");
              }

              return Row(
                children: [
                  Expanded(child: _buildVitalChip("Blood Pressure", getLatestValue("Blood Pressure", "mmHg"), "mmHg")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildVitalChip("Glucose", getLatestValue("Blood Glucose", "mg/dL"), "mg/dL")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildVitalChip("Weight", getLatestValue("Weight", "kg"), "kg")),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVitalChip(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label, 
            style: AppTextStyles.vitalLabel.copyWith(
              color: AppColors.textLight.withValues(alpha: 0.8),
            ), 
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value, 
            style: AppTextStyles.vitalValuePlaceholder.copyWith(
              color: AppColors.textLight,
              fontSize: value.length > 6 ? 15 : 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit, 
            style: AppTextStyles.vitalUnit.copyWith(
              color: AppColors.textLight.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
