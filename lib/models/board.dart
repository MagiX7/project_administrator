class Board {
  String name;
  String columnImage;
  String? firebaseID;

  Board({required this.name, required this.columnImage});

  Board.fromFirestore(this.firebaseID, Map<String, dynamic> data)
      : name = data['name'],
        columnImage = data['columnImage'];
}
