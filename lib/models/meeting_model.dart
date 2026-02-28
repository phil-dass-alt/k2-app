class MeetingModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final List<String> attendees;
  final String? clientId;
  final int reminderMinutes;
  final bool isCompleted;
  final String createdBy;
  final DateTime createdAt;

  const MeetingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.attendees = const [],
    this.clientId,
    this.reminderMinutes = 30,
    this.isCompleted = false,
    required this.createdBy,
    required this.createdAt,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      attendees: List<String>.from(json['attendees'] ?? []),
      clientId: json['clientId'] as String?,
      reminderMinutes: json['reminderMinutes'] as int? ?? 30,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'attendees': attendees,
      'clientId': clientId,
      'reminderMinutes': reminderMinutes,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MeetingModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    List<String>? attendees,
    String? clientId,
    int? reminderMinutes,
    bool? isCompleted,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return MeetingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      clientId: clientId ?? this.clientId,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
