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

  void updateColumnsInBoard() {
    final db = FirebaseFirestore.instance;
    final doc = db.doc("Board/${widget.board.firebaseID}");
    List<String> columnNames = [];
    for (int i = 3; i < columns.length; ++i) {
      columnNames.add(columns[i].name);
    }
    doc.update({'columns': FieldValue.arrayUnion(columnNames)});
  }

  void eliminateColumnInBoard(String value) {
    final db = FirebaseFirestore.instance;
    final doc = db.doc("Board/${widget.board.firebaseID}");
    List<String> columnString = [value];
    doc.update({
      'columns': FieldValue.arrayRemove([value])
    });
  }

  @override
  void initState() {
    pageController = PageController();
    textController = TextEditingController();
    textController.text = widget.name;
    columns = [];

    getColumnsData();

    menuItems = [
      MenuItem(name: "Add Column", icon: const Icon(Icons.add)),
      MenuItem(name: "Remove Column", icon: const Icon(Icons.remove)),
      MenuItem(name: "Change Background", icon: const Icon(Icons.remove)),
    ];
    super.initState();
  }

  void getColumnsData() async {
    final collection = FirebaseFirestore.instance.collection('Board');
    final doc = collection.doc(widget.board.firebaseID);

    await doc.get().then((value) {
      List<String> test = List.from(value.data()!['columns']);
      for (int i = 0; i < test.length; ++i) {
        ColumnScreen column = ColumnScreen(
            name: test[i],
            ownerBoard: widget.board,
            pageController: pageController);
        setState(() {
          columns.add(column);
        });
      }
    });
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
            onTap: () {
              textController.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.name.length),
              );
            },
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
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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
          updateColumnsInBoard();
        });
      });
    } else if (item == menuItems[1]) {
      String columnName = columns.elementAt(pageController.page!.toInt()).name;
      eliminateColumnInBoard(columnName);
      setState(() {
        columns.removeAt(pageController.page!.toInt());
      });
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
