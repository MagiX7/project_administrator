import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/screens/create_task_screen.dart';
import 'package:project_administrator/widgets/column_tile.dart';

class ColumnScreen extends StatefulWidget {
  String name;

  ColumnScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<ColumnScreen> createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen>
    with AutomaticKeepAliveClientMixin<ColumnScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    tasks = [Task(name: "Add your tasks!", priority: 5, time: DateTime.now())];
    super.initState();
  }

  void newTask(Task task) {
    final db = FirebaseFirestore.instance;
    // TODO: This should get the board the column belongs to and put it in here
    final doc = db.collection("Board/New Board/Tasks/").add({
      'name': task.name,
      'time': DateTime.now(),
      'priority': 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: tasksSnapshots(widget.name),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ErrorWidget("Could not connect to Firestore");
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              // TODO: Handle this case.
              break;
          }
          return Container(
              child: tasks.isEmpty
                  ? Container(
                      color: Colors.red,
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                return ColumnTile(task: tasks[index]);
                              },
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateTaskScreen()))
                                    .then((value) {
                                  newTask(value);
                                  setState(() {
                                    tasks.add(value);
                                  });
                                });
                              },
                              child: const Text("Add Task"))
                        ],
                      ),
                    ));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
