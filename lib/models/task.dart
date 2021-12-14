import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Task {
  String name;
  String type;
  DateTime time;
  int priority;

  Task(
      {required this.name,
      required this.time,
      required this.priority,
      required this.type});

  Task.fromFirestore(Map<String, dynamic> data)
      : name = data['name'],
        time = (data['time'] as Timestamp).toDate(),
        priority = data['priority'],
        type = data['type'];

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'time': Timestamp.fromDate(time),
        'priority': priority,
        'type': type,
      };
}

Stream<List<Task>> tasksSnapshots(String docId) {
  final db = FirebaseFirestore.instance;
  final stream = db.collection("Board/$docId/Tasks/").snapshots();
  return stream.map((querySnapshot) {
    List<Task> tasks = [];
    for (final doc in querySnapshot.docs) {
      tasks.add(Task.fromFirestore(doc.data()));
    }
    return tasks;
  });
}
