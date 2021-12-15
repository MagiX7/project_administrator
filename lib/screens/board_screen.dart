import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/menu_item.dart';
import 'package:project_administrator/screens/column_screen.dart';
import 'package:project_administrator/screens/create_column_screen.dart';
import 'package:project_administrator/screens/select_background_screen.dart';

class BoardScreen extends StatefulWidget {
  String name;
  String columnImage;

  BoardScreen({Key? key, required this.name, required this.columnImage})
      : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

void updateBoard(String docID, String colImage) {
  final db = FirebaseFirestore.instance;
  db.doc("Board/$docID").update({'columnImage': colImage});
}

class _BoardScreenState extends State<BoardScreen> {
  late PageController pageController;
  late List<ColumnScreen> columns;
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    pageController = PageController();
    columns = [
      ColumnScreen(
        name: "To Do",
        boardName: widget.name,
        pageController: pageController,
        backgroundImage: widget.columnImage,
      ),
      ColumnScreen(
        name: "In Progress",
        boardName: widget.name,
        pageController: pageController,
        backgroundImage: widget.columnImage,
      ),
      ColumnScreen(
        name: "Done",
        boardName: widget.name,
        pageController: pageController,
        backgroundImage: widget.columnImage,
      ),
    ];

    menuItems = [
      MenuItem(name: "Add Column", icon: const Icon(Icons.add)),
      MenuItem(name: "Remove Column", icon: const Icon(Icons.remove)),
      MenuItem(name: "Change Background", icon: const Icon(Icons.remove)),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        //backgroundColor: Colors.grey[850],
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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/${widget.columnImage}'),
              fit: BoxFit.cover,
            ),
          ),
          child: PageView(
            controller: pageController,
            children: [for (int i = 0; i < columns.length; ++i) columns[i]],
          )),
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
        value = value as ColumnScreen;
        value.backgroundImage = widget.columnImage;
        setState(() {
          value.columns.add(value);
        });
      });
    } else if (item == menuItems[1]) {
      // TODO: Pop a message saying this column is not deletable
      if (pageController.page!.toInt() > 2) {
        setState(() {
          columns.removeAt(pageController.page!.toInt());
        });
      }
    } else if (item == menuItems[2]) {
      Navigator.of(context)
          .push(
              MaterialPageRoute(builder: (context) => SelectBackgroundScreen()))
          .then((value) {
        updateBoard(widget.name, value);
        setState(() {
          widget.columnImage = value;
        });
      });
    }
  }
}
