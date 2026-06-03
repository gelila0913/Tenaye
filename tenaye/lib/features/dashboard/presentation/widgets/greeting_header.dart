import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Good afternoon,", style: AppTextStyles.greetingSub),
                    SizedBox(height: 4),
                    Text("Gelila 👋", style: AppTextStyles.greetingName),
                    SizedBox(height: 6),
                    Text("ጤናዬ — Your Health Companion", style: AppTextStyles.amharicSubtitle),
                  ],
                ),
              ),
              Row(
                children: [
                  // Quick AI shortcut button block
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.smart_toy_outlined, color: AppColors.textLight),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sudden danger instant SOS trigger badge
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.emergencyRed,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.textLight),
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          // Horizontal inline vitals tracker panel segment row
          Row(
            children: [
              Expanded(child: _buildVitalChip("Blood Pressure", "—", "mmHg")),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalChip("Glucose", "—", "mg/dL")),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalChip("Weight", "—", "kg")),
            ],
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
          Text(label, style: AppTextStyles.vitalLabel.copyWith(color: AppColors.textLight.withValues(alpha: 0.8)), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.vitalValuePlaceholder.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 4),
          Text(unit, style: AppTextStyles.vitalUnit.copyWith(color: AppColors.textLight.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}
