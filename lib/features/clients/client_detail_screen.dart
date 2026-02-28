import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../services/client_service.dart';
import '../../services/task_service.dart';
import '../../models/client_model.dart';

class ClientDetailScreen extends ConsumerWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<ClientModel?>(
      future: clientService.getClient(clientId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final client = snap.data;
        if (client == null) {
          return const Scaffold(
            body: Center(child: Text('Client not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(client.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                client.name.substring(0, 1),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  client.industry,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  client.region,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Contact',
                          value: client.contactName),
                      const Divider(height: 16),
                      _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: client.contactEmail),
                      const Divider(height: 16),
                      _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: client.contactPhone),
                    ],
                  ),
                ),
                if (client.notes != null && client.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Text(
                      client.notes!,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder(
                  future: taskService.getTasks(clientId: clientId),
                  builder: (context, taskSnap) {
                    if (taskSnap.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    final tasks = taskSnap.data ?? [];
                    if (tasks.isEmpty) {
                      return const AppCard(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'No tasks for this client',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: tasks
                          .take(5)
                          .map((task) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8),
                                child: AppCard(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Text(
                                        task.status.name,
                                        style: const TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
