import 'package:flutter/material.dart';

class MoveTaskScreen extends StatefulWidget {
  const MoveTaskScreen({ Key? key }) : super(key: key);

  @override
  _MoveTaskScreenState createState() => _MoveTaskScreenState();
}

class _MoveTaskScreenState extends State<MoveTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Move task to another column"),
      ),
      body: Column(
        
      ),
    );
  }
}