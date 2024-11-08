class Plant {
  final String name;

  Plant(this.name);

  Plant.fromJson(Map<String, dynamic> json) : name = json['name'] as String;
}
