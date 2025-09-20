class TrainingSession {
  final String id;
  final DateTime dateTime;
  final String branchId;
  final String coachId;
  final List<String> signedUpChildIds;
  final int maxParticipants;

  TrainingSession({
    required this.id,
    required this.dateTime,
    required this.branchId,
    required this.coachId,
    required this.signedUpChildIds,
    required this.maxParticipants,
  });
}
