/// {@category Domain}
class Plant {
  final String id;
  final String name;
  final String place;
  final String code;
  Plant(
      {required this.id,
      required this.name,
      required this.place,
      required this.code});

  factory Plant.fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    String place = json['place'] as String;
    String code = json['code'] as String;
    return Plant(id: id, name: name, place: place, code: code);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "place": place,
      "code": code,
    };
  }
}
