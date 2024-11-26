import 'package:flutter/foundation.dart';
import '../utils/data.dart';

class Task extends ChangeNotifier {
  String id;
  String name;  
  String description;
  int points; 
  String imageUrl;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.imageUrl,
    this.isCompleted = false,
    this.dueDate,
  });
}

class TaskProvider with ChangeNotifier {  
  final List<Task> _tasks = tasksData.sublist(tasksData.length -3).cast<Task>(); 
  List<Task> get tasks => _tasks;

  Future<void> refreshTasks() async {    
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task? updatedTask) {
    if (updatedTask != null){
      final existingTaskIndex = _tasks.indexWhere((t) => t.id == updatedTask.id);
      _tasks[existingTaskIndex] = updatedTask;
    }
    notifyListeners();    
  }

  void removeTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}


