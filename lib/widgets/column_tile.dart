import 'package:flutter/material.dart';
import 'package:project_administrator/models/task.dart';

class ColumnTile extends StatelessWidget {
  Task task;
  
  ColumnTile({ required this.task, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(5,7), blurRadius: 3)]),                     
        child: Center(child: Text(task.name)),
      ),
    );
  }
}