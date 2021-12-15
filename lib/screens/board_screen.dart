import 'package:flutter/material.dart';
import 'package:project_administrator/models/menu_item.dart';
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
  late List<ColumnScreen> columns;
  List<MenuItem> menuItems = [
    MenuItem(name: "Add Column", icon: const Icon(Icons.add)),
    MenuItem(name: "Remove Column", icon: const Icon(Icons.remove)),
  ];

  @override
  void initState() {
    pageController = PageController();
    columns = [
      ColumnScreen(
        name: "To Do",
        boardName: widget.name,
        pageController: pageController,
      ),
      ColumnScreen(
          name: "In Progress",
          boardName: widget.name,
          pageController: pageController),
      ColumnScreen(
        name: "Done",
        boardName: widget.name,
        pageController: pageController,
      ),
    ];
    menuItems = [
      MenuItem(name: "Add Column", icon: const Icon(Icons.add)),
      MenuItem(name: "Remove Column", icon: const Icon(Icons.remove)),
    ];
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
        backgroundColor: Colors.grey[850],
        title: Text(widget.name),
        actions: [
          PopupMenuButton<MenuItem>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.lightBlueAccent[200]!.withAlpha(200),
            onSelected: (item) {
              onSelectedMenuItem(item);
            },
            itemBuilder: (context) {
              return menuItems.map((item) {
                return PopupMenuItem<MenuItem>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList();
            },
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

  void onSelectedMenuItem(item) {
    if (item == menuItems[0]) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => CreateColumnScreen(
            pageController: pageController,
          ),
        ),
      )
          .then((value) {
        setState(() {
          columns.add(value);
        });
      });
    } else {
      // TODO: Pop a message saying this column is not deletable
      if (pageController.page!.toInt() > 2) {
        setState(() {
          columns.removeAt(pageController.page!.toInt());
        });
      }
    }
  }
}
