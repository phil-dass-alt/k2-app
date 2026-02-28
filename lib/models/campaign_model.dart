enum CampaignStatus { planning, active, paused, completed }

class CampaignMilestone {
  final String title;
  final bool isCompleted;
  final DateTime? targetDate;

  const CampaignMilestone({
    required this.title,
    this.isCompleted = false,
    this.targetDate,
  });

  factory CampaignMilestone.fromJson(Map<String, dynamic> json) {
    return CampaignMilestone(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'targetDate': targetDate?.toIso8601String(),
    };
  }
}

class CampaignModel {
  final String id;
  final String title;
  final String clientId;
  final CampaignStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final List<CampaignMilestone> milestones;
  final List<String> assetUrls;
  final String? notes;
  final String createdBy;
  final DateTime createdAt;

  const CampaignModel({
    required this.id,
    required this.title,
    required this.clientId,
    required this.status,
    required this.startDate,
    this.endDate,
    this.milestones = const [],
    this.assetUrls = const [],
    this.notes,
    required this.createdBy,
    required this.createdAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as String,
      title: json['title'] as String,
      clientId: json['clientId'] as String,
      status: CampaignStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CampaignStatus.planning,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      milestones: (json['milestones'] as List<dynamic>? ?? [])
          .map((e) => CampaignMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetUrls: List<String>.from(json['assetUrls'] ?? []),
      notes: json['notes'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'clientId': clientId,
      'status': status.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'milestones': milestones.map((e) => e.toJson()).toList(),
      'assetUrls': assetUrls,
      'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
