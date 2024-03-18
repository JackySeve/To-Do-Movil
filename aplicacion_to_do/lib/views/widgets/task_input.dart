import 'package:flutter/material.dart';

class TaskInput extends StatelessWidget {
  final Function(String) onAddTask;

  TaskInput({required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Nueva tarea'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onAddTask(value);
                }
              },
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              // Se puede agregar lógica adicional aquí si es necesario
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
