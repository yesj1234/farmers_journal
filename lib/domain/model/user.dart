import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/plant.dart';

class User {
  final String email;
  final String password;
  final Timestamp createdAt;
  final List<dynamic> journals;
  final List<dynamic> plants;

  User(
      {required this.email,
      required this.password,
      required this.createdAt,
      required this.journals,
      required this.plants});

  factory User.fromJson(Map<String, dynamic> json) {
    String email = json['email'] as String;
    String password = json['password'] as String;
    Timestamp createdAt = json['createdAt'] as Timestamp;
    List<dynamic> journals = json['journals'] as List<dynamic>;
    List<dynamic> plants = json['plants'] as List<dynamic>;

    return User(
        email: email,
        password: password,
        createdAt: createdAt,
        journals: journals.map((journal) => Journal.fromJson(journal)).toList(),
        plants: plants.map((plant) => Plant.fromJson(plant)).toList());
  }
}
