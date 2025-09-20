import 'package:flutter/material.dart';
import '../../models/training_session_model.dart';
import '../../models/branch_model.dart';
import '../../models/user_model.dart';
import '../../services/training_service.dart';
import '../../services/branch_service.dart';
import '../../services/user_service.dart';

class TrainingEditScreen extends StatefulWidget {
  final TrainingSession? session;
  final DateTime selectedDate;

  const TrainingEditScreen({super.key, this.session, required this.selectedDate});

  @override
  State<TrainingEditScreen> createState() => _TrainingEditScreenState();
}

class _TrainingEditScreenState extends State<TrainingEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trainingService = TrainingService();
  final _branchService = BranchService();
  final _userService = UserService();

  // Form state
  late DateTime _dateTime;
  String? _branchId;
  String? _coachId;
  late int _maxParticipants;

  // Data for dropdowns
  List<Branch> _branches = [];
  List<User> _coaches = [];

  bool get _isEditing => widget.session != null;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.session?.dateTime ?? widget.selectedDate;
    _branchId = widget.session?.branchId;
    _coachId = widget.session?.coachId;
    _maxParticipants = widget.session?.maxParticipants ?? 10;

    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    final branches = await _branchService.getBranches();
    final allUsers = await _userService.getUsers();
    final coaches = allUsers.where((u) => u.role == UserRole.coach).toList();
    setState(() {
      _branches = branches;
      _coaches = coaches;
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final sessionToSave = TrainingSession(
        id: widget.session?.id ?? DateTime.now().toIso8601String(),
        dateTime: _dateTime,
        branchId: _branchId!,
        coachId: _coachId!,
        signedUpChildIds: widget.session?.signedUpChildIds ?? [],
        maxParticipants: _maxParticipants,
      );

      if (_isEditing) {
        await _trainingService.updateSession(sessionToSave);
      } else {
        await _trainingService.addSession(sessionToSave);
      }
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать' : 'Добавить Тренировку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Дата: ${_dateTime.toLocal().toString().split(' ')[0]}'),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_dateTime),
                  );
                  if (time != null) {
                    setState(() {
                      _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, time.hour, time.minute);
                    });
                  }
                },
                child: Text('Выбрать время: ${TimeOfDay.fromDateTime(_dateTime).format(context)}'),
              ),
              DropdownButtonFormField<String>(
                value: _branchId,
                decoration: const InputDecoration(labelText: 'Филиал'),
                items: _branches.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))).toList(),
                onChanged: (v) => setState(() => _branchId = v),
                validator: (v) => v == null ? 'Выберите филиал' : null,
              ),
              DropdownButtonFormField<String>(
                value: _coachId,
                decoration: const InputDecoration(labelText: 'Тренер'),
                items: _coaches.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => _coachId = v),
                validator: (v) => v == null ? 'Выберите тренера' : null,
              ),
              TextFormField(
                initialValue: _maxParticipants.toString(),
                decoration: const InputDecoration(labelText: 'Макс. участников'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null ? 'Введите число' : null,
                onSaved: (v) => _maxParticipants = int.parse(v!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveForm, child: const Text('Сохранить')),
            ],
          ),
        ),
      ),
    );
  }
}
