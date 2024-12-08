import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime dueDate;

  @HiveField(3)
  int dueTime; // Mengganti TimeOfDay dengan int

  @HiveField(4)
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required TimeOfDay dueTime,
    this.isCompleted = false,
  }) : dueTime = dueTime.hour * 60 + dueTime.minute;

  TimeOfDay getDueTime() {
    return TimeOfDay(hour: dueTime ~/ 60, minute: dueTime % 60);
  }

  void setDueTime(TimeOfDay time) {
    dueTime = time.hour * 60 + time.minute;
  }
}
