import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late TextEditingController textController;
  Task task = Task(
      name: "Default",
      time: DateTime.now(),
      priority: 2,
      type: "null",
      boardName: "null");

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.grey[850],
      ),
      body: Column(
        children: [
          TextField(
            controller: textController,
            onSubmitted: (text) {
              task.name = text;
              Navigator.of(context).pop(task);
            },
          )
        ],
      ),
    );
  }
}
