import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  DateTime? selectedDeadline;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.task.title,
    );

    descriptionController = TextEditingController(
      text: widget.task.description,
    );

    if (widget.task.deadline.isNotEmpty) {
      selectedDeadline = DateTime.tryParse(
        widget.task.deadline,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDeadline = pickedDate;
      });
    }
  }

  Future<void> updateTask() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Judul task wajib diisi"),
    ),
  );

  return;
}

    final updatedTask = Task(
      id: widget.task.id,
      title: title,
      description: description,
      deadline: selectedDeadline?.toIso8601String() ?? '',
    );

    await Provider.of<TaskProvider>(
      context,
      listen: false,
    ).updateTask(updatedTask);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Judul Task",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,

              title: Text(
                selectedDeadline == null
                    ? "Pilih Deadline"
                    : "Deadline: "
                      "${selectedDeadline!.day}/"
                      "${selectedDeadline!.month}/"
                      "${selectedDeadline!.year}",
              ),

              trailing: const Icon(
                Icons.calendar_today,
              ),

              onTap: selectDeadline,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: updateTask,

                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}