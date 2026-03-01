import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: allUsersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (users) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final user = users[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _roleColor(user.role).withOpacity(0.15),
                child: Text(
                  user.name.substring(0, 1),
                  style: TextStyle(
                    color: _roleColor(user.role),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${user.email} • ${user.role.name}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusBadge(user.status),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'activate') {
                        await userService.activateUser(user.id);
                        ref.invalidate(allUsersProvider);
                      } else if (action == 'deactivate') {
                        await userService.deactivateUser(user.id);
                        ref.invalidate(allUsersProvider);
                      }
                    },
                    itemBuilder: (_) => [
                      if (user.status != UserStatus.active)
                        const PopupMenuItem(
                          value: 'activate',
                          child: Text('Activate'),
                        ),
                      if (user.status == UserStatus.active)
                        const PopupMenuItem(
                          value: 'deactivate',
                          child: Text('Deactivate'),
                        ),
                    ],
                    icon: const Icon(Icons.more_vert, size: 18),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    return role == UserRole.admin ? AppColors.accent : AppColors.primary;
  }
}

class _StatusBadge extends StatelessWidget {
  final UserStatus status;

  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case UserStatus.active:
        color = AppColors.success;
        label = 'Active';
        break;
      case UserStatus.pending:
        color = AppColors.warning;
        label = 'Pending';
        break;
      case UserStatus.suspended:
        color = AppColors.error;
        label = 'Suspended';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
