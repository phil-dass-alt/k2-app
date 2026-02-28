import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersProvider);
    final pendingUsersAsync = ref.watch(pendingUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            allUsersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox(),
              data: (users) {
                final active =
                    users.where((u) => u.status == UserStatus.active).length;
                final pending =
                    users.where((u) => u.status == UserStatus.pending).length;

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _StatCard(
                        label: 'Total Users',
                        value: '${users.length}',
                        icon: Icons.people_outline,
                        color: AppColors.primary),
                    _StatCard(
                        label: 'Active Users',
                        value: '$active',
                        icon: Icons.check_circle_outline,
                        color: AppColors.success),
                    _StatCard(
                        label: 'Pending',
                        value: '$pending',
                        icon: Icons.hourglass_empty,
                        color: AppColors.warning),
                    _StatCard(
                        label: 'Total Clients',
                        value: '5',
                        icon: Icons.business_outlined,
                        color: AppColors.accent),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Links',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _AdminLink(
              icon: Icons.people,
              title: 'User Management',
              subtitle: 'Manage all employees and roles',
              onTap: () => context.push('/admin/users'),
            ),
            const SizedBox(height: 10),
            _AdminLink(
              icon: Icons.how_to_reg,
              title: 'Pending Activations',
              subtitle: 'Approve new user registrations',
              badge: pendingUsersAsync.maybeWhen(
                data: (users) => users.length,
                orElse: () => 0,
              ),
              onTap: () => context.push('/admin/activation'),
            ),
            const SizedBox(height: 10),
            _AdminLink(
              icon: Icons.bar_chart,
              title: 'Reports',
              subtitle: 'View activity and performance reports',
              onTap: () => context.push('/admin/reports'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int badge;

  const _AdminLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                      color: AppColors.textLight, fontSize: 12),
                ),
              ],
            ),
          ),
          if (badge > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }
}
