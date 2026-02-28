import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/meeting_service.dart';
import '../../../models/meeting_model.dart';
import 'package:uuid/uuid.dart';

class MeetingFormScreen extends ConsumerStatefulWidget {
  const MeetingFormScreen({super.key});

  @override
  ConsumerState<MeetingFormScreen> createState() => _MeetingFormScreenState();
}

class _MeetingFormScreenState extends ConsumerState<MeetingFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _reminderMinutes = 30;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedDate = date;
        _selectedTime = time;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() => _isLoading = true);

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final meeting = MeetingModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dateTime: dateTime,
      location: _locationController.text.trim(),
      attendees: [user.id],
      reminderMinutes: _reminderMinutes,
      isCompleted: false,
      createdBy: user.id,
      createdAt: DateTime.now(),
    );

    await meetingService.createMeeting(meeting);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting created successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Meeting')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Meeting Title',
                hint: 'Enter meeting title',
                validator: (v) => AppValidators.minLength(v, 3, 'Title'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descController,
                label: 'Description',
                hint: 'What is this meeting about?',
                maxLines: 3,
                validator: (v) => AppValidators.required(v, 'Description'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Room / Video call link',
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => AppValidators.required(v, 'Location'),
              ),
              const SizedBox(height: 16),
              const Text('Date & Time *',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDateTime,
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
                      const Icon(Icons.event, color: AppColors.textLight, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate == null
                            ? 'Select date and time'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                ' at ${_selectedTime!.format(context)}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? AppColors.textLight
                              : AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Reminder',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _reminderMinutes,
                onChanged: (v) => setState(() => _reminderMinutes = v!),
                items: const [
                  DropdownMenuItem(value: 5, child: Text('5 minutes before')),
                  DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                  DropdownMenuItem(value: 60, child: Text('1 hour before')),
                ],
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Create Meeting',
                isLoading: _isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
