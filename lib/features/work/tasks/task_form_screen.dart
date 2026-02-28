import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/task_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/task_model.dart';
import '../../../services/client_service.dart';
import '../../../models/client_model.dart';
import 'package:uuid/uuid.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  String? _selectedClientId;
  List<ClientModel> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await clientService.getClients();
    if (mounted) setState(() => _clients = clients);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final task = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      status: TaskStatus.todo,
      dueDate: _dueDate,
      createdBy: user.id,
      assignedTo: user.id,
      clientId: _selectedClientId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await ref.read(tasksProvider.notifier).createTask(task);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(tasksProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Task Title',
                hint: 'Enter task title',
                validator: (v) => AppValidators.minLength(v, 3, 'Title'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Describe the task',
                maxLines: 3,
                validator: (v) => AppValidators.required(v, 'Description'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Priority',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                onChanged: (v) => setState(() => _priority = v!),
                items: TaskPriority.values
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        ))
                    .toList(),
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Due Date (Optional)',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.surface,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Text(
                        _dueDate == null
                            ? 'Select due date'
                            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        style: TextStyle(
                          color: _dueDate == null
                              ? AppColors.textLight
                              : AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Client (Optional)',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: _selectedClientId,
                onChanged: (v) => setState(() => _selectedClientId = v),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ..._clients.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      )),
                ],
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Create Task',
                isLoading: isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
