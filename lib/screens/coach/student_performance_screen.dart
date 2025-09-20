import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/discipline_model.dart';
import '../../services/discipline_service.dart';

class StudentPerformanceScreen extends StatefulWidget {
  final User student;

  const StudentPerformanceScreen({super.key, required this.student});

  @override
  State<StudentPerformanceScreen> createState() => _StudentPerformanceScreenState();
}

class _StudentPerformanceScreenState extends State<StudentPerformanceScreen> {
  final DisciplineService _disciplineService = DisciplineService();
  late Future<List<Discipline>> _disciplinesFuture;

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = _disciplineService.getDisciplines();
  }

  void _addRecord(Discipline discipline) {
    // In a real app, this would open a more complex dialog or screen
    // based on the discipline.type. For now, a simple dialog.
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Новая запись: ${discipline.name}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Результат'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              dynamic value = controller.text;
              if (discipline.type == DisciplineType.count) {
                value = int.tryParse(controller.text) ?? 0;
              } else if (discipline.type == DisciplineType.percentage) {
                value = double.tryParse(controller.text) ?? 0.0;
              }
              await _disciplineService.addPerformanceRecord(discipline.id, widget.student.id, value);
              Navigator.of(context).pop();
              // Optionally refresh data
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Успеваемость: ${widget.student.name}'),
      ),
      body: FutureBuilder<List<Discipline>>(
        future: _disciplinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Дисциплины не найдены.'));
          }

          final disciplines = snapshot.data!;
          return ListView.builder(
            itemCount: disciplines.length,
            itemBuilder: (context, index) {
              final discipline = disciplines[index];
              return ListTile(
                title: Text(discipline.name),
                subtitle: const Text('Нажмите, чтобы просмотреть историю или добавить запись'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addRecord(discipline),
                ),
                onTap: () {
                  // TODO: Navigate to a detailed history view for this discipline
                },
              );
            },
          );
        },
      ),
    );
  }
}
