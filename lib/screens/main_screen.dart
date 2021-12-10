import 'package:flutter/material.dart';
import 'package:project_administrator/screens/board_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("-- Titulo app --"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BoardScreen()));
            },
            child: const Text("Ir a tablero"),
          ),
        ],
      ),
    );
  }
}
