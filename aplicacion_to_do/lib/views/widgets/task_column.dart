import 'package:flutter/material.dart';
import 'task.dart';
import 'task_input.dart';

class TaskColumn extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Function(String, String) onAddTask;
  final Function(Task) onMoveTask;
  final Function(Task, String, String, String) onEditTask;
  final Function(Task) onRemoveTask;
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
                    title: Text(task.name),
                    subtitle: Text(task.description),
                    onTap: () =>
                        onEditTask(task, task.name, title, task.description),
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
