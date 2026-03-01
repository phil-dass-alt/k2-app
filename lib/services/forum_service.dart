import '../models/forum_channel_model.dart';
import '../models/forum_thread_model.dart';

class ForumService {
  static final List<ForumChannelModel> _mockChannels = [
    ForumChannelModel(
      id: 'ch-001',
      name: 'Announcements',
      description: 'Official company announcements and news.',
      type: ForumChannelType.announcement,
      iconName: 'megaphone',
      isPinned: true,
      createdAt: DateTime(2023, 1, 1),
      threadCount: 12,
      unreadCount: 2,
    ),
    ForumChannelModel(
      id: 'ch-002',
      name: 'Wins 🏆',
      description: 'Share and celebrate team wins and achievements.',
      type: ForumChannelType.wins,
      iconName: 'trophy',
      isPinned: true,
      createdAt: DateTime(2023, 1, 1),
      threadCount: 34,
      unreadCount: 5,
    ),
    ForumChannelModel(
      id: 'ch-003',
      name: 'Media Leads',
      description: 'Share media opportunities and leads with the team.',
      type: ForumChannelType.mediaLeads,
      iconName: 'newspaper',
      isPinned: false,
      createdAt: DateTime(2023, 1, 5),
      threadCount: 28,
      unreadCount: 1,
    ),
    ForumChannelModel(
      id: 'ch-004',
      name: 'Client Help',
      description: 'Ask for help or share insights on client situations.',
      type: ForumChannelType.clientHelp,
      iconName: 'help_circle',
      isPinned: false,
      createdAt: DateTime(2023, 2, 1),
      threadCount: 19,
      unreadCount: 0,
    ),
    ForumChannelModel(
      id: 'ch-005',
      name: 'Learning Hub',
      description: 'Share articles, courses, and learning resources.',
      type: ForumChannelType.learning,
      iconName: 'book_open',
      isPinned: false,
      createdAt: DateTime(2023, 2, 10),
      threadCount: 15,
      unreadCount: 3,
    ),
  ];

  static final List<ForumThreadModel> _mockThreads = [
    ForumThreadModel(
      id: 'thread-001',
      channelId: 'ch-001',
      title: 'Welcome to K2 Communications Employee App!',
      body: 'We\'re excited to launch our new employee collaboration platform. This app will help us stay connected, share knowledge, and celebrate our wins together. Please explore all sections and share your feedback.',
      authorId: 'admin-001',
      authorName: 'Arjun Kumar',
      isPinned: true,
      likesCount: 12,
      commentsCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ForumThreadModel(
      id: 'thread-002',
      channelId: 'ch-002',
      title: 'Reliance Festive Campaign - 143% Target Achieved! 🎉',
      body: 'Huge congratulations to the Reliance Retail team! We crushed our festive campaign targets at 143% of the goal. Exceptional work by Ravi and the entire team. This is what K2 is all about!',
      authorId: 'admin-001',
      authorName: 'Arjun Kumar',
      isPinned: true,
      likesCount: 21,
      commentsCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ForumThreadModel(
      id: 'thread-003',
      channelId: 'ch-003',
      title: 'Forbes India Feature Opportunity - Fintech Sector',
      body: 'Forbes India is looking for expert voices on the future of fintech in India. Deadline is this Friday. If any of our banking clients would be a good fit, please reach out to me ASAP.',
      authorId: 'emp-003',
      authorName: 'Meena Iyer',
      isPinned: false,
      likesCount: 7,
      commentsCount: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ForumThreadModel(
      id: 'thread-004',
      channelId: 'ch-004',
      title: 'Best approach for TCS account onboarding?',
      body: 'Starting the TCS onboarding process next week. Has anyone worked with large IT firm accounts before? Looking for tips on stakeholder mapping and the first 90 days approach.',
      authorId: 'emp-004',
      authorName: 'Sanjay Mehta',
      isPinned: false,
      likesCount: 3,
      commentsCount: 6,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    ForumThreadModel(
      id: 'thread-005',
      channelId: 'ch-005',
      title: 'Great Course: AI for Marketing Professionals',
      body: 'Just finished the "AI for Marketing Professionals" course on Coursera. Highly recommended for everyone on the team. It covers prompt engineering, AI-powered analytics, and content automation. Link: https://coursera.org/ai-marketing',
      authorId: 'emp-001',
      authorName: 'Priya Sharma',
      isPinned: false,
      likesCount: 9,
      commentsCount: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final List<ForumCommentModel> _mockComments = [
    ForumCommentModel(
      id: 'comment-001',
      threadId: 'thread-002',
      authorId: 'emp-001',
      authorName: 'Priya Sharma',
      body: 'Amazing work Ravi! The festive campaign strategy was spot on. Looking forward to building on this success for Q4!',
      likesCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    ),
    ForumCommentModel(
      id: 'comment-002',
      threadId: 'thread-002',
      authorId: 'emp-002',
      authorName: 'Ravi Patel',
      body: 'Thank you everyone! Couldn\'t have done it without the whole team\'s support. Special thanks to Meena for the content strategy.',
      likesCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    ),
    ForumCommentModel(
      id: 'comment-003',
      threadId: 'thread-004',
      authorId: 'emp-001',
      authorName: 'Priya Sharma',
      body: 'For large IT accounts, I\'d suggest starting with IT communications and then working your way to business units. Happy to jump on a quick call!',
      likesCount: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
  ];

  Future<List<ForumChannelModel>> getChannels() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockChannels);
  }

  Future<List<ForumThreadModel>> getThreads(String channelId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockThreads.where((t) => t.channelId == channelId).toList();
  }

  Future<ForumThreadModel?> getThread(String threadId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockThreads.firstWhere((t) => t.id == threadId);
    } catch (_) {
      return null;
    }
  }

  Future<List<ForumCommentModel>> getComments(String threadId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockComments.where((c) => c.threadId == threadId).toList();
  }

  Future<ForumThreadModel> createThread(ForumThreadModel thread) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockThreads.add(thread);
    final chIdx = _mockChannels.indexWhere((c) => c.id == thread.channelId);
    if (chIdx != -1) {
      final ch = _mockChannels[chIdx];
      _mockChannels[chIdx] = ForumChannelModel(
        id: ch.id,
        name: ch.name,
        description: ch.description,
        type: ch.type,
        iconName: ch.iconName,
        isPinned: ch.isPinned,
        createdAt: ch.createdAt,
        threadCount: ch.threadCount + 1,
        unreadCount: ch.unreadCount,
      );
    }
    return thread;
  }

  Future<ForumCommentModel> createComment(ForumCommentModel comment) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockComments.add(comment);
    return comment;
  }

  Future<ForumThreadModel> likeThread(String threadId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _mockThreads.indexWhere((t) => t.id == threadId);
    if (idx != -1) {
      final t = _mockThreads[idx];
      _mockThreads[idx] = ForumThreadModel(
        id: t.id,
        channelId: t.channelId,
        title: t.title,
        body: t.body,
        authorId: t.authorId,
        authorName: t.authorName,
        attachmentUrls: t.attachmentUrls,
        isPinned: t.isPinned,
        isLocked: t.isLocked,
        likesCount: t.likesCount + 1,
        commentsCount: t.commentsCount,
        createdAt: t.createdAt,
        updatedAt: DateTime.now(),
      );
      return _mockThreads[idx];
    }
    throw Exception('Thread not found');
  }
}

final forumService = ForumService();
