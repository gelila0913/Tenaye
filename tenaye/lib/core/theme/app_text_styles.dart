import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Prevent instantiation
  AppTextStyles._();

  // Main Screen Titles (e.g., "Health Tracking", "Mood & Wellness")
  static const TextStyle mainTitle = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Large User Greeting Name (e.g., "Gelila 👋")
  static const TextStyle greetingName = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
    letterSpacing: -0.2,
  );

  // Welcome Time Text (e.g., "Good afternoon,")
  static const TextStyle greetingSub = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // Amharic Subtitle (e.g., "ጤናዬ — Your Health Companion")
  static const TextStyle amharicSubtitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Color(0xE6FFFFFF),
  );

  // Section Headers & Card Titles (e.g., "QUICK ACTIONS", "How are you feeling today?")
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // Subtitles / Action Explanations (e.g., "Log your mood", "Monitor your vitals")
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Vitals Box Measurement Type (e.g., "Blood Pressure", "Glucose")
  static const TextStyle vitalLabel = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Empty State / Placeholder Dash (e.g., "—")
  static const TextStyle vitalValuePlaceholder = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Small Measurement Units (e.g., "mmHg", "mg/dL", "kg")
  static const TextStyle vitalUnit = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Quick Action Grid Titles (e.g., "Health", "Meds", "Nutrition")
  static const TextStyle quickActionTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Emergency SOS Title (e.g., "Emergency SOS", "SOS ACTIVE")
  static const TextStyle emergencyTitle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.emergencyRed,
    letterSpacing: 0.5,
  );

  // Emergency Medical Summary Text Block
  static const TextStyle medicalSummaryBody = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4, // Adds line height for high readability in a crisis
  );

  // Primary Button Text (White text on Green/Red/Orange buttons)
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
}
