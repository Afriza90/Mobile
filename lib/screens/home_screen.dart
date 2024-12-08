// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:todo_list_app/models/task.dart';

class HomeScreen extends StatelessWidget {
  final Function onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () => onThemeChanged(),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
          child: const Text('Add Task'),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Task Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Task Description'),
            ),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(hintText: 'Due Date'),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  dateController.text = DateFormat.yMd().format(selectedDate);
                }
              },
            ),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: const InputDecoration(hintText: 'Due Time'),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  timeController.text = selectedTime.format(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();
              final date = dateController.text.trim();
              final time = timeController.text.trim();

              if (title.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
                final parsedDate = DateFormat.yMd().parse(date);
                final parsedTime = DateFormat.jm().parse(time);
                final newTask = Task(
                  title: title,
                  description: description,
                  dueDate: parsedDate,
                  dueTime: TimeOfDay.fromDateTime(parsedTime),
                );
                Hive.box<Task>('tasks').add(newTask);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
