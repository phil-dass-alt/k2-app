enum ForumChannelType { announcement, general, wins, mediaLeads, clientHelp, learning }

class ForumChannelModel {
  final String id;
  final String name;
  final String description;
  final ForumChannelType type;
  final String iconName;
  final bool isPinned;
  final DateTime createdAt;
  final int threadCount;
  final int unreadCount;

  const ForumChannelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.iconName,
    this.isPinned = false,
    required this.createdAt,
    this.threadCount = 0,
    this.unreadCount = 0,
  });

  factory ForumChannelModel.fromJson(Map<String, dynamic> json) {
    return ForumChannelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: ForumChannelType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ForumChannelType.general,
      ),
      iconName: json['iconName'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      threadCount: json['threadCount'] as int? ?? 0,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'iconName': iconName,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'threadCount': threadCount,
      'unreadCount': unreadCount,
    };
  }
}
