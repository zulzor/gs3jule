import 'package:flutter/material.dart';
import '../../models/branch_model.dart';
import '../../services/branch_service.dart';
import 'branch_edit_screen.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  final BranchService _branchService = BranchService();
  late Future<List<Branch>> _branchesFuture;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  void _loadBranches() {
    setState(() {
      _branchesFuture = _branchService.getBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление Филиалами'),
      ),
      body: FutureBuilder<List<Branch>>(
        future: _branchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Филиалы не найдены.'));
          }

          final branches = snapshot.data!;
          return ListView.builder(
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              return ListTile(
                title: Text(branch.name),
                subtitle: Text(branch.address),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Simple confirmation dialog
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Подтверждение'),
                        content: const Text('Вы уверены, что хотите удалить этот филиал?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _branchService.deleteBranch(branch.id);
                      _loadBranches(); // Refresh the list
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BranchEditScreen(branch: branch),
                    ),
                  ).then((_) => _loadBranches()); // Refresh on return
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BranchEditScreen(),
            ),
          ).then((_) => _loadBranches()); // Refresh on return
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
