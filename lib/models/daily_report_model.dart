class DailyReportModel {
  final String id;
  final String userId;
  final DateTime date;
  final String summary;
  final List<String> tasksCompleted;
  final List<String> meetingsHeld;
  final String challenges;
  final String nextDayPlan;
  final DateTime createdAt;

  const DailyReportModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.summary,
    this.tasksCompleted = const [],
    this.meetingsHeld = const [],
    required this.challenges,
    required this.nextDayPlan,
    required this.createdAt,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      summary: json['summary'] as String,
      tasksCompleted: List<String>.from(json['tasksCompleted'] ?? []),
      meetingsHeld: List<String>.from(json['meetingsHeld'] ?? []),
      challenges: json['challenges'] as String,
      nextDayPlan: json['nextDayPlan'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'summary': summary,
      'tasksCompleted': tasksCompleted,
      'meetingsHeld': meetingsHeld,
      'challenges': challenges,
      'nextDayPlan': nextDayPlan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
