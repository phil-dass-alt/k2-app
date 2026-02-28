enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, done, cancelled }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final String createdBy;
  final String? assignedTo;
  final String? clientId;
  final List<String> tags;
  final List<DateTime> reminders;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    required this.createdBy,
    this.assignedTo,
    this.clientId,
    this.tags = const [],
    this.reminders = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.todo,
      ),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdBy: json['createdBy'] as String,
      assignedTo: json['assignedTo'] as String?,
      clientId: json['clientId'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      reminders: (json['reminders'] as List<dynamic>? ?? [])
          .map((e) => DateTime.parse(e as String))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'dueDate': dueDate?.toIso8601String(),
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'clientId': clientId,
      'tags': tags,
      'reminders': reminders.map((e) => e.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    String? createdBy,
    String? assignedTo,
    String? clientId,
    List<String>? tags,
    List<DateTime>? reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      clientId: clientId ?? this.clientId,
      tags: tags ?? this.tags,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
