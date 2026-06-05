import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../emergency_sos/presentation/screens/sos_active_screen.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final String bloodPressure;
  final String glucose;
  final String weight;
  final bool isLoading;

  const GreetingHeader({
    super.key,
    required this.userName,
    required this.bloodPressure,
    required this.glucose,
    required this.weight,
    required this.isLoading,
  });

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
      padding: const EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 16.0),
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
                    Text(
                      userName.isNotEmpty ? "Good afternoon," : "Good afternoon!",
                      style: AppTextStyles.greetingSub,
                    ),
                    if (userName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text("$userName 👋", style: AppTextStyles.greetingName),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                          ),
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
          const SizedBox(height: 20),
          
          // Horizontal inline vitals tracker panel segment row
          Row(
            children: [
              Expanded(child: _buildVitalChip("Blood Pressure", bloodPressure, "mmHg")),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalChip("Glucose", glucose, "mg/dL")),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalChip("Weight", weight, "kg")),
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
          Text(
            label, 
            style: AppTextStyles.vitalLabel.copyWith(
              color: AppColors.textLight.withValues(alpha: 0.8),
            ), 
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
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
