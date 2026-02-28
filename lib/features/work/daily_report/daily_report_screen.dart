import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../models/task_model.dart';
import '../../../models/daily_report_model.dart';
import 'package:uuid/uuid.dart';

class DailyReportScreen extends ConsumerStatefulWidget {
  final bool embedded;

  const DailyReportScreen({super.key, this.embedded = false});

  @override
  ConsumerState<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends ConsumerState<DailyReportScreen> {
  final _summaryController = TextEditingController();
  final _challengesController = TextEditingController();
  final _nextDayPlanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Set<String> _selectedTaskIds = {};
  final Set<String> _selectedMeetingIds = {};
  bool _submitted = false;

  @override
  void dispose() {
    _summaryController.dispose();
    _challengesController.dispose();
    _nextDayPlanController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final report = DailyReportModel(
      id: const Uuid().v4(),
      userId: user.id,
      date: DateTime.now(),
      summary: _summaryController.text.trim(),
      tasksCompleted: _selectedTaskIds.toList(),
      meetingsHeld: _selectedMeetingIds.toList(),
      challenges: _challengesController.text.trim(),
      nextDayPlan: _nextDayPlanController.text.trim(),
      createdAt: DateTime.now(),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily report submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksProvider);
    final doneTasks = tasksState.tasks
        .where((t) => t.status != TaskStatus.cancelled)
        .toList();
    final user = ref.watch(authProvider).user;

    if (_submitted) {
      Widget body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Report Submitted!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your daily report has been submitted for today.',
              style: TextStyle(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Submit Another',
              variant: AppButtonVariant.outline,
              fullWidth: false,
              onPressed: () => setState(() => _submitted = false),
            ),
          ],
        ),
      );
      if (widget.embedded) return body;
      return Scaffold(
        appBar: AppBar(title: const Text('Daily Report')),
        body: body,
      );
    }

    Widget body = Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Daily Report – ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            if (user != null)
              Text(
                user.name,
                style: const TextStyle(color: AppColors.textLight),
              ),
            const SizedBox(height: 24),
            const Text('Summary *',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppTextField(
              controller: _summaryController,
              hint: 'What did you accomplish today?',
              maxLines: 4,
              validator: (v) => AppValidators.required(v, 'Summary'),
            ),
            const SizedBox(height: 16),
            const Text('Tasks Completed Today',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...doneTasks.map(
              (task) => CheckboxListTile(
                title: Text(task.title, style: const TextStyle(fontSize: 14)),
                value: _selectedTaskIds.contains(task.id),
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedTaskIds.add(task.id);
                    } else {
                      _selectedTaskIds.remove(task.id);
                    }
                  });
                },
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Challenges Faced *',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppTextField(
              controller: _challengesController,
              hint: 'Any blockers or challenges?',
              maxLines: 3,
              validator: (v) => AppValidators.required(v, 'Challenges'),
            ),
            const SizedBox(height: 16),
            const Text('Plan for Tomorrow *',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AppTextField(
              controller: _nextDayPlanController,
              hint: "What's your plan for tomorrow?",
              maxLines: 3,
              validator: (v) => AppValidators.required(v, 'Plan for tomorrow'),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Submit Daily Report',
              onPressed: _submit,
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );

    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Report')),
      body: body,
    );
  }
}
