import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/medication_model.dart';

class MedicationService {
  // Singleton pattern
  static final MedicationService _instance = MedicationService._internal();
  factory MedicationService() => _instance;
  MedicationService._internal();

  // Internal storage
  final List<Medication> _medications = [];

  // Public ValueNotifier to broadcast changes to the UI
  final ValueNotifier<List<Medication>> medicationsNotifier = ValueNotifier<List<Medication>>([]);

  // Alarm Callback hooks
  void Function(Medication medication, String scheduledTime)? onAlarmTriggered;

  // Background timer to monitor time matches
  Timer? _alarmTimer;

  // Set to keep track of already triggered alarms today to avoid duplicates in the same minute
  // Format of key: "medId-time-dayOfYear"
  final Set<String> _triggeredAlarms = {};

  List<Medication> get medications => List.unmodifiable(_medications);

  void addMedication(Medication medication) {
    _medications.add(medication);
    _notifyListeners();
  }

  void removeMedication(String id) {
    _medications.removeWhere((med) => med.id == id);
    _notifyListeners();
  }

  void toggleAlarm(String id) {
    final index = _medications.indexWhere((med) => med.id == id);
    if (index != -1) {
      _medications[index].isAlarmSet = !_medications[index].isAlarmSet;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    medicationsNotifier.value = List.from(_medications);
  }

  // Starts the background checker for alarms
  void startAlarmCheckService() {
    _alarmTimer?.cancel();
    // Check every 10 seconds for precise minute matching without heavy CPU usage
    _alarmTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkAlarms();
    });
  }

  void stopAlarmCheckService() {
    _alarmTimer?.cancel();
    _alarmTimer = null;
  }

  void _checkAlarms() {
    if (onAlarmTriggered == null) return;

    final now = DateTime.now();
    // Format hour and minute as "HH:mm" (e.g. "08:00", "20:00")
    final currentHour = now.hour.toString().padLeft(2, '0');
    final currentMinute = now.minute.toString().padLeft(2, '0');
    final currentTimeString = "$currentHour:$currentMinute";
    final dayKey = "${now.year}-${now.month}-${now.day}";

    for (final med in _medications) {
      if (!med.isAlarmSet) continue;

      // Check dates if present
      if (med.startDate != null && now.isBefore(med.startDate!)) continue;
      if (med.endDate != null && now.isAfter(med.endDate!.add(const Duration(days: 1)))) continue;

      for (final scheduledTime in med.times) {
        // Simple sanitization: clean white spaces
        final cleanedScheduledTime = scheduledTime.trim();

        if (cleanedScheduledTime == currentTimeString) {
          final alarmKey = "${med.id}-$cleanedScheduledTime-$dayKey";
          if (!_triggeredAlarms.contains(alarmKey)) {
            _triggeredAlarms.add(alarmKey);
            // Trigger the alarm callback
            onAlarmTriggered!(med, cleanedScheduledTime);
          }
        }
      }
    }
  }
}
