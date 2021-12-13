class Board {
  String name;

  Board({required this.name});

  Board.fromFirestore(Map<String, dynamic> data) : name = data['name'];
}
