import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/models/menu_item.dart';

class ColumnTile extends StatelessWidget {
  List<MenuItem> menuItems = [
    MenuItem(name: "Move", icon: Icon(Icons.arrow_forward_ios_rounded)),
    MenuItem(name: "Remove", icon: Icon(Icons.remove)),
  ];

  Task task;
  double heightTile;
  double widthTile;
  Color? colorTile = Colors.black12;
  String dropDownValue = " ";
  ColumnTile(
      {required this.task,
      Key? key,
      this.colorTile,
      required this.heightTile,
      required this.widthTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: heightTile,
        width: widthTile,
        //padding: const EdgeInsets.symmetric(vertical: 7),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: colorTile ?? Colors.black12,
                  offset: const Offset(5, 7),
                  blurRadius: 3)
            ]),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, left: 7),
              alignment: Alignment.centerLeft,
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: task.colorPriority,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<MenuItem>(
                  color: Colors.lightBlueAccent[200]!.withAlpha(200),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  padding: const EdgeInsets.only(
                      bottom: 0), // DO NOT ERASE. IT WORKS
                  onSelected: (item) {},
                  itemBuilder: (context) {
                    return menuItems.map((item) {
                      return PopupMenuItem<MenuItem>(
                        onTap: () => removeTask(task),
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
                    }).toList();
                  }),
            ),
            Center(child: Text(task.name)),
          ],
        ),
      ),
    );
  }
}
