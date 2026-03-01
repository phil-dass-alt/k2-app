class ForumThreadModel {
  final String id;
  final String channelId;
  final String title;
  final String body;
  final String authorId;
  final String authorName;
  final List<String> attachmentUrls;
  final bool isPinned;
  final bool isLocked;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ForumThreadModel({
    required this.id,
    required this.channelId,
    required this.title,
    required this.body,
    required this.authorId,
    required this.authorName,
    this.attachmentUrls = const [],
    this.isPinned = false,
    this.isLocked = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ForumThreadModel.fromJson(Map<String, dynamic> json) {
    return ForumThreadModel(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      isPinned: json['isPinned'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelId': channelId,
      'title': title,
      'body': body,
      'authorId': authorId,
      'authorName': authorName,
      'attachmentUrls': attachmentUrls,
      'isPinned': isPinned,
      'isLocked': isLocked,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ForumCommentModel {
  final String id;
  final String threadId;
  final String authorId;
  final String authorName;
  final String body;
  final int likesCount;
  final DateTime createdAt;

  const ForumCommentModel({
    required this.id,
    required this.threadId,
    required this.authorId,
    required this.authorName,
    required this.body,
    this.likesCount = 0,
    required this.createdAt,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    return ForumCommentModel(
      id: json['id'] as String,
      threadId: json['threadId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      body: json['body'] as String,
      likesCount: json['likesCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'authorId': authorId,
      'authorName': authorName,
      'body': body,
      'likesCount': likesCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
