enum DisciplineType {
  time,       // e.g., "00:05:30" (hh:mm:ss)
  count,      // e.g., 25 (push-ups)
  percentage, // e.g., 95.5
}

class Discipline {
  final String id;
  final String name;
  final DisciplineType type;
  // Map<StudentId, List<PerformanceRecord>>
  final Map<String, List<Map<String, dynamic>>> performanceData;

  Discipline({
    required this.id,
    required this.name,
    required this.type,
    required this.performanceData,
  });
}

// Example for a performance record inside performanceData:
// {
//   'date': '2024-09-16T10:00:00Z',
//   'value': 30 // or '00:02:15' or 88.0
// }
