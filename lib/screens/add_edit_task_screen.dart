import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descController.text = widget.task!.description;
      selectedDate = widget.task!.date;
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveTask() {
    if (titleController.text.isEmpty) return;

    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task == null) {
      // ADD TASK
      provider.addTask(
        Task(
          id: Random().nextDouble().toString(),
          title: titleController.text,
          description: descController.text,
          date: selectedDate,
        ),
      );
    } else {
      // UPDATE TASK
      provider.updateTask(
        widget.task!.id,
        titleController.text,
        descController.text,
        selectedDate,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 20),

            // 📅 DATE DISPLAY
            Text(
              "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // 📅 DATE PICKER BUTTON
            ElevatedButton(
              onPressed: pickDate,
              child: const Text("Pick Date"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
