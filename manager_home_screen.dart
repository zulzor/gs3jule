import 'package:flutter/material.dart';
import 'manager/branch_list_screen.dart';
import 'manager/user_list_screen.dart';
import 'manager/training_calendar_screen.dart';
import 'manager/credit_add_screen.dart';
import '../models/user_model.dart';

class ManagerHomeScreen extends StatelessWidget {
  final User user;

  const ManagerHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель Управляющего'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text('Управление Филиалами'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BranchListScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Управление Пользователями'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserListScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Календарь Тренировок'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainingCalendarScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_card_outlined),
            title: const Text('Начислить Тренировки'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreditAddScreen(),
                ),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
