import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_administrator/models/board.dart';

class CreateBoardScreen extends StatefulWidget {
  const CreateBoardScreen({Key? key}) : super(key: key);

  @override
  State<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  late TextEditingController textController;
  Board board = Board(name: "Default", columnImage: "");

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
        //backgroundColor: Colors.grey[850],
        title: const Text("Create new board screen"),
      ),
      body: Column(
        children: [
          TextField(controller: textController),
          ElevatedButton(
              onPressed: () {
                // final db = FirebaseFirestore.instance;
                // db.collection("Board/").add({
                //   'Name': textController.text,
                // });
                board.name = textController.text;
                Navigator.of(context).pop(board);
              },
              child: const Text("Create new board"))
        ],
      ),
    );
  }
}
