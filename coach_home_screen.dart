import 'package/flutter/material.dart';
import '../models/user_model.dart';
import '../models/training_session_model.dart';
import '../services/training_service.dart';
import 'coach/attendance_screen.dart';

class CoachHomeScreen extends StatefulWidget {
  final User user;

  const CoachHomeScreen({super.key, required this.user});

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  final TrainingService _trainingService = TrainingService();
  late Future<List<TrainingSession>> _scheduleFuture;

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _loadSchedule();
  }

  Future<List<TrainingSession>> _loadSchedule() async {
    final allSessions = await _trainingService.getSessions();
    // Filter sessions for the current coach and sort by date
    final coachSessions = allSessions
        .where((s) => s.coachId == widget.user.id)
        .toList();
    coachSessions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return coachSessions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание, ${widget.user.name}'),
      ),
      body: FutureBuilder<List<TrainingSession>>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('У вас нет назначенных тренировок.'));
          }

          final schedule = snapshot.data!;
          return ListView.builder(
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final session = schedule[index];
              return ListTile(
                title: Text('Тренировка ${session.dateTime.toLocal().toString().substring(0, 16)}'),
                subtitle: Text('Филиал ID: ${session.branchId}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceScreen(session: session),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
