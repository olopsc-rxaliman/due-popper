import 'package:duepopper/hive/hive_box_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveFunctions {
  static final taskBox = Hive.box(taskBoxName);

  // Create
  static addTask(Map data) {
    taskBox.add(data);
  }

  // Retrieve
  static List getAllTasks() {
    final data = taskBox.keys.map((key) {
      final value = taskBox.get(key);
      return {
        'key': key,
        'title': value['title'],
        'description': value['description'],
        'checked': value['checked'],
      };
    }).toList();

    return data.toList();
  }
  static Map getTask(int key) => taskBox.get(key);

  // Update
  static modifyTask(int key, Map data) {
    taskBox.put(key, data);
  }
  static updateTaskStatus(int key) {
    final data = taskBox.get(key);
    taskBox.put(key, {
      'key': key,
      'title': data['title'],
      'description': data['description'],
      'checked': !data['checked'],
    });
  }

  // Delete
  static deleteTask(int key) => taskBox.delete(key);
  static deleteAllTasks() => taskBox.deleteAll(taskBox.keys);
}