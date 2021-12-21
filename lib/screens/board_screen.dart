import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/board.dart';
import 'package:project_administrator/models/menu_item.dart';
import 'package:project_administrator/screens/column_screen.dart';
import 'package:project_administrator/screens/create_column_screen.dart';
import 'package:project_administrator/screens/select_background_screen.dart';

class BoardScreen extends StatefulWidget {
  String name;
  String? docID;
  String columnImage;
  Board board;

  BoardScreen(
      {Key? key,
      required this.board,
      required this.name,
      required this.columnImage})
      : super(key: key) {
    docID = name;
  }

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

void updateBoard(Board board) {
  // TODO: If you want to update the id, you should recreate the document in Firestore
  final db = FirebaseFirestore.instance;
  final doc = db.doc("Board/${board.firebaseID}");
  doc.update({'columnImage': board.columnImage, 'name': board.name});
}

class _BoardScreenState extends State<BoardScreen> {
  late TextEditingController textController;
  late PageController pageController;
  late List<ColumnScreen> columns;
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    pageController = PageController();
    textController = TextEditingController();
    textController.text = widget.name;
    columns = [
      ColumnScreen(
        name: "To Do",
        pageController: pageController,
        ownerBoard: widget.board,
      ),
      ColumnScreen(
        name: "In Progress",
        pageController: pageController,
        ownerBoard: widget.board,
      ),
      ColumnScreen(
        name: "Done",
        pageController: pageController,
        ownerBoard: widget.board,
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
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: const TextStyle(color: Colors.white, fontSize: 25),
            controller: textController,
            decoration: null,
            onSubmitted: (text) {
              widget.board.name = text;
              updateBoard(widget.board);
            },
          ),
          actions: [
            buildMenuButton(),
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
          ),
        ),
      ),
    );
  }

  PopupMenuButton<MenuItem> buildMenuButton() {
    return PopupMenuButton<MenuItem>(
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
        value.ownerBoard = widget.board;
        value.pageController = pageController;
        value.ownerBoard.columnImage = widget.columnImage;
        setState(() {
          columns.add(value);
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
        widget.board.columnImage = value;
        updateBoard(widget.board);
        setState(() {
          widget.columnImage = value;
        });
      });
    }
  }
}
