import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../services/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class HealthRecord {
  final String id;
  final String type;
  final String displayValue;
  final String timestamp;
  final DateTime createdAt;
  final String? value;
  final String? notes;
  final String? photoUrl;

  HealthRecord({
    required this.id,
    required this.type,
    required this.displayValue,
    required this.timestamp,
    required this.createdAt,
    this.value,
    this.notes,
    this.photoUrl,
  });
}

class HealthTrackingService {
  static final HealthTrackingService _instance = HealthTrackingService._internal();
  factory HealthTrackingService() => _instance;
  HealthTrackingService._internal();

  final ApiClient _apiClient = ApiClient();
  final String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';

  final List<HealthRecord> _records = [];

  late final ValueNotifier<List<HealthRecord>> recordsNotifier = 
      ValueNotifier<List<HealthRecord>>([]);

  late final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  List<HealthRecord> get records => List.unmodifiable(_records);

  String _formatIsoTimestamp(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final monthStr = months[dateTime.month - 1];
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return "$monthStr ${dateTime.day}, $hour:$minute $period";
    } catch (e) {
      return isoString;
    }
  }

  String _getDisplayValue(String type, String value) {
    if (type == 'Blood Pressure') {
      return "$value mmHg";
    } else if (type == 'Blood Glucose') {
      return "$value mg/dL";
    } else if (type == 'Weight') {
      return "$value kg";
    } else if (type == 'Heart Rate') {
      return "$value bpm";
    } else if (type == 'Water Intake') {
      return "$value mL";
    } else if (type == 'Oxygen Level') {
      return "$value%";
    } else if (type == 'Temperature') {
      return "$value °C";
    }
    return value;
  }

  /// Load health measurements & weight history from API
  Future<void> loadRecords() async {
    isLoading.value = true;
    _records.clear();
    try {
      // Fetch concurrently
      final responses = await Future.wait([
        _apiClient.get('${ApiConstants.baseUrl}/metrics/history/$_userId'),
        _apiClient.get('${ApiConstants.baseUrl}/weight/history/$_userId'),
      ]);

      final metricsResponse = responses[0];
      final weightResponse = responses[1];

      // Parse health measurements
      if (metricsResponse != null && metricsResponse['success'] == true) {
        final groupedData = metricsResponse['data'] as Map<String, dynamic>? ?? {};
        groupedData.forEach((type, list) {
          if (list is List) {
            for (var item in list) {
              final id = item['id']?.toString() ?? '';
              final val = item['value']?.toString() ?? '';
              final notes = item['notes']?.toString();
              final createdAtStr = item['createdAt']?.toString() ?? '';
              final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
              _records.add(
                HealthRecord(
                  id: id,
                  type: type,
                  displayValue: _getDisplayValue(type, val),
                  timestamp: _formatIsoTimestamp(createdAtStr),
                  createdAt: createdAt,
                  value: val,
                  notes: notes,
                ),
              );
            }
          }
        });
      }

      // Parse weight logs
      if (weightResponse != null && weightResponse['success'] == true) {
        final list = weightResponse['data'] as List? ?? [];
        for (var item in list) {
          final id = item['id']?.toString() ?? '';
          final val = item['weight']?.toString() ?? '';
          final photoUrl = item['photoUrl']?.toString();
          final createdAtStr = item['createdAt']?.toString() ?? '';
          final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
          _records.add(
            HealthRecord(
              id: id,
              type: 'Weight',
              displayValue: _getDisplayValue('Weight', val),
              timestamp: _formatIsoTimestamp(createdAtStr),
              createdAt: createdAt,
              value: val,
              photoUrl: photoUrl,
            ),
          );
        }
      }

      // Sort combined records chronologically descending (newest first)
      _records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
    } catch (e) {
      debugPrint('Error loading health records: $e');
    } finally {
      recordsNotifier.value = List.from(_records);
      isLoading.value = false;
    }
  }

  /// Log a new measurement to the backend
  Future<bool> addRecord(
    String type,
    String value, {
    String? diastolic,
    XFile? image,
    String? notes,
  }) async {
    try {
      if (type == 'Weight') {
        if (image != null) {
          final fields = {
            'userId': _userId,
            'weight': value,
          };
          final file = File(image.path);
          await _apiClient.postMultipart(
            '${ApiConstants.baseUrl}/weight/log',
            fields,
            fileKey: 'photo',
            file: file,
          );
        } else {
          await _apiClient.post(
            '${ApiConstants.baseUrl}/weight/log',
            {
              'userId': _userId,
              'weight': value,
            },
          );
        }
      } else {
        String finalValue = value;
        if (type == 'Blood Pressure') {
          finalValue = "$value/${diastolic ?? '80'}";
        }
        await _apiClient.post(
          '${ApiConstants.baseUrl}/metrics/log',
          {
            'userId': _userId,
            'type': type,
            'value': finalValue,
            'notes': notes,
          },
        );
      }
      
      // Reload history to update UI state
      await loadRecords();
      return true;
    } catch (e) {
      debugPrint('Error saving record: $e');
      return false;
    }
  }

  /// Update an existing measurement in the backend
  Future<bool> editRecord(
    String id,
    String type,
    String value, {
    String? diastolic,
    String? notes,
  }) async {
    try {
      if (type == 'Weight') {
        await _apiClient.put(
          '${ApiConstants.baseUrl}/weight/$id',
          {
            'weight': value,
          },
        );
      } else {
        String finalValue = value;
        if (type == 'Blood Pressure') {
          finalValue = "$value/${diastolic ?? '80'}";
        }
        await _apiClient.put(
          '${ApiConstants.baseUrl}/metrics/$id',
          {
            'value': finalValue,
            'notes': notes,
          },
        );
      }

      // Reload history to update UI state
      await loadRecords();
      return true;
    } catch (e) {
      debugPrint('Error editing record: $e');
      return false;
    }
  }

  /// Delete a measurement from the backend
  Future<bool> deleteRecord(String id, String type) async {
    try {
      if (type == 'Weight') {
        await _apiClient.delete(
          '${ApiConstants.baseUrl}/weight/$id',
        );
      } else {
        await _apiClient.delete(
          '${ApiConstants.baseUrl}/metrics/$id',
        );
      }

      // Locally remove the item immediately from the notifier to reflect instantly
      _records.removeWhere((rec) => rec.id == id);
      recordsNotifier.value = List.from(_records);
      return true;
    } catch (e) {
      debugPrint('Error deleting record: $e');
      return false;
    }
  }
}
