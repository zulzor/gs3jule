import '../models/user_model.dart';

class UserService {
  final List<User> _users = [
    User(id: 'manager1', name: 'Главный Управляющий', email: 'manager@school.com', role: UserRole.manager),
    User(id: 'coach1', name: 'Иван Тренеров', email: 'coach@school.com', role: UserRole.coach, branchId: 'branch1'),
    User(id: 'parent1', name: 'Анна Родителева', email: 'parent@school.com', role: UserRole.parent, familyId: 'family1'),
    User(id: 'child1', name: 'Петя Родителев', email: 'child@school.com', role: UserRole.child, familyId: 'family1', branchId: 'branch1'),
  ];

  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _users;
  }

  Future<void> addUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.add(user);
  }

  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((u) => u.id == userId);
  }
}
