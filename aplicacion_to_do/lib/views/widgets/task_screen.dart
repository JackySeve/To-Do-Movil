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

  void editTask(String oldTask, String newTask, String status) async {
    // Aquí puedes usar nameController
    nameController.text = newTask;
    // Otro código de la función editTask
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

                  // Guardar el estado original de la tarea y su índice
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

                  // Si el estado original es diferente al nuevo estado, eliminar la tarea del estado anterior y agregarla al nuevo estado
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
                    // Si el estado original es el mismo que el nuevo estado, simplemente cambiar el nombre de la tarea
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
              showTaskInput: true, // Mostrar el campo de texto en "Pendiente"
            ),
            TaskColumn(
              title: 'En desarrollo',
              tasks: inProgressTasks,
              onAddTask: (task) {
                // No se agrega el widget TaskInput aquí
              },
              onMoveTask: (task) =>
                  moveTask(task, inProgressTasks, completedTasks),
              onEditTask: editTask,
              showTaskInput: false,
            ),
            TaskColumn(
              title: 'Completado',
              tasks: completedTasks,
              onAddTask: (task) {
                // No se agrega el widget TaskInput aquí
              },
              onMoveTask: (task) {
                // No se agrega el widget TaskInput aquí
              },
              onEditTask: editTask,
              showTaskInput: false,
            ),
          ],
        ),
      ),
    );
  }
}
