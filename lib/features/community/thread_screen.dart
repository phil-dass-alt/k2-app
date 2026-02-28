import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../providers/forum_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/forum_thread_model.dart';
import '../../core/utils/app_date_utils.dart';
import 'package:uuid/uuid.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  final String channelId;
  final String threadId;

  const ThreadScreen(
      {super.key, required this.channelId, required this.threadId});

  @override
  ConsumerState<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends ConsumerState<ThreadScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(forumProvider.notifier).loadComments(widget.threadId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final comment = ForumCommentModel(
      id: const Uuid().v4(),
      threadId: widget.threadId,
      authorId: user.id,
      authorName: user.name,
      body: text,
      createdAt: DateTime.now(),
    );

    await ref.read(forumProvider.notifier).createComment(comment);
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final forumState = ref.watch(forumProvider);
    final threads =
        forumState.threadsByChannel[widget.channelId] ?? [];
    final thread = threads
        .where((t) => t.id == widget.threadId)
        .firstOrNull;
    final comments =
        forumState.commentsByThread[widget.threadId] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Thread')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Thread header
                if (thread != null)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.12),
                              child: Text(
                                thread.authorName.substring(0, 1),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  thread.authorName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  AppDateUtils.formatDateTime(
                                      thread.createdAt),
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          thread.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          thread.body,
                          style: const TextStyle(
                            height: 1.6,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => ref
                                  .read(forumProvider.notifier)
                                  .likeThread(
                                      widget.threadId, widget.channelId),
                              child: Row(
                                children: [
                                  const Icon(Icons.favorite_border,
                                      size: 18, color: AppColors.error),
                                  const SizedBox(width: 4),
                                  Text('${thread.likesCount} likes'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                const Icon(Icons.comment_outlined,
                                    size: 18, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Text('${comments.length} comments'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Comments',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                ...comments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      color: AppColors.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    AppColors.accent.withOpacity(0.15),
                                child: Text(
                                  comment.authorName.substring(0, 1),
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                comment.authorName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              const Spacer(),
                              Text(
                                AppDateUtils.timeAgo(comment.createdAt),
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            comment.body,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (comments.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No comments yet. Be the first!',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Comment Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.accent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _submitComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
