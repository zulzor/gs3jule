import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/discipline_model.dart';
import '../../services/discipline_service.dart';

class ParentProgressScreen extends StatefulWidget {
  final User student;

  const ParentProgressScreen({super.key, required this.student});

  @override
  State<ParentProgressScreen> createState() => _ParentProgressScreenState();
}

class _ParentProgressScreenState extends State<ParentProgressScreen> {
  final DisciplineService _disciplineService = DisciplineService();
  late Future<List<Discipline>> _disciplinesFuture;

  @override
  void initState() {
    super.initState();
    _disciplinesFuture = _disciplineService.getDisciplines();
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
          if (!snapshot.hasData) {
            return const Center(child: Text('Нет данных.'));
          }
          final disciplines = snapshot.data!;
          return ListView.builder(
            itemCount: disciplines.length,
            itemBuilder: (context, index) {
              final discipline = disciplines[index];
              final records = discipline.performanceData[widget.student.id] ?? [];

              return ExpansionTile(
                title: Text(discipline.name),
                subtitle: Text('${records.length} записей'),
                children: records.isEmpty
                    ? [const ListTile(title: Text('Нет данных по этой дисциплине.'))]
                    : records.map((record) {
                        final date = DateTime.parse(record['date']).toLocal().toString().substring(0, 10);
                        return ListTile(
                          title: Text('Результат: ${record['value']}'),
                          subtitle: Text('Дата: $date'),
                        );
                      }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
