import 'package:flutter/foundation.dart';
import '../../services/api_client.dart';
import '../constants/api_constants.dart';

class ProfileController {
  // Global ValueNotifier to hold UserProfile details
  static final ValueNotifier<Map<String, dynamic>?> profile = ValueNotifier<Map<String, dynamic>?>(null);
  
  // Loading status indicator
  static final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  static const String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';
  static final ApiClient _apiClient = ApiClient();

  /// Parse and format a clean display name from user's email address
  static String get userName {
    final email = profile.value?['email']?.toString() ?? '';
    if (email.isEmpty) return '';
    
    final username = email.split('@').first;
    
    // Custom mapping for known test accounts to make them look nice!
    if (username.toLowerCase().startsWith('gelila')) {
      return 'Gelila';
    }
    if (username.toLowerCase() == 'testuser') {
      return 'Test User';
    }
    
    // Generic fallback: remove numbers/symbols and capitalize
    final cleaned = username.replaceAll(RegExp(r'[0-9_\-\.]'), '');
    if (cleaned.isEmpty) return username;
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }

  /// Query backend user profile API and update state
  static Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get('${ApiConstants.profile}/$_userId');
      if (response != null && response['success'] == true) {
        profile.value = response['data'] as Map<String, dynamic>?;
      }
    } on ApiException catch (e) {
      if (e.statusCode != 404) {
        debugPrint('Failed to load profile: ${e.message}');
      } else {
        profile.value = null;
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      profile.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update the local profile cache directly
  static void setProfile(Map<String, dynamic> data) {
    profile.value = data;
  }
}
