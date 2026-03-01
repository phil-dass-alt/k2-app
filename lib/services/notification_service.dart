import '../models/notification_model.dart';

class NotificationService {
  static final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 'notif-001',
      userId: 'emp-001',
      title: 'Task Due Tomorrow',
      body: 'Your task "Prepare Q4 Campaign Deck" is due tomorrow.',
      type: NotificationType.task,
      data: {'taskId': 'task-001'},
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationModel(
      id: 'notif-002',
      userId: 'emp-001',
      title: 'Meeting in 30 minutes',
      body: 'HDFC Campaign Review starts in 30 minutes.',
      type: NotificationType.meeting,
      data: {'meetingId': 'meet-001'},
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    NotificationModel(
      id: 'notif-003',
      userId: 'emp-001',
      title: 'K2 Wins Best Agency Award! 🏆',
      body: 'K2 Communications has been recognized as the Best B2B Agency 2024.',
      type: NotificationType.announcement,
      data: {'channelId': 'ch-001', 'threadId': 'thread-001'},
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      id: 'notif-004',
      userId: 'emp-001',
      title: 'Breaking News Alert',
      body: 'India\'s AI Startup Ecosystem Reaches \$5B Valuation',
      type: NotificationType.news,
      data: {'articleId': 'news-001'},
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-005',
      userId: 'emp-001',
      title: 'Account Activated',
      body: 'Your K2 Communications account has been activated by admin.',
      type: NotificationType.system,
      data: {},
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<List<NotificationModel>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockNotifications.where((n) => n.userId == userId).toList();
  }

  Future<NotificationModel> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      _mockNotifications[idx] = _mockNotifications[idx].copyWith(isRead: true);
      return _mockNotifications[idx];
    }
    throw Exception('Notification not found');
  }

  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _mockNotifications.length; i++) {
      if (_mockNotifications[i].userId == userId) {
        _mockNotifications[i] = _mockNotifications[i].copyWith(isRead: true);
      }
    }
  }

  Future<void> clearAll(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockNotifications.removeWhere((n) => n.userId == userId);
  }

  int getUnreadCount(String userId) {
    return _mockNotifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }
}

final notificationService = NotificationService();
