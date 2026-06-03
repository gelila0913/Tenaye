import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // High-visibility Emergency Header (image_d9c71d.png)
              const Text(
                'Emergency SOS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Activate for immediate help',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // SOS Active State Warning Banner (image_d9c71d.png)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.red.withOpacity(0.8), width: 1.5),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SOS ACTIVE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Help is being alerted',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Medical Summary Card Info Segment (image_d9c6da.png)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.border.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MEDICAL SUMMARY',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Emergency Summary: 22-year-old female, AB+ blood type, with no known medical conditions or current medications. She has a milk allergy. Location: 8.7524, 38.9682.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Emergency Contacts List Array Segment (image_d9c6da.png)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.border.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EMERGENCY CONTACTS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sintayehu Demeke',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'father',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        // Action Trigger Dial Button Outlined Variant
                        OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          ),
                          icon: const Icon(Icons.phone_outlined, color: AppColors.primaryGreen, size: 18),
                          label: const Text(
                            'Call',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mark as Resolved Action Interaction Anchor (image_d9c6da.png)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryGreen, size: 20),
                  label: const Text(
                    'Mark as Resolved',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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