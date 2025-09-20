import 'package:flutter/material.dart';
import '../../models/branch_model.dart';
import '../../services/branch_service.dart';

class BranchEditScreen extends StatefulWidget {
  final Branch? branch;

  const BranchEditScreen({super.key, this.branch});

  @override
  State<BranchEditScreen> createState() => _BranchEditScreenState();
}

class _BranchEditScreenState extends State<BranchEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _branchService = BranchService();
  late String _name;
  late String _address;

  bool get _isEditing => widget.branch != null;

  @override
  void initState() {
    super.initState();
    _name = widget.branch?.name ?? '';
    _address = widget.branch?.address ?? '';
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_isEditing) {
        final updatedBranch = Branch(
          id: widget.branch!.id,
          name: _name,
          address: _address,
          coachIds: widget.branch!.coachIds,
          studentIds: widget.branch!.studentIds,
        );
        await _branchService.updateBranch(updatedBranch);
      } else {
        final newBranch = Branch(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID
          name: _name,
          address: _address,
          coachIds: [],
          studentIds: [],
        );
        await _branchService.addBranch(newBranch);
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
        title: Text(_isEditing ? 'Редактировать Филиал' : 'Добавить Филиал'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Название филиала'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Адрес'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите адрес';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
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
