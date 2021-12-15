class Board {
  String name;
  String columnImage;

  Board({required this.name, required this.columnImage});

  Board.fromFirestore(Map<String, dynamic> data)
      : name = data['name'],
        columnImage = data['columnImage'];
}
