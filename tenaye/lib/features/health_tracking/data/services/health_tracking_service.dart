import 'package:flutter/foundation.dart';

class HealthRecord {
  final String type;
  final String displayValue;
  final String timestamp;

  HealthRecord({
    required this.type,
    required this.displayValue,
    required this.timestamp,
  });
}

class HealthTrackingService {
  static final HealthTrackingService _instance = HealthTrackingService._internal();
  factory HealthTrackingService() => _instance;
  HealthTrackingService._internal();

  final List<HealthRecord> _records = [
    HealthRecord(
      type: 'Blood Pressure',
      displayValue: '120/80 mmHg',
      timestamp: 'Jun 3, 1:18 PM',
    ),
  ];

  late final ValueNotifier<List<HealthRecord>> recordsNotifier = 
      ValueNotifier<List<HealthRecord>>(List.from(_records));

  List<HealthRecord> get records => List.unmodifiable(_records);

  void addRecord(String type, String value, {String? diastolic}) {
    String displayValue = value;
    if (type == 'Blood Pressure') {
      displayValue = "$value/${diastolic ?? '80'} mmHg";
    } else if (type == 'Blood Glucose') {
      displayValue = "$value mg/dL";
    } else if (type == 'Weight') {
      displayValue = "$value kg";
    } else if (type == 'Heart Rate') {
      displayValue = "$value bpm";
    } else if (type == 'Water Intake') {
      displayValue = "$value mL";
    } else if (type == 'Oxygen Level') {
      displayValue = "$value%";
    } else if (type == 'Temperature') {
      displayValue = "$value °C";
    }

    final now = DateTime.now();
    final months = ['Jun', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    // Safety check for month bounds
    final monthStr = (now.month >= 1 && now.month <= 12) ? months[now.month - 1] : 'Jun';
    
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final hour = now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final formattedTime = "$monthStr ${now.day}, $hour:$minute $period";

    final newRecord = HealthRecord(
      type: type,
      displayValue: displayValue,
      timestamp: formattedTime,
    );

    _records.add(newRecord);
    recordsNotifier.value = List.from(_records);
  }
}
