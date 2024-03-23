import 'package:flutter/material.dart';
import 'task.dart';
import 'task_column.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = []; // Utilizaremos una lista única para todas las tareas

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addTask(String name, String description) {
    setState(() {
      tasks
          .add(Task(name: name, description: description, status: 'Pendiente'));
    });
  }

  void moveTask(Task task, String newStatus) {
    setState(() {
      task.status = newStatus;
    });
  }

  void removeTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  void editTask(Task task, String newName, String newStatus,
      String newDescription) async {
    nameController.text = newName;
    descriptionController.text = newDescription;
    String? dropdownValue = newStatus;
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
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: null,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    items: <String>['Pendiente', 'En desarrollo', 'Completado']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
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
                  task.name = nameController.text;
                  task.description = descriptionController.text;
                  task.status = dropdownValue!;
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

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar nueva tarea'),
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
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    maxLines: null,
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
                if (nameController.text.isNotEmpty) {
                  addTask(nameController.text, descriptionController.text);
                  nameController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Agregar'),
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
              tasks: tasks.where((task) => task.status == 'Pendiente').toList(),
              onAddTask: addTask,
              onMoveTask: (task) =>
                  (String newStatus) => moveTask(task, newStatus),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: false,
            ),
            TaskColumn(
              title: 'En desarrollo',
              tasks: tasks
                  .where((task) => task.status == 'En desarrollo')
                  .toList(),
              onAddTask: addTask,
              onMoveTask: (task) =>
                  (String newStatus) => moveTask(task, newStatus),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: false,
            ),
            TaskColumn(
              title: 'Completado',
              tasks:
                  tasks.where((task) => task.status == 'Completado').toList(),
              onAddTask: addTask,
              onMoveTask: (task) =>
                  (String newStatus) => moveTask(task, newStatus),
              onEditTask: editTask,
              onRemoveTask: removeTask,
              showTaskInput: false,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskDialog();
        },
        tooltip: 'Agregar tarea',
        child: Icon(Icons.add),
      ),
    );
  }
}
