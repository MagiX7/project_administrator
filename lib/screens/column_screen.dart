import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';

class ColumnScreen extends StatelessWidget {
  String name;
  List<Task> tasks = [Task(name: "OLA", priority: 5, time: DateTime.now())];
  ColumnScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tasks.isEmpty
          ? Container(
              color: Colors.red,
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].name),
                );
              }),
    );
  }
}
