import '../models/training_session_model.dart';

class TrainingService {
  final List<TrainingSession> _sessions = [
    TrainingSession(
      id: 'ts1',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      branchId: 'branch1',
      coachId: 'coach1',
      signedUpChildIds: ['child1'],
      maxParticipants: 10,
    ),
    TrainingSession(
      id: 'ts2',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 4)),
      branchId: 'branch2',
      coachId: 'coach1', // Assuming coach can work in multiple branches
      signedUpChildIds: [],
      maxParticipants: 12,
    ),
  ];

  Future<List<TrainingSession>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sessions;
  }

  Future<void> addSession(TrainingSession session) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessions.add(session);
  }

  Future<void> updateSession(TrainingSession session) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
    }
  }

  Future<void> deleteSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessions.removeWhere((s) => s.id == sessionId);
  }

  Future<bool> signUpForSession(String sessionId, String childId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    if (session.signedUpChildIds.length < session.maxParticipants) {
      session.signedUpChildIds.add(childId);
      return true; // Success
    }
    return false; // Full
  }
}
