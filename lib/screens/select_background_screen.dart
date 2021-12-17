import 'package:flutter/material.dart';

class SelectBackgroundScreen extends StatelessWidget {
  List<String> images = [
    'galaxyBackground.jpg',
    'beach.jpg',
    'galaxyTwo.jpg',
    'lotusTree.jpg',
    'paris.jpg',
    'road.jpg',
  ];
  SelectBackgroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change background"),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            for (int i = 0; i < images.length; ++i)
              GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(images[i]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/' + images[i]),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
