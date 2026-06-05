class ApiConstants {
  // Base URL pointing to Node.js backend on host machine (localhost:3000 mapped to emulator loopback 10.0.2.2)
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Endpoint constants
  static const String profile = '$baseUrl/profile';
  static const String weight = '$baseUrl/weight';
  static const String medications = '$baseUrl/medications';
  static const String mood = '$baseUrl/mood';
  static const String metrics = '$baseUrl/metrics';
  static const String nutrition = '$baseUrl/nutrition';
  static const String fitness = '$baseUrl/fitness';
  static const String chat = '$baseUrl/chat';
}
