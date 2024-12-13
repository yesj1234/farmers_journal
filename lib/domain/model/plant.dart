class Plant {
  final String name;

  Plant({required this.name});

  factory Plant.fromJson(Map<String, dynamic> json) {
    String name = json['name'] as String;
    return Plant(name: name);
  }
}
