import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/family_service.dart';
import '../services/credit_service.dart';
import 'parent/parent_schedule_screen.dart';
import 'parent/parent_progress_screen.dart';

class FamilyHomeScreen extends StatefulWidget {
  final User user;

  const FamilyHomeScreen({super.key, required this.user});

  @override
  State<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends State<FamilyHomeScreen> {
  final FamilyService _familyService = FamilyService();
  final CreditService _creditService = CreditService();
  late Future<Map<User, int>> _creditsFuture;

  @override
  void initState() {
    super.initState();
    _creditsFuture = _loadFamilyCredits();
  }

  Future<Map<User, int>> _loadFamilyCredits() async {
    if (widget.user.familyId == null) {
      return {};
    }
    final children = await _familyService.getChildrenInFamily(widget.user.familyId!);
    final Map<User, int> creditsMap = {};
    for (final child in children) {
      creditsMap[child] = await _creditService.getCreditsForChild(child.id);
    }
    return creditsMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинет Семьи'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Баланс тренировок:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          FutureBuilder<Map<User, int>>(
            future: _creditsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ListTile(title: Text('Нет данных о детях в семье.'));
              }
              final creditsData = snapshot.data!;
              return Column(
                children: creditsData.entries.map((entry) {
                  final child = entry.key;
                  final credits = entry.value;
                  return ListTile(
                    leading: const Icon(Icons.child_care),
                    title: Text(child.name),
                    subtitle: const Text('Нажмите, чтобы посмотреть успеваемость'),
                    trailing: Text(
                      '$credits тренировок',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParentProgressScreen(student: child),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Записаться на тренировку'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentScheduleScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
