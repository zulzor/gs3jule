import '../models/family_model.dart';
import '../models/user_model.dart';

class FamilyService {
  // Mock data
  final List<Family> _families = [
    Family(
      id: 'family1',
      familyName: 'Семья Родителевых',
      parentIds: ['parent1'],
      childIds: ['child1'],
    ),
  ];

  final List<User> _users = [
    User(id: 'parent1', name: 'Анна Родителева', email: 'parent@school.com', role: UserRole.parent, familyId: 'family1'),
    User(id: 'child1', name: 'Петя Родителев', email: 'child@school.com', role: UserRole.child, familyId: 'family1', branchId: 'branch1'),
  ];

  Future<Family?> getFamilyById(String familyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _families.firstWhere((f) => f.id == familyId);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getChildrenInFamily(String familyId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final family = await getFamilyById(familyId);
    if (family == null) return [];
    return _users.where((u) => family.childIds.contains(u.id)).toList();
  }
}
