// IMPORTANT: This screen requires the 'table_calendar' package.
// Add `table_calendar: ^3.0.0` to pubspec.yaml
import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart'; // Commented out to avoid compile errors
import '../../models/training_session_model.dart';
import '../../services/training_service.dart';
import 'training_edit_screen.dart';

class TrainingCalendarScreen extends StatefulWidget {
  const TrainingCalendarScreen({super.key});

  @override
  State<TrainingCalendarScreen> createState() => _TrainingCalendarScreenState();
}

class _TrainingCalendarScreenState extends State<TrainingCalendarScreen> {
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
      if (sessionsByDate[date] == null) {
        sessionsByDate[date] = [];
      }
      sessionsByDate[date]!.add(session);
    }
    setState(() {
      _sessionsByDate = sessionsByDate;
    });
  }

  List<TrainingSession> _getEventsForDay(DateTime day) {
    return _sessionsByDate[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь Тренировок'),
      ),
      body: FutureBuilder(
          future: _loadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && _sessionsByDate.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                // --- Calendar Placeholder ---
                GestureDetector(
                  onTap: () async {
                    final newDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDay ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (newDate != null) {
                      setState(() {
                        _selectedDay = newDate;
                        _focusedDay = newDate;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Tap to select a date (Calendar Placeholder)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Selected Day: ${_selectedDay?.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                  ),
                ),
                // --- End Placeholder ---
                const SizedBox(height: 8.0),
                const Text('Тренировки на выбранный день:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final session = _getEventsForDay(_selectedDay!)[index];
                      return ListTile(
                        title: Text('Тренировка в ${TimeOfDay.fromDateTime(session.dateTime).format(context)}'),
                        subtitle: Text('Тренер ID: ${session.coachId}, Филиал ID: ${session.branchId}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingEditScreen(
                                session: session,
                                selectedDate: _selectedDay!,
                              ),
                            ),
                          ).then((_) => _loadSessions());
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainingEditScreen(
                selectedDate: _selectedDay!,
              ),
            ),
          ).then((_) => _loadSessions());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
