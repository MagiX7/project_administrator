import 'package:flutter/material.dart';
import 'package:project_administrator/models/board.dart';
import 'package:project_administrator/screens/column_screen.dart';

class CreateColumnScreen extends StatefulWidget {
  PageController pageController;
  CreateColumnScreen({Key? key, required this.pageController})
      : super(key: key);

  @override
  _CreateColumnScreenState createState() => _CreateColumnScreenState();
}

class _CreateColumnScreenState extends State<CreateColumnScreen> {
  late TextEditingController textController;

  int radioGroupValue = 0;
  ColumnScreen column = ColumnScreen(
    name: "Column",
    ownerBoard: Board(columnImage: '', name: ''),
  );

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new column"),
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 13, top: 15),
              child: Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 30),
                ),
              ),
              controller: textController,
              mouseCursor: MouseCursor.defer,
              onSubmitted: (text) {
                column.name = textController.text;
                Navigator.of(context).pop(column);
              },
              autocorrect: false,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              column.name = textController.text;
              column.pageController = widget.pageController;
              Navigator.of(context).pop(column);
            },
            child: Container(
              width: 150,
              height: 35,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.shade700,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  "Add column",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
