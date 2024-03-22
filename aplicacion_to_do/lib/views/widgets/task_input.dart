import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final Function(String) onAddTask;

  TaskInput({required this.onAddTask});

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: 'Nueva tarea'),
              onSubmitted: (value) {
                _addTask(value);
              },
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              _addTask(_textEditingController.text);
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _addTask(String value) {
    if (value.isNotEmpty) {
      widget.onAddTask(value);
      _textEditingController.clear();
    }
  }
}
