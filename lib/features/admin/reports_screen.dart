import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/task_provider.dart';
import '../../models/task_model.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);
    final tasks = tasksState.tasks;

    final totalTasks = tasks.length;
    final doneTasks = tasks.where((t) => t.status == TaskStatus.done).length;
    final inProgressTasks =
        tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final todoTasks = tasks.where((t) => t.status == TaskStatus.todo).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _SummaryCard(
                  label: 'Daily Reports',
                  value: '12',
                  icon: Icons.description_outlined,
                  color: AppColors.primary,
                ),
                _SummaryCard(
                  label: 'Tasks Created',
                  value: '$totalTasks',
                  icon: Icons.task_alt,
                  color: AppColors.accent,
                ),
                _SummaryCard(
                  label: 'Forum Posts',
                  value: '24',
                  icon: Icons.forum_outlined,
                  color: AppColors.success,
                ),
                _SummaryCard(
                  label: 'Meetings',
                  value: '8',
                  icon: Icons.video_call_outlined,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Tasks by Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _BarRow(
                    label: 'To Do',
                    count: todoTasks,
                    total: totalTasks,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 12),
                  _BarRow(
                    label: 'In Progress',
                    count: inProgressTasks,
                    total: totalTasks,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  _BarRow(
                    label: 'Done',
                    count: doneTasks,
                    total: totalTasks,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Top Performers This Week',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _EmployeeRow(name: 'Priya Sharma', metric: '3 tasks done', rank: 1),
                  const Divider(height: 16),
                  _EmployeeRow(name: 'Meena Iyer', metric: '2 tasks done', rank: 2),
                  const Divider(height: 16),
                  _EmployeeRow(name: 'Ravi Patel', metric: '1 task done', rank: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _BarRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('$count', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: AppColors.divider,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _EmployeeRow extends StatelessWidget {
  final String name;
  final String metric;
  final int rank;

  const _EmployeeRow({
    required this.name,
    required this.metric,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: rank == 1
                ? const Color(0xFFFFD700).withOpacity(0.2)
                : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: rank == 1
                    ? const Color(0xFFB8860B)
                    : AppColors.textLight,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Text(metric,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
      ],
    );
  }
}
