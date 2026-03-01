import '../models/task_model.dart';

class TaskService {
  static final List<TaskModel> _mockTasks = [
    TaskModel(
      id: 'task-001',
      title: 'Prepare Q4 Campaign Deck',
      description: 'Create presentation slides for HDFC Bank Q4 digital campaign strategy.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdBy: 'emp-001',
      assignedTo: 'emp-001',
      clientId: 'client-002',
      tags: ['presentation', 'campaign'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    TaskModel(
      id: 'task-002',
      title: 'Client Meeting Follow-up',
      description: 'Send follow-up email to Infosys contact with action items from last meeting.',
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdBy: 'emp-001',
      assignedTo: 'emp-001',
      clientId: 'client-001',
      tags: ['email', 'follow-up'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: 'task-003',
      title: 'Market Research Report',
      description: 'Compile competitive analysis report for Reliance Retail expansion strategy.',
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      createdBy: 'emp-002',
      assignedTo: 'emp-002',
      clientId: 'client-003',
      tags: ['research', 'report'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TaskModel(
      id: 'task-004',
      title: 'Social Media Content Calendar',
      description: 'Prepare November social media content calendar for all active clients.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      createdBy: 'emp-003',
      assignedTo: 'emp-003',
      tags: ['social-media', 'content'],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    TaskModel(
      id: 'task-005',
      title: 'Bajaj Campaign Analytics',
      description: 'Analyze performance data from Q3 Bajaj Finserv insurance campaign.',
      priority: TaskPriority.low,
      status: TaskStatus.done,
      createdBy: 'emp-003',
      assignedTo: 'emp-003',
      clientId: 'client-004',
      tags: ['analytics'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    TaskModel(
      id: 'task-006',
      title: 'Onboarding TCS Account',
      description: 'Set up new account structure and onboarding materials for TCS.',
      priority: TaskPriority.urgent,
      status: TaskStatus.todo,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      createdBy: 'admin-001',
      assignedTo: 'emp-004',
      clientId: 'client-005',
      tags: ['onboarding'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: 'task-007',
      title: 'Weekly Team Sync Notes',
      description: 'Compile and distribute meeting notes from weekly team sync.',
      priority: TaskPriority.low,
      status: TaskStatus.done,
      createdBy: 'admin-001',
      assignedTo: 'emp-001',
      tags: ['meeting', 'notes'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    TaskModel(
      id: 'task-008',
      title: 'Budget Reconciliation',
      description: 'Reconcile October marketing spend vs. budget across all clients.',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      createdBy: 'admin-001',
      assignedTo: 'emp-002',
      tags: ['finance', 'budget'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  Future<List<TaskModel>> getTasks({String? userId, String? clientId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var tasks = List<TaskModel>.from(_mockTasks);
    if (userId != null) {
      tasks = tasks
          .where((t) => t.assignedTo == userId || t.createdBy == userId)
          .toList();
    }
    if (clientId != null) {
      tasks = tasks.where((t) => t.clientId == clientId).toList();
    }
    return tasks;
  }

  Future<TaskModel?> getTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockTasks.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return null;
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockTasks.add(task);
    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockTasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _mockTasks[idx] = task;
    }
    return task;
  }

  Future<void> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTasks.removeWhere((t) => t.id == taskId);
  }
}

final taskService = TaskService();
