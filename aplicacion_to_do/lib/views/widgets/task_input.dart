import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final Function(String, String) onAddTask;

  TaskInput({required this.onAddTask});

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nombre'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Descripción'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onAddTask(
                  _nameController.text, _descriptionController.text);
              _nameController.clear();
              _descriptionController.clear();
            },
            child: Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
