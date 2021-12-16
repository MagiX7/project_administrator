import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/widgets/custom_button.dart';

enum TaskPriorities {
  low,
  medium,
  high,
  veryHigh,
}

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

  List<String> priorities = ["Low", "Medium", "High", "Very High"];

  TaskPriorities currentPriority = TaskPriorities.low;

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
        //backgroundColor: Colors.grey[850],
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 13, top: 15),
              child: Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 30),
                ),
              ),
              controller: textController,
              mouseCursor: MouseCursor.defer,
              onSubmitted: (text) {
                task.name = text;
                //textController.clear();
                //Navigator.of(context).pop(task);
              },
              autocorrect: false,
            ),
          ),
          const Divider(color: Colors.black),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text(
                "Select the priority",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildRadioButton("Low", TaskPriorities.low),
              buildRadioButton("Medium", TaskPriorities.medium),
              buildRadioButton("High", TaskPriorities.high),
              buildRadioButton("Very High", TaskPriorities.veryHigh),
            ],
          ),
          // This is for the offset
          Expanded(
            child: Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(task);
              },
              child: const CustomButton(
                text: "Create Task",
              ),
            ),
          )
        ],
      ),
    );
  }

  Column buildRadioButton(String text, TaskPriorities value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        Radio(
          value: value,
          groupValue: currentPriority,
          onChanged: (value) {
            setState(() {
              currentPriority = value as TaskPriorities;
              switch (currentPriority) {
                case TaskPriorities.low:
                  task.colorPriority = Colors.green;
                  task.priority = 0;
                  break;
                case TaskPriorities.medium:
                  task.colorPriority = Colors.yellow;
                  task.priority = 1;
                  break;
                case TaskPriorities.high:
                  task.colorPriority = Colors.orange;
                  task.priority = 2;
                  break;
                case TaskPriorities.veryHigh:
                  task.colorPriority = Colors.red;
                  task.priority = 3;
                  break;
              }
            });
          },
        ),
      ],
    );
  }
}
