import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/board.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/screens/create_task_screen.dart';
import 'package:project_administrator/widgets/column_tile.dart';
import 'package:project_administrator/widgets/custom_button.dart';

class ColumnScreen extends StatefulWidget {
  String name;
  //String boardName;
  PageController? pageController;
  //String? backgroundImage;
  int timer = 0;
  Board ownerBoard;

  ColumnScreen({
    Key? key,
    required this.name,
    required this.ownerBoard,
    this.pageController,
  }) : super(key: key);

  _ColumnScreenState columnState = _ColumnScreenState();

  @override
  State<ColumnScreen> createState() => columnState;
}

class _ColumnScreenState extends State<ColumnScreen>
    with AutomaticKeepAliveClientMixin<ColumnScreen> {
  void newTask(Task task) {
    final db = FirebaseFirestore.instance;
    db.collection("Board/${widget.ownerBoard.name}/Tasks/").add({
      'name': task.name,
      'time': DateTime.now(),
      'priority': task.priority,
      'type': task.type,
      'boardName': task.boardName
    });
  }

  void updateBackgroundImage(String newImageName) {
    setState(() {
      widget.ownerBoard.columnImage = newImageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: tasksSnapshots(widget.ownerBoard.firebaseID!, widget.name),
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
      // color: Colors.white60,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/${widget.backgroundImage}'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: DragTarget(builder: (BuildContext context,
          List<Object?> candidateData, List<dynamic> rejectedData) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade700,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: columnName(),
              ),
            ),
            Expanded(
              child: Stack(children: [
                framework(snapshot),
                addTaskButton(),
              ]),
            ),
          ],
        );
      }, onAccept: (Task value) {
        setState(() {
          removeTask(context, value);
          value.type = widget.name;
          newTask(value);
        });
      }),
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
            value.boardName = widget.ownerBoard.name;
            newTask(value);
          });
        },
        child: const CustomButton(text: "Add Task"),
      ),
    );
  }

  void setColumnBackground(String imagePath) {
    setState(() {
      widget.ownerBoard.columnImage = imagePath;
    });
  }

  Container framework(AsyncSnapshot<List<Task>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 50, right: 50),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300]!.withAlpha(200),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        // boxShadow: const [
        //   BoxShadow(
        //       color: Colors.black38, offset: Offset(-1, -5), blurRadius: 3),
        //   BoxShadow(color: Colors.black38, offset: Offset(1, 5), blurRadius: 3)
        // ],
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

  void doDragAndDrop(DragUpdateDetails details) {
    if (details.globalPosition.dx < 100) {
      widget.timer++;
      if (widget.timer > 180) {
        widget.timer = 0;
        widget.pageController!.previousPage(
            duration: const Duration(seconds: 2),
            curve: Curves.linearToEaseOut);
      }
    } else if (details.globalPosition.dx >
        MediaQuery.of(context).size.width - 100) {
      widget.timer++;
      if (widget.timer > 180) {
        widget.timer = 0;
        widget.pageController!.nextPage(
            duration: const Duration(seconds: 2),
            curve: Curves.linearToEaseOut);
      }
    } else {
      widget.timer = 0;
    }
  }

  Draggable<Object> buildDraggable(
      AsyncSnapshot<List<Task>> snapshot, int index) {
    return Draggable<Task>(
      data: snapshot.data![index],
      onDragUpdate: doDragAndDrop,
      child: ColumnTile(
        task: snapshot.data![index],
        heightTile: 30,
        widthTile: 20,
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(5, 7),
          )
        ], color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
        width: 250,
        height: 30,
      ),
      feedback: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: ColumnTile(
          heightTile: 30,
          widthTile: 250,
          task: snapshot.data![index],
          colorTile: Colors.teal,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
