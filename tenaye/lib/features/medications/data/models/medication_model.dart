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
}
