import 'package:flutter/material.dart';
import '../../models/training_session_model.dart';
import '../../services/training_service.dart';
import '../../models/user_model.dart';
import '../../services/family_service.dart';

class ParentScheduleScreen extends StatefulWidget {
  final User user;
  const ParentScheduleScreen({super.key, required this.user});

  @override
  State<ParentScheduleScreen> createState() => _ParentScheduleScreenState();
}

class _ParentScheduleScreenState extends State<ParentScheduleScreen> {
  final TrainingService _trainingService = TrainingService();
  late Map<DateTime, List<TrainingSession>> _sessionsByDate;
  late Future<void> _loadFuture;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _sessionsByDate = {};
    _loadFuture = _loadSessions();
    _selectedDay = _focusedDay;
  }

  Future<void> _loadSessions() async {
    final sessions = await _trainingService.getSessions();
    final Map<DateTime, List<TrainingSession>> sessionsByDate = {};
    for (final session in sessions) {
      final date = DateTime.utc(session.dateTime.year, session.dateTime.month, session.dateTime.day);
      if (sessionsByDate[date] == null) sessionsByDate[date] = [];
      sessionsByDate[date]!.add(session);
    }
    setState(() {
      _sessionsByDate = sessionsByDate;
    });
  }

  List<TrainingSession> _getEventsForDay(DateTime day) {
    return _sessionsByDate[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _signUp(TrainingSession session) async {
    final familyService = FamilyService();
    final children = await familyService.getChildrenInFamily(widget.user.familyId!);

    if (children.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('В вашей семье нет детей для записи.'), backgroundColor: Colors.orange),
      );
      return;
    }

    String? childToSignUpId;
    if (children.length == 1) {
      childToSignUpId = children.first.id;
    } else {
      // Show dialog to select child
      childToSignUpId = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Выберите ребенка'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: children.map((child) => ListTile(
              title: Text(child.name),
              onTap: () => Navigator.of(context).pop(child.id),
            )).toList(),
          ),
        ),
      );
    }

    if (childToSignUpId != null) {
      // TODO: Check for available credits before signing up
      final success = await _trainingService.signUpForSession(session.id, childToSignUpId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись прошла успешно!'), backgroundColor: Colors.green),
        );
        _loadSessions(); // Refresh the view
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось записаться. Нет свободных мест.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание и Запись'),
      ),
      body: Column(
        children: [
          // Placeholder for calendar
          GestureDetector(
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: _selectedDay ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (newDate != null) setState(() { _selectedDay = newDate; _focusedDay = newDate; });
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  const Text('Нажмите, чтобы выбрать дату', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Выбранный день: ${_selectedDay?.toLocal().toString().split(' ')[0]}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text('Доступные тренировки:', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: FutureBuilder(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _sessionsByDate.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final events = _getEventsForDay(_selectedDay!);
                if (events.isEmpty) return const Center(child: Text('Нет тренировок в этот день.'));
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final session = events[index];
                    return ListTile(
                      title: Text('Тренировка в ${TimeOfDay.fromDateTime(session.dateTime).format(context)}'),
                      subtitle: Text('Свободно мест: ${session.maxParticipants - session.signedUpChildIds.length}'),
                      trailing: ElevatedButton(
                        onPressed: () => _signUp(session),
                        child: const Text('Записаться'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
