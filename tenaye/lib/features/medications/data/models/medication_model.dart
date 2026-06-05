import 'dart:convert';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times; // Format: ["08:00", "20:00"]
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;
  bool isAlarmSet;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    this.startDate,
    this.endDate,
    this.notes,
    this.isAlarmSet = true,
  });

  // Helper to check if a specific time is scheduled
  bool hasAlarmAt(String timeString) {
    return isAlarmSet && times.contains(timeString);
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    // Backend returns times as either list of dynamic or stringified array
    List<String> parsedTimes = [];
    if (json['times'] != null) {
      if (json['times'] is List) {
        parsedTimes = List<String>.from(json['times'] as List);
      } else if (json['times'] is String) {
        try {
          final decoded = jsonDecode(json['times'] as String);
          if (decoded is List) {
            parsedTimes = List<String>.from(decoded);
          }
        } catch (_) {
          parsedTimes = [json['times'] as String];
        }
      }
    }

    return Medication(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      times: parsedTimes,
      startDate: json['startDate'] != null 
          ? DateTime.tryParse(json['startDate'] as String) 
          : null,
      endDate: json['endDate'] != null 
          ? DateTime.tryParse(json['endDate'] as String) 
          : null,
      notes: json['notes'] as String?,
      isAlarmSet: true, // Default local UI state
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': times,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
    };
  }
}

