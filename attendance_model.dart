class Attendance {
  final String id;
  final String trainingId;
  final String childId;
  final bool wasPresent; // Confirmed by the coach
  final DateTime? confirmationDate;

  Attendance({
    required this.id,
    required this.trainingId,
    required this.childId,
    required this.wasPresent,
    this.confirmationDate,
  });
}
