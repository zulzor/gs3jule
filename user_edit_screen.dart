import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/branch_model.dart';
import '../../services/user_service.dart';
import '../../services/branch_service.dart';

class UserEditScreen extends StatefulWidget {
  final User? user;

  const UserEditScreen({super.key, this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _branchService = BranchService();

  late String _name;
  late String _email;
  late UserRole _role;
  String? _branchId;
  String? _familyId;

  bool get _isEditing => widget.user != null;
  List<Branch> _branches = [];

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name ?? '';
    _email = widget.user?.email ?? '';
    _role = widget.user?.role ?? UserRole.child;
    _branchId = widget.user?.branchId;
    _familyId = widget.user?.familyId;

    _branchService.getBranches().then((branches) {
      setState(() {
        _branches = branches;
      });
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final userToSave = User(
        id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        email: _email,
        role: _role,
        branchId: _branchId,
        familyId: _familyId,
      );

      if (_isEditing) {
        await _userService.updateUser(userToSave);
      } else {
        await _userService.addUser(userToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать' : 'Добавить Пользователя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (v) => v!.isEmpty ? 'Введите имя' : null,
                onSaved: (v) => _name = v!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Введите email' : null,
                onSaved: (v) => _email = v!,
              ),
              DropdownButtonFormField<UserRole>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Роль'),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role.toString().split('.').last));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              if (_role == UserRole.coach || _role == UserRole.child)
                DropdownButtonFormField<String>(
                  value: _branchId,
                  decoration: const InputDecoration(labelText: 'Филиал'),
                  items: _branches.map((branch) {
                    return DropdownMenuItem(value: branch.id, child: Text(branch.name));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _branchId = value;
                    });
                  },
                ),
              if (_role == UserRole.parent || _role == UserRole.child)
                TextFormField(
                  initialValue: _familyId,
                  decoration: const InputDecoration(labelText: 'ID Семьи'),
                  onSaved: (v) => _familyId = v,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
