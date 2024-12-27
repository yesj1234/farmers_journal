import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/model/plant.dart';

class AppUser {
  final String email;
  final String password;
  final Timestamp createdAt;
  final List<dynamic> journals;
  final List<dynamic> plants;

  AppUser(
      {required this.email,
      required this.password,
      required this.createdAt,
      required this.journals,
      required this.plants});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    String email = json['email'] as String;
    String password = json['password'] as String;
    Timestamp createdAt = json['createdAt'] as Timestamp;
    List<dynamic> journals = json['journals'] as List<dynamic>;
    List<dynamic> plants = json['plants'] as List<dynamic>;

    return AppUser(
        email: email,
        password: password,
        createdAt: createdAt,
        journals: journals,
        plants: plants
            .map((plant) => Plant.fromJson(plant as Map<String, dynamic>))
            .toList());
  }
}
