import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/forum_provider.dart';
import '../../core/utils/app_date_utils.dart';

class ChannelScreen extends ConsumerStatefulWidget {
  final String channelId;

  const ChannelScreen({super.key, required this.channelId});

  @override
  ConsumerState<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends ConsumerState<ChannelScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(forumProvider.notifier).loadThreads(widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    final forumState = ref.watch(forumProvider);
    final channel = forumState.channels
        .where((c) => c.id == widget.channelId)
        .firstOrNull;
    final threads = forumState.threadsByChannel[widget.channelId] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(channel?.name ?? 'Channel')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/community/${widget.channelId}/new'),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: threads.isEmpty
          ? const Center(
              child: Text('No posts yet. Be the first to post!',
                  style: TextStyle(color: AppColors.textLight)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: threads.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final thread = threads[i];
                return AppCard(
                  onTap: () => context.push(
                      '/community/${widget.channelId}/${thread.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                AppColors.primary.withOpacity(0.12),
                            child: Text(
                              thread.authorName.substring(0, 1),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                thread.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                AppDateUtils.timeAgo(thread.createdAt),
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (thread.isPinned) ...[
                            const Spacer(),
                            const Icon(Icons.push_pin,
                                size: 14, color: AppColors.accent),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        thread.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        thread.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border,
                              size: 15, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            '${thread.likesCount}',
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.comment_outlined,
                              size: 15, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            '${thread.commentsCount}',
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
