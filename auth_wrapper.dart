import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'manager_home_screen.dart';
import 'coach_home_screen.dart';
import 'family_home_screen.dart';

/// This stateful widget is the main entry point for the app's UI after launch.
/// It acts as a controller that determines which screen to show based on the
/// user's authentication state.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  /// Holds the currently logged-in user. A null value means no user is logged in.
  /// In a real app, this would come from a state management solution
  /// like Provider or BLoC, listening to an auth stream.
  User? _currentUser;

  /// Callback function passed to the LoginScreen.
  /// When login is successful, this function is called to update the
  /// state of the wrapper with the logged-in user.
  void _updateUser(User? user) {
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If no user is logged in, show the LoginScreen.
    // We pass the _updateUser callback to allow the LoginScreen to update our state.
    if (_currentUser == null) {
      return LoginScreen(onLoginSuccess: _updateUser);
    } else {
      // If a user is logged in, use a switch statement on their role
      // to determine which home screen to display.
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
