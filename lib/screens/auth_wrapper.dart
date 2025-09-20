import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'manager_home_screen.dart';
import 'coach_home_screen.dart';
import 'family_home_screen.dart';

// This widget will act as a controller to show the correct screen
// based on the authentication state.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // In a real app, this would come from a state management solution
  // like Provider or BLoC, listening to an auth stream.
  User? _currentUser;

  void _updateUser(User? user) {
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      // To make this work, LoginScreen needs to be updated
      return LoginScreen(onLoginSuccess: _updateUser);
    } else {
      switch (_currentUser!.role) {
        case UserRole.manager:
          return ManagerHomeScreen(user: _currentUser!);
        case UserRole.coach:
          return CoachHomeScreen(user: _currentUser!);
        case UserRole.parent:
        case UserRole.child:
          return FamilyHomeScreen(user: _currentUser!);
      }
    }
  }
}
