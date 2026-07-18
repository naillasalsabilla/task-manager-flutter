import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
  });

  String formatDeadline(String deadline) {
    final date = DateTime.tryParse(deadline);

    if (date == null) {
      return deadline;
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,

          onChanged: (_) {
            onToggle();
          },
        ),

        title: Text(
          task.title,

          style: TextStyle(
            fontWeight: FontWeight.bold,

            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 4),

            Text(
              task.description,

              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            const SizedBox(height: 6),

            if (task.deadline.isNotEmpty)
              Text(
                "Deadline: ${formatDeadline(task.deadline)}",

                style: TextStyle(
                  color: task.isCompleted
                      ? Colors.grey
                      : Colors.red,

                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 4),

            Text(
              task.isCompleted
                  ? "Status: Selesai"
                  : "Status: Belum Selesai",

              style: TextStyle(
                color: task.isCompleted
                    ? Colors.green
                    : Colors.orange,

                fontSize: 12,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            IconButton(
              icon: const Icon(Icons.edit),

              onPressed: onEdit,
            ),

            IconButton(
              icon: const Icon(Icons.delete),

              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}