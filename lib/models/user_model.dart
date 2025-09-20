enum UserRole {
  manager,
  coach,
  parent,
  child,
}

extension UserRoleExtension on UserRole {
  String get nameInRussian {
    switch (this) {
      case UserRole.manager:
        return 'Управляющий';
      case UserRole.coach:
        return 'Тренер';
      case UserRole.parent:
        return 'Родитель';
      case UserRole.child:
        return 'Ребенок';
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? familyId; // Связь с семьей
  final String? branchId; // Связь с филиалом

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.familyId,
    this.branchId,
  });
}
