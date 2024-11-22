import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String password;
  final Timestamp createdAt;
  final List<dynamic> journals;
  final List<dynamic> plants;

  User(this.email, this.password, this.createdAt, this.journals, this.plants);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        password = json['password'] as String,
        createdAt = json['createdAt'] as Timestamp,
        journals = json['journals'] as List<dynamic>,
        plants = json['plants'] as List<dynamic>;
}
