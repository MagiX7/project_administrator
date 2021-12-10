import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/screens/create_task_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tasks.isEmpty
          ? Container(
              color: Colors.red,
            )
          : Column(
              children: [
                Text(widget.name),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tasks[index].name),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const CreateTaskScreen()))
                          .then(
                            (value) => setState(() {
                              tasks.add(value);
                            }),
                          );
                    },
                    child: const Text("Add Task"))
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
