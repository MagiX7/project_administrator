import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/board.dart';
import 'package:project_administrator/screens/board_screen.dart';
import 'package:project_administrator/screens/create_board_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Board> boardList;

  @override
  void initState() {
    boardList = [Board(name: "test", columnImage: "")];
    super.initState();
  }

  Stream<List<Board>> boardsSnapshots(String id) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection(id).snapshots();
    return stream.map((querySnapshot) {
      List<Board> boards = [];
      for (final doc in querySnapshot.docs) {
        boards.add(Board.fromFirestore(doc.data()));
      }
      return boards;
    });
  }

  void addBoard(Board board) {
    final db = FirebaseFirestore.instance;
    db.collection("Board").add({
      'name': board.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text("Ragebab"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const CreateBoardScreen()))
                    .then((value) {
                  addBoard(value);
                  setState(() {
                    boardList.add(value);
                  });
                });
              }),
        ],
      ),
      body: buildBoards(),
    );
  }

  StreamBuilder<List<Board>> buildBoards() {
    return StreamBuilder(
      stream: boardsSnapshots("Board"),
      builder: (context, snapshot) {
        if (snapshot.hasError && !snapshot.hasData) {
          return ErrorWidget(snapshot.error.toString());
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ErrorWidget("Could not connect to Firestore");
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return Builder(builder: (context) {
              return Column(
                children: [
                  Expanded(
                    child: buildGrid(snapshot),
                  ),
                ],
              );
            });

          case ConnectionState.done:
            break;
        }
        return Container();
      },
    );
  }

  GridView buildGrid(AsyncSnapshot<List<Board>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data!.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final board = snapshot.data![index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BoardScreen(
                  name: board.name,
                  columnImage: board.columnImage,
                ),
              ),
            );
          },
          child: buildGridTile(board),
        );
      },
    );
  }

  GridTile buildGridTile(Board board) {
    return GridTile(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              board.name,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }
}
