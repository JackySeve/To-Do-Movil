import 'package:flutter/material.dart';
import 'task_input.dart';

class TaskColumn extends StatelessWidget {
  final String title;
  final List<String> tasks;
  final Function(String) onAddTask;
  final Function(String) onMoveTask;
  final Function(String, String, String) onEditTask;
  final Function(String) onRemoveTask;
  final bool showTaskInput;

  TaskColumn({
    required this.title,
    required this.tasks,
    required this.onAddTask,
    required this.onMoveTask,
    required this.onEditTask,
    required this.onRemoveTask,
    required this.showTaskInput,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task),
                    onTap: () => onEditTask(task, task, title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onRemoveTask(task),
                    ),
                  );
                },
              ),
            ),
            if (showTaskInput) TaskInput(onAddTask: onAddTask),
          ],
        ),
      ),
    );
  }
}
