import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../providers/task_provider.dart';
import '../../../models/task_model.dart';
import '../../../core/utils/app_date_utils.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final bool embedded;
  final VoidCallback? onNewTask;

  const TasksScreen({super.key, this.embedded = false, this.onNewTask});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskStatus? _filter;

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.urgent:
        return AppColors.error;
      case TaskPriority.high:
        return AppColors.warning;
      case TaskPriority.medium:
        return AppColors.accent;
      case TaskPriority.low:
        return AppColors.success;
    }
  }

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.urgent:
        return 'URGENT';
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MED';
      case TaskPriority.low:
        return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksProvider);
    var tasks = tasksState.tasks;
    if (_filter != null) {
      tasks = tasks.where((t) => t.status == _filter).toList();
    }

    Widget body = Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _Chip('All', _filter == null,
                  () => setState(() => _filter = null)),
              const SizedBox(width: 8),
              _Chip('To Do', _filter == TaskStatus.todo,
                  () => setState(() => _filter = TaskStatus.todo)),
              const SizedBox(width: 8),
              _Chip('In Progress', _filter == TaskStatus.inProgress,
                  () => setState(() => _filter = TaskStatus.inProgress)),
              const SizedBox(width: 8),
              _Chip('Done', _filter == TaskStatus.done,
                  () => setState(() => _filter = TaskStatus.done)),
            ],
          ),
        ),
        Expanded(
          child: tasksState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : tasks.isEmpty
                  ? const Center(
                      child: Text('No tasks found',
                          style: TextStyle(color: AppColors.textLight)))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final task = tasks[i];
                        return AppCard(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _priorityColor(task.priority),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _priorityColor(task.priority)
                                                .withOpacity(0.12),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _priorityLabel(task.priority),
                                            style: TextStyle(
                                              color: _priorityColor(
                                                  task.priority),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        if (task.dueDate != null) ...[
                                          const Icon(Icons.calendar_today,
                                              size: 12,
                                              color: AppColors.textLight),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppDateUtils.relativeDay(
                                                task.dueDate!),
                                            style: const TextStyle(
                                              color: AppColors.textLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                        _StatusDot(task.status),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onNewTask ?? () => context.push('/work/tasks/new'),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: body,
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip(this.label, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.text,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13,
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final TaskStatus status;

  const _StatusDot(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case TaskStatus.todo:
        color = AppColors.textLight;
        label = 'To Do';
        break;
      case TaskStatus.inProgress:
        color = AppColors.accent;
        label = 'In Progress';
        break;
      case TaskStatus.done:
        color = AppColors.success;
        label = 'Done';
        break;
      case TaskStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
        break;
    }
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
