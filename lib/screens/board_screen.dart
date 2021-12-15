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
    columns = [
      ColumnScreen(name: "To Do", boardName: widget.name),
      ColumnScreen(name: "In Progress", boardName: widget.name),
      ColumnScreen(name: "Done", boardName: widget.name),
    ];
    menuItems = [
      MenuItem(name: "Add Column", icon: const Icon(Icons.add)),
      MenuItem(name: "Remove Column", icon: const Icon(Icons.remove)),
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
        backgroundColor: Colors.grey[850],
        title: Text(widget.name),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (item) {
              if (item == menuItems[0]) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const CreateColumnScreen()))
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
}
