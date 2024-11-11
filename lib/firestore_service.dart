import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:farmers_journal/model/user.dart';
import 'package:farmers_journal/model/journal.dart';

part 'firestore_service.g.dart';

// firestore_service.dart => firebase service (providers) 로 네이밍 변경
@riverpod
Future<User?> user(Ref ref) async {
  final db = FirebaseFirestore.instance;
  final user = db.collection("users").doc('otOHyOdeUe97mmVyeIXz');
  final result = await user.get().then((DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    final userModel = User.fromJson(json);
    return userModel;
  });

  return result;
}

@riverpod
Future<List<dynamic>> journal(Ref ref) async {
  final db = FirebaseFirestore.instance;

  var result = [];
  db.collection("journals").get().then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // print(docSnapshot.data());
        result.add(Journal.fromFirestore(docSnapshot, null));
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return result;
}
