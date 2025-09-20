enum UserRole {
  manager,
  coach,
  parent,
  child,
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
