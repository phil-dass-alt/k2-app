import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/forum_provider.dart';
import '../../models/forum_channel_model.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  IconData _channelIcon(ForumChannelType type) {
    switch (type) {
      case ForumChannelType.announcement:
        return Icons.campaign_outlined;
      case ForumChannelType.wins:
        return Icons.emoji_events_outlined;
      case ForumChannelType.mediaLeads:
        return Icons.newspaper_outlined;
      case ForumChannelType.clientHelp:
        return Icons.help_outline;
      case ForumChannelType.learning:
        return Icons.school_outlined;
      case ForumChannelType.general:
        return Icons.chat_bubble_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumState = ref.watch(forumProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: forumState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: forumState.channels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final channel = forumState.channels[i];
                return AppCard(
                  onTap: () => context.push('/community/${channel.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _channelIcon(channel.type),
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  channel.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if (channel.isPinned) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.push_pin,
                                      size: 13, color: AppColors.textLight),
                                ],
                              ],
                            ),
                            Text(
                              channel.description,
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${channel.threadCount} posts',
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (channel.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${channel.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        const Icon(Icons.chevron_right,
                            color: AppColors.textLight),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
