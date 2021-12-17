import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/models/menu_item.dart';
import 'package:project_administrator/screens/move_task_screen.dart';

class ColumnTile extends StatefulWidget {
  Task task;
  double heightTile;
  double widthTile;
  Color? colorTile = Colors.black12;

  ColumnTile(
      {required this.task,
      Key? key,
      this.colorTile,
      required this.heightTile,
      required this.widthTile})
      : super(key: key);

  @override
  State<ColumnTile> createState() => _ColumnTileState();
}

class _ColumnTileState extends State<ColumnTile> {
  List<MenuItem> menuItems = [
    MenuItem(name: "Rename", icon: Icon(Icons.remove)),
    MenuItem(name: "Move", icon: Icon(Icons.arrow_forward_ios_rounded)),
    MenuItem(name: "Remove", icon: Icon(Icons.remove)),
  ];

  String dropDownValue = " ";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: widget.heightTile,
        width: widget.widthTile,
        //padding: const EdgeInsets.symmetric(vertical: 7),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: widget.colorTile ?? Colors.black12,
                  offset: const Offset(5, 7),
                  blurRadius: 3)
            ]),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 7, left: 7),
              alignment: Alignment.centerLeft,
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: widget.task.colorPriority,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: buildMenuButton(),
            ),
            Center(child: Text(widget.task.name)),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<MenuItem> buildMenuButton() {
    return PopupMenuButton<MenuItem>(
        color: Colors.lightBlueAccent[200]!.withAlpha(200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.arrow_drop_down_outlined),
        padding: const EdgeInsets.only(bottom: 0), // DO NOT ERASE. IT WORKS
        onSelected: (item) {
          switch (item.name) {
          case "Rename":
            //TODO: Do pertinent stuff here
            break;
          case "Remove":
            removeTask(context, widget.task);
            break;
          case "Move":
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoveTaskScreen()));
            break;
        }
        },
        itemBuilder: (context) {
          return menuItems.map((item) {
            return buildMenuItem(context, item);
          }).toList();
        });
  }

  PopupMenuItem<MenuItem> buildMenuItem(BuildContext context, MenuItem item) {
    return PopupMenuItem<MenuItem>(
      value: item,
      child: SizedBox(
        width: 75,
        child: Center(
          child: Text(
            item.name,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
