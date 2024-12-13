import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_journal/data/interfaces.dart';
import 'package:farmers_journal/domain/firebase/DefaultImage.dart';
import 'package:farmers_journal/domain/model/journal.dart';
import 'package:farmers_journal/domain/model/user.dart';

class FireStoreDefaultImageRepository implements DefaultImageRepository {
  final FirebaseFirestore instance;
  FireStoreDefaultImageRepository({required this.instance});
  @override
  Future<DefaultImage> getDefaultImage() async {
    // TODO: send request, parse response, return DefaultImage object or throw.
    final image = instance.collection('images').doc('LNnga0Rn86RkxU6kB8VO');
    final result = await image.get().then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      final defaultImage = DefaultImage.fromJson(json);
      return defaultImage;
    });
    return result;
  }
}

class FireStoreUserRepository implements UserRepository {
  final FirebaseFirestore instance;
  FireStoreUserRepository({required this.instance});
  @override
  Future<User?> getUsers() async {
    final user = instance.collection("users").doc('otOHyOdeUe97mmVyeIXz');
    final result = await user.get().then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      final userModel = User.fromJson(json);
      return userModel;
    });
    return result;
  }

  @override
  Future<List<Journal?>> getJournals() async {
    // 1. Fetch the current user.
    // 2. Fetch the journals of the current user.
    final user = instance.collection("users").doc('otOHyOdeUe97mmVyeIXz');
    final result = await user.get().then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      final userModel = User.fromJson(json);
      return userModel.journals as List<Journal?>;
    });
    return result;
  }

  @override
  Future<void> createJournal(
      {required String title,
      required String content,
      required DateTime date,
      required String? image}) async {
    // 1. Fetch the current user.
    // 2. create new Journal object with the provided date, title and content
    // 3. call firestore API which creates new Journal in the user's journal field.
    final userRef = instance.collection("users").doc('otOHyOdeUe97mmVyeIXz');
    final newJournal =
        Journal(title: title, content: content, image: image, createdAt: date);
    userRef.update({
      "journals": FieldValue.arrayUnion([newJournal.toJson()])
    });
  }
}

class FireStoreJournalRepository implements JournalRepository {
  final FirebaseFirestore instance;
  FireStoreJournalRepository({required this.instance});

  @override
  Future<List<Journal>> getJournals() async {
    List<Journal> result = [];
    instance
        .collection("journals")
        .orderBy("createdAt", descending: true)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          result.add(Journal.fromJson(docSnapshot.data()));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }
}
