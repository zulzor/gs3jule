import '../models/user_model.dart';

class AuthService {
  // Mock login function
  // In a real app, this would make an API call.
  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'manager@school.com' && password == 'password') {
      return User(
        id: 'manager1',
        name: 'Главный Управляющий',
        email: email,
        role: UserRole.manager,
      );
    }
    if (email == 'coach@school.com' && password == 'password') {
      return User(
        id: 'coach1',
        name: 'Иван Тренеров',
        email: email,
        role: UserRole.coach,
        branchId: 'branch1',
      );
    }
    if (email == 'parent@school.com' && password == 'password') {
      return User(
        id: 'parent1',
        name: 'Анна Родителева',
        email: email,
        role: UserRole.parent,
        familyId: 'family1',
      );
    }
    
    // Return null if login fails
    return null;
  }

  // Mock registration
  Future<User?> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you'd check if the email is already taken.
    // For now, we just create a new parent user.
    return User(
      id: 'new_parent_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: UserRole.parent,
      familyId: 'family_new',
    );
  }

  // Mock logout
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would clear the session token.
  }
}
