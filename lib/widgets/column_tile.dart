import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';
import 'package:project_administrator/models/menu_item.dart';

class ColumnTile extends StatefulWidget {
  Task task;
  double heightTile;
  double widthTile;
  Color? colorTile = Colors.black12;

  Widget? trailing;

  ColumnTile(
      {required this.task,
      this.trailing,
      Key? key,
      this.colorTile,
      required this.heightTile,
      required this.widthTile})
      : super(key: key);

  @override
  State<ColumnTile> createState() => _ColumnTileState();
}

class _ColumnTileState extends State<ColumnTile> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.text = widget.task.name;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
            Center(
              child: TextField(
                maxLength: 18,
                onSubmitted: (text) {
                  widget.task.name = text;
                  updateTask(widget.task);
                },
                textAlign: TextAlign.center,
                decoration: null,
                controller: textController,
              ),
            ),
            if (widget.trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: widget.trailing,
              ),
          ],
        ),
      ),
    );
  }
}
