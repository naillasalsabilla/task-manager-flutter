import 'package:flutter/material.dart';

import '../models/task.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  bool _isLoading = false;

  String _filter = 'all';

  String _searchQuery = '';

  List<Task> get tasks => _tasks;

  bool get isLoading => _isLoading;

  String get filter => _filter;

  String get searchQuery => _searchQuery;

  // =========================
  // LOAD TASK
  // =========================

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await DatabaseHelper.instance.getTasks();

    _isLoading = false;
    notifyListeners();
  }

  // =========================
  // SEARCH
  // =========================

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();

    notifyListeners();
  }

  // =========================
  // FILTER + SEARCH
  // =========================

  List<Task> get filteredTasks {
    List<Task> result = _tasks;

    if (_filter == 'completed') {
      result = result
          .where((task) => task.isCompleted)
          .toList();
    }

    if (_filter == 'incomplete') {
      result = result
          .where((task) => !task.isCompleted)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
            task.description
                .toLowerCase()
                .contains(_searchQuery);
      }).toList();
    }

    return result;
  }

  // =========================
  // STATISTIK TASK
  // =========================

  int get totalTasks {
    return _tasks.length;
  }

  int get completedTasks {
    return _tasks
        .where((task) => task.isCompleted)
        .length;
  }

  int get incompleteTasks {
    return _tasks
        .where((task) => !task.isCompleted)
        .length;
  }

  // =========================
  // FILTER
  // =========================

  bool isFilterActive(String filterName) {
    return _filter == filterName;
  }

  void setFilter(String filter) {
    _filter = filter;

    notifyListeners();
  }

  // =========================
  // ADD TASK
  // =========================

  Future<void> addTask(Task task) async {
    final id = await DatabaseHelper.instance.insertTask(task);

    if (task.deadline.isNotEmpty) {
      await NotificationService.scheduleTaskNotification(
        id: id,
        title: task.title,
        deadline: DateTime.parse(task.deadline),
      );
    }

    await loadTasks();
  }

  // =========================
  // UPDATE TASK
  // =========================

  Future<void> updateTask(Task task) async {
  if (task.id != null) {
    await NotificationService.cancelTaskNotification(
      task.id!,
    );
  }

  await DatabaseHelper.instance.updateTask(task);

  if (task.deadline.isNotEmpty && task.id != null) {
    await NotificationService.scheduleTaskNotification(
      id: task.id!,
      title: task.title,
      deadline: DateTime.parse(task.deadline),
    );
  }

  await loadTasks();
}

  // =========================
  // TOGGLE TASK
  // =========================

  Future<void> toggleTask(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      isCompleted: !task.isCompleted,
    );

    await DatabaseHelper.instance.updateTask(updatedTask);

    if (updatedTask.isCompleted && updatedTask.id != null) {
      await NotificationService.cancelTaskNotification(
        updatedTask.id!,
      );
    }

    if (!updatedTask.isCompleted &&
        updatedTask.deadline.isNotEmpty &&
        updatedTask.id != null) {
      await NotificationService.scheduleTaskNotification(
        id: updatedTask.id!,
        title: updatedTask.title,
        deadline: DateTime.parse(updatedTask.deadline),
      );
    }

    await loadTasks();
  }

  // =========================
  // DELETE TASK
  // =========================

  Future<void> deleteTask(int id) async {
    await NotificationService.cancelTaskNotification(id);

    await DatabaseHelper.instance.deleteTask(id);

    await loadTasks();
  }
}