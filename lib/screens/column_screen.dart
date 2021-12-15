import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/screens/create_task_screen.dart';
import 'package:project_administrator/widgets/column_tile.dart';
import 'package:project_administrator/widgets/custom_button.dart';

class ColumnScreen extends StatefulWidget {
  String name;
  String boardName;

  ColumnScreen({Key? key, required this.name, required this.boardName})
      : super(key: key);

  @override
  State<ColumnScreen> createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen>
    with AutomaticKeepAliveClientMixin<ColumnScreen> {
  void newTask(Task task) {
    final db = FirebaseFirestore.instance;
    final doc = db.collection("Board/${widget.boardName}/Tasks/").add({
      'name': task.name,
      'time': DateTime.now(),
      'priority': 0,
      'type': task.type
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: tasksSnapshots(widget.boardName, widget.name),
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return ErrorWidget("Could not connect to Firestore");
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return Builder(builder: (context) {
                  return Container(
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
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Draggable(
                                child: ColumnTile(
                                  task: snapshot.data![index],
                                  heightTile: 30,
                                  widthTile: 200,
                                ),
                                childWhenDragging: ColumnTile(
                                  heightTile: 50,
                                  widthTile: 50,
                                  task: snapshot.data![index],
                                ),
                                feedback: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ColumnTile(
                                    heightTile: 10,
                                    widthTile: 50,
                                    task: snapshot.data![index],
                                    colorTile: Colors.teal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateTaskScreen()))
                                .then((value) {
                              value = value as Task;
                              value.type = widget.name;
                              newTask(value);
                            });
                          },
                          child: const CustomButton(),
                        )
                      ],
                    ),
                  );
                });
              case ConnectionState.done:
                // TODO: Handle this case.
                break;
            }
            return Container();
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
