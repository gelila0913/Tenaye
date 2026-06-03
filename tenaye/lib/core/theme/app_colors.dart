import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Branding (Seen on Dashboard Green Header & Buttons)
  static const Color primaryGreen = Color(0xFF20A382); 
  static const Color primaryGreenDark = Color(0xFF167F65);
  static const Color primaryGreenLight = Color(0xFFE8F6F3); // For soft background cards

  // Emergency & SOS System (High Contrast Alert Colors)
  static const Color emergencyRed = Color(0xFFDC3545);      // SOS Active / Danger button
  static const Color emergencyRedLight = Color(0xFFFDE8E9); // Soft background for active SOS card
  static const Color resolveOrange = Color(0xFFE67E22);     // "Mark as Resolved" button

  // Accent Colors & Wellness States
  static const Color moodAccent = Color(0xFFFDF2E9);        // Soft orange "How are you feeling" container
  static const Color sliderActive = Color(0xFF20A382);      // Active state for sliders
  static const Color sliderInactive = Color(0xFFD6E4E2);    // Inactive track color

  // Neutral Backgrounds & Surfaces
  static const Color background = Color(0xFFF8F9FA);        // Clean, light app background
  static const Color surface = Color(0xFFFFFFFF);           // White card layouts
  static const Color border = Color(0xFFE9ECEF);            // Subtle divider lines

  // Text Hierarchy Colors
  static const Color textPrimary = Color(0xFF212529);       // Main titles and headers
  static const Color textSecondary = Color(0xFF6C757D);     // Subtitles ("Log your mood", "mmHg")
  static const Color textLight = Color(0xFFFFFFFF);         // Text on primary buttons or headers
}