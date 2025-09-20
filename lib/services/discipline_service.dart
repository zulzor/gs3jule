import '../models/discipline_model.dart';

class DisciplineService {
  final List<Discipline> _disciplines = [
    Discipline(
      id: 'd1',
      name: 'Бег на 100м (сек)',
      type: DisciplineType.time,
      performanceData: {},
    ),
    Discipline(
      id: 'd2',
      name: 'Отжимания (кол-во)',
      type: DisciplineType.count,
      performanceData: {
        'child1': [
          {'date': '2024-09-10', 'value': 20},
          {'date': '2024-09-15', 'value': 22},
        ]
      },
    ),
    Discipline(
      id: 'd3',
      name: 'Точность ударов (%)',
      type: DisciplineType.percentage,
      performanceData: {},
    ),
  ];

  Future<List<Discipline>> getDisciplines() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _disciplines;
  }

  Future<void> addPerformanceRecord(String disciplineId, String childId, dynamic value) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final discipline = _disciplines.firstWhere((d) => d.id == disciplineId);
    final record = {
      'date': DateTime.now().toIso8601String(),
      'value': value,
    };
    if (discipline.performanceData[childId] == null) {
      discipline.performanceData[childId] = [];
    }
    discipline.performanceData[childId]!.add(record);
  }
}
