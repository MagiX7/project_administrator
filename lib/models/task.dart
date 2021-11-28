import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String name;
  DateTime time;
  int priority;

  Task(this.name, this.time, this.priority);

  Task.fromFirestore(Map<String, dynamic> data)
      : name = data['name'],
        time = (data['timestamp'] as Timestamp).toDate(),
        priority = data['priority'];

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'time': Timestamp.fromDate(time),
        'priority': priority,
      };
}

Stream<List<Task>> columnSnapshots() {
  final db = FirebaseFirestore.instance;
  final stream = db
      .collection("TaskStatusColumn")
      .orderBy('timestamp', descending: true)
      .snapshots();
  return stream.map((QuerySnapshot<Map<String, dynamic>> qs) {
    final docs = qs.docs;
    List<Task> tasks =
        docs.map((QueryDocumentSnapshot<Map<String, dynamic>> ds) {
      final data = ds.data();
      return Task.fromFirestore(data);
    }).toList();
    return tasks;
  });
}
