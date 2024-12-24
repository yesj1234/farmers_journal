class Plant {
  final String id;
  final String name;
  final String place;
  Plant({required this.id, required this.name, required this.place});

  factory Plant.fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    String place = json['place'] as String;
    return Plant(id: id, name: name, place: place);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "place": place,
    };
  }
}
