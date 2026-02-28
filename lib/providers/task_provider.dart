import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'auth_provider.dart';

class TasksState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? error;
  final TaskStatus? filterStatus;

  const TasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  TasksState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
    TaskStatus? filterStatus,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }

  List<TaskModel> get filteredTasks {
    if (filterStatus == null) return tasks;
    return tasks.where((t) => t.status == filterStatus).toList();
  }
}

class TasksNotifier extends StateNotifier<TasksState> {
  final TaskService _taskService;
  final String? _userId;

  TasksNotifier(this._taskService, this._userId)
      : super(const TasksState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final tasks = await _taskService.getTasks(userId: _userId);
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> createTask(TaskModel task) async {
    try {
      final newTask = await _taskService.createTask(task);
      state = state.copyWith(tasks: [...state.tasks, newTask]);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    try {
      final updated = await _taskService.updateTask(task);
      final updatedList = state.tasks.map((t) => t.id == updated.id ? updated : t).toList();
      state = state.copyWith(tasks: updatedList);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      state = state.copyWith(tasks: state.tasks.where((t) => t.id != taskId).toList());
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  void setFilter(TaskStatus? status) {
    if (status == null) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterStatus: status);
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>((ref) {
  final authState = ref.watch(authProvider);
  return TasksNotifier(taskService, authState.user?.id);
});
