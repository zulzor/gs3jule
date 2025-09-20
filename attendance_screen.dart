import 'package:flutter/material.dart';
import '../../models/training_session_model.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/credit_service.dart';
import '../../services/attendance_service.dart';
import 'student_performance_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final TrainingSession session;

  const AttendanceScreen({super.key, required this.session});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final UserService _userService = UserService();
  final CreditService _creditService = CreditService();
  final AttendanceService _attendanceService = AttendanceService();

  late Future<List<User>> _childrenFuture;
  final Map<String, bool> _attendanceState = {}; // Map<childId, isPresent>

  @override
  void initState() {
    super.initState();
    _childrenFuture = _loadChildrenDetails();
  }

  Future<List<User>> _loadChildrenDetails() async {
    final allUsers = await _userService.getUsers();
    final childrenInSession = allUsers
        .where((u) => widget.session.signedUpChildIds.contains(u.id))
        .toList();
    
    // Initialize attendance state
    for (var child in childrenInSession) {
      _attendanceState[child.id] = true; // Default to present
    }
    return childrenInSession;
  }

  Future<void> _confirmAttendance() async {
    for (final entry in _attendanceState.entries) {
      final childId = entry.key;
      final wasPresent = entry.value;

      await _attendanceService.createAttendanceRecord(
        trainingId: widget.session.id,
        childId: childId,
        wasPresent: wasPresent,
      );

      if (wasPresent) {
        await _creditService.deductCredit(childId);
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Посещаемость отмечена.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отметить Посещаемость'),
        subtitle: Text(widget.session.dateTime.toLocal().toString().substring(0, 16)),
      ),
      body: FutureBuilder<List<User>>(
        future: _childrenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('На эту тренировку никто не записан.'));
          }

          final children = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return CheckboxListTile(
                      title: Text(child.name),
                      value: _attendanceState[child.id] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          _attendanceState[child.id] = value!;
                        });
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.assessment_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentPerformanceScreen(student: child),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _confirmAttendance,
                  child: const Text('Подтвердить'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
