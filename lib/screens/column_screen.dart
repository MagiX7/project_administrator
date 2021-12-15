import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/screens/create_task_screen.dart';
import 'package:project_administrator/widgets/column_tile.dart';
import 'package:project_administrator/widgets/custom_button.dart';

class ColumnScreen extends StatefulWidget {
  String name;
  String boardName;
  PageController? pageController;

  ColumnScreen(
      {Key? key,
      required this.name,
      required this.boardName,
      this.pageController})
      : super(key: key);

  @override
  State<ColumnScreen> createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen>
    with AutomaticKeepAliveClientMixin<ColumnScreen> {
  void newTask(Task task) {
    final db = FirebaseFirestore.instance;
    db.collection("Board/${widget.boardName}/Tasks/").add({
      'name': task.name,
      'time': DateTime.now(),
      'priority': 0,
      'type': task.type,
      'boardName': task.boardName
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
                return buildScreen(snapshot);
              case ConnectionState.done:
                // TODO: Handle this case.
                break;
            }
            return Container();
          }),
    );
  }

  Widget buildScreen(AsyncSnapshot<List<Task>> snapshot) {
    return Container(
      color: Colors.white60,
      child: DragTarget(
        builder: (BuildContext context, List<Object?> candidateData,
            List<dynamic> rejectedData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: columnName(),
              ),
              Expanded(
                child: Stack(children: [
                  framework(snapshot),
                  addTaskButton(),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Container addTaskButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const CreateTaskScreen()))
              .then((value) {
            value = value as Task;
            value.type = widget.name;
            value.boardName = widget.boardName;
            newTask(value);
          });
        },
        child: const CustomButton(),
      ),
    );
  }

  Container framework(AsyncSnapshot<List<Task>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, offset: Offset(-1, -5), blurRadius: 3),
          BoxShadow(color: Colors.black38, offset: Offset(1, 5), blurRadius: 3)
        ],
      ),
      child: buildList(snapshot),
    );
  }

  Text columnName() {
    return Text(
      widget.name,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  ListView buildList(AsyncSnapshot<List<Task>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return buildDraggable(snapshot, index);
      },
    );
  }

  Draggable<Object> buildDraggable(
      AsyncSnapshot<List<Task>> snapshot, int index) {
    return Draggable(
      child: ColumnTile(
        task: snapshot.data![index],
        heightTile: 30,
        widthTile: 20,
      ),
      childWhenDragging: ColumnTile(
        heightTile: 30,
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
  }

  @override
  bool get wantKeepAlive => true;
}
