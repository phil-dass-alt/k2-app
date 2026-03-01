import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forum_channel_model.dart';
import '../models/forum_thread_model.dart';
import '../services/forum_service.dart';

class ForumState {
  final List<ForumChannelModel> channels;
  final Map<String, List<ForumThreadModel>> threadsByChannel;
  final Map<String, List<ForumCommentModel>> commentsByThread;
  final bool isLoading;
  final String? error;

  const ForumState({
    this.channels = const [],
    this.threadsByChannel = const {},
    this.commentsByThread = const {},
    this.isLoading = false,
    this.error,
  });

  ForumState copyWith({
    List<ForumChannelModel>? channels,
    Map<String, List<ForumThreadModel>>? threadsByChannel,
    Map<String, List<ForumCommentModel>>? commentsByThread,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ForumState(
      channels: channels ?? this.channels,
      threadsByChannel: threadsByChannel ?? this.threadsByChannel,
      commentsByThread: commentsByThread ?? this.commentsByThread,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ForumNotifier extends StateNotifier<ForumState> {
  final ForumService _forumService;

  ForumNotifier(this._forumService) : super(const ForumState()) {
    loadChannels();
  }

  Future<void> loadChannels() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final channels = await _forumService.getChannels();
      state = state.copyWith(channels: channels, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadThreads(String channelId) async {
    try {
      final threads = await _forumService.getThreads(channelId);
      final updated = Map<String, List<ForumThreadModel>>.from(state.threadsByChannel);
      updated[channelId] = threads;
      state = state.copyWith(threadsByChannel: updated);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> loadComments(String threadId) async {
    try {
      final comments = await _forumService.getComments(threadId);
      final updated = Map<String, List<ForumCommentModel>>.from(state.commentsByThread);
      updated[threadId] = comments;
      state = state.copyWith(commentsByThread: updated);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<bool> createThread(ForumThreadModel thread) async {
    try {
      final newThread = await _forumService.createThread(thread);
      final updated = Map<String, List<ForumThreadModel>>.from(state.threadsByChannel);
      updated[thread.channelId] = [...(updated[thread.channelId] ?? []), newThread];
      state = state.copyWith(threadsByChannel: updated);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<bool> createComment(ForumCommentModel comment) async {
    try {
      final newComment = await _forumService.createComment(comment);
      final updated = Map<String, List<ForumCommentModel>>.from(state.commentsByThread);
      updated[comment.threadId] = [...(updated[comment.threadId] ?? []), newComment];
      state = state.copyWith(commentsByThread: updated);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<void> likeThread(String threadId, String channelId) async {
    try {
      final updated = await _forumService.likeThread(threadId);
      final threads = Map<String, List<ForumThreadModel>>.from(state.threadsByChannel);
      if (threads.containsKey(channelId)) {
        threads[channelId] = threads[channelId]!
            .map((t) => t.id == threadId ? updated : t)
            .toList();
        state = state.copyWith(threadsByChannel: threads);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }
}

final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  return ForumNotifier(forumService);
});
