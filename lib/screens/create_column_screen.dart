import 'package:flutter/material.dart';
import 'package:project_administrator/screens/column_screen.dart';

class CreateColumnScreen extends StatefulWidget {
  const CreateColumnScreen({Key? key}) : super(key: key);

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
        title: const Text("Create new column"),
      ),
      body: Column(
        children: [
          TextField(controller: textController),
          ElevatedButton(
              onPressed: () {
                column.name = textController.text;
                Navigator.of(context).pop(column);
              },
              child: const Text("Add Column"))
        ],
      ),
    );
  }
}
