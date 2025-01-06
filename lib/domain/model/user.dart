import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/domain/model/plant.dart';

class AppUser {
  final String email;
  final Timestamp createdAt;
  final List<dynamic> journals;

  final List<dynamic> plants;
  final bool isInitialSettingRequired;
  final String? profileImage;
  final String? name;
  final String? nickName;
  AppUser({
    required this.email,
    required this.createdAt,
    required this.journals,
    required this.plants,
    required this.isInitialSettingRequired,
    this.profileImage,
    this.name,
    this.nickName,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    String email = json['email'] as String;
    Timestamp createdAt = json['createdAt'] as Timestamp;
    List<dynamic> journals = json['journals'] as List<dynamic>;

    List<dynamic> plants = json['plants'] as List<dynamic>;
    bool isInitialSettingRequired = json['isInitialSettingRequired'] as bool;
    String profileImage = json['profileImage'] as String;
    String name = json['name'] as String;
    String nickName = json['nickName'] as String;
    return AppUser(
        email: email,
        createdAt: createdAt,
        name: name,
        nickName: nickName,
        profileImage: profileImage,
        journals: journals,
        isInitialSettingRequired: isInitialSettingRequired,
        plants: plants
            .map((plant) => Plant.fromJson(plant as Map<String, dynamic>))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'createdAt': createdAt,
      'name': name ?? '',
      'nickName': nickName ?? '',
      'profileImage': profileImage ?? '',
      'journals': journals,
      'plants': plants,
      'isInitialSettingRequired': isInitialSettingRequired,
    };
  }
}
