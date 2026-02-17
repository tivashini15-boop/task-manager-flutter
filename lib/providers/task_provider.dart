import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> get tasks => _taskBox.values.toList();

  void addTask(Task task) {
    _taskBox.put(task.id, task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _taskBox.delete(id);
    notifyListeners();
  }

  void updateTask(String id, String title, String description, DateTime date) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.title = title;
      task.description = description;
      task.date = date;
      task.save();
      notifyListeners();
    }
  }
}
