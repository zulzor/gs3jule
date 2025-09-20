import '../models/branch_model.dart';

class BranchService {
  // Mock data - in a real app, this would come from a database or API
  final List<Branch> _branches = [
    Branch(
      id: 'branch1',
      name: 'Центральный Филиал',
      address: 'ул. Главная, 1',
      coachIds: ['coach1'],
      studentIds: ['student1', 'student2'],
    ),
    Branch(
      id: 'branch2',
      name: 'Южный Филиал',
      address: 'пр. Солнечный, 15',
      coachIds: [],
      studentIds: [],
    ),
  ];

  Future<List<Branch>> getBranches() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _branches;
  }

  Future<void> addBranch(Branch branch) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _branches.add(branch);
  }

  Future<void> updateBranch(Branch branch) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _branches.indexWhere((b) => b.id == branch.id);
    if (index != -1) {
      _branches[index] = branch;
    }
  }

  Future<void> deleteBranch(String branchId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _branches.removeWhere((b) => b.id == branchId);
  }
}
