import 'package:flutter/material.dart';
import 'package:project_administrator/screens/column_screen.dart';
import 'package:project_administrator/screens/create_column_screen.dart';

class BoardScreen extends StatefulWidget {
  String name;

  BoardScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late PageController pageController;
  List<ColumnScreen> columns = [];

  @override
  void initState() {
    columns = [
      ColumnScreen(name: "To Do", boardName: widget.name),
      ColumnScreen(name: "In Progress", boardName: widget.name),
      ColumnScreen(name: "Done", boardName: widget.name),
    ];
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const CreateColumnScreen()))
                  .then((value) {
                setState(() {
                  columns.add(value);
                });
              });
            },
            child: const Text("Crear Columna"),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          for (int i = 0; i < columns.length; ++i) columns[i],
        ],
      ),
    );
  }
}
