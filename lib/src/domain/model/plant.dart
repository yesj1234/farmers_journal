/// {@category Domain}
class Plant {
  final String id;
  final String name;
  final String place;
  final double? lat;
  final double? lng;
  final String code;
  Plant(
      {required this.id,
      required this.name,
      required this.place,
      required this.lat,
      required this.lng,
      required this.code});

  factory Plant.fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    String place = json['place'] as String;
    String code = json['code'] as String;
    double? lat = json['lat'] as double;
    double? lng = json['lng'] as double;
    return Plant(
        id: id, name: name, place: place, code: code, lat: lat, lng: lng);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "place": place,
      "lat": lat,
      "lng": lng,
      "code": code,
    };
  }
}
