import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String? id;
  String name;
  String type;
  String boardName;
  DateTime time;
  int priority;
  late Color colorPriority;

  Task({
    required this.name,
    required this.time,
    required this.priority,
    required this.type,
    required this.boardName,
  }) {
    switch (priority) {
      case 0:
        colorPriority = Colors.green;
        break;
      case 1:
        colorPriority = Colors.yellow;
        break;
      case 2:
        colorPriority = Colors.orange;
        break;
      case 3:
        colorPriority = Colors.red;
        break;
    }
  }

  Task.fromFirestore(String docId, Map<String, dynamic> data)
      : id = docId,
        name = data['name'],
        time = (data['time'] as Timestamp).toDate(),
        priority = data['priority'],
        type = data['type'],
        boardName = data['boardName'] {
    switch (priority) {
      case 0:
        colorPriority = Colors.green;
        break;
      case 1:
        colorPriority = Colors.yellow;
        break;
      case 2:
        colorPriority = Colors.orange;
        break;
      case 3:
        colorPriority = Colors.red;
        break;
    }
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'time': Timestamp.fromDate(time),
        'priority': priority,
        'type': type,
        'boardName': boardName
      };
}

Stream<List<Task>> tasksSnapshots(String docId, String columnName) {
  final db = FirebaseFirestore.instance;
  final stream = db.collection("Board/$docId/Tasks/").snapshots();
  return stream.map((querySnapshot) {
    List<Task> tasks = [];
    for (final doc in querySnapshot.docs) {
      Task task = Task.fromFirestore(doc.id, doc.data());
      if (task.type == columnName) {
        tasks.add(task);
      }
    }
    return tasks;
  });
}

void removeTask(BuildContext context, Task task) {
  final db = FirebaseFirestore.instance;
  db.doc("Board/${task.boardName}/Tasks/${task.id}").delete();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("${task.name} was deleted"),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "UNDO",
        onPressed: () {
          db.doc("Board/${task.boardName}/Tasks/${task.id}").set({
            'boardName': task.boardName,
            'name': task.name,
            'priority': task.priority,
            'time': task.time,
            'type': task.type,
          });
        },
      ),
    ),
  );
}

void updateTask(Task task)
{
  final db = FirebaseFirestore.instance;
  final doc = db.doc("Board/${task.boardName}/Tasks/${task.id}");
  doc.update({'type': task.type});
}