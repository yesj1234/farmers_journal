import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/model/plant.dart';

class AppUser {
  final String email;
  final Timestamp createdAt;
  final List<dynamic> journals;
  final List<dynamic> plants;
  final bool isInitialSettingRequired;
  AppUser(
      {required this.email,
      required this.createdAt,
      required this.journals,
      required this.plants,
      required this.isInitialSettingRequired});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    String email = json['email'] as String;
    Timestamp createdAt = json['createdAt'] as Timestamp;
    List<dynamic> journals = json['journals'] as List<dynamic>;
    List<dynamic> plants = json['plants'] as List<dynamic>;
    bool isInitialSettingRequired = json['isInitialSettingRequired'] as bool;
    return AppUser(
        email: email,
        createdAt: createdAt,
        journals: journals,
        isInitialSettingRequired: isInitialSettingRequired,
        plants: plants
            .map((plant) => Plant.fromJson(plant as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email ?? '',
      'createdAt': createdAt ?? '',
      'journals': journals ?? [],
      'plants': plants ?? [],
    };
  }
}
