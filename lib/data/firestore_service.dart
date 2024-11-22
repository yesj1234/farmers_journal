import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:farmers_journal/domain/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Models

import 'package:farmers_journal/domain/model/journal.dart';

part 'firestore_service.g.dart';

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

@Riverpod(keepAlive: true)
Future<List<Journal>> journal(Ref ref) async {
  final db = FirebaseFirestore.instance;

  List<Journal> result = [];
  db.collection("journals").orderBy("createdAt", descending: true).get().then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        result.add(Journal.fromMap(docSnapshot.data(), null));
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
  return result;
}
