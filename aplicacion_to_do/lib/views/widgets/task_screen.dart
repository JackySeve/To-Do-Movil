import 'package:flutter/material.dart';
import 'task_column.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<String> pendingTasks = [];
  List<String> inProgressTasks = [];
  List<String> completedTasks = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController descrptionController = TextEditingController();

  void addTask(String task) {
    setState(() {
      pendingTasks.add(task);
    });
  }

  void moveTask(String task, List<String> source, List<String> destination) {
    setState(() {
      source.remove(task);
      destination.add(task);
    });
  }

  void removeTask(String task) {
    setState(() {
      pendingTasks.remove(task);
      inProgressTasks.remove(task);
      completedTasks.remove(task);
    });
  }

  void editTask(String oldTask, String newTask, String status) async {
    nameController.text = newTask;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar tarea'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: descrptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: null,
                  ),
                  DropdownButton<String>(
                    value: status,
                    items: <String>['Pendiente', 'En desarrollo', 'Completado']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final indexPending = pendingTasks.indexOf(oldTask);
                  final indexInProgress = inProgressTasks.indexOf(oldTask);
                  final indexCompleted = completedTasks.indexOf(oldTask);

                  String originalStatus = '';
                  int originalIndex = -1;

                  if (indexPending != -1) {
                    originalStatus = 'Pendiente';
                    originalIndex = indexPending;
                  } else if (indexInProgress != -1) {
                    originalStatus = 'En desarrollo';
                    originalIndex = indexInProgress;
                  } else if (indexCompleted != -1) {
                    originalStatus = 'Completado';
                    originalIndex = indexCompleted;
                  }

                  if (originalStatus != status) {
                    if (originalStatus == 'Pendiente') {
                      pendingTasks.removeAt(originalIndex);
                    } else if (originalStatus == 'En desarrollo') {
                      inProgressTasks.removeAt(originalIndex);
                    } else if (originalStatus == 'Completado') {
                      completedTasks.removeAt(originalIndex);
                    }

                    if (status == 'Pendiente') {
                      pendingTasks.add(nameController.text);
                    } else if (status == 'En desarrollo') {
                      inProgressTasks.add(nameController.text);
                    } else if (status == 'Completado') {
                      completedTasks.add(nameController.text);
                    }
                  } else {
                    if (originalStatus == 'Pendiente') {
                      pendingTasks[originalIndex] = nameController.text;
                    } else if (originalStatus == 'En desarrollo') {
                      inProgressTasks[originalIndex] = nameController.text;
                    } else if (originalStatus == 'Completado') {
                      completedTasks[originalIndex] = nameController.text;
                    }
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TaskColumn(
              title: 'Pendiente',
              tasks: pendingTasks,
              onAddTask: addTask,
              onMoveTask: (task) =>
                  moveTask(task, pendingTasks, inProgressTasks),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: true,
            ),
            TaskColumn(
              title: 'En desarrollo',
              tasks: inProgressTasks,
              onAddTask: (task) {},
              onMoveTask: (task) =>
                  moveTask(task, inProgressTasks, completedTasks),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: true,
            ),
            TaskColumn(
              title: 'Completado',
              tasks: completedTasks,
              onAddTask: (task) {},
              onMoveTask: (task) =>
                  moveTask(task, inProgressTasks, completedTasks),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: true,
            ),
          ],
        ),
      ),
    );
  }
}
