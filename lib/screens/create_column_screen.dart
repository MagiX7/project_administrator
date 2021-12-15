import 'package:flutter/material.dart';
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
  ColumnScreen column = ColumnScreen(name: "Column", boardName: "Hola");

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
        backgroundColor: Colors.grey[850],
        title: const Text("Create new column"),
      ),
      body: Column(
        children: [
          TextField(controller: textController),
          ElevatedButton(
              onPressed: () {
                column.name = textController.text;
                column.pageController = widget.pageController;
                Navigator.of(context).pop(column);
              },
              child: const Text("Add Column"))
        ],
      ),
    );
  }
}
