import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/credit_service.dart';

class CreditAddScreen extends StatefulWidget {
  const CreditAddScreen({super.key});

  @override
  State<CreditAddScreen> createState() => _CreditAddScreenState();
}

class _CreditAddScreenState extends State<CreditAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  final _creditService = CreditService();

  List<User> _children = [];
  String? _selectedChildId;
  int _amountToAdd = 0;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final users = await _userService.getUsers();
    setState(() {
      _children = users.where((u) => u.role == UserRole.child).toList();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _creditService.addCredits(_selectedChildId!, _amountToAdd);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_amountToAdd тренировок добавлено.'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        setState(() {
          _selectedChildId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Начислить Тренировки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedChildId,
                decoration: const InputDecoration(labelText: 'Выберите ребенка'),
                items: _children.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _selectedChildId = v),
                validator: (v) => v == null ? 'Нужно выбрать ребенка' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Количество тренировок'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty || int.parse(v) <= 0) {
                    return 'Введите положительное число';
                  }
                  return null;
                },
                onSaved: (v) => _amountToAdd = int.parse(v!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Начислить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
