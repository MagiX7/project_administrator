import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Task {
  String? id;
  String name;
  String type;
  String boardName;
  DateTime time;
  int priority;

  Task({
    required this.name,
    required this.time,
    required this.priority,
    required this.type,
    required this.boardName,
  });

  Task.fromFirestore(String docId, Map<String, dynamic> data)
      : id = docId,
        name = data['name'],
        time = (data['time'] as Timestamp).toDate(),
        priority = data['priority'],
        type = data['type'],
        boardName = data['boardName'];

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

void removeTask(Task task) {
  final db = FirebaseFirestore.instance;
  db.doc("Board/${task.boardName}/Tasks/${task.id}").delete();
}
