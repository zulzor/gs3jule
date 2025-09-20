import '../models/attendance_model.dart';
import 'package:flutter/foundation.dart';

class AttendanceService {
  final List<Attendance> _attendanceRecords = [];

  Future<void> createAttendanceRecord({
    required String trainingId,
    required String childId,
    required bool wasPresent,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final record = Attendance(
      id: '${trainingId}_${childId}', // Simple unique ID for mock
      trainingId: trainingId,
      childId: childId,
      wasPresent: wasPresent,
      confirmationDate: DateTime.now(),
    );
    _attendanceRecords.add(record);
    if (kDebugMode) {
      print('Attendance recorded: ${record.id}, Present: ${record.wasPresent}');
    }
  }

  Future<List<Attendance>> getAttendanceForTraining(String trainingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _attendanceRecords.where((r) => r.trainingId == trainingId).toList();
  }
}
